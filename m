Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620833;
	b=uW22tZJrwL2yNDcFFGDZ2bGVdfsfeOiM0n2+pnFRFeEqYsEwOroe+qVXTEkNAuvNRXcO
	 GoWWDQt1EAyDAcvg66skT8WT+CyVT3y/Z021heStM+DvIRzKpJT7Ans+eVGVP5L/pRciA
	 fEnXDPXgQDiWSI26E/kC67bJb/eGejhfhduTEKZ3J0vZiMZzij3vvoLE+teXpzrX015QG
	 HvTb/2Nod1NkUtm48MhTaU2W07DV71losmFeARRacIETy0F+tT6RkKQpLmQcm5U2bklmZ
	 4LRmiY5DM7uJfSQlWYH4uijH0GVWQWNEo8zu6ytT7y+ngLOsOO3KQ3DzoBg0NVtqpyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rv7NpDdGs7CTCM9w5N3eY1sFrxJvbAYoH8su9OU+up4=;
	b=qaVeO+7bxBXcrndx3IJC8KzGmcSZl0MyPA4x8bMUKHELXgP3cVmHwyDgDY4pOAXKw92W
	 v4wNwA9lXgmty00FioQoR/Blghh5ZZ7B1JTJkcktqpXrccK42b7lgT9EB1P7cHEaIqojM
	 iATvQ+GekXBq+rYdP6f3fHlY2VSY8ukG0YfEvEoHQCsx3wOwtAZpphfoytQG2VT8v2EV1
	 BHZB/9B4Sb9TrCVsDd95hF9rf7o/zPPvB+Z/xyo0OulCGg4bfkBzQ83beBWwtHL5Rc0Z1
	 8NZFE8StTJGrZJozjIkaaOIM7FVIiG7ERfq4vS8949V3R31hD4hVh5b3bgQJAJrO/eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PIEAdUWZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CB6606A31E;
	Wed, 25 Nov 2026 15:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PIEAdUWZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3F41F000C0;
	Wed, 25 Nov 2026 15:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620833;
	bh=Rv7NpDdGs7CTCM9w5N3eY1sFrxJvbAYoH8su9OU+up4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PIEAdUWZEojsvEJToiOwrm5ivlKqtUJHIQYk9d715adHJ1TQqXHi2cKmaizJE2Bnw
	 5LRI7m6Co+FCWt98jRjcwACdHlvn7shkKsLFllHgATTqfbS3bEZx2nDrce3wp3Jkwp
	 B6zxYBVYjZoBLoUhek8wXx+m+NsHgmZUGXaBp/oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 037/990] ax25: end a REJ recovery count once frames are acknowledged
Date: Wed, 25 Nov 2026 15:23:24 +0100
Message-ID: <20261125143822.957833646@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

Commit a3aa611e37d4 ("ax25: bound REJ-driven fast retransmits with the
existing N2 counter") counts REJ-driven retransmits in n2count and
relies on an I frame received in sequence to reset it. A station that
only sends, such as a BBS forwarding mail, never receives I frames:
the peer acknowledges with RR. After a single REJ, n2count then stays
above zero for the rest of the connection, with two effects:

 - ax25_calculate_rtt() no longer updates the round trip time (it
   requires n2count == 0), and with the default linear backoff
   ax25_calculate_t1() keeps T1 at (2 + 2 * n2count) * rtt instead of
   2 * rtt;

 - isolated REJs, even hours apart, add up, and the N2-th one sends
   a healthy link into the state 4 enquiry.

An RR, RNR or REJ whose N(R) acknowledges new frames shows the link
is getting data through, so reset n2count when it moves V(A). A REJ
storm that makes no progress keeps the same N(R) and is still bounded
by N2. The reset is done after the acknowledgment is processed, so
the round trip of retransmitted frames is still not measured.

Fixes: a3aa611e37d4 ("ax25: bound REJ-driven fast retransmits with the existing N2 counter")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 6f10bf991bc130b56339200965d87512b443954a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_std_in.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/ax25/ax25_std_in.c b/net/ax25/ax25_std_in.c
index d0269ece4fc58..92d89d4df0f83 100644
--- a/net/ax25/ax25_std_in.c
+++ b/net/ax25/ax25_std_in.c
@@ -190,7 +190,12 @@ static int ax25_std_state3_machine(ax25_cb *ax25, struct sk_buff *skb, int frame
 		if (type == AX25_COMMAND && pf)
 			ax25_std_enquiry_response(ax25);
 		if (ax25_validate_nr(ax25, nr)) {
+			int progress = nr != ax25->va;
+
 			ax25_check_iframes_acked(ax25, nr);
+			/* Frames got through: end any REJ recovery count. */
+			if (progress)
+				ax25->n2count = 0;
 		} else {
 			ax25_std_nr_error_recovery(ax25);
 			ax25->state = AX25_STATE_1;
@@ -202,8 +207,17 @@ static int ax25_std_state3_machine(ax25_cb *ax25, struct sk_buff *skb, int frame
 		if (type == AX25_COMMAND && pf)
 			ax25_std_enquiry_response(ax25);
 		if (ax25_validate_nr(ax25, nr)) {
+			int progress = nr != ax25->va;
+
 			ax25_frames_acked(ax25, nr);
 			ax25_calculate_rtt(ax25);
+			/*
+			 * Only REJs that make no progress count towards N2:
+			 * a REJ whose N(R) acknowledges new frames shows the
+			 * link is getting data through.
+			 */
+			if (progress)
+				ax25->n2count = 0;
 			/*
 			 * REJ triggers an immediate go-back-N retransmit,
 			 * deliberately bypassing the T1/N2 backoff that
@@ -224,10 +238,11 @@ static int ax25_std_state3_machine(ax25_cb *ax25, struct sk_buff *skb, int frame
 			 * once N2 of them have failed to make it through,
 			 * fall back to the normal paced state 4 enquiry
 			 * (which will genuinely give up and disconnect after
-			 * N2 further tries if the link stays bad). A single
-			 * frame accepted in sequence resets the counter (see
-			 * the AX25_I case below), so an isolated REJ during
-			 * otherwise healthy traffic never gets close to N2.
+			 * N2 further tries if the link stays bad). A frame
+			 * accepted in sequence (see the AX25_I case below) or
+			 * an RR/RNR/REJ that acknowledges new frames resets
+			 * the counter, so an isolated REJ during otherwise
+			 * healthy traffic never gets close to N2.
 			 */
 			if (ax25->n2count == ax25->n2) {
 				ax25->n2count = 1;
-- 
2.53.0



