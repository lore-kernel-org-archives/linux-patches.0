Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5081D5141;
	Wed, 25 Feb 2026 01:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983413; cv=none; b=lxGlCe/mXLaF+hd8ndzuGk7hNf0iyC03uod/zyzFbqsQIR3uZswS/qOkimss81qahbjJDiLe10YTkEEizshRiflqp7RbA66pmdVqPU/Ywz83v8ajG+Q4XgaVbvAAC02yJ0NIlza9y2+7hX1fJmgTAJ56a696JYR59mAQbGaVE2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983413; c=relaxed/simple;
	bh=/yKTmPzjxhs9pj/KUyMvpDPymtdk5Xxv2kt3aeuxUEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdTxUjNr9Tdp55NkDenHD9NIf/Xlqwv8NP8KsgP0+TJ5Yjkokfdc4ASKfVeNjBNiLN+My+b5GiStgiOYjTHgsYcAPkT6EQ1l0vJgGm2Rxrl77QxEhB/khjT+pfgM9lfmrmPweoLB7zNVzNAiOsX3v2bujtt97s1tMyvERaFP67M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAKRmXhw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAKRmXhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FC0C116D0;
	Wed, 25 Feb 2026 01:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983413;
	bh=/yKTmPzjxhs9pj/KUyMvpDPymtdk5Xxv2kt3aeuxUEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UAKRmXhwfIprcJDoNllCDRxVF86hO9K/EK8ZV5ObZqiCQThZDmU36lV8AP4ODn3ws
	 bvDXyvbp7vHRWqAv61kbPZGC4SwhUB41QHIs8sS7b2OgbHG8ZIPVWFz4Gx9hskzwle
	 F7/7MTthdmn04exAOdxnHSmG5TIWAt/+zVG0lQMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuxiong Wang <yuxiong.wang@linux.alibaba.com>,
	Huang Ying <ying.huang@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 490/781] cxl: Fix premature commit_end increment on decoder commit failure
Date: Tue, 24 Feb 2026 17:19:59 -0800
Message-ID: <20260225012411.825909331@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index a7ad730763e85..bc4b0c8607258 100644
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



