Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D905335092;
	Fri, 17 Oct 2025 15:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713568; cv=none; b=PQp8CPDWa2MxIBXfsQWpLmOY9qrIv1O2ZJqmUhDn0oQZsOmn1l2Z4cSuH3kvp5zQ8oU03T/3TMK0Ra5MK8ghycoijGMKkXja9VyyhI5LzQbnXghMHAAXU4JDCIyvrQWLjM0frK6pXFRUbu+60Z0iSkKlF7cq8q5JyMFaY5afNvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713568; c=relaxed/simple;
	bh=/NIMGXhwKXG8KO8Ia6nMbUyf7Fg9KzBX7OKshaOWILs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZejQtd3AUUxvlCQWaoHPCSRyFyssyvo+UfWrWFWnvPfD9hE1NYvh2zTRVv08Ywb3mQxE2Pl0uuV6v8k/DFP95HNUZoIoQxh9ZxaqlI6NIcJnaLGOVF5lJudJOZPDjjMet4hffCbCWn4sF3E+vmL00ukD0dvw1QUwSyVMg6yaF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4miB3w6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4miB3w6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF65C4CEE7;
	Fri, 17 Oct 2025 15:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713568;
	bh=/NIMGXhwKXG8KO8Ia6nMbUyf7Fg9KzBX7OKshaOWILs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4miB3w6mUOLRx9JJ+epeWBkzPfv/XHJmCEG7QqdtwkSM0VeV5twlbXuTyg27hfWJ
	 cP2EkbaBepBROOkcczFjXdVE3Bu8k2dKe0+g0joNPeDy+dGnCwUv5+4tVqJffmM3Q4
	 R8sibAacg0GKY9tlx91xeCcKO34+ueIIOaJTI4kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/201] tcp: take care of zero tp->window_clamp in tcp_set_rcvlowat()
Date: Fri, 17 Oct 2025 16:51:42 +0200
Message-ID: <20251017145136.255774022@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 21b29e74ffe5a6c851c235bb80bf5ee26292c67b ]

Some applications (like selftests/net/tcp_mmap.c) call SO_RCVLOWAT
on their listener, before accept().

This has an unfortunate effect on wscale selection in
tcp_select_initial_window() during 3WHS.

For instance, tcp_mmap was negotiating wscale 4, regardless
of tcp_rmem[2] and sysctl_rmem_max.

Do not change tp->window_clamp if it is zero
or bigger than our computed value.

Zero value is special, it allows tcp_select_initial_window()
to enable autotuning.

Note that SO_RCVLOWAT use on listener is probably not wise,
because tp->scaling_ratio has a default value, possibly wrong.

Fixes: d1361840f8c5 ("tcp: fix SO_RCVLOWAT and RCVBUF autotuning")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Link: https://patch.msgid.link/20251003184119.2526655-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7d824578f217a..5dde0aed31440 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1724,6 +1724,7 @@ EXPORT_SYMBOL(tcp_peek_len);
 /* Make sure sk_rcvbuf is big enough to satisfy SO_RCVLOWAT hint */
 int tcp_set_rcvlowat(struct sock *sk, int val)
 {
+	struct tcp_sock *tp = tcp_sk(sk);
 	int space, cap;
 
 	if (sk->sk_userlocks & SOCK_RCVBUF_LOCK)
@@ -1742,7 +1743,9 @@ int tcp_set_rcvlowat(struct sock *sk, int val)
 	space = tcp_space_from_win(sk, val);
 	if (space > sk->sk_rcvbuf) {
 		WRITE_ONCE(sk->sk_rcvbuf, space);
-		WRITE_ONCE(tcp_sk(sk)->window_clamp, val);
+
+		if (tp->window_clamp && tp->window_clamp < val)
+			WRITE_ONCE(tp->window_clamp, val);
 	}
 	return 0;
 }
-- 
2.51.0



