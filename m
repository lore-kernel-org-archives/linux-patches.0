Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECDE427A10;
	Tue, 21 Jul 2026 19:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661596; cv=none; b=Mi6hNf+lFqx0H+Ckxw5zMafs+wxa8g/5oL/++F68LbICmyCeUPRGtE1O7LofWXUK3aiQ0OPSRooUwGU83N35klQC2z63XCxJ0/7obqmQDDHKO5ZU4bZgmvAkJZQPt2qa3ElmcAUchqqJ0zXV9yV0SKrsDpYPdKLDA4mAMX0enEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661596; c=relaxed/simple;
	bh=FCT0tnjnQzSvLUm6KjRNRsyF/rDt2cMmRKNqW93GPrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b78+NzkcJU1A9NUApD8ne54NAfxG2723ucCRmyM5YZMu693XT8dNmOAoqt1/rZdRK7GUETdOo5wMWJsFuqnqrlzUaOdyR31AI71owGGhp7nuGjf71EELg/HBS/8HIL7Nst2aHkXxzePSTpWlHs4ESOmC6T9N/RFoiqO/kzs5njg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQAI3Ste; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQAI3Ste"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44C71F000E9;
	Tue, 21 Jul 2026 19:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661595;
	bh=tbY7mIfWFfUtQ9MZzN6fAxG9LGZHnslFr4cmfjD8gWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NQAI3StevdSCOZHmlM9d/ict7AgoOLB1VUwqlWG+qkRJKXKpx7qU2T890nxtbEjy8
	 TPDrwJiSvtHKZtLv1Srb0H6OOcNJ7IEo2ZMVd92hGsIZlKJBjY5OKHdoXlrgHfJMBV
	 ALomyhafb4GFoEw1x/tAOS234uMCPSaDQXRTY/SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0125/1276] RDMA/hns: Initialize seqfile before creating file
Date: Tue, 21 Jul 2026 17:09:28 +0200
Message-ID: <20260721152448.901936057@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



