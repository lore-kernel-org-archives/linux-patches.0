Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746BE443A89;
	Thu, 30 Jul 2026 15:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427042; cv=none; b=GOvDD/2oOLWaHpD5MM/JMnClu8mFlZKyy5kbLoIR+6+9HtyJ1y5om4nv2bInbXJWpvfLkxKzkXtRUyF2CuUUc4n4FwU208taI0iZyx3V0atg6Ls0HRtx8YLAP6BBVqWky+yHw8aXz5F3RiTAXcXV60NrnzqlLI4OegzokYSTpes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427042; c=relaxed/simple;
	bh=hXzu/PhEBXSN/mXcdF2s42/4/jETNLkeidZDmgVpjx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pj6JHdk1YAfZHbUr4p6QKoLLCw5rE621oBVOh3kW5cz0J2vu+xcsaejjdt+QG9YRLoOSKextdkV9HLeq5KhmWWfcBTTToEzUtG3gIPrp84/8jTOFfu789g9AX5i6zflEPp5BRmCqBCUe29QoWqcBXzF85+v4kYEn4dhJVFZ/SUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QR+0gNE9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QR+0gNE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEFF1F000E9;
	Thu, 30 Jul 2026 15:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427041;
	bh=G+pnrPfcUCo8dw2tqJlbPYIbqXdfrrhOkkNF8HUd5tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QR+0gNE9UYBsmT4dE4dL1LjYxwIEA28dHjdqLxGbUs0cvL6VUMmpDL6M8RZlJHYmK
	 Aa63bgc78nDaY2YNkTAu/ocV+shxaU8vwxdIUZW7YKeLW8r1kZTuMOrjrOwOLZ0o+s
	 f31chg7Afog8zHawolxvgGPLM0k/S1rCHoilpmNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/484] mtd: mtdswap: remove debugfs stats file on teardown
Date: Thu, 30 Jul 2026 16:08:48 +0200
Message-ID: <20260730141424.101968336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 680366616da240..4d695875ea1b23 100644
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



