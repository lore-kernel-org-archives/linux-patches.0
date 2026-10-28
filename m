Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209923;
	b=UN53Vo/PcOV5srvgtGjgfardHm9dA99cGL9ial0DLALGIRreNthgjLd6JW1gK28ziDxT
	 fuE/FP/MVfXl1L6T8Mr9x4LBzgESsQAwnI9Ir0xhsdGQcQi1buC6M44wavMn68JUVbauU
	 aNeYeoG9idBAU1NEI48vnpHsj+zUtLJ9pewd7gUC3x5QDI8jjA7stBxNzcie6sMqiBig5
	 si5wZ/EheVE0NW9ICK6TujN1zYyEIx1VC/+cuWWmk/qpTqLmXwAmyLP6kNirdMJBWADyO
	 o0x39TRdHI9VTaP4Yg43c5dokkYqZIHuBNE7tn48yf4TJgZR5JjMTaPp2tvkqDNGZOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FRb5BIutP0rODDuIZehqBoD05QwuPjp1VaYvrs2iL6c=;
	b=qxoL0CiLLNLWud0TFwv1FNs+UxG7zETTym5kcm+2Eu9HZPlAZ/30wYefks9va92T2vqa
	 EzlRypz1DxPgxOZ1DQYpDAMOQnRqR8ziRmgZZtdZezUskO2Wo9T2HND0rCrVFn9GvBW5w
	 /+hml5cdNS5z8LP4qqjF+6hpIrx5Ik1bv5sF5dZC/68ksEWA8WTX1hf6iM5pnUkh3rc5+
	 J8vVvkFNNXPrYNWHKdE0E41EAJRwz7BwoOR4QkabYpb3E3wbBZUrRsj+XDY79e+5egqjw
	 sY2Q48U/BLeLsx/OD3hbKJit2uN4PcYk6jTtyRcJqKOy+A6H3lN4CKgUZ2sNU6GrasA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HSBG4Mhz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5824606A339;
	Wed, 28 Oct 2026 17:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HSBG4Mhz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19CA1F01825;
	Wed, 28 Oct 2026 17:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209922;
	bh=FRb5BIutP0rODDuIZehqBoD05QwuPjp1VaYvrs2iL6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSBG4MhzahAcOK0kwSW66FqPBmYWdLIUK+EFywwkhA5b+Wcp9qW73v2krbMnbedMb
	 K90MsqmHlFbx2umGOiOYTSeLg/vSrkMntrLn/eWBCY7bgpIQXglns23flgBC9dUPhp
	 zggDwlpBPq5n9ruTFVJ6tjtIJl/zTtwehSr5ok3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/168] ASoC: stm32: spdifrx: fix synchronization state check
Date: Wed, 28 Oct 2026 17:59:11 +0100
Message-ID: <20261028165943.458445028@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 0936bbd35a247665c64886135835faa3c3f4f29f ]

The interrupt handler uses a logical AND to check whether SPDIFRX
was in the SYNC state before clearing errors. Since both SYNC (1)
and ENABLE (3) are nonzero, this also treats ENABLE as SYNC (and
any other non-zero value that might be added).

The logical && basically just converts this to check for != 0.

So errors occurring while SPDIFRX is enabled cause the driver
to retry synch instead of disconnecting the PCM stream.

Fix is to change the logical && to equality (==) and only retry
when exactly in sync state.

Fixes: 0c93c291321f2 ("ASoC: stm32: spdifrx: retry synchronization in sync state")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Reviewed-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://patch.msgid.link/20261011035459.2289403-1-thnkslprpt@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_spdifrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/stm/stm32_spdifrx.c b/sound/soc/stm/stm32_spdifrx.c
index 4e17909d21267..4c2ff09971635 100644
--- a/sound/soc/stm/stm32_spdifrx.c
+++ b/sound/soc/stm/stm32_spdifrx.c
@@ -728,7 +728,7 @@ static irqreturn_t stm32_spdifrx_isr(int irq, void *devid)
 
 	if (err) {
 		regmap_read(spdifrx->regmap, STM32_SPDIFRX_CR, &cr);
-		sync_state = FIELD_GET(SPDIFRX_CR_SPDIFEN_MASK, cr) &&
+		sync_state = FIELD_GET(SPDIFRX_CR_SPDIFEN_MASK, cr) ==
 			     SPDIFRX_SPDIFEN_SYNC;
 
 		/* SPDIFRX is in STATE_STOP. Disable SPDIFRX to clear errors */
-- 
2.53.0



