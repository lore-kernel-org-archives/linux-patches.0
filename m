Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216871;
	b=Zwwx2HslN/Gp7zSJmwuF1wUF+SdsMbR3KvSRXaXk7LgBJEAGnQwi2RzfzSLhePqFjBOe
	 GF3TjF/ceJrYMUZpWqKnKe8yuvCxtb0h01aO2/mIDgYF9ifPn/xgsZ33PDlkt4QHFApgK
	 fRAzja8X0EvgdaQvijtKGsV1wvXcaaUf8Svq/fD9GHu/S2OAB7xYctJbnEAA5rzEO0sam
	 47x1FKbJ0nFqHEy+HJZ1PCxestP0Pw8kTmWQB+zoJVod74OvAgtdsFzCmjpV+AS0zygQ1
	 wrRb9oJoFDYR6zDaK/qR5GixheRFrUfOUiPbH5ne1iJ1R48WRW8HPs46eJXKjuFF6Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p5N80+Wlmrlnn9yjCMECop0qER29FSo24DD6T0rymME=;
	b=RXnMGDtFWaiCVjhVIZmUQuDRAm28nDc5fIYJzSXyAZ8a4cS1h2s4EZZ5LiSPBPyzZ0jg
	 QO6Go6SdRWEOpOmU67VJK3Dr7G8oioBrHH//2O8bz451ORu44QaepOMC+djhYbJpbHoOu
	 rLmsIbl2b14jg98ovSA9jYDty5I6uxfTzU4ilkigAF1KAbuYJrIy1tVGeZBzMQIMe5Ggz
	 bai434VLOs4fm1hm5D4axI870fEdodjjLnWeG2M86pAkDCAqbkFJlwM4VxXxk84qd8QD6
	 8csn+Jc56+Z+TQNVS4Yt9xWe7jOEqaXVrbMJS5tEJjVo/NSoVgfQaKEAUuqYefZbzGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ojsdjRd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB41606A320;
	Wed, 28 Oct 2026 19:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ojsdjRd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEF51F01825;
	Wed, 28 Oct 2026 19:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216871;
	bh=p5N80+Wlmrlnn9yjCMECop0qER29FSo24DD6T0rymME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ojsdjRdRJQ/9G27yktBSv5ojw0Tv6ho5t3lr+rkIHZYye9oVTB+2Ori6Z/W5imkM
	 AR8GSOYJnKp4I3j8PvqtagVKNzC1bQbPL8l2/Uh5Vok3JNWjm2xnsnps18nUFjKOb0
	 OmqoDSzW1RF5bnEJ2w9TRunMyou1QZG9Xl0xMYCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1709/1887] ASoC: stm32: spdifrx: fix synchronization state check
Date: Wed, 28 Oct 2026 18:03:25 +0100
Message-ID: <20261028170538.348937466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e66382680e098..6caa6fd118e9a 100644
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



