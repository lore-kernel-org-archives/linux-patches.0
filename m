Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0E11465A8;
	Tue, 25 Jun 2024 09:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308751; cv=none; b=X0fvxhZEaOzJ0jM4UnhJy7J1oQeFiofJLY+aoGQFWYAohazADU1ryZcJuvMrkZKMbDp2KpAqzCj3ebRuFRp4756YWuMyryVgzHa2UzFE1UaqK2dajzv3+ioU8Q/YCNr/mfgHTo07AxE2TQwgv9fMf8XbC8tPDbb7r5fhEndRG/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308751; c=relaxed/simple;
	bh=Hbzf5OVsyENcQtD2P3CIX9kojdCjwNRMdSJa+4aHI+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIiTpUmAXXf6vOxR6qUDFUV63gh9EuH3cDVFweDHm6ytdxzBdna0mQItzIM18/NKSCWcDd/jk92Kj0xXo3Nx5FX6dkNifFSQW7mkhq8rPrZcDOXwUu3S5a1kICUxQMXs0NJf4RDsCXdwlRYG2nXLYVfySZA5bql5G0zVv3jy7GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UV64Hy5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UV64Hy5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57FEC32781;
	Tue, 25 Jun 2024 09:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308751;
	bh=Hbzf5OVsyENcQtD2P3CIX9kojdCjwNRMdSJa+4aHI+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UV64Hy5qbBCN5Za+xulsSfnzy/L/x+ikLtq/15zM5ftTclNbXafCTV5fe3x9ygmuy
	 uluoo3zpwOboMDWJ6CnGbaVEPqxeP1/cYCH0D/RbSmij8eyjXSfC0HLwnMZZsplU9i
	 SXqPl+aT/1CUsWQLAIg87wO2FnCYodV4RkQlMi/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Cardwell <ncardwell@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.9 226/250] tcp: clear tp->retrans_stamp in tcp_rcv_fastopen_synack()
Date: Tue, 25 Jun 2024 11:33:04 +0200
Message-ID: <20240625085556.726001109@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 9e046bb111f13461d3f9331e24e974324245140e upstream.

Some applications were reporting ETIMEDOUT errors on apparently
good looking flows, according to packet dumps.

We were able to root cause the issue to an accidental setting
of tp->retrans_stamp in the following scenario:

- client sends TFO SYN with data.
- server has TFO disabled, ACKs only SYN but not payload.
- client receives SYNACK covering only SYN.
- tcp_ack() eats SYN and sets tp->retrans_stamp to 0.
- tcp_rcv_fastopen_synack() calls tcp_xmit_retransmit_queue()
  to retransmit TFO payload w/o SYN, sets tp->retrans_stamp to "now",
  but we are not in any loss recovery state.
- TFO payload is ACKed.
- we are not in any loss recovery state, and don't see any dupacks,
  so we don't get to any code path that clears tp->retrans_stamp.
- tp->retrans_stamp stays non-zero for the lifetime of the connection.
- after first RTO, tcp_clamp_rto_to_user_timeout() clamps second RTO
  to 1 jiffy due to bogus tp->retrans_stamp.
- on clamped RTO with non-zero icsk_retransmits, retransmits_timed_out()
  sets start_ts from tp->retrans_stamp from TFO payload retransmit
  hours/days ago, and computes bogus long elapsed time for loss recovery,
  and suffers ETIMEDOUT early.

Fixes: a7abf3cd76e1 ("tcp: consider using standard rtx logic in tcp_rcv_fastopen_synack()")
CC: stable@vger.kernel.org
Co-developed-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Co-developed-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240614130615.396837-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6289,6 +6289,7 @@ static bool tcp_rcv_fastopen_synack(stru
 		skb_rbtree_walk_from(data)
 			 tcp_mark_skb_lost(sk, data);
 		tcp_xmit_retransmit_queue(sk);
+		tp->retrans_stamp = 0;
 		NET_INC_STATS(sock_net(sk),
 				LINUX_MIB_TCPFASTOPENACTIVEFAIL);
 		return true;


