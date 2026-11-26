Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705152;
	b=pKsfh1mpAMgZ47lqljqneGOyTpBCMCmZznu7zAahbVAGJjKGI6LFjqpDK9hA8wWRWrE1
	 iisQRQ11TT58W9uR1Z3dNyun/cS69Iag1MEvGLWB4lhYPHJxGKBzJO56UBgvfN1OM+C0e
	 T3wcj+f0JiaOjDIwok+GTxR+BORJz0ol9Vx1Jht1cglvfxhMThXwGR0ijddyjYbKi0MJy
	 DgcyXS3Ar6w5BcgRQU0hldMWvKuLg2iZRugWyhXXftPKKvO+HWkqKvHuFG/7AKUPi+Nws
	 D6CN1rh5sC1YCf2igAS7gv8DOWDegpzey6UNE9nErpi7Ly2aiYyMoT4X3HcUZRKQ3lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nlPSjkDuPDA406WSU+QYKTUaeUrmQjR4PoVdtOwh9rk=;
	b=xbml7tEDE1u6BHqhiRhrxnRH9PEeqlZcvGBWUpK9g0KxhkoWMFtWF1ZovVPy5Hkkko/e
	 0MfF/Nq4VPUj7AyyRdcdNEcideZwNrObAy8HtFRjSECwrqDbsojVqW/8V72iVw0TerFMW
	 LfJgp5oCuquDxs9WEgN1Z78ldxXthteh/sTtmW0R5aJrfHN6jzuX+kd93AaBH/7Z3fKcU
	 DNzn3AmeoDlsW68+fqKEiGl/rrnVK13Ha4+b1F6qstwrfbeIZwrTYpKB9pOV3Bse8gBsk
	 gYnqw79mN2LLvS+11hwThBTsEgVN7O220gwJRcfSnAKBMFC5B/eaEKFNZresoTBpXcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ofJPOXjD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E57606A332;
	Thu, 26 Nov 2026 14:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ofJPOXjD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE051F000D2;
	Thu, 26 Nov 2026 14:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705152;
	bh=nlPSjkDuPDA406WSU+QYKTUaeUrmQjR4PoVdtOwh9rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofJPOXjDSw+ZmiPN6LjXrQ6Dr0CgnqoMq7fahHin+fFjjJsxhD9FjvQKS75PoFx6o
	 prvjo4nkTNjWBFr4mAvyMNr6G+iRYuQUWQ2KeMe/tu5xluCOY4IM8BT+zO9unpEXCo
	 mkugKb039IUa8DIEy2/JJkDpj9lm5PoZ2M10OBNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colton Pawielski <colton.pawielski@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/319] net: 8139cp: keep Rx masked while NAPI is scheduled
Date: Thu, 26 Nov 2026 15:37:49 +0100
Message-ID: <20261126144009.024443114@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Colton Pawielski <colton.pawielski@gmail.com>

[ Upstream commit 547b1ae5ec50b7d81b05b4219e0db7e56279d65f ]

cp_rx_poll() calls napi_complete_done() and only then takes cp->lock
with interrupts disabled to unmask the Rx interrupts. An interrupt
that is not masked while polling (TxOK, TxErr, ...) can arrive in
between. cp_interrupt() then sees the Rx status bits, which are still
set, finds NAPI no longer scheduled, masks Rx and schedules NAPI again.
cp_rx_poll() then carries on and unmasks Rx anyway.

>From that point Rx interrupts are enabled while NAPI is scheduled:
cp_interrupt() leaves the Rx bits for the poll routine, does not mask
them because napi_schedule_prep() fails, and the level-triggered
interrupt fires again as soon as it returns. On an SH7751 LANDISK
under combined Tx/Rx load this interrupt storm was captured with a RAM
trace right before the board locked up hard.

Mask Rx in cp_interrupt() whenever Rx status is pending, not only when
NAPI gets scheduled. If the race leaves Rx unmasked, the next interrupt
masks it again, and the pending poll unmasks it when it completes.

Fixes: ab1e7e1d2666 ("8139cp: use napi_complete_done()")
Signed-off-by: Colton Pawielski <colton.pawielski@gmail.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261031-b4-8139cp-napi-v2-1-5824797c0fe6@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/8139cp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 6938093e36ace..b8cb0d589b9d6 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -600,11 +600,11 @@ static irqreturn_t cp_interrupt (int irq, void *dev_instance)
 		goto out_unlock;
 	}
 
-	if (status & (RxOK | RxErr | RxEmpty | RxFIFOOvr))
-		if (napi_schedule_prep(&cp->napi)) {
-			cpw16_f(IntrMask, cp_norx_intr_mask);
+	if (status & (RxOK | RxErr | RxEmpty | RxFIFOOvr)) {
+		cpw16_f(IntrMask, cp_norx_intr_mask);
+		if (napi_schedule_prep(&cp->napi))
 			__napi_schedule(&cp->napi);
-		}
+	}
 
 	if (status & (TxOK | TxErr | TxEmpty | SWInt))
 		cp_tx(cp);
-- 
2.53.0



