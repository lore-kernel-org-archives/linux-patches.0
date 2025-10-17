Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4F836CE19;
	Fri, 17 Oct 2025 15:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715187; cv=none; b=TfSa5+fOfDEQGygvS6Iw9p2stQGA2I3IESnKH/KwcaTXOj7A8HYzag11H76pfxnv0qa3TQqiT8ngW/bcxPyCInHJxXmdGE0CrqVa2gtP4kHJVoUCVaDbqd8pe5qOS+6mOFsyhWD9xEeIzofzitfR0TJxbKLxcxzdloJXyCYyMMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715187; c=relaxed/simple;
	bh=WG00oQunSAvlw9OLb552YG5OWIRcIZRfG5Ba2RaMtwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBK6k/6kKSoXDuQ+ZHMPe6dF6u8cVMRMtvdhSRuPvFRIGkI1opsQdj69ipF3EGBVyXCzL40PXvRmrSx2oEXyPScFrTJUUU/4VfNFLm+nwdgk5hf1QpcBny1urA4lAKrcpxqLlWTwXRHY0ho+O6CUKa4fnZi9A88fH1Q2YOEjj2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uf3gdNyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uf3gdNyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47495C113D0;
	Fri, 17 Oct 2025 15:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715187;
	bh=WG00oQunSAvlw9OLb552YG5OWIRcIZRfG5Ba2RaMtwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uf3gdNykYBTh40fVOFXtbU4uhYaftrO5N+Cifmab4p3fzU1rgYtYSOK5eVtM6+GaF
	 0GrLgCEDxsKX/k4c+BnIGKIHz3enJnt5miFrSYVgWZ+sDGPlso6hVLNz/5iGJbMjGV
	 X85G8LHIlIFZtM1imri+fnez+GvrUWNobSTEjcsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 096/371] tcp: take care of zero tp->window_clamp in tcp_set_rcvlowat()
Date: Fri, 17 Oct 2025 16:51:11 +0200
Message-ID: <20251017145205.413221502@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 89040007c7b70..ba36f558f144c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1771,6 +1771,7 @@ EXPORT_IPV6_MOD(tcp_peek_len);
 /* Make sure sk_rcvbuf is big enough to satisfy SO_RCVLOWAT hint */
 int tcp_set_rcvlowat(struct sock *sk, int val)
 {
+	struct tcp_sock *tp = tcp_sk(sk);
 	int space, cap;
 
 	if (sk->sk_userlocks & SOCK_RCVBUF_LOCK)
@@ -1789,7 +1790,9 @@ int tcp_set_rcvlowat(struct sock *sk, int val)
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



