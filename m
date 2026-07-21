Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F294B3F12CE;
	Tue, 21 Jul 2026 17:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655833; cv=none; b=YEpq7SOc9+lzTnK2Xtt8a9NuDyoZQJo2AVmjpJrsgpkX0MYhjuWfrGmWY2vKb+QvMek/iq2LWDY6dtUgYTnpwQ+dbOqw+BITyx3zphcExZIPBqxlSl8C/Umvd9bTJuYj5NyYmo2ItjGr7t2QZYTnPEJQ5OGHoedD0a4yVTx37y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655833; c=relaxed/simple;
	bh=86F31f0U+jvIKYw4W1OmInuDvTzx2c6H3sZ/gyLfFTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ezxud0BbZK14vRsZuYGdJI0Az8/B+tuGzvH8M7Daly60q3Pn6nrIxOqr5MNf48expR4N2wWDvUCMZnrLnQZZLCoWcZ2uQ3lvB3ewTNDgvsEoO5WH93OdnlRJ3jBMFryd8phFmXlf0VW66XYL818vl79mnKWwKkCNqbYoQZkoT8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jexFMd85; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jexFMd85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6027D1F00A3A;
	Tue, 21 Jul 2026 17:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655831;
	bh=Ays0FexFqyxM/vIutoEcsSda+Wi38qIwL64zghIxbeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jexFMd850DnYksLD6kfx7m/cJC94pgBWzcBdWEkHuhy/fpBxknIrGkvhjCWwfdQQt
	 BHZMdoIq3u0vwdFQDN/bci6P9MV02wPwccrR7QhVcr9lKMDGICKStEU0Vqe375U/zL
	 A/h7HjEGEYSYIUbjCqt8TPSBIeKnDuGU1AC4G9Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0159/1611] RDMA/hns: Initialize seqfile before creating file
Date: Tue, 21 Jul 2026 17:04:35 +0200
Message-ID: <20260721152518.458779327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit b4070770506ff516e21b4923afdaf7eb5da0e150 ]

The debugfs file was created before seq->read and seq->data were set,
leaving a small window where userspace could access an uninitialized
seqfile.

Move debugfs_create_file() after the assignments to avoid this issue.
Also, inline the original init_debugfs_seqfile() since it is not a
really necessary helper.

Fixes: ca7ad04cd5d2 ("RDMA/hns: Add debugfs to hns RoCE")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20260507012148.1079712-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_debugfs.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_debugfs.c b/drivers/infiniband/hw/hns/hns_roce_debugfs.c
index b869cdc5411893..db32c5897640fb 100644
--- a/drivers/infiniband/hw/hns/hns_roce_debugfs.c
+++ b/drivers/infiniband/hw/hns/hns_roce_debugfs.c
@@ -26,17 +26,6 @@ static const struct file_operations hns_debugfs_seqfile_fops = {
 	.llseek = seq_lseek
 };
 
-static void init_debugfs_seqfile(struct hns_debugfs_seqfile *seq,
-				 const char *name, struct dentry *parent,
-				 int (*read_fn)(struct seq_file *, void *),
-				 void *data)
-{
-	debugfs_create_file(name, 0400, parent, seq, &hns_debugfs_seqfile_fops);
-
-	seq->read = read_fn;
-	seq->data = data;
-}
-
 static const char * const sw_stat_info[] = {
 	[HNS_ROCE_DFX_AEQE_CNT] = "aeqe",
 	[HNS_ROCE_DFX_CEQE_CNT] = "ceqe",
@@ -76,10 +65,12 @@ static void create_sw_stat_debugfs(struct hns_roce_dev *hr_dev,
 {
 	struct hns_sw_stat_debugfs *dbgfs = &hr_dev->dbgfs.sw_stat_root;
 
-	dbgfs->root = debugfs_create_dir("sw_stat", parent);
+	dbgfs->sw_stat.read = sw_stat_debugfs_show;
+	dbgfs->sw_stat.data = hr_dev;
 
-	init_debugfs_seqfile(&dbgfs->sw_stat, "sw_stat", dbgfs->root,
-			     sw_stat_debugfs_show, hr_dev);
+	dbgfs->root = debugfs_create_dir("sw_stat", parent);
+	debugfs_create_file("sw_stat", 0400, dbgfs->root, &dbgfs->sw_stat,
+			    &hns_debugfs_seqfile_fops);
 }
 
 /* debugfs for device */
-- 
2.53.0



