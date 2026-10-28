Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207479;
	b=de+5vDYoQdBhlhLS2qby1ztqUf5xS+S9d0twvF6byTcFMFxdCGpRBlE+ZQE3710Or5l/
	 XaTQy13vXH7nTYDkMTOdUOHzZOmHgqnCGg0B7WEYrthE5VcNvHdjjb9nGnAvDM2rSA5Z+
	 nv10oVSwMgfRYLy1eFu0ZAcJiIZ5lqcY9uSHzqj+fwFgVMsdp3SXeH2Gphfjg2x4v6nEV
	 d4Zf9K00AifMDYyOEw3ZRQaPOYPtuzK2IkJngsaWl754NXWF5b9sYjJn+pddHx8p2oezK
	 NjH3PFiZ7cCOPu6QUbAOYRtikUdb8It6ewdW44wulAbRTWsw63FQQj8Nb5pnj+ki0vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yNPieXeWQo9ykkOgmrYXVtj2ulWCzN9SGPIw6G8VJT8=;
	b=IvImN/kQy0Qf7W7az7Q0du334Q51ELqgaHyWarbTVCTp/vOozQSgTQ9FyMSI0NGl402R
	 jNx/n5Fu6XeRnZBRwscHaZJzykh6fWKYRHZOnqLo3zvzxU2VYSOQacF6hlYh09PIi/FIN
	 AK/I9v6i6SHM1rcHHlUI/R2EiHcuj+zNX41YfzPjyTRCvz7GvUBOFHbbyBREcakgRFQXo
	 1LOMd2lpPV4Ysfa2oHREjQbNXr0oXZFkmJi9KZp5kId4vyU7AXuf41z5Eagg5f72TKSNR
	 CvalesAsyWpO3/GyHJNRsbPh8i6YtDWbaJ/x5uhbvb1veuH6rxyhD1EZm5ragbX4HEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKmNslzl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D89A606A31A;
	Wed, 28 Oct 2026 17:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKmNslzl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91BC1F01825;
	Wed, 28 Oct 2026 17:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207479;
	bh=yNPieXeWQo9ykkOgmrYXVtj2ulWCzN9SGPIw6G8VJT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKmNslzljVjecGak560IYcqWBQ2qAvgcD6G1AXvzhm2/Ulqy8kQKk/piaxpsf4J3v
	 uVl2N/DLR2O8kDfa7IwIdjZ/bWgcXHGEU1VGggIMqHDZ+rjyb0vyGa8Y8lggbD233Z
	 oTAYn+scwW9okdSnbRuPs2zwvcqWommTOIAknGRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/247] ASoC: stm32: spdifrx: fix synchronization state check
Date: Wed, 28 Oct 2026 17:57:13 +0100
Message-ID: <20261028165948.080555408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9e30852de93cd..6cc6ff5f6c289 100644
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



