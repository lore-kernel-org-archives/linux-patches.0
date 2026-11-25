Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621597;
	b=abfWstnHHxTd5Th0p3mMSnZVaCud8ZUqqEmu5NF7mhz9p1NBpXzBcyD3P8QN46ah4tWp
	 uIkneuW3NNO74ICtBKNrx72Xk2SoTahQH3zT3tZo1Gp4CCsGazs5+LmD0jA/3gprZ+Pxx
	 i6gZ8CoEoMZufeCl6MzfdyKzpxJ9GZcH3QhswCMpLPLlA1wgRPsJ1EyOqj6KKNaMHWp6v
	 28tNWmXVvS5OkY30wNKICjJEEi7J3aOZQhlIyQYMwskf9xE07zpVJEwAdozu4CmCd3gct
	 E4D4Ie+RXR0Dx4Qe9rvzYpag7BF0rwwn6G4hyvDbYRxuGo4qAo7Rux8NxO+3ejc6nDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/4dTYLjAZ21u1drCREHWIxRR0tDDSawoe7cpfFLURhc=;
	b=FsAM5lxlsOLRPeJMv7tdqEdVyq7aDSled3hqwWELSuB6zaraGoduVHEYM7pvz2GJuQRF
	 GPclJr2GtcYnfgK41n9IUsq706GE3FpfHL3Hoij2P4nQPf/3+5Ftk3yFt5im9zgOtVXrb
	 mSadVEquGsavdmSpTW9NI3P8Tv5xv45BE8YLQEB7hub1MxnFj5MXNG9lnYsZcN+HCHx9N
	 a/uSsQNYvxW24Ow+UV/V92xE6cy9tgPB7+5BbogzF6LJ7W0BjEsqJzMLTboK8M+2fc9TR
	 uJxoPXtFS5IX48DFh5/ZtTj+EbYERprrunVg9TftW/zLm32EzqC+9EAEoU5gRj31VZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=td6632Yh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C848606A339;
	Wed, 25 Nov 2026 15:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=td6632Yh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACF81F000C0;
	Wed, 25 Nov 2026 15:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621596;
	bh=/4dTYLjAZ21u1drCREHWIxRR0tDDSawoe7cpfFLURhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=td6632YhJFPS84d4QqLs2FdnZgRN7xJdmVUJQSaLB+OS4adS2lJQofuZC1d9vesHx
	 CjgNwC8aR6tqJ+KSqUC+JBM53b5/iHN1neHAMEODgNuTPGB6i7ENqsX+JW7Fqe2pss
	 w+6a0mh0TZqlwgt/J2GLSn5hL/WfyOM6HR996zyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colton Pawielski <colton.pawielski@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 276/990] net: 8139cp: keep Rx masked while NAPI is scheduled
Date: Wed, 25 Nov 2026 15:27:23 +0100
Message-ID: <20261125143828.552923448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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



