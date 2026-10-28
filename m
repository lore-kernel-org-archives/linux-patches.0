Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207420;
	b=u5X4f6TObovRE1sFXMOD3b9GEcW1+Jr1s1VAktjsoWUd5/S4IuhI1wAW5c2T2sxjuQDM
	 G2qaD9OHsxlKujb3pYJmWViORj48K3cvxr5nNXalA+4MQEKHJCE0jzurARifTLHyDccJz
	 +HmbB8QSDk0AuPIwjHRuhcfLTyqHNRuWS9X6eDDPpbilMoTEkN7iV3JtWi7/6ZOw6tS1r
	 1e8VJ38lbNnfhXNjKEOIqiEbhM6dtwzBWQ57jb6UewjPbRjAjI56EVeLyPWPPDzdHyjAl
	 MlJylIqhHqJitmnRZayI3rJ1ldQxlHuYuImj0QE41e4/kU/4VKxcyMIXPyCkPLxrFQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N1PgLUGJ4AZBm0C9a8WtvUmwLVOFDYdkhwiCEUBIe6k=;
	b=GT37o2XqC7/u2cxd6BY7ltwSN2MaipavwbtPqC2a6D06bddfEkW0VFMifLv3k1HQ71Li
	 UYDcb8aVZhEZOFibLrju9ile41azyGpuXa8G82sctJu39Nbde/cO7DhcYBR9taqhdiWu7
	 SwOt1G0+G5HqgNc2QjGSv0Z4tjfJLSaB3zLammPRM+qQrZkcU23tqTkSiRP9HogjKvtSj
	 1hqdzPfog5UG7RZrq37WquRjyAQ82ty7R7+O8kMjLWGfNESgBL5NaxsYyT2+iqyxb5bSk
	 78y60GyAHdes+blO74n0KFrR54tkrxO668QuKsJdZcpJ9KLpQkGesMOm6NsgfrwNiYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sNKhUjU4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1992606A31A;
	Wed, 28 Oct 2026 17:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sNKhUjU4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C55C1F01825;
	Wed, 28 Oct 2026 17:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207419;
	bh=N1PgLUGJ4AZBm0C9a8WtvUmwLVOFDYdkhwiCEUBIe6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sNKhUjU48gNW4aFvZPk20YHB4fSzey1qLabTIiCSqWixfu0042jDJIKaQyllVpov3
	 d4ws5tczkfkfzKFe9kmz3EslNV8i2HNHQqN4uht2kkqp0hMzKBozad/CoiD3RhCYNi
	 7PdSKfixr4jjal45hJact0xDXthabKCg+whavSac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/247] ax25: bound REJ-driven fast retransmits with the existing N2 counter
Date: Wed, 28 Oct 2026 17:56:54 +0100
Message-ID: <20261028165947.624662093@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

REJ deliberately bypasses the T1/N2 backoff to trigger an immediate
go-back-N retransmit -- that is the whole point of REJ, fast recovery
from a single lost or out-of-order frame. But unlike every other
recovery path in this same state machine (T1 timeout, state 4
enquiry/DM, state 1/2 SABM retries), the REJ case in
ax25_std_state3_machine() never touches n2count, so it has no bound.

If something keeps corrupting or reordering every retransmitted burst
-- lossy RF, or packet reordering over a UDP-based transport such as
axudp -- each attempt draws an immediate fresh REJ and the link
retransmits at wire/CPU speed indefinitely, a "machine-gun" storm that
never reaches the N2 give-up already relied on everywhere else in this
file.

Reported independently twice: Chris Maness (KQ6UP) on a plain AX.25
link with no ROSE involved at all, and observed live on a ROSE/FPAC
White Pages link (f6bvp-8<->f6bvp-10, same LAN, so plain network
reordering over the Internet is not the trigger there -- likely lossy
retransmission of the same PDU) reaching ~5900 pkt/s. Both hit the same
code path since ax25_std_in.c is shared regardless of what rides on
top of AX.25.

Count consecutive REJ-driven fast retransmits the same way a T1
timeout already does in this state, and once N2 of them have failed to
get an in-sequence frame through, fall back to the paced state 4
enquiry -- which will genuinely disconnect after N2 further tries if
the link stays bad, exactly like every other recovery path already
does. A single frame accepted in sequence resets the counter, so an
isolated REJ during otherwise healthy traffic never gets close to N2.

Deployed on three Raspberry Pi nodes (f6bvp-12, f6bvp-8, f6bvp-10)
since 2026-09-13, running live production AX.25/ROSE/NET-ROM traffic
since, with no recurrence of the machine-gun storm and no other AX.25
regression observed.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit a3aa611e37d4345ebcc98c847dedaf4bcf23c7ee)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_std_in.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/net/ax25/ax25_std_in.c b/net/ax25/ax25_std_in.c
index ba176196ae068..f280683f83fcf 100644
--- a/net/ax25/ax25_std_in.c
+++ b/net/ax25/ax25_std_in.c
@@ -196,6 +196,38 @@ static int ax25_std_state3_machine(ax25_cb *ax25, struct sk_buff *skb, int frame
 		if (ax25_validate_nr(ax25, nr)) {
 			ax25_frames_acked(ax25, nr);
 			ax25_calculate_rtt(ax25);
+			/*
+			 * REJ triggers an immediate go-back-N retransmit,
+			 * deliberately bypassing the T1/N2 backoff that
+			 * paces every other recovery path in this state
+			 * machine -- that is the whole point of REJ, fast
+			 * recovery from a single lost/out-of-order frame.
+			 * But unlike every other recovery path here, this
+			 * one never touches n2count, so it has no bound: if
+			 * something keeps corrupting or reordering each
+			 * retransmitted burst (lossy RF, or reordering over
+			 * a UDP-based link such as axudp), every attempt
+			 * draws an immediate fresh REJ and the link is
+			 * retransmitted at wire/CPU speed indefinitely
+			 * ("machine-gun" storm), never reaching the N2 give
+			 * up that bounds every other recovery attempt.
+			 * Count consecutive REJ-driven fast retransmits the
+			 * same way a T1 timeout would in this state, and
+			 * once N2 of them have failed to make it through,
+			 * fall back to the normal paced state 4 enquiry
+			 * (which will genuinely give up and disconnect after
+			 * N2 further tries if the link stays bad). A single
+			 * frame accepted in sequence resets the counter (see
+			 * the AX25_I case below), so an isolated REJ during
+			 * otherwise healthy traffic never gets close to N2.
+			 */
+			if (ax25->n2count == ax25->n2) {
+				ax25->n2count = 1;
+				ax25_std_transmit_enquiry(ax25);
+				ax25->state = AX25_STATE_4;
+				break;
+			}
+			ax25->n2count++;
 			ax25_stop_t1timer(ax25);
 			ax25_start_t3timer(ax25);
 			ax25_requeue_frames(ax25);
@@ -226,6 +258,10 @@ static int ax25_std_state3_machine(ax25_cb *ax25, struct sk_buff *skb, int frame
 			if (ax25->condition & AX25_COND_OWN_RX_BUSY)
 				ax25->vr = ns;	/* ax25->vr - 1 */
 			ax25->condition &= ~AX25_COND_REJECT;
+			/* Genuine forward progress: a frame made it through in
+			 * sequence, so this is not part of a REJ storm.
+			 */
+			ax25->n2count = 0;
 			if (pf) {
 				ax25_std_enquiry_response(ax25);
 			} else {
-- 
2.53.0



