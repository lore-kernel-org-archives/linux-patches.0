Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93092132C35;
	Tue, 23 Jan 2024 00:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969127; cv=none; b=gkLYnYvt+qNptPWYrAIHKT8LidgYU1cUjFnmK1PENNazdminppF7Te+wt9RxB+ceSI6Xyzl6Nw+nLosUyH+PW3X+4+CHEa9nS6YYZgWsUUGLOGfCLRfFakwWUSmxGmLQIfpRKzFWVAuPkN4zPLZO/VCT5hBIyu5LUahypwrs7B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969127; c=relaxed/simple;
	bh=qAtcBJ3tEREfirvAZXZ9jZQQywTPIVwEOPDB6Y9c0vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eZZfYI6Q2ZbNDTJONKX5Gx8djzpjeVAMBtR8EUuE1vgTaCnYFtPawb/lmv3VtqoctNpdvfk+d7GSwS9OrzDo0YpZid1MWrYhEVUS74rUtiZKybwymPWhOZV7ozz5LMoKnrGrR/vbCWDD2mn2Iqfh8Rgwsby7l9HiIaorvNgAkMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3F02WB1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3F02WB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57307C433F1;
	Tue, 23 Jan 2024 00:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969127;
	bh=qAtcBJ3tEREfirvAZXZ9jZQQywTPIVwEOPDB6Y9c0vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3F02WB1qhKjvh3S6KLjlQibsqyuBi8BV0yv2wYBdvV4JQlJyt7QAhcvTNpFrdHv6
	 zXzPv3POqOcAXWj80iBezrfAtnrCqBKeNbdpc9SFTT+anJZLtVbuL3xp5WHO5F27yE
	 jEyJESOWtzjUz03nb/Qk807qciYbVx4cvR3pTXT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoLong Wang <wangzhaolong1@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 039/641] mtd: Fix gluebi NULL pointer dereference caused by ftl notifier
Date: Mon, 22 Jan 2024 15:49:03 -0800
Message-ID: <20240122235819.301542170@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



