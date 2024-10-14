Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA641AAE08;
	Mon, 14 Oct 2024 14:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916980; cv=none; b=m4xgi0xIK6wjzHn/u49J79F0m6Uct+EfdFk2dfFTyBA5hW9OriOWY40t23vxuAukxoJXLCQtnr1Khp8AA9vUk8Ds79JK8AKXqjypDWLFzkiMfkpX1RewFMOdrwxha9pfcFqmVI49psGOcx37nvOj1rZwjKewnN402HuTLo6TI/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916980; c=relaxed/simple;
	bh=2u4KIZvytcDgAbfrX+FXB3AyxXowIccrM8K4dAHhyYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=reDM42WwpLpiqMFbP+BC1TmC0m3ff6XuZ9JB25Xlfi5XVN+2fvBAvPi7XgjkSrn5vSNStGwZpnpgK8GMrrvSUy4uJ0J1BqBs88hFl9owd4lYGm207MNLSMhuHJCH4mmK4nzbXZ28Olu2qXNZTBCvnFy6Wgw4PU+PRStrB/RknD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ig34IEcp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ig34IEcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FF9C4CEC3;
	Mon, 14 Oct 2024 14:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916980;
	bh=2u4KIZvytcDgAbfrX+FXB3AyxXowIccrM8K4dAHhyYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ig34IEcpb7Bdn87UGbKLdtCvhatT1DEFsqfrht66/G2FiY5bDhci76DY0DZ/AKtUE
	 hywXfoQwLajSV84/8h285KB82XOITiXTSy4SO95yCLoymYDeEncUgiicRIukoAOIsp
	 Coa9WP0/whYG9Rj4K1wg3y/wUFD97fJ9vxcq9kGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Cardwell <ncardwell@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/213] tcp: fix TFO SYN_RECV to not zero retrans_stamp with retransmits out
Date: Mon, 14 Oct 2024 16:20:24 +0200
Message-ID: <20241014141047.573363140@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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
index d472f7052cd32..fb053942dba2a 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6554,10 +6554,17 @@ static void tcp_rcv_synrecv_state_fastopen(struct sock *sk)
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



