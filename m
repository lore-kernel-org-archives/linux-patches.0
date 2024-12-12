Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9E610F2;
	Thu, 12 Dec 2024 15:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018933; cv=none; b=e7NYdzLS8EarI9/FK9RNBWG6ZuMu9lqkSUdwrCa9V6Zryb0Vzo1yJ6DEpsph4c2bg33C8mySe4Kf4oWRswXZ5MJoGUTv+rAQAaapfVZ+r9tIKf/GLVm6RK3uzXu6JhI0QDCBXkKd/Lj9csdeTRGxYK7dsvf6/D50skRD+PQ1/KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018933; c=relaxed/simple;
	bh=7U1HIMHvqlv/WAEHD4yWQd1/vd2PFcdP268dmCJkWVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCMthw/s90kOT3vA0X+1CAuSlILfhnmQ9dslQbfqlkHRyCEG+E+CuqQ3215/5Xmp6c8LLd1feb4uLdGrpAbrS7hPdVE63j6IJ57IAl2poTcv3osLzhwGWkD4uHaCJCAZOU/Gx4M8uXKrzGZau6DnCfrUFLZnBHMOeLanN192280=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPsGd4CW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPsGd4CW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D97C4CECE;
	Thu, 12 Dec 2024 15:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018933;
	bh=7U1HIMHvqlv/WAEHD4yWQd1/vd2PFcdP268dmCJkWVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPsGd4CWBE5cUrfJas4pUpzpsbklaDSfHxZ2WWpiYKoVPENTB0s0ZXptxlCVaTpjC
	 0ck38Up3xVsJNT4EoHYSKwuFPA63p+jrs3GQwQyKPF/sg/bV4DgnPTWQz3w2lyxxQ+
	 qwKGx5k0nd8os/qeZSQJVVnNchY/OWrRoaB8IvMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Everest K.C." <everestkc@everestkc.com.np>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/772] crypto: cavium - Fix the if condition to exit loop after timeout
Date: Thu, 12 Dec 2024 15:50:19 +0100
Message-ID: <20241212144352.987564073@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



