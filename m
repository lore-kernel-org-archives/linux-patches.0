Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028919;
	b=IQEe/kKdOJcL0lO3U4bya/apxM4DulD256TqX3Bo8NunZmyjp+eGo268oBQZEN+KLiDA
	 iTh3pNMFGu9/vcSRmDJIFDLbZPtwunMQFltw/OY/8RpH8AIx5/Lo8qgZH9dxU9rFLacQ7
	 s5gSOORy2qhD0HURCd2KxtZCPUp4DM7ec4iTH9vQ7CBFJQNQYI2kLig9S6OXZ9Ao/jNnm
	 58fnClU3PLLxMHmdo/VMV1ruoQ5Pfi/b3x4kPMoPR/TjKcVE4a22P1jboS6+2vHclaiFi
	 0dReFC41herumw1fbLgkSocSzXfNC+HbdVSb3TnDuCScl53AkQDWaRc2D+54lIE0vhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EJeouwX/BRGjl7iJ1c8OVgaSv8jeU3/2AnvbksuOYfs=;
	b=K5pg9xomw+Qmg3qe2CtlfH85hmP5ClUGuAldfvn+mNjgQr5llOxHCcTR/h27bNEG9MaX
	 YZSCucw16GoO81mCTqONrfL5DpZlpDnC5nhWG75lR5rNn1272mAb1n4FjZA6F4g021dBE
	 m+T7aCNJL/OZC9LJEXE8Vt1IcD2N4sAGvh+CZ+1OHaFvmH/V00mrNKh9ndnPYbCvJX/X3
	 x94/BIh+BbBU6qlNbF84he2tg8Y1lYR7RSNPJ0GfYSMDVevv8EKjMTp6kSkTmZC5ZE7Rp
	 WNO1OZtBiSHBwoCOIhTaUv+7tdmNnpdWD1SelYB9SXxGLjCWbsTr/UyUyJZSTQPofpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YqUhnU9r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF91D606A335;
	Wed, 18 Nov 2026 19:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YqUhnU9r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206EA1F000C4;
	Wed, 18 Nov 2026 19:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028919;
	bh=EJeouwX/BRGjl7iJ1c8OVgaSv8jeU3/2AnvbksuOYfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YqUhnU9rM9jgeNjq5RGdf/ysNBvYF/u4N6KXlsLARn74m9kn2iQjUaNb/rpJlAKDP
	 ID11S5Z3Kq13xOhC2LHd5/21HSvQAfHNaI5nPOtyhbYKd5jY+ObLPuPOBryit3lIHr
	 I5mboMv+mi+YKXDdQ4WNS4w57P3zOnM8pGLB3B6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0109/1756] rose: check the length of Restart Request and Diagnostic frames
Date: Wed, 18 Nov 2026 15:37:16 +0100
Message-ID: <20261118150012.541510879@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

rose_route_frame() only makes sure that a frame holds the three bytes
of the ROSE header before it hands the frames with LCI 0 to
rose_link_rx_restart(). There, a Restart Request has its cause read
from byte 3 to set dce_mode, and a Diagnostic has bytes 3 to 6 printed.
A peer that sends them shorter makes the kernel read past the end of
the frame, and set dce_mode, which decides from which end LCIs are
given out, from whatever lies there.

Only read the restarting cause when the frame has one, and leave
dce_mode as it was otherwise. Ignore a Diagnostic too short to hold
its diagnostic code and the three bytes it reports, as x25 does with
pskb_may_pull().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 13db36d85e64fa98f579d5ee38e416baf9fc0dec)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_link.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
index 2e2837e632426..c544157944f57 100644
--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -185,7 +185,9 @@ void rose_link_rx_restart(struct sk_buff *skb, struct rose_neigh *neigh, unsigne
 			rose_link_restarted(neigh);
 		rose_stop_t0timer(neigh);
 		neigh->restarted = 1;
-		neigh->dce_mode  = (skb->data[3] == ROSE_DTE_ORIGINATED);
+		/* The restarting cause, when present, tells if the peer is a DTE */
+		if (skb->len > ROSE_MIN_LEN)
+			neigh->dce_mode = (skb->data[3] == ROSE_DTE_ORIGINATED);
 		rose_transmit_restart_confirmation(neigh);
 		break;
 
@@ -195,6 +197,9 @@ void rose_link_rx_restart(struct sk_buff *skb, struct rose_neigh *neigh, unsigne
 		break;
 
 	case ROSE_DIAGNOSTIC:
+		/* Diagnostic code and the first three bytes of the bad packet */
+		if (skb->len < ROSE_MIN_LEN + 4)
+			break;
 		pr_warn("ROSE: received diagnostic #%d - %3ph\n", skb->data[3],
 			skb->data + 4);
 		break;
-- 
2.53.0



