Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5587038D017
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302195; cv=none; b=AIzcW5clkOBSh9oiQtlEDL505jiMIS9jhrWt6jN8zCAPNehbpxmE9umc4pgwBZiFByo4xyjO5CVZWbkXx5VqqxLBw8Qcn5oEqcs/IdZuS/UVzr5crwDHzuiI0ruolHtfikNZdKz3iklVI957a8o2KzxVnPOed/IqWDi7lFJtnC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302195; c=relaxed/simple;
	bh=N9aJjbHiRYqPmIkz4MN4GJKNYORZ8zi12Zo4yferKJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0SsdgD1wq4QmtvdlYq2coRek7YArfkduI04NBc3CIORieBAXpBfas3eHRFwKKefQAPZD30waRObXEO1qaHRcZAL48wz4HqwdLrs9X65lCZsp3Ad4x1YkycD+mg9S9RwCEc7t6LITp7c15HvUjtN7B3HIrgf3WW/SgtnSBD4ZDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eoDlcunD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eoDlcunD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C68C19423;
	Sat, 28 Feb 2026 18:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302195;
	bh=N9aJjbHiRYqPmIkz4MN4GJKNYORZ8zi12Zo4yferKJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eoDlcunDMlVm1F3OYgObnQlsEHmfnN0ArOJuHVC5NuSRBO9HK79Md3c4U0P/aSEwS
	 uR33Az/Q7Vd5dVz8/BknfsdAW+2q9NMjS9ORLcISm5+KNoHr8UU4oBfuVvNgfCCau3
	 C4J8Wp0RIe/4yJq/vhpbtTc8Mc3VR6rpdJiSBMvWUU/Oe7ImNRNG8cy5yBU19G5ACq
	 Jg7paCeUDhmBjdTFLgw5okmAIA7JKFg4LXst6K6e6UKBSRI2R0XKNnVV2Ef6sckjvd
	 q0r2H8OHX6qhasHZgdo4D2CVMVOGh/nxAURSQ6YYjgqLjhZLgL9I/WkMUBliQmHlKf
	 Bez7po8yuZrmw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yuxiong Wang <yuxiong.wang@linux.alibaba.com>,
	Huang Ying <ying.huang@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 198/283] cxl: Fix premature commit_end increment on decoder commit failure
Date: Sat, 28 Feb 2026 13:05:40 -0500
Message-ID: <20260228180709.1583486-198-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Yuxiong Wang <yuxiong.wang@linux.alibaba.com>

[ Upstream commit 7b6f9d9b1ea05c9c22570126547c780e8c6c3f62 ]

In cxl_decoder_commit(), commit_end is incremented before verifying
whether the commit succeeded, and the CXL_DECODER_F_ENABLE bit in
cxld->flags is only set after a successful commit. As a result, if the
commit fails, commit_end has been incremented and cxld->reset() has no
effect since the flag is not set, so commit_end remains incorrectly
incremented. The inconsistency between commit_end and CXL_DECODER_F_ENABLE
causes failure during subsequent either commit or reset operations.

Fix this by incrementing commit_end only after confirming the commit
succeeded. Also, remove the ineffective cxld->reset() call. According to
CXL Spec r4.0 8.2.4.20.12 Committing Decoder Programming, since
cxld_await_commit() has cleared the decoder commit bit on failure, no
additional reset is required.

[dj: Fixed commit log 80 char wrapping. ]
[dj: Fix "Fixes" tag to correct hash length. ]
[dj: Change spec to r4.0. ]

Fixes: 176baefb2eb5 ("cxl/hdm: Commit decoder state to hardware")
Signed-off-by: Yuxiong Wang <yuxiong.wang@linux.alibaba.com>
Acked-by: Huang Ying <ying.huang@linux.alibaba.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260129064552.31180-1-yuxiong.wang@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/hdm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 36b20b844b109..f9738c863df0e 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -710,14 +710,13 @@ static int cxl_decoder_commit(struct cxl_decoder *cxld)
 	writel(ctrl, hdm + CXL_HDM_DECODER0_CTRL_OFFSET(id));
 	up_read(&cxl_dpa_rwsem);
 
-	port->commit_end++;
 	rc = cxld_await_commit(hdm, cxld->id);
 	if (rc) {
 		dev_dbg(&port->dev, "%s: error %d committing decoder\n",
 			dev_name(&cxld->dev), rc);
-		cxld->reset(cxld);
 		return rc;
 	}
+	port->commit_end++;
 	cxld->flags |= CXL_DECODER_F_ENABLE;
 
 	return 0;
-- 
2.51.0

