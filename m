Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75345350A0D;
	Tue, 21 Oct 2025 20:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077462; cv=none; b=EAOZWgzTITjfvCJTt1wBBnUnJXI40jHwdp3HFRA1dJQFTGQsNGAbRv5Pj2IWkl+bGtWLcksvH04wSN/AsLXbzNMDgdcbNyS79LXgIV+SzhIVSLnziP/szSt6JHMVS3DprpBeEAHlgzwVAVd3wvbn3aGc7KQEjiRDPqmLUlRquFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077462; c=relaxed/simple;
	bh=R61AsS9x4HRrtUxdRKGumtIc87zynrMHHY1zbK+VDLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VB/8axmsETNu/qDBgMos64yxDuv4ub55OWvfMT/4xxFYH0FtjFkhhqUyEO7BYk5w4m8koVB1XC8XAD/LMZlcfgmdYNFDcF9z+4g+pPBolaLUCbFJzNCqgBI1JUY2DRt5VClxxarUlPzzJ4uLIRNyvOj8Q+FNA9PATkKU71HBIbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwr8UG1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwr8UG1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4900C4CEF1;
	Tue, 21 Oct 2025 20:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077462;
	bh=R61AsS9x4HRrtUxdRKGumtIc87zynrMHHY1zbK+VDLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwr8UG1o+RWiigKB++Acht3RAZag95FuhRS7/1j7yu3dq6CTbYu+NHh0e/SVFNQVG
	 TNOPDxyy2T18rsRZ4sRD6RBQ9Xw1dYAgjinT0pVI19fJiaDBXJp4orKBt/lsxTvPAF
	 tFGtKA41uaat8JSIAPh2h+KpGMmD17DQs1kwZEMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 113/159] cxl/features: Add check for no entries in cxl_feature_info
Date: Tue, 21 Oct 2025 21:51:30 +0200
Message-ID: <20251021195045.884300195@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit a375246fcf2bbdaeb1df7fa7ee5a8b884a89085e ]

cxl EDAC calls cxl_feature_info() to get the feature information and
if the hardware has no Features support, cxlfs may be passed in as
NULL.

[   51.957498] BUG: kernel NULL pointer dereference, address: 0000000000000008
[   51.965571] #PF: supervisor read access in kernel mode
[   51.971559] #PF: error_code(0x0000) - not-present page
[   51.977542] PGD 17e4f6067 P4D 0
[   51.981384] Oops: Oops: 0000 [#1] SMP NOPTI
[   51.986300] CPU: 49 UID: 0 PID: 3782 Comm: systemd-udevd Not tainted 6.17.0dj
test+ #64 PREEMPT(voluntary)
[   51.997355] Hardware name: <removed>
[   52.009790] RIP: 0010:cxl_feature_info+0xa/0x80 [cxl_core]

Add a check for cxlfs before dereferencing it and return -EOPNOTSUPP if
there is no cxlfs created due to no hardware support.

Fixes: eb5dfcb9e36d ("cxl: Add support to handle user feature commands for set feature")
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/features.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cxl/core/features.c b/drivers/cxl/core/features.c
index 7c750599ea690..4bc484b46f439 100644
--- a/drivers/cxl/core/features.c
+++ b/drivers/cxl/core/features.c
@@ -371,6 +371,9 @@ cxl_feature_info(struct cxl_features_state *cxlfs,
 {
 	struct cxl_feat_entry *feat;
 
+	if (!cxlfs || !cxlfs->entries)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	for (int i = 0; i < cxlfs->entries->num_features; i++) {
 		feat = &cxlfs->entries->ent[i];
 		if (uuid_equal(uuid, &feat->uuid))
-- 
2.51.0



