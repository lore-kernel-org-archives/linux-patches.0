Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FC31EABD1;
	Tue, 15 Oct 2024 12:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994175; cv=none; b=CPyzieMT0HjVbABNY6SOK7XESH2l3T7inZsoGET1pfghbw+8U41CVtQQeEATMPrg5SZvj33bQ4/QJHxoNXhbGTs68BXyqAF1aYKQrnr7nj+CQ88Tlcwx2Wp+13z8C/9gHnooGwXPoxYrOUw4ULFzKSihZMhNp+wQrEukwkEIecs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994175; c=relaxed/simple;
	bh=OahfFuCaISYWq/XpHgmwQEi7gh0Txw6OkOWDjwxyTNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuMgcCpoW7lvRsV8tFZnrq8eh1/HJE+63GXy62+p1GmMI7G7aK3kYtiLr1wbWshaEddOfjVRpLUbBmOJowFkzgY8ghytvI0sv98DusKm7VDbSfK8wuchCA4qRypQTBsKff6Eu4NOr67e9u1sseE4aslXYMshFolope2MdBnTlvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mONDI2CB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mONDI2CB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2669EC4CEC6;
	Tue, 15 Oct 2024 12:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994175;
	bh=OahfFuCaISYWq/XpHgmwQEi7gh0Txw6OkOWDjwxyTNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mONDI2CBkisMF3rIfBWBmUNTOfmfnezPW1yTW/hlo49TszJLVfpyCCL1je5Aqgqkq
	 bZSZc2YfV7xoe8KUPasbszCvkne9vc31ypvmz9IcY1zVid3tgxP65MO9hgsFfDX5HA
	 VTMCxEk6hwr7PB3Virhu3yzjW6D7r9+vSzz/U17U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geumhwan Yu <geumhwan.yu@samsung.com>,
	Neal Cardwell <ncardwell@google.com>,
	Yuchung Cheng <ycheng@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 629/691] tcp: fix to allow timestamp undo if no retransmits were sent
Date: Tue, 15 Oct 2024 13:29:37 +0200
Message-ID: <20241015112505.296301757@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit e37ab7373696e650d3b6262a5b882aadad69bb9e ]

Fix the TCP loss recovery undo logic in tcp_packet_delayed() so that
it can trigger undo even if TSQ prevents a fast recovery episode from
reaching tcp_retransmit_skb().

Geumhwan Yu <geumhwan.yu@samsung.com> recently reported that after
this commit from 2019:

commit bc9f38c8328e ("tcp: avoid unconditional congestion window undo
on SYN retransmit")

...and before this fix we could have buggy scenarios like the
following:

+ Due to reordering, a TCP connection receives some SACKs and enters a
  spurious fast recovery.

+ TSQ prevents all invocations of tcp_retransmit_skb(), because many
  skbs are queued in lower layers of the sending machine's network
  stack; thus tp->retrans_stamp remains 0.

+ The connection receives a TCP timestamp ECR value echoing a
  timestamp before the fast recovery, indicating that the fast
  recovery was spurious.

+ The connection fails to undo the spurious fast recovery because
  tp->retrans_stamp is 0, and thus tcp_packet_delayed() returns false,
  due to the new logic in the 2019 commit: commit bc9f38c8328e ("tcp:
  avoid unconditional congestion window undo on SYN retransmit")

This fix tweaks the logic to be more similar to the
tcp_packet_delayed() logic before bc9f38c8328e, except that we take
care not to be fooled by the FLAG_SYN_ACKED code path zeroing out
tp->retrans_stamp (the bug noted and fixed by Yuchung in
bc9f38c8328e).

Note that this returns the high-level behavior of tcp_packet_delayed()
to again match the comment for the function, which says: "Nothing was
retransmitted or returned timestamp is less than timestamp of the
first retransmission." Note that this comment is in the original
2005-04-16 Linux git commit, so this is evidently long-standing
behavior.

Fixes: bc9f38c8328e ("tcp: avoid unconditional congestion window undo on SYN retransmit")
Reported-by: Geumhwan Yu <geumhwan.yu@samsung.com>
Diagnosed-by: Geumhwan Yu <geumhwan.yu@samsung.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241001200517.2756803-2-ncardwell.sw@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c51ad6b353eef..699c48745cdd9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2433,8 +2433,22 @@ static bool tcp_skb_spurious_retrans(const struct tcp_sock *tp,
  */
 static inline bool tcp_packet_delayed(const struct tcp_sock *tp)
 {
-	return tp->retrans_stamp &&
-	       tcp_tsopt_ecr_before(tp, tp->retrans_stamp);
+	const struct sock *sk = (const struct sock *)tp;
+
+	if (tp->retrans_stamp &&
+	    tcp_tsopt_ecr_before(tp, tp->retrans_stamp))
+		return true;  /* got echoed TS before first retransmission */
+
+	/* Check if nothing was retransmitted (retrans_stamp==0), which may
+	 * happen in fast recovery due to TSQ. But we ignore zero retrans_stamp
+	 * in TCP_SYN_SENT, since when we set FLAG_SYN_ACKED we also clear
+	 * retrans_stamp even if we had retransmitted the SYN.
+	 */
+	if (!tp->retrans_stamp &&	   /* no record of a retransmit/SYN? */
+	    sk->sk_state != TCP_SYN_SENT)  /* not the FLAG_SYN_ACKED case? */
+		return true;  /* nothing was retransmitted */
+
+	return false;
 }
 
 /* Undo procedures. */
-- 
2.43.0



