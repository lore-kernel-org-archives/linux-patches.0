Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC3858AD2;
	Tue, 23 Jan 2024 01:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974099; cv=none; b=mnbj/8Tk42++Rwl2Fj1z1QRIfRR2S22zbDczxM85+G5n1ynctdbX+eUdeLhGP6QG29Cs8jiQCsW8ryitH2klrG11uRjAyALW8oAdeDKfA+29a8bWiZw5BSnkQijGTfiDJySatohMiEe7YRH/PjdWY1Sg6r3N9z1RBltbGioJx2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974099; c=relaxed/simple;
	bh=H8I9qC6TVZZK94I1yjoua0QNRkRFCZXj/7u772tSbHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kav8zzkA+P8cR2iD92nN4GrimmT50aXQwj8v8tsz6lR0Syhw2aRQKPyrDyiQ5GS5bSZju2zAraepRtzzbVfq1xyvVLUKPuTt4nRCjOvtEiSIilLfNMovB8Ou38ogYktMkLVx7fW3YTpJq8zXGQcjbxLUzbb6VN3Vq6xkL3jAmZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKx8cb0t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKx8cb0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDF0C433C7;
	Tue, 23 Jan 2024 01:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974099;
	bh=H8I9qC6TVZZK94I1yjoua0QNRkRFCZXj/7u772tSbHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKx8cb0tRjGi2bp7Rhp2P3bTeF++ecWGBpG4kOyr8eCq1EfrmAl1kTni3Rnw7uDrw
	 /VIFFtvcQZay4wdWSyk0CXFky5EWPOm5Asstwrg2dIgphUh5KEDOodOzx9r9JLCSp9
	 2NXOzbb+mNrYmF3IXUONL5r4sktrmp3ousEOFpcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoLong Wang <wangzhaolong1@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/583] mtd: Fix gluebi NULL pointer dereference caused by ftl notifier
Date: Mon, 22 Jan 2024 15:51:29 -0800
Message-ID: <20240122235813.320764655@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ff18636e0889..5bc32108ca03 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -463,7 +463,7 @@ static void blktrans_notify_add(struct mtd_info *mtd)
 {
 	struct mtd_blktrans_ops *tr;
 
-	if (mtd->type == MTD_ABSENT)
+	if (mtd->type == MTD_ABSENT || mtd->type == MTD_UBIVOLUME)
 		return;
 
 	list_for_each_entry(tr, &blktrans_majors, list)
@@ -503,7 +503,7 @@ int register_mtd_blktrans(struct mtd_blktrans_ops *tr)
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



