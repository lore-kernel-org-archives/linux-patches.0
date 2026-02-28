Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A562D359A8F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302422; cv=none; b=GE4vDXemjOiRf/B22eJrFJnCY80PydElCDMy5p0pfExsvLdzxXDasKMBoanbayoQJOrN3m4+HtpqUI8Fq1hUdqHHd5xWrdov3cUuJLp1V8TiSFserL0ve9/He++Ea1wE5J4S6MZEzf1WmGiSAA+cs7QzIGEOW31nXlEfdVJ2KgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302422; c=relaxed/simple;
	bh=QJaVYNEG+QvduxMROx+IcwQrVSurRydmcyqvqGSq0Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFU2CG7glCFbRLa4m8pSn1HW+EWtqMxnKpdezBm+QgtirsKxAfWEkA6zqGeFzDxuWuly3bwpcv2lwdUm/ex7Atuy56HY27A40IQ91sQ7VI6RGIB+sqvTy5m8N5zqWyCmQrZDdvDU/Y3+G42bfXt7iCryk9cslgxQ3bBLEhyRD+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ANhEB435; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ANhEB435"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1BEC116D0;
	Sat, 28 Feb 2026 18:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302422;
	bh=QJaVYNEG+QvduxMROx+IcwQrVSurRydmcyqvqGSq0Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANhEB435SqWCqg0Axg6FRGsS4ecl0kBLQ8bL4RkqE+5Cu9846lemb+CggApMHIu61
	 hQOnpxEO/rzGUKgxbGVn3b9PEMflceK5wccdt3eWIdTC76Fzag9bIuxvOkawQOzBsA
	 OUW1LlaIr5uMxLWl1VgdXIZyKSkSGEz5tmZ449NVztN0CtaE05DoCYskTT9Gy/VXpw
	 XlpVyYavHwdlq3sDrBzFFS2xdB0cWkFkk5wlWQ73XJDdi0C2S2FwwasznBYXVXcFcu
	 OKBF9f/ovwLyQJXoBrvgPsT2hILzaZ8g5YBY0s0gMDsqebDv1Pz204C/lGTcH8DXE0
	 Y2IXKfVn6FaFQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yuxiong Wang <yuxiong.wang@linux.alibaba.com>,
	Huang Ying <ying.huang@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/232] cxl: Fix premature commit_end increment on decoder commit failure
Date: Sat, 28 Feb 2026 13:10:11 -0500
Message-ID: <20260228181127.1592657-158-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 8c1db4e1b816d..7d48f5a575ceb 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -628,15 +628,14 @@ static int cxl_decoder_commit(struct cxl_decoder *cxld)
 	writel(ctrl, hdm + CXL_HDM_DECODER0_CTRL_OFFSET(id));
 	up_read(&cxl_dpa_rwsem);
 
-	port->commit_end++;
 	rc = cxld_await_commit(hdm, cxld->id);
 err:
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

