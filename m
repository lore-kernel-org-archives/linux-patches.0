Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842DE46D57A;
	Tue, 21 Jul 2026 15:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648625; cv=none; b=qbiwUGteqkZtkK8DCnjLRF3ys7OuK3ms2k3QLdX4kT6X/RoWW0sN0TD4cwkMBg2A0JH9DE3gNehRfn/pIeR8VPoIYds0oZselSXJvUpdPGFFRQYGlxfcmZi1p3DVyf/zMceZqYdRIOrKxHenlGXeEkDaOW5sWsbs+Qoui2NOO6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648625; c=relaxed/simple;
	bh=aN7h45aAROV/pZoOahu0JuQOcUgukCKwq5QlWQ+opeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvlJ2Mvu5nSnRnfnSCVJAOTfnSlj92mH2f3wojI1r7PgxpmD6ED2JCheF6ggkYnGAq2RfzFUjXE4tDykhkkuICgSVQ+UmgkDA8L5XUpJJZsDM7AsQpvx6PBGXzRYO7SMrIc1cYBd+gZV1tbXfj7vJ++VQOTr/1g4gol5grEmr4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdvJs2aK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdvJs2aK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACF21F000E9;
	Tue, 21 Jul 2026 15:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648624;
	bh=SV/5jVwKTUE3zKDNhXIqmXu60A850ozv/hH3l0LesuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdvJs2aKdXsZSiFTcxpolUekdB0lbAyKaY72VUYsKMAbvbZ8623O6o79vEaa97OK9
	 2cy2tX0hYnD0sCCwd/ahtbCXj+DG4xGBGCy/MYrFzrfRtAZH0cJLQJXA4eox1Ty8V4
	 daOEjHZ5auxelveCQFDdpUnM4x6Gu9Wa0S9dd/+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0226/2077] RDMA/hns: Initialize seqfile before creating file
Date: Tue, 21 Jul 2026 16:58:19 +0200
Message-ID: <20260721152558.010064446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



