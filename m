Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704333;
	b=3TYtthOTc1C58rKRMrm3SUcu7iQcD+yzlnntxyNnSaiVMVcLA2yUpSo2nzaMvE5U8KzU
	 xC9bH9ppy2fO4T1OTHZulCjmmdIExS8oR77kaRK8oAVEmiFPyn7Zksb3KGayMlWb/cKTh
	 pL6KLWuEXSlJMl+wKcLkjTv3GFApaEh/RXv4dci8fXjBljhoHeA4lk/WshfvUb/+Hvld5
	 XH18y2DBlpXlUHW5lAdwIjW67Bc/hHIqWKau3GSJnUaJ9PVTreXK3W7oRz3XYkRqxDzRy
	 qsYcFeCc8mS9ejxrMErpSbJlRX+xhaacrPMJTIVhnnp/KmfsFoV/KvNu/EsQu8vXqVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B8mnbwiqYsFDsAv5f1NhJZjKlcRLq0fYPUIY+hFkQCU=;
	b=k8Eh0/+ivbcutdSkK37RADTBY1k7x6DAQRg2HK7O6jkT9OveYoo+JYFF5FjqQp30Mhi+
	 GXv17yqDLdGZarBENy7IKAVImeUSjHufUrrBMk2UTHh8zZcGBnlrC1iEz3LILjsSnKwvD
	 +JSIFjpcWBZCURymMe/jQ0As/3meEN8FNigSCSshUlcV/ghSfVJm9xddO9X7HvWH60T4o
	 hFhLiA9d8TFomdNNU/pZgRmdWBVW6XSfqZZ1bFlL6qRN83dLl6knfeMOfyXHnY7W33nLO
	 MtB4WJ9PkQoXOERHnVVLmc9vsZQb458mIKpk4MokCcSH+G0lOfYKhV4zIZYVP+zim7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eaLb+8hW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14508606A326;
	Thu, 26 Nov 2026 14:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eaLb+8hW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045EE1F000C0;
	Thu, 26 Nov 2026 14:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704332;
	bh=B8mnbwiqYsFDsAv5f1NhJZjKlcRLq0fYPUIY+hFkQCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eaLb+8hW++ajkXu4bMGAm0nuHW/JTFcT/Jo6Gk6W9V4EJ3eO2jzeu89kCZOY4r/LM
	 SllIGUNLRrQnFP4pxIxXKdvrFC6zcgPDifMuY8oVSYPe7oxFO6jEYIsYWTaA9wrACQ
	 U5Ak5nTZ1SSgl0FmKItcbdB0fdqJjwxoTgp8+8Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colton Pawielski <colton.pawielski@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/265] net: 8139cp: keep Rx masked while NAPI is scheduled
Date: Thu, 26 Nov 2026 15:36:55 +0100
Message-ID: <20261126143610.957995057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
index 086fce1b15269..6e48cf171f0c5 100644
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



