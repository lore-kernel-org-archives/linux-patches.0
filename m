Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209316;
	b=ZIMEfhctNBZjnOxI5ixnl/cJJ32i9BB2LiQl1K9z0xUWNynXUcUSwNhTXxk5YLUdfDre
	 1DTJHY2ftL3V4LLkHgcT1OiCazHEao7hxJSZT/SWfo/kw3Gpczb/ko4ctT6buvCjmA+O1
	 SxhmYRqs3GHpr17gp6ik3sECbe4qyiotYjs5Od2npAAv0ziiIS9yMF24u3I72vhUxxB1l
	 kGSGCL4o1RSSuhRSCAslypnLgE4Db2C9EeBPIFlX8jViccHwDE3dfYuMtRqGbgJFIL0G/
	 /cuDgageBAP15DT3NupnoxJcyUhDQFEHW0cI0S9QQ1+W2MNUpZvCE0WQL+ALUD3ydkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hw5EfZVp+iC7t8D+GyQAxub68tUTGteojdec8m1rWo4=;
	b=Lz9JwX9vBBf062IkMqa8n9JBF3wiQl1GzRExs4ZluMMOHOAufgL0djc+9oMIgCmM3uzO
	 P0WFiiXIl5a+fNaHmiXilna6JGtL+IdtZYC5QEY1I72AgRCCnTOCtgXVlrOT4EcSgdQfe
	 BTv00KG9nCEzYNum0wDs6zjYxve2WiC8sCIOdmNlBRTGH57MenJyYRBJq7M+OVp1rfnlE
	 dYcfkrTklHN0UCIyB0NBAEVxG28gHzM58yHmKUqE7NFiLlnoxLaxuwulmabn1xTtM7yZj
	 7hBAtPDzN0j9QGy+S+l0lBCiyy5E6cBTGgljrx8X5u35taRZRmDSrbJShJVYNW7M9lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oz9VF67C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0811B606A31A;
	Wed, 28 Oct 2026 17:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oz9VF67C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140291F01825;
	Wed, 28 Oct 2026 17:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209315;
	bh=Hw5EfZVp+iC7t8D+GyQAxub68tUTGteojdec8m1rWo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oz9VF67CvRHXgG/JfM7rwjU3ImrPRysjcMad44PEADl1wn6RAPUZrobr4kCyw0HXt
	 kMFyB8jSM8Vur16PqBmSRZodPlrN/RnjyCeEa1D3c71r6rx4M3CNS4w5tEKxt1oqmp
	 mXwe0400zBNLKtEO5ciXQz1BBifKo0bsuHtIfMYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 429/516] ASoC: stm32: spdifrx: fix synchronization state check
Date: Wed, 28 Oct 2026 17:59:41 +0100
Message-ID: <20261028170013.648700929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2bf834800cc08..d9214f69fc675 100644
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



