Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EB42D6E58;
	Wed, 25 Feb 2026 06:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002624; cv=none; b=QWSLhdQVptOGrum8KtyCbUEHqd30F40m7Ju4j/mZytHJUk+mbVhPvRVdtlIBeESnZ382c4wqb3CPujyll6BknWxopcljg6m7EPLacNNFdbOLwtS0RCSvSReB3FTWFaGN2Dof6On+Ym6bs42NOnm3G8DLbftNV5gOS4zWiYFBy3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002624; c=relaxed/simple;
	bh=IH2u9ka2MFnpO/L260oqPNJ8NPOypxY+USFgdJwmthU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQ7czjguSBVppeEPairRns3XQy1PeeHfu/hJa4+aEOQr4GrBxhlW5dbm7LXJb6gONezpK1mRM5Tgk5NVYOBE1e95Y4L0Zmb/3oIR+qdKmfFudhEKYRKQPyGrjVxILR25qfcRbE9f87zt4O1sJH3ziSZk9Hm+HiIeJlxoK9z2nOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bb8sYd3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bb8sYd3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3E9C19422;
	Wed, 25 Feb 2026 06:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002623;
	bh=IH2u9ka2MFnpO/L260oqPNJ8NPOypxY+USFgdJwmthU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bb8sYd3pXBKEX17wCxralKWemreWN319cElZw5Rn6QbdyEXk4xov+/a7YpjrqxKkW
	 PMrloqNPG7gsKS8xA1+YI5kcOaN4HtgxjBhCFVgoBQ4lDe8UBoNC9aIuHZV9B9HP+k
	 Lx7vk5LniKB8j5m5wO+srqh46xM2jJk3yPJWWJro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuxiong Wang <yuxiong.wang@linux.alibaba.com>,
	Huang Ying <ying.huang@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 383/641] cxl: Fix premature commit_end increment on decoder commit failure
Date: Tue, 24 Feb 2026 17:21:49 -0800
Message-ID: <20260225012357.871335043@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 20dd638108062..13dafac7c6d56 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -844,14 +844,13 @@ static int cxl_decoder_commit(struct cxl_decoder *cxld)
 	scoped_guard(rwsem_read, &cxl_rwsem.dpa)
 		setup_hw_decoder(cxld, hdm);
 
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



