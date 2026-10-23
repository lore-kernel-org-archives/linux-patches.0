Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774414;
	b=JD14RwNeKvIUBJGTKCKQ+6n0DMENQR0wPhG+QpLXMgd/61l/uxczH/GLsuJ6w5qi1Cxv
	 ytmCBJhmc0ucyvgOf7+EotWkLtyDykfeuk7OLvGUbv368JzXzTY/FH6wFWXyNlcKhuWZ3
	 IRhy3j0aSyS1B3sMhBnPVzD6D0+VlpumEMfpRhZhLVUqyX4v1TSXEg121RWV7OWjTDexU
	 tzcjwglqgJRTE9JYPONXJkAvsFey5fyIq8un4L+KG1C4ow3cyckbhCcUP02UibwxLwP5L
	 rnlfVT+GRSVTKk9uWiy4BMlQ+28uC7DuuvTUoxAypuXXS/rN63QQh4szLud55KVQ2BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xrqHDQAY+cUJDMp9S/au8IJoSwyvKmyLVMVgtNIVxnk=;
	b=i+vqwV3UukNBzjufeuI0SgUbfWU/GtgfgwpNVmRcziNJV8vrR1YnjnI+N2AmacrlWE0Z
	 y7b9G7eAp4ah+SEaZ4Nqkpe3HUjkPbV5U9PFBa/Fxw0OPlbBnbwuf/vOYSThqA7jPKOf2
	 uPjKzjLd+BaNeu0f6F4lRJm7Y/cmJh6/wc0nbrAZB3fIpTJZpB/w0Zeb8traSaNUyabHz
	 r1FpO0bHoSAur2S303r5uABZeUL4ZHZxWbSVsNsJts3bk6kprvuRrmcqGSFbaHqyX1plw
	 4M6PbZPQZmFGio+nHnm3ZHIBALXwFhlJQtbO5CQ6MWq2SHjkToOVwDABi1nBP63wL9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mif5Urg0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBFC606A31A;
	Fri, 23 Oct 2026 16:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mif5Urg0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40D11F01825;
	Fri, 23 Oct 2026 16:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774413;
	bh=xrqHDQAY+cUJDMp9S/au8IJoSwyvKmyLVMVgtNIVxnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mif5Urg0uGBfmNDbT/sTsmfh4x+8fWGoTwPLguUlBJqSUMG2FwVW5cq+2JHpv5E4G
	 Q4/VKYli6I9zG0K+OmtszQRhWTx5lZ+723S34fkiGjqFrcCriz3SJnCGGBwlcrVsZG
	 k2KCvrJfw86UzoWqTUrji+/LpQuLPyxt25MyZprg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 032/242] ASoC: stm32: spdifrx: fix synchronization state check
Date: Fri, 23 Oct 2026 18:37:54 +0200
Message-ID: <20261023163714.540875412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 2f83ca989e688..7ad2e5426bb32 100644
--- a/sound/soc/stm/stm32_spdifrx.c
+++ b/sound/soc/stm/stm32_spdifrx.c
@@ -720,7 +720,7 @@ static irqreturn_t stm32_spdifrx_isr(int irq, void *devid)
 
 	if (err) {
 		regmap_read(spdifrx->regmap, STM32_SPDIFRX_CR, &cr);
-		sync_state = FIELD_GET(SPDIFRX_CR_SPDIFEN_MASK, cr) &&
+		sync_state = FIELD_GET(SPDIFRX_CR_SPDIFEN_MASK, cr) ==
 			     SPDIFRX_SPDIFEN_SYNC;
 
 		/* SPDIFRX is in STATE_STOP. Disable SPDIFRX to clear errors */
-- 
2.53.0



