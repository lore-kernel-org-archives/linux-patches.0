Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948EB653;
	Tue, 23 Jan 2024 00:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968203; cv=none; b=gLac16HZFjegUl9wbNkK1mHhqRpzb/x7WkoubP5M05eqeqe1YRjZj/xVsjIygdQ/kXcURFRz3seso7oqbso+D5VsFVrEiX393Yi+akiDCsFitWauvSOfE62+i/kdqiHxq/VdtyMxV3WIxe0N7j9sIelYUwzhO02bNeev/yoEEjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968203; c=relaxed/simple;
	bh=14Mpy9no3CerKOV5PpWYWMbUS4ApTV+xIaUF0ksxwMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gfUiwE2K5mcHNuA3oIYksAO5tbjAS8D8V6a7N+KWv7wq+nJXetdSYwunz60ZwsJ5INCEWYoPDp1mAd5GE1laj0fy7YIaM2XfMCj2VysMLYj8F1513ARnHCTzYuJBp42VCmK7pbR2bYAbi8Un70mE7dfH1TyqUG269OrKFRmbx30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qt96wzYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qt96wzYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7538C43394;
	Tue, 23 Jan 2024 00:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968203;
	bh=14Mpy9no3CerKOV5PpWYWMbUS4ApTV+xIaUF0ksxwMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qt96wzYU6+6tbvFevl7+iDLp9QYQgOO5aV5+xqOwsagFWZiD6EDG9/VH45toABE43
	 9+Lp89lTkToxdjRo406YVR20zwSTyX/od3SZEluNV6NHVxmP5bYhKi/InmO9IP+213
	 dlkR9Zub8iI2+tT4RpKIVimbMcdweezHPaO4wjYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoLong Wang <wangzhaolong1@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 043/148] mtd: Fix gluebi NULL pointer dereference caused by ftl notifier
Date: Mon, 22 Jan 2024 15:56:39 -0800
Message-ID: <20240122235714.146848250@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 6a41dfa3c36b..a9aa1b518d81 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -521,7 +521,7 @@ static void blktrans_notify_add(struct mtd_info *mtd)
 {
 	struct mtd_blktrans_ops *tr;
 
-	if (mtd->type == MTD_ABSENT)
+	if (mtd->type == MTD_ABSENT || mtd->type == MTD_UBIVOLUME)
 		return;
 
 	list_for_each_entry(tr, &blktrans_majors, list)
@@ -564,7 +564,7 @@ int register_mtd_blktrans(struct mtd_blktrans_ops *tr)
 	list_add(&tr->list, &blktrans_majors);
 
 	mtd_for_each_device(mtd)
-		if (mtd->type != MTD_ABSENT)
+		if (mtd->type != MTD_ABSENT && mtd->type != MTD_UBIVOLUME)
 			tr->add_mtd(tr, mtd);
 
 	mutex_unlock(&mtd_table_mutex);
-- 
2.43.0



