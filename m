Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623916;
	b=O8l2be0BomYWe3HXa3Nknaf7ans2uPo50e2CfCx4rVdVMcInVO0iOu4m/LM9KZ2ZJ1En
	 khM9T5KV0Cn28yhBg/l0IgkHlgQVX5lShf8ssIEYHeZTDS0H21H8kxr9M/1sAfVFzNNZ7
	 wdVVTl7SIdgL+xI7aP1kkLh0FTlYOjCoesr9rq69x6fqO/9qaCL26dBRQXQTFlaO2VqOJ
	 1yus7/ps+a8eF/fKXvsJX43QdhGca7CUbLQz1oJgiJnq1q2CQ5QH/GHQc0daQ/O/6avEo
	 jYXxwYMqlsZTreX1/vSd1THOv/0U8i2IhMjaWB3TBAF0U7Zd7eTRritHEGOd9xQxktw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l0wO7alqS7KevWe4y0l6wDEdHxeNvcsIppAy9t/eOIQ=;
	b=5kA4Fuk9urFcvpKIPYTCZAMvBs0UC1FsN5Y3UqR65O394uTzoT6wavR9FEFb1NRFL07e
	 zkBUxvYvkcNuzXQhyx2l1CPE77RPofm+5y2++u8Lqb8pL3s5lDcc7MQCS7ZZRbd18J3Nj
	 /jNz1iym+fVj7dN5+NMT4magaVoVuG5RCJpQIa9vRN7tieelgI8yC0f5HMgtOkq3GkWt/
	 W78GqHyhJU/bqJ1tOk6hBSpG4oCWoeiXQF0/u3w4gh5N0PPNZZgByuQDYrz38mX7MQRtc
	 7J+GJApF4cPc/s7xuSzhNbeb7aLd6w0nhAnoZNlqXvX3V0sErgkTJnbHRUD+QBjtkEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qdjlzNex;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B666606A326;
	Wed, 25 Nov 2026 16:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qdjlzNex
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E421F000C0;
	Wed, 25 Nov 2026 16:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623916;
	bh=l0wO7alqS7KevWe4y0l6wDEdHxeNvcsIppAy9t/eOIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qdjlzNexgv/tWVl7KDRfspEmJS8+IK3LlX90x2gr4ceaFhtwkGLpatEFa1Ln3Fcrn
	 Fns4k9tE0iNaJKeD4Z3Urb9VufMeWur74ct1CkC0oLQH8n5Tlps0E95rzHRy/YHped
	 We/1NSl1SEn+os+tvkoNJH/He4DGIbKXZuCB2f5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/816] netrom: keep T1 running after answering a NAK
Date: Wed, 25 Nov 2026 15:26:14 +0100
Message-ID: <20261125143849.821153811@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

When an INFO or INFOACK frame carries the NAK flag, nr_send_nak_frame()
sends the frame at V(A) again and then stops T1, although that frame,
and any sent after it, are still waiting for an acknowledgment.

If this copy is lost too, no timer is left: nothing is sent again, and
the circuit is not cleared after N2 tries either. It stays stuck until
the peer sends something or the idle timer, if set, closes it.

Restart T1 instead, as nr_check_iframes_acked() does when part of the
window is acknowledged.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit e18a382a74b93a3c0ab52e0fedc8343d9d4facc9)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_out.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netrom/nr_out.c b/net/netrom/nr_out.c
index 150cb4263d314..1c6b4386c86b4 100644
--- a/net/netrom/nr_out.c
+++ b/net/netrom/nr_out.c
@@ -135,7 +135,12 @@ void nr_send_nak_frame(struct sock *sk)
 	nr->condition &= ~NR_COND_ACK_PENDING;
 	nr->vl         = nr->vr;
 
-	nr_stop_t1timer(sk);
+	/*
+	 * The frame just sent again, and any sent after it, still wait for
+	 * an acknowledgment: keep T1 running so that losing this copy too
+	 * is noticed.
+	 */
+	nr_start_t1timer(sk);
 }
 
 void nr_kick(struct sock *sk)
-- 
2.53.0



