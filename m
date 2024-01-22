Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E1A55E40;
	Tue, 23 Jan 2024 01:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974011; cv=none; b=RjLNJAhF2aKGCDt4MhMK0vf0tMcOtATUKvAqdN7nNXY+Czy+quU/jTFdwuCLdcaB1d5pkgpaYayNUNYVWHklwNP7SBijw++Fofw0H3Gv+pQB8d+gbXNFAHf3m8Bh1Xu176BWdHUKdcLp5XTFzruFZ924jwcvhdsnQiOxtDeTtDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974011; c=relaxed/simple;
	bh=K66OTmkJsCIUKgus2I/1kY+JKnbdvBM62HcEYQNjOUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UFID7+OakzJGePKH2LtR7K+Gzy6BkFlgI/CrXrFilfGR4MgpWzWGBG6CEkoYeVMQmR2HjprA6J3bTtlcntsKTyR8XvM4z0T3dgrPcWfTM15TgdVP3vc2jXnvftAVtBfueiEWVruPzeS8/QG1N2w7jRcY3ZubpvKhYDzExmk1WrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJVaCD9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJVaCD9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D807FC433B1;
	Tue, 23 Jan 2024 01:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974011;
	bh=K66OTmkJsCIUKgus2I/1kY+JKnbdvBM62HcEYQNjOUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJVaCD9G6vLkAkXDURFFeYwYBTl86vxeIT0wq2vjudI2OE9hx/A1zbZCpYln+KSG4
	 FzefjMmHpr9AeSw4zzNWbe6Mpmhv8SqaXUqTISg0mAHtlux4xdlXbiRlLrJV87ez64
	 0IHLye4z6n/FJuu8Z1quwMnUF1ZMhI+5LoUSRaAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoLong Wang <wangzhaolong1@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/374] mtd: Fix gluebi NULL pointer dereference caused by ftl notifier
Date: Mon, 22 Jan 2024 15:55:48 -0800
Message-ID: <20240122235747.810996385@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhaoLong Wang <wangzhaolong1@huawei.com>

[ Upstream commit a43bdc376deab5fff1ceb93dca55bcab8dbdc1d6 ]

If both ftl.ko and gluebi.ko are loaded, the notifier of ftl
triggers NULL pointer dereference when trying to access
‘gluebi->desc’ in gluebi_read().

ubi_gluebi_init
  ubi_register_volume_notifier
    ubi_enumerate_volumes
      ubi_notify_all
        gluebi_notify    nb->notifier_call()
          gluebi_create
            mtd_device_register
              mtd_device_parse_register
                add_mtd_device
                  blktrans_notify_add   not->add()
                    ftl_add_mtd         tr->add_mtd()
                      scan_header
                        mtd_read
                          mtd_read_oob
                            mtd_read_oob_std
                              gluebi_read   mtd->read()
                                gluebi->desc - NULL

Detailed reproduction information available at the Link [1],

In the normal case, obtain gluebi->desc in the gluebi_get_device(),
and access gluebi->desc in the gluebi_read(). However,
gluebi_get_device() is not executed in advance in the
ftl_add_mtd() process, which leads to NULL pointer dereference.

The solution for the gluebi module is to run jffs2 on the UBI
volume without considering working with ftl or mtdblock [2].
Therefore, this problem can be avoided by preventing gluebi from
creating the mtdblock device after creating mtd partition of the
type MTD_UBIVOLUME.

Fixes: 2ba3d76a1e29 ("UBI: make gluebi a separate module")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217992 [1]
Link: https://lore.kernel.org/lkml/441107100.23734.1697904580252.JavaMail.zimbra@nod.at/ [2]
Signed-off-by: ZhaoLong Wang <wangzhaolong1@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Acked-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20231220024619.2138625-1-wangzhaolong1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtd_blkdevs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index b8ae1ec14e17..5288a6aaf182 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -457,7 +457,7 @@ static void blktrans_notify_add(struct mtd_info *mtd)
 {
 	struct mtd_blktrans_ops *tr;
 
-	if (mtd->type == MTD_ABSENT)
+	if (mtd->type == MTD_ABSENT || mtd->type == MTD_UBIVOLUME)
 		return;
 
 	list_for_each_entry(tr, &blktrans_majors, list)
@@ -497,7 +497,7 @@ int register_mtd_blktrans(struct mtd_blktrans_ops *tr)
 	mutex_lock(&mtd_table_mutex);
 	list_add(&tr->list, &blktrans_majors);
 	mtd_for_each_device(mtd)
-		if (mtd->type != MTD_ABSENT)
+		if (mtd->type != MTD_ABSENT && mtd->type != MTD_UBIVOLUME)
 			tr->add_mtd(tr, mtd);
 	mutex_unlock(&mtd_table_mutex);
 	return 0;
-- 
2.43.0



