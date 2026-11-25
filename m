Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624589;
	b=fLKTS3k5zQZ4yX9V5jO6y830G2bvo16Wfd/vBOuMJKvuvTVKQap8NBCI9pAB0+orB01F
	 8cKH8iD6ru9J9VgJHbaLLHrDetpQ7aWDFb+ON/Gam7T7au/HnTiSf2S65G4/GbfbCI0hk
	 UYEMHAU+VsvGhv2Rgn8w4xrBxMlnEMdVprKoXtFFERkeRYzJDusfRuELlvv6tXiuj8Geo
	 m0phOgCvJUqszM2t9PhTVzd9YU91lh2u9pvE+OIcqv5M8HsHhqseQbzjEh0NqIlGXB6qM
	 FVuB4IyquNLyIOu1jstQXVxXlFMof9VkBfmldhj1eeSVpXGFvE/2mzi+nytnPFDiaBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kyW9EeJShVV+JdtwqqIYQMmjVU9mmiEE/TL3skXzYrU=;
	b=jRkURLjH9tBmrlslsrVpSZUm5wOJyfNqqIuuzymun8EzuboNW1R1NIYtATHyhRdezHyK
	 s3X9sGnPaXvWBY8k3Gkdp2/82LAT9UCPo52HaS+sHV92L0Tm2FCHT7u9RxervRhXVQI48
	 862rUxOaO2fjrkrlgmk8S26mW6iy9bHv3Tom3BfmpwaT/+DbeP6AbpKZjlt4hVRYpq9mT
	 GiDQeLl6nl1HUFNupK6GsKTEiG5257Hzh2OLSSZjXKrP7W94hK0jk+vlLhsTKrdmOAYUn
	 6OCl7tjnxC6D6q6hDYdr/T6NZ3JSOhQPvm2TV1UejwR9E4agSROAHp3eR9Rwf1RAglw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k+hhqlpu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E46606A336;
	Wed, 25 Nov 2026 16:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k+hhqlpu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979771F000C6;
	Wed, 25 Nov 2026 16:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624589;
	bh=kyW9EeJShVV+JdtwqqIYQMmjVU9mmiEE/TL3skXzYrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k+hhqlpulnTVRg1oFki49YfxLovxE94pcuZy26ahqfGy/BjIrqSlXl4beoBHQTakb
	 6pAP1XmzyHXr/e2s5g7qtXHuyu8jJsZ7yqB9qJeqxxvqPEYb8ADK9ylB9hUAgeQe4F
	 mKdT50NvNMg1FRCQmfAEkJZNwuHpQ+OxbYhe2H3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colton Pawielski <colton.pawielski@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 225/816] net: 8139cp: keep Rx masked while NAPI is scheduled
Date: Wed, 25 Nov 2026 15:29:33 +0100
Message-ID: <20261125143854.415251300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 9016527e229ac..8f81dc7deef1e 100644
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



