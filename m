Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8092F5E;
	Tue, 12 Aug 2025 18:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023919; cv=none; b=InobvH87AWGm8B1cTDaXV7z3OjfxW0WhzXRIWAV3agsva8Qk7kkNEORbZo7iwqi2i05cwdqyCoPeZkthhudfhEnkiiNGd9Q9EINkB/98Y2CtSsPgFPAdPAAHtwaSbz7G+3/8nGQ41uwXpaXcBp7fTQxCj+jda70AJI/4CAvR82Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023919; c=relaxed/simple;
	bh=hIlfwxS6e2iaXvexqIrQOKUq7leLoBsbGwhdRlhS2bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jC2xwUadZye+Qe1fIUs8JJ+04oeHI84dgab73cdXdO8j7hoJnN3lgAONVCIkVYHnDuXjijSW4/dhkmYc0v7CFGMZwyWKDW61VjDTMgJ5J44IlOQTIILmC+lByM/5GIV5zBVCegT47EImeV3FK4WlHZvGp9R2XUWyt1GbM3+95+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OLrXbzOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OLrXbzOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1044C4CEF0;
	Tue, 12 Aug 2025 18:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023919;
	bh=hIlfwxS6e2iaXvexqIrQOKUq7leLoBsbGwhdRlhS2bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLrXbzOaPECupqAc8kjBMIDofyGb+D1715GTO6XD8dZuUi01SAvrZw4Rt90xmezW3
	 F8gZUmKWgY6wiE8DNpT3qnDzmcPVJrasRBEQZmWy8H9AfoFUwwGx9Qr72AodGlJOc5
	 Qat0zVlKo0Do0puIHfJ2CudjlNMXE6FsUL2U8kIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 221/627] tcp: call tcp_measure_rcv_mss() for ooo packets
Date: Tue, 12 Aug 2025 19:28:36 +0200
Message-ID: <20250812173427.686453620@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 38d7e444336567bae1c7b21fc18b7ceaaa5643a0 ]

tcp_measure_rcv_mss() is used to update icsk->icsk_ack.rcv_mss
(tcpi_rcv_mss in tcp_info) and tp->scaling_ratio.

Calling it from tcp_data_queue_ofo() makes sure these
fields are updated, and permits a better tuning
of sk->sk_rcvbuf, in the case a new flow receives many ooo
packets.

Fixes: dfa2f0483360 ("tcp: get rid of sysctl_tcp_adv_win_scale")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250711114006.480026-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 76b01df70e56..94391f32a5d8 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5055,6 +5055,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		return;
 	}
 
+	tcp_measure_rcv_mss(sk, skb);
 	/* Disable header prediction. */
 	tp->pred_flags = 0;
 	inet_csk_schedule_ack(sk);
-- 
2.39.5



