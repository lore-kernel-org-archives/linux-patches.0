Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209683;
	b=1LOnd304doS7hqMbQG+6GKogWKUHjk1eyHWqAYWfl47T/jqF+6J5fr3HjeYkIk5yYc0x
	 SJJo5QAjFVKXY1TC9zdR/2qNSaexJyQlxUYMWy3f85S8tSmwH0CqZIsr8g+CPsokvfASd
	 yGdMEzt4mhjdjvIoA7ux7bjwJcDRMfQGmfiWQ662c80L8srI1WFcWJC7gBdF2zkQJveYp
	 8JVw6csUe1azSyE7UKHmquw/rRslNJLUroqjJKFt6BoCS0ldUXHRD+nghiNFA2ieFXJIw
	 Epn9NjmuwDHJpzyneVpnOWK7HHKB0zaqRemuNCZdpLQ8YxhsRDcUVm/PVPSEu49fTHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9y/A5/ag9gd3Z2IUQ5FSracNr2Jnf+YZdif2APu5Dqk=;
	b=ZeLIbu4+SToTkTF5gxCoIPWeIO3o5SuF3lOcXRTNWH0uLOyR1cGD43N6yGhve7Uzu21F
	 RlFtqtodW5pCWWt0U1Q+elgZ6IGpkqWogULuma+KZRcHcfnLMfgpCnyyLGDZO4Hxzk2cg
	 FRtU2Wg0iPdRGvMG9SDzeKoZCsKynx8Y73wTW65GznoBGFctEjEgWhXk6WkSR/EqoxxOz
	 aIS7My7cL6CYAVj6b1Aku4oaC+SQydr+V/uWRsYDZZ3Ln+ZRM5I7B8IYGYY697q6aBjBv
	 GZLX677FYZJI9ti9UrbUTp0bNqDlVFnLP+Ye5uE0BL5NZOLsOZuJn7yX4J+eX9gGNQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2joXeeJd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65C5606A31C;
	Wed, 28 Oct 2026 17:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2joXeeJd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BD01F01825;
	Wed, 28 Oct 2026 17:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209682;
	bh=9y/A5/ag9gd3Z2IUQ5FSracNr2Jnf+YZdif2APu5Dqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2joXeeJdQS6J2CCurxZDb09P7LNyzAwFcGwNen4ro7SWYCmGzrMOEZzKHCOJTS9sZ
	 e7WBXZEgdmjmiLzCI5AwD0Ovc4jsn915ZqhrMnx/ie/7I+yQ1rwkD16CHJH30Ml1yv
	 drq5+3SEsXzgh9fLixJWCOl5p0pR76yGL94SmX/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 005/109] rose: clear stale N(R)/N(S) before (re)transmitting a data frame
Date: Wed, 28 Oct 2026 17:59:49 +0100
Message-ID: <20261028165942.487955808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

rose_kick() transmits a skb_clone() of each data frame and keeps the
original on ack_queue. The clone shares its data buffer with the
original, so the sequence numbers that rose_send_iframe() ORs into
byte 2 of the header are also left in the queued original.

After a RESET, rose_requeue_frames() puts those originals back on the
write queue and rose_kick() sends them again with vs/vr restarted at
zero. rose_send_iframe() only ORs the new values into byte 2, so the
retransmitted frame carries the bitwise OR of the old and new N(R) and
N(S). The peer rejects the invalid N(R) with a new RESET REQUEST, the
frames are requeued again, and the two nodes reset each other forever.

This was observed on a live FPAC network: a White Pages circuit between
two nodes looping on RESET REQUEST / RESET CONFIRMATION / DATA at about
2000 frames per second, with DATA frames resent as "R3 S7" right after
a reset instead of "R0 S0", until the application was restarted.

Clear everything but the M bit before setting the sequence numbers, as
x25_send_iframe() does for modulo 8 circuits.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit b16b091aeb78faac22cf2b850246826d23f4a335)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_out.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rose/rose_out.c b/net/rose/rose_out.c
index 9050e33c96042..6672fc65a7651 100644
--- a/net/rose/rose_out.c
+++ b/net/rose/rose_out.c
@@ -34,6 +34,7 @@ static void rose_send_iframe(struct sock *sk, struct sk_buff *skb)
 	if (skb == NULL)
 		return;
 
+	skb->data[2] &= ROSE_M_BIT;
 	skb->data[2] |= (rose->vr << 5) & 0xE0;
 	skb->data[2] |= (rose->vs << 1) & 0x0E;
 
-- 
2.53.0



