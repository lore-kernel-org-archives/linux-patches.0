Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211707;
	b=D7FLWwsvWWQIAd6vP37Ixx4jaOc4HeGG91aa/224SbsQULh/omWDVy9I9SzUz6uWzhg4
	 nyzCvTUpUsSFUZfHVD6Ze3Gi2uJDRZ/vjqG8C1koktxn7svGmBt8ZxYuZqfg+viqMKB9L
	 YkzM4YfiKtRUZ0UzvNUlCryWijuN73Z18aKW4qydsJMR4uGZsxhK0l9jxVUho5CYJPlGg
	 1yZ1X2qmhcCSQbIvmazQpxwP4w93eWFQR55uXECNpT3g7/4kSHEvDh+zn0Cb32Cad3v2L
	 NffLGPwsfA80ELNJItcBhwY9ui+hYwtE2sovp3qeuaE6y3lsK3DA+oV/rGgg5CvVcyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3uHPoqd68Wu1cnWR2mrRu9NIoN4r//RteY3sAOxNq20=;
	b=hkZc7L87MhHnz4x3EyXpBfszd/SIvhMPkerTCUBdZbuJ7DmpgPtthbXFYiWMPST//Ggb
	 UU2QPCuOzbiMX+09Z2rCJdsXjCLlCrp3HhrrkCj2gMK5Ll9yE5DAIfSLbWyWI0MOTCD+9
	 W/1/NxdUHlcz+M0TqkU4G9QsoZRWgDIrNAhlNtsXFT46BHFEOrc0oPj0X90F3jWtHLGAu
	 K8FnuqD2uo8P9PJSZNeq6X91Dw85s0P3MVORkc4VFXbmdcLgrGkSO1u/F29WdyMnp74po
	 QMUT5ELMlFf7LaCAo4Xt/bkClSlEkRSfMAB3IL5wP2pIdcWkSHgQ1mf/TfQwDXSn0Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IMS7mr4H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A282B606A33D;
	Wed, 28 Oct 2026 18:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IMS7mr4H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5B51F01825;
	Wed, 28 Oct 2026 18:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211706;
	bh=3uHPoqd68Wu1cnWR2mrRu9NIoN4r//RteY3sAOxNq20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IMS7mr4HydfPUccLPtspfW5QmVJ8Sej5ck3jRKlon+ScL6jzMraFJakiqUi1DwC4Y
	 IPkqiYETgZxiIMzub6gTD8vkIIXyG0m2YU3fgreDMhOs2UZ+e1WvlTG4alX66hplPs
	 48irkgFt60q9dTgWPwRMguc7juj8CNScqawcaMjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 473/571] ASoC: stm32: spdifrx: fix synchronization state check
Date: Wed, 28 Oct 2026 18:00:20 +0100
Message-ID: <20261028170019.244800377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 80f7761cbcb7b..441e2a7c3daf1 100644
--- a/sound/soc/stm/stm32_spdifrx.c
+++ b/sound/soc/stm/stm32_spdifrx.c
@@ -727,7 +727,7 @@ static irqreturn_t stm32_spdifrx_isr(int irq, void *devid)
 
 	if (err) {
 		regmap_read(spdifrx->regmap, STM32_SPDIFRX_CR, &cr);
-		sync_state = FIELD_GET(SPDIFRX_CR_SPDIFEN_MASK, cr) &&
+		sync_state = FIELD_GET(SPDIFRX_CR_SPDIFEN_MASK, cr) ==
 			     SPDIFRX_SPDIFEN_SYNC;
 
 		/* SPDIFRX is in STATE_STOP. Disable SPDIFRX to clear errors */
-- 
2.53.0



