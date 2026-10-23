Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773835;
	b=j+8jYSwksZZrNSvCddoErkUsD3opxKNhGkl6OJHt261KK//wsAtnDMg+BzwkA9QzR25g
	 gkKigLjvzlsfdWgjH7zinIwSJ+yr9VQb5CzbPW7AtXBFv+0ITQglVRs1VUxPf/jaFngjp
	 9lfa51QEAGevpCoDKhdGiwYlWzZ/Wm+191uR928kTLuI3Z3OrGkhf84MGC/khoTi4GPrY
	 EOrHPDP1UIxFcgtlHRtyvP8ZEPb9kZyILj8ug2YIlh+ahIikzVYywzNezi3LLAnbAk6Zd
	 emb//howj0jRRfwokxukAyvwQSD1ueDSnN+BmlW4/qKN7AkqbLE4O3rGYPQVRTdOE2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zosXpn1+UGU9IcTdqFIRBLwmlSiychN2BxZGwHLiXiY=;
	b=COPvp2XKVNYJIQZVFKYs8oGa2ae9hJzUpM3d1X3ACHhRFMQY8Tfzz2absZBPOY4Ut3pY
	 3IWh+XmuvuwQrkWjYerfR4ve+VAOq8oLL/O5Ep4AoxY5AMyjHuD4vd2qycMy8cX9ol/1V
	 l62OMuKTsBETihF09bdfM9zEMFZ4+9ZCnsuz9ZHdHH1sCDnu4ioBke/HRRdAHIb9kuMYo
	 2WmlpylM8iHSzlFSozKg12PlecQHzweulO6l2PZH0KLrg/GbqHGMEEOlLhiROdWFB2nXb
	 0R1gN+fujDzYKuFWng+gAvvQPdEkhU++CL8zbk8W3KnnccpXx7TcqlDaFpQ65IyCtKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cOMM1oyf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC78460A380C;
	Fri, 23 Oct 2026 16:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cOMM1oyf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78551F031E6;
	Fri, 23 Oct 2026 16:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773834;
	bh=zosXpn1+UGU9IcTdqFIRBLwmlSiychN2BxZGwHLiXiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cOMM1oyfEEHuQlUl7/nR0TIlaw9jcc8b86aYTePen8BUfpx76c+GHPkieMBaJfn4l
	 bz2gzYnd/WR0mizoIdId9c5Tsuf/wqYHAmxbRq9u8u9EibtsCVgZ0GS3QVz7bWB1zt
	 rzo0Qh36BRD8/FFaPpi69M8npebGQlt/FwXigQO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 031/193] ASoC: stm32: spdifrx: fix synchronization state check
Date: Fri, 23 Oct 2026 18:35:08 +0200
Message-ID: <20261023163714.937387763@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 57b711c442784..47cd3efcadc1a 100644
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



