Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B52373128;
	Sat, 28 Feb 2026 17:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301508; cv=none; b=dWmsY+0ET9b7yiGIAEag2S4LvimzhlC9JUyLRB0meGRI1ifEgyiPNHqUISLnKO3oP379zSsD6bjsrR+LTF78ks0R9NQMbIa2ceChfk/686SCvlkL1P/I06m5r8cAz4h22Q0UDQYIpaZjH/OmM0PW5AB0DkssMiLbtIconFrYseM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301508; c=relaxed/simple;
	bh=sVKXGti/1tHXqLvuJLqu4mRGLNaVilAoFO9v0XPvu+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9SZ+LQdSFhG3mEsnP665Obx+8XSMxsAP7lTIbjuqcUb3DDWbsIDXEo6KSS/h1puNvlCmDgtJW7seA1bQvZ5sRxovcCezEcys2rh2bas3CSA8RTZHrh/atMF1mIWzRfp71s6GaNYabI58EclaNSr+o0ljuV0EyyjttfBXBLpEyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTgzk/fz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTgzk/fz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D028C116D0;
	Sat, 28 Feb 2026 17:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301508;
	bh=sVKXGti/1tHXqLvuJLqu4mRGLNaVilAoFO9v0XPvu+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTgzk/fzCm7xk+Fh3m4TQkNDtPpBPiCt7H+KFYDjPkodxHL5eyTRy53RhGbcBaVbY
	 gKZ3WzFeXkjJ+8SWwIabWzC+a537WZ8IUxjA0D8BekHG3mmLXptwLz2SdNvZkOZOjv
	 1DCs37VAt3g3za9VCcNWW55GOKBQHVHhwBxikcvAU9RryWqx8UBj0MQckPD6Y8cJ/s
	 ZPmWcYvyMUTN7kQqBrXV0Diq6qIezP/3b2QmE2HZy+TGyadwFcPjjrbK6+nBHwvTtK
	 OJ0A1iPyAHRafaieqMHB4YXNj49HMoooyWKDiy44tyyPkHiFOmLB5889xg/OluqN5C
	 XEyugKoiJ+5pg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	stable@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 693/752] net: wan/fsl_ucc_hdlc: Fix dma_free_coherent() in uhdlc_memclean()
Date: Sat, 28 Feb 2026 12:46:44 -0500
Message-ID: <20260228174750.1542406-693-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 36bd7d5deef936c4e1e3cd341598140e5c14c1d3 ]

The priv->rx_buffer and priv->tx_buffer are alloc'd together as
contiguous buffers in uhdlc_init() but freed as two buffers in
uhdlc_memclean().

Change the cleanup to only call dma_free_coherent() once on the whole
buffer.

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Fixes: c19b6d246a35 ("drivers/net: support hdlc function for QE-UCC")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20260206085334.21195-2-fourier.thomas@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/fsl_ucc_hdlc.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index f999798a56127..dff84731343cc 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -790,18 +790,14 @@ static void uhdlc_memclean(struct ucc_hdlc_private *priv)
 
 	if (priv->rx_buffer) {
 		dma_free_coherent(priv->dev,
-				  RX_BD_RING_LEN * MAX_RX_BUF_LENGTH,
+				  (RX_BD_RING_LEN + TX_BD_RING_LEN) * MAX_RX_BUF_LENGTH,
 				  priv->rx_buffer, priv->dma_rx_addr);
 		priv->rx_buffer = NULL;
 		priv->dma_rx_addr = 0;
-	}
 
-	if (priv->tx_buffer) {
-		dma_free_coherent(priv->dev,
-				  TX_BD_RING_LEN * MAX_RX_BUF_LENGTH,
-				  priv->tx_buffer, priv->dma_tx_addr);
 		priv->tx_buffer = NULL;
 		priv->dma_tx_addr = 0;
+
 	}
 }
 
-- 
2.51.0

