Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA50220EB;
	Mon, 14 Oct 2024 14:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916252; cv=none; b=LmcJXIrqzyxm9+hRga1z/o4OPrjNmsXUCwZd4MbSlhbkxjki+9W2f34HKC260L5iQGNXiRURitEssqpD4WUDxPEtKJ4C5aIrvD2t7KLj4CfWQ10yTd2r6xkSY2oZCurPik3UCrjU38xHpAbWN0lMqof0owuhET7kgFZteWzToKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916252; c=relaxed/simple;
	bh=zX8oNh4kHKouO5e/EZ3ii9Tb8tqpagK7/7vnW6QeQZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Is3NLpcn74cxmBeqrYMJRRybE3l1pkemAkVpsb1aNXZLONSr+rXM4FdBGen8Fb7G3Gc0q0Jz8rJLxImYThmhju8IhugrzsnIW4SyuklRm1pFfqBm4TAcK/PVhxJCbhG8O6SHL0iA351qSL7dMSMMj76fghogYRqiRzLsVZkYoNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wF59XFYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wF59XFYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC92EC4CEC3;
	Mon, 14 Oct 2024 14:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916252;
	bh=zX8oNh4kHKouO5e/EZ3ii9Tb8tqpagK7/7vnW6QeQZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wF59XFYTYomqX6+snHSs3LJb8auYIzZRo58zwKt8eV9z9ugwwLuwjBiyB5XtFQuSt
	 0EnNOwVyRuZ+KxFXBf7loPM0dvtE5szrs9eZvFdT0cMd5WcG/XN4JFqK8ejyQD2tKP
	 Y4wRHHHVY9R75i0GI7eK5Z+hvHqkWLUcPHEOfe8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Cardwell <ncardwell@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 096/214] tcp: fix TFO SYN_RECV to not zero retrans_stamp with retransmits out
Date: Mon, 14 Oct 2024 16:19:19 +0200
Message-ID: <20241014141048.740608415@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit 27c80efcc20486c82698f05f00e288b44513c86b ]

Fix tcp_rcv_synrecv_state_fastopen() to not zero retrans_stamp
if retransmits are outstanding.

tcp_fastopen_synack_timer() sets retrans_stamp, so typically we'll
need to zero retrans_stamp here to prevent spurious
retransmits_timed_out(). The logic to zero retrans_stamp is from this
2019 commit:

commit cd736d8b67fb ("tcp: fix retrans timestamp on passive Fast Open")

However, in the corner case where the ACK of our TFO SYNACK carried
some SACK blocks that caused us to enter TCP_CA_Recovery then that
non-zero retrans_stamp corresponds to the active fast recovery, and we
need to leave retrans_stamp with its current non-zero value, for
correct ETIMEDOUT and undo behavior.

Fixes: cd736d8b67fb ("tcp: fix retrans timestamp on passive Fast Open")
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241001200517.2756803-4-ncardwell.sw@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 631e44c344454..889db23bfc05d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6677,10 +6677,17 @@ static void tcp_rcv_synrecv_state_fastopen(struct sock *sk)
 	if (inet_csk(sk)->icsk_ca_state == TCP_CA_Loss && !tp->packets_out)
 		tcp_try_undo_recovery(sk);
 
-	/* Reset rtx states to prevent spurious retransmits_timed_out() */
 	tcp_update_rto_time(tp);
-	tp->retrans_stamp = 0;
 	inet_csk(sk)->icsk_retransmits = 0;
+	/* In tcp_fastopen_synack_timer() on the first SYNACK RTO we set
+	 * retrans_stamp but don't enter CA_Loss, so in case that happened we
+	 * need to zero retrans_stamp here to prevent spurious
+	 * retransmits_timed_out(). However, if the ACK of our SYNACK caused us
+	 * to enter CA_Recovery then we need to leave retrans_stamp as it was
+	 * set entering CA_Recovery, for correct retransmits_timed_out() and
+	 * undo behavior.
+	 */
+	tcp_retrans_stamp_cleanup(sk);
 
 	/* Once we leave TCP_SYN_RECV or TCP_FIN_WAIT_1,
 	 * we no longer need req so release it.
-- 
2.43.0



