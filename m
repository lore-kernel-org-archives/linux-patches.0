Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB22C1F7558;
	Tue,  3 Dec 2024 15:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240206; cv=none; b=JOJvo8rUlUGJvINs5WFxDFzBk35flOZM6EzJBrc2fsjmPKFZlxCpQgh14k0K9/qmQwLYCHWycDoetuBl7N+hFluksaqgSUVnrp0FM8v+shxnOQ2SF3x42KhCxEO4I/zf3m40pHIAINcClhseeVdsLkjzwZxYX7j0ngSgJnoGFiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240206; c=relaxed/simple;
	bh=MGoM515IOjV8U+A8FzUpodHla6KuGcdRdahdpP3l/H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oA8EkAi/4bzMlhU9ykC02Amv1lsgux0V3rRlpFGnGDFyJkSrDBm3R1ovHPoUOQv8XxLqMz72/cF5p+5afHzFI/cuMq8gJ6dlbQydYMlZcZkMNsZzqFOkpWaJM6RLn4RfH4ivQFxTHiOy8iv7ZEMu8kVWz4pCYR5zp7KI50lgzKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZenMUZjk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZenMUZjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAA8C4CED8;
	Tue,  3 Dec 2024 15:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240206;
	bh=MGoM515IOjV8U+A8FzUpodHla6KuGcdRdahdpP3l/H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZenMUZjkfMHxEAoBZ7tVMVBaeLAZpMxyhDvjNDiIK7ks+Nn/aK+7eSLQ6r1MaGmdr
	 ytvcR1EpJkAs11VVk8RLzBErmVduIUQ1mUm3slAwQu9ie8UJE08gPu+e5YpYs1xfiB
	 UgGFGgtHkbC84gqyeYiw1OjyWkx0k2zfe4ifV1OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Everest K.C." <everestkc@everestkc.com.np>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/826] crypto: cavium - Fix the if condition to exit loop after timeout
Date: Tue,  3 Dec 2024 15:36:26 +0100
Message-ID: <20241203144745.774563335@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Everest K.C <everestkc@everestkc.com.np>

[ Upstream commit 53d91ca76b6c426c546542a44c78507b42008c9e ]

The while loop breaks in the first run because of incorrect
if condition. It also causes the statements after the if to
appear dead.
Fix this by changing the condition from if(timeout--) to
if(!timeout--).

This bug was reported by Coverity Scan.
Report:
CID 1600859: (#1 of 1): Logically dead code (DEADCODE)
dead_error_line: Execution cannot reach this statement: udelay(30UL);

Fixes: 9e2c7d99941d ("crypto: cavium - Add Support for Octeon-tx CPT Engine")
Signed-off-by: Everest K.C. <everestkc@everestkc.com.np>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/cavium/cpt/cptpf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index 6872ac3440010..ec17beee24c07 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -44,7 +44,7 @@ static void cpt_disable_cores(struct cpt_device *cpt, u64 coremask,
 		dev_err(dev, "Cores still busy %llx", coremask);
 		grp = cpt_read_csr64(cpt->reg_base,
 				     CPTX_PF_EXEC_BUSY(0));
-		if (timeout--)
+		if (!timeout--)
 			break;
 
 		udelay(CSR_DELAY);
@@ -394,7 +394,7 @@ static void cpt_disable_all_cores(struct cpt_device *cpt)
 		dev_err(dev, "Cores still busy");
 		grp = cpt_read_csr64(cpt->reg_base,
 				     CPTX_PF_EXEC_BUSY(0));
-		if (timeout--)
+		if (!timeout--)
 			break;
 
 		udelay(CSR_DELAY);
-- 
2.43.0



