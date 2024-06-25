Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A99149C4F;
	Tue, 25 Jun 2024 09:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309299; cv=none; b=gho5hXvBDIhYH7uSmiPpGqCVBb3ITXeX3nAw6Cv+lQtUX4QjZd+KcmraQRORyLeGEAu76VhGBNinDFEIMIxlrM8DTc4RFwoasvAdwO28yOe9PspRLO6pZjz2P/K7d/ZUwEbW+X69qHtsePTYHNRlmM6GFyRPgh3WARIeSo8bw0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309299; c=relaxed/simple;
	bh=CK4+JH4OCD5kQiGn3M+8QSNM/dUuaTSRO1phapABJd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Snv7EYfrqNZArLRmlVRJ2tSpV4kBi4SFl7+o71yw74T5YhYfIxmJoM6zGU2Oza71f3jfcbdwQcLMcXPE2ewgSx2xTGkEy1GP0mGrD1LMt0MVvdItag9BC+tMgn5O2Fgc8QQeOsjMXcYTjjhi+51oHy71Yg9DyWxCPjLaSszLf3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFE71xmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFE71xmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACACFC32781;
	Tue, 25 Jun 2024 09:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309299;
	bh=CK4+JH4OCD5kQiGn3M+8QSNM/dUuaTSRO1phapABJd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFE71xmEAvRWfnKMxWh1dIXGNHOOFdmilDZ9GkTCL/E3YHfhsH09GkYbFxYxr7UPs
	 0QXRQl4D+gaBp2FqlsrIZQsR4dASKAfx2WdxpEpwWyXjPFikqTd9TEF5MnlypmSiie
	 fXmI4MsaYgGjpy2wokI14FnHjVBiVaLSTN7Srxdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Cardwell <ncardwell@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 163/192] tcp: clear tp->retrans_stamp in tcp_rcv_fastopen_synack()
Date: Tue, 25 Jun 2024 11:33:55 +0200
Message-ID: <20240625085543.419059678@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6176,6 +6176,7 @@ static bool tcp_rcv_fastopen_synack(stru
 		skb_rbtree_walk_from(data)
 			 tcp_mark_skb_lost(sk, data);
 		tcp_xmit_retransmit_queue(sk);
+		tp->retrans_stamp = 0;
 		NET_INC_STATS(sock_net(sk),
 				LINUX_MIB_TCPFASTOPENACTIVEFAIL);
 		return true;


