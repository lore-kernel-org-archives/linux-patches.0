Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD3E78C61;
	Mon, 15 Apr 2024 14:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191196; cv=none; b=caeMLTESc8ApOnbBDvuVkXnntusutIwvJvceuXbIt9Ie2F+rKV8Ed8ibN7uVlJjYjtZ6SPqksuHLVEeyHvmLv+Py5zF9966sCr+2HYaN6EWJ9Ddiymo1Sa7VEz9BSEfn7xkSmS9mIeaPrPn2AqHVeZh4eSG33awBtaaZ+u1m9n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191196; c=relaxed/simple;
	bh=wu/NLwf23mrIqbAxcN3f4Re/mNXvbkRLKceAvRpIHSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/HBRKTNbF5MiqU9oiguAfWzQO9xUqSuhJ8YtWJSt5HZ42Kw3N4aVmln8OxGnoNG0F8KaYNs+eHWlsVhoECtDpMAA1BT7Qcm0DalkRb4Nq1EKNUgPekZaNBzpdbycmnfRGw0fgSrFLFv2aJdLKqpzX1DjP1bmNo6VQahKM0WCEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmWTATgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmWTATgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10598C2BD10;
	Mon, 15 Apr 2024 14:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191196;
	bh=wu/NLwf23mrIqbAxcN3f4Re/mNXvbkRLKceAvRpIHSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmWTATgwTzKtNZE7UHBaYjnbPlSvLJKQWiCgzo1NJvEE1FgwamLETOohzg3dTLXd6
	 sl3RiYWVdzUfG1WgYz32GKt9MZG+St9SH/tmftcVvnCDP45/eOCMo33YeXWgfOME8o
	 lMYVzTB0lnP7iMMf0YplemIHo6NOC08PmLHTypVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 065/172] octeontx2-af: Fix NIX SQ mode and BP config
Date: Mon, 15 Apr 2024 16:19:24 +0200
Message-ID: <20240415142002.389155961@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit faf23006185e777db18912685922c5ddb2df383f ]

NIX SQ mode and link backpressure configuration is required for
all platforms. But in current driver this code is wrongly placed
under specific platform check. This patch fixes the issue by
moving the code out of platform check.

Fixes: 5d9b976d4480 ("octeontx2-af: Support fixed transmit scheduler topology")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Link: https://lore.kernel.org/r/20240408063643.26288-1-gakula@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 66203a90f052b..42db213fb69a6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4721,18 +4721,18 @@ static int rvu_nix_block_init(struct rvu *rvu, struct nix_hw *nix_hw)
 		 */
 		rvu_write64(rvu, blkaddr, NIX_AF_CFG,
 			    rvu_read64(rvu, blkaddr, NIX_AF_CFG) | 0x40ULL);
+	}
 
-		/* Set chan/link to backpressure TL3 instead of TL2 */
-		rvu_write64(rvu, blkaddr, NIX_AF_PSE_CHANNEL_LEVEL, 0x01);
+	/* Set chan/link to backpressure TL3 instead of TL2 */
+	rvu_write64(rvu, blkaddr, NIX_AF_PSE_CHANNEL_LEVEL, 0x01);
 
-		/* Disable SQ manager's sticky mode operation (set TM6 = 0)
-		 * This sticky mode is known to cause SQ stalls when multiple
-		 * SQs are mapped to same SMQ and transmitting pkts at a time.
-		 */
-		cfg = rvu_read64(rvu, blkaddr, NIX_AF_SQM_DBG_CTL_STATUS);
-		cfg &= ~BIT_ULL(15);
-		rvu_write64(rvu, blkaddr, NIX_AF_SQM_DBG_CTL_STATUS, cfg);
-	}
+	/* Disable SQ manager's sticky mode operation (set TM6 = 0)
+	 * This sticky mode is known to cause SQ stalls when multiple
+	 * SQs are mapped to same SMQ and transmitting pkts at a time.
+	 */
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_SQM_DBG_CTL_STATUS);
+	cfg &= ~BIT_ULL(15);
+	rvu_write64(rvu, blkaddr, NIX_AF_SQM_DBG_CTL_STATUS, cfg);
 
 	ltdefs = rvu->kpu.lt_def;
 	/* Calibrate X2P bus to check if CGX/LBK links are fine */
-- 
2.43.0



