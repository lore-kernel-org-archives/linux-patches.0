Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E875A221FD6;
	Mon, 23 Jun 2025 22:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716427; cv=none; b=PJs84dlqiyeMfiYdxkuy3ITRYACyHXPXh9JwgHEF2jDZFUliqxroL9S8VhxMHCwquJSpeLLXO/HCvyYD809bqatwgb+K15REFyBk079vkm+rJZtHZujvOIRz9x32Fup3x0NFPhxfHdYjGsaS2Xy7BeOWlcTE606/I2cTFLD1MIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716427; c=relaxed/simple;
	bh=tuZrvLmuRd4nAAnfmpFYBrp2Z6EnS4gBp4vTP9J54UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjmfCI9Fnu3H8tDpDoGME/PuBwPqOUDUbFpdjk619rOksYOk5156ngWKLgHcs5wQbJjui9x6KLHdxN3FVKu4injcwOAbnm9eSxSOmjc4v9khbWIAPHO2qYbgqVy71t82QHSSS2rpwgCU7yJzeoecWjt0g1gA91A5YECNNJoibV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/FeJC1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/FeJC1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1B4C4CEEA;
	Mon, 23 Jun 2025 22:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716426;
	bh=tuZrvLmuRd4nAAnfmpFYBrp2Z6EnS4gBp4vTP9J54UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/FeJC1/EURygx9yqBFFXPOjeoQcHi1YwaJINW6h1/z5b7c/LfHT6OKdDaAFsaK04
	 ldtFlzopfT4ol1AAmiwVm6ZvtqCXReXYO3oLc6cAbqXULT0GEtKVZEa/fLa1iLnme/
	 2CtJy61mfM/ZeV6A9sr2DtOGhxx3C+UI4QONBRsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Wei Wang <weiwan@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 315/411] tcp: fix initial tp->rcvq_space.space value for passive TS enabled flows
Date: Mon, 23 Jun 2025 15:07:39 +0200
Message-ID: <20250623130641.569376526@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cd171461b90a2d2cf230943df60d580174633718 ]

tcp_rcv_state_process() must tweak tp->advmss for TS enabled flows
before the call to tcp_init_transfer() / tcp_init_buffer_space().

Otherwise tp->rcvq_space.space is off by 120 bytes
(TCP_INIT_CWND * TCPOLEN_TSTAMP_ALIGNED).

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Wei Wang <weiwan@google.com>
Link: https://patch.msgid.link/20250513193919.1089692-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 000557f5c54bc..a52d5b718e6e1 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6573,6 +6573,9 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (!tp->srtt_us)
 			tcp_synack_rtt_meas(sk, req);
 
+		if (tp->rx_opt.tstamp_ok)
+			tp->advmss -= TCPOLEN_TSTAMP_ALIGNED;
+
 		if (req) {
 			tcp_rcv_synrecv_state_fastopen(sk);
 		} else {
@@ -6597,9 +6600,6 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		tp->snd_wnd = ntohs(th->window) << tp->rx_opt.snd_wscale;
 		tcp_init_wl(tp, TCP_SKB_CB(skb)->seq);
 
-		if (tp->rx_opt.tstamp_ok)
-			tp->advmss -= TCPOLEN_TSTAMP_ALIGNED;
-
 		if (!inet_csk(sk)->icsk_ca_ops->cong_control)
 			tcp_update_pacing_rate(sk);
 
-- 
2.39.5



