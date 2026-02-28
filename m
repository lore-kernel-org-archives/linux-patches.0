Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564EA2DB7B2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301861; cv=none; b=P5Bdv1KGhEZpue3l6T2qwQj/Hm9my5X2iMi5D7vnrN7jL+RFJJeAUrloBz/YGVJF1GCOy11q3jJtKAKB1K2nCoN9D376ODyWvImupMf5I62vQYWkxpMZ6NC5P76+jaBGSQq+Ssvh3K0EJEcbxKOWSduZlQyGOSoxSyOtcr+7Sqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301861; c=relaxed/simple;
	bh=kRxxJWKQhbqPKRpnRuJWLaf8Pyt0dE9rzzfWoiTfIq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORgOxXxFnXy9qgx2D1EbaJxl4bGq6IVU/w458MtMea4ALOkNRmk/BMaEw5VqvX5DQRg96AhSLMUF6i8aKpcP0tstigT7itapBuODpwuxoPa5Grw/fOKOACdg+VVNIu4fpoV1lOWdBHlgugDcDtLpn+wOTKOBywSz9ePNhiKNk7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ja8Mw7Sr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ja8Mw7Sr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A8CC19424;
	Sat, 28 Feb 2026 18:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301861;
	bh=kRxxJWKQhbqPKRpnRuJWLaf8Pyt0dE9rzzfWoiTfIq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ja8Mw7SrLFcpYKsE8/TZAp9bUUlrBOV0OhfC1cckL5y0T1FITU/DSzGWuE31OubqJ
	 Xl3HapMw6KUDnLbWpTsUyb9M4cpSVCTVYt/KWWLUlbGwKKVZcblgqjGrA83uFH1G1L
	 Y85AzxwaIhKZ+wh5lDpPpuG4+IHGzQMImJZB6i3lG0VJ28dAwYyrJKqGxpgC7OzaV4
	 Cfo2UeezS6G7kv1QS/gwcPPOXOPzFTeI4Z02zaxA8VI5kVTFg+hkr5XaH4DysKy24a
	 GcWaApFMVKh0fADXtZaeOzo/r/WKLpDFY50QyQ+M/popGMWNWozzkzizcmcA2eRsPC
	 EPZeN2HdsCyWw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yuxiong Wang <yuxiong.wang@linux.alibaba.com>,
	Huang Ying <ying.huang@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 283/385] cxl: Fix premature commit_end increment on decoder commit failure
Date: Sat, 28 Feb 2026 12:58:25 -0500
Message-ID: <20260228180011.1568201-283-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 223c273c0cd17..fde609f37e562 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -699,14 +699,13 @@ static int cxl_decoder_commit(struct cxl_decoder *cxld)
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

