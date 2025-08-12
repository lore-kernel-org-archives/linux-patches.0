Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B422221FAC;
	Tue, 12 Aug 2025 17:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021210; cv=none; b=gQJeo0X2qvauVtmWLJ1fD89BpnkkXzF4vGbMvdWPmVcS16YTEv3e68LEC5EgI/VTEi4b4dty7dO3vnUJSjhe/YjRrM2SJl19Kt0Fry5E8/899JJDRGoVcLYZf0FBYncZ9dNgeFhu6wCEs8TRWG2tbFasypXu49Q1BvsZLQgfqZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021210; c=relaxed/simple;
	bh=o1qyW3BnBO4bevlilRmACezvOT3ousSxF4bhIRhmM84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbxVYWjyg+UuD3pehrMzaEnnFKK8PMXdj2uUhYEFrg7X+DfabEpBgEqCk0j/O9FBL2Y3jSXUgZu2j1OLz3L7Nbe7rVuHyu+yehD/2J+OqJ9poc5sgVZvH/vVjD8BwXXVwUB+RTjcG4+z4TejrRSiqYb5H6XILeg7UEedNKZNASs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIuqBbhQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIuqBbhQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E095C4CEF6;
	Tue, 12 Aug 2025 17:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021210;
	bh=o1qyW3BnBO4bevlilRmACezvOT3ousSxF4bhIRhmM84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIuqBbhQ5+zNQhwGzd6gk7AjmU2F75UhbENJg2nU8l+EbjT9YnHjrJpC31/RDNbyJ
	 sGwb6qRLZxUxd/kyV0IkBWFMN16B/ZrX9Wgagcl8ujP8pVqDVLJvBoGnAX4DVizjpM
	 5wZSm4zj7reHPcKK9x2FiIm6XDYc4mdYax2gGT/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/262] tcp: call tcp_measure_rcv_mss() for ooo packets
Date: Tue, 12 Aug 2025 19:27:46 +0200
Message-ID: <20250812172956.359881959@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8520c43726e2..c6d00817ad3f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4941,6 +4941,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		return;
 	}
 
+	tcp_measure_rcv_mss(sk, skb);
 	/* Disable header prediction. */
 	tp->pred_flags = 0;
 	inet_csk_schedule_ack(sk);
-- 
2.39.5



