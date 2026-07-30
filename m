Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7403FADF1;
	Thu, 30 Jul 2026 14:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423422; cv=none; b=PCw62tfHtrbzorKHE+EnbMvtkUbRuh82fDB6Y52T0xFuyFHWPL8LmmOz0N7ver57SsxLSuLOpGzqAoqHVfx6pgHZmJOtD3oLPe/X4UEomo9ekW02nq6jk7XykMLv8P68pRR0osGTF+Ou7FxkrU7NBpp6QWVGNg2jLcBFQmNcmMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423422; c=relaxed/simple;
	bh=qz69b/88JpA0fAdzWp8RCq6nDm2GB2B7fkYINScm4Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xos1FY7raVTk+/knCR9TiGq7Jiavc0phdKPcBwxMVaUaR0raNRtIo0vWjGNVEdDAJykEWxVJKc/dIQOkN9rhnPPCMi86U8WebkaVis+SFwUYNEbgnqVUytdbAS6Anm9jUt9nR0KsaSfMcN5jwYOE6bCwMUJHgNQVALpEmqEviEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJYETHMn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJYETHMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61F31F000E9;
	Thu, 30 Jul 2026 14:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423421;
	bh=ZskH8yywm+X6gtpUHTyki+PGXbn2mM1pXCeteOhabuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJYETHMn8Rwu4P+8Q7Ekoj2t00IhIBxZJQB23UsW33SZP4DQdUVgqkLaMMKHakqJO
	 +4GgvIDPTRBMNQGE/B0C5F6ZLuctDlnPL1ylC78sVHoA/koYTuUdEVmb0IS63Z2bB5
	 N1uU+K4oBFxNif4feVtByVBk2O8gAaMIP06VqwXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 039/675] mtd: mtdswap: remove debugfs stats file on teardown
Date: Thu, 30 Jul 2026 16:06:09 +0200
Message-ID: <20260730141445.950094988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 66fb31358108d10245b9e4ef0eef3e7d9747055e ]

mtdswap_add_debugfs() creates an mtdswap_stats debugfs file under the
per-MTD debugfs directory, but mtdswap_remove_dev() never removes it
before freeing the mtdswap_dev.

Store the returned dentry and remove it during device teardown before the
driver-private state is freed.

Fixes: a32159024620 ("mtd: Add mtdswap block driver")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdswap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdswap.c b/drivers/mtd/mtdswap.c
index d8f2e5be2d315e..42ff7deace80c5 100644
--- a/drivers/mtd/mtdswap.c
+++ b/drivers/mtd/mtdswap.c
@@ -125,6 +125,7 @@ struct mtdswap_dev {
 
 	char *page_buf;
 	char *oob_buf;
+	struct dentry *debugfs_stats;
 };
 
 struct mtdswap_oobdata {
@@ -1262,7 +1263,8 @@ static int mtdswap_add_debugfs(struct mtdswap_dev *d)
 	if (IS_ERR_OR_NULL(root))
 		return -1;
 
-	debugfs_create_file("mtdswap_stats", S_IRUSR, root, d, &mtdswap_fops);
+	d->debugfs_stats = debugfs_create_file("mtdswap_stats", 0400, root,
+					       d, &mtdswap_fops);
 
 	return 0;
 }
@@ -1463,6 +1465,7 @@ static void mtdswap_remove_dev(struct mtd_blktrans_dev *dev)
 {
 	struct mtdswap_dev *d = MTDSWAP_MBD_TO_MTDSWAP(dev);
 
+	debugfs_remove(d->debugfs_stats);
 	del_mtd_blktrans_dev(dev);
 	mtdswap_cleanup(d);
 	kfree(d);
-- 
2.53.0



