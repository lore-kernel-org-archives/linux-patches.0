Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17F0C8C8;
	Mon, 11 Dec 2023 18:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgkAxEqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47853C433CA;
	Mon, 11 Dec 2023 18:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320381;
	bh=TGzXTfEICl/VoO7YSi5M/+zHWoYDYxCKb4aPeBAGL/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgkAxEqQKzrtFavhsHFEVVF5O84tufq1V/0kB7uPjv/ik5NYX86V8FYmv6mPeUBXa
	 hl20zN2WwF6W4X8XT4/Z0gJUaewT2Ck7vE4pwynFkHN7dkQD9wgqpibZGOZynl0DxH
	 CiHMg925XZFXBEIUPtSbsjNLVIcq66r/mhKyNaGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gibson <david@gibson.dropbear.id.au>,
	Stefano Brivio <sbrivio@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/194] tcp: fix mid stream window clamp.
Date: Mon, 11 Dec 2023 19:20:30 +0100
Message-ID: <20231211182038.374626631@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 58d3aade20cdddbac6c9707ac0f3f5f8c1278b74 ]

After the blamed commit below, if the user-space application performs
window clamping when tp->rcv_wnd is 0, the TCP socket will never be
able to announce a non 0 receive window, even after completely emptying
the receive buffer and re-setting the window clamp to higher values.

Refactor tcp_set_window_clamp() to address the issue: when the user
decreases the current clamp value, set rcv_ssthresh according to the
same logic used at buffer initialization, but ensuring reserved mem
provisioning.

To avoid code duplication factor-out the relevant bits from
tcp_adjust_rcv_ssthresh() in a new helper and reuse it in the above
scenario.

When increasing the clamp value, give the rcv_ssthresh a chance to grow
according to previously implemented heuristic.

Fixes: 3aa7857fe1d7 ("tcp: enable mid stream window clamp")
Reported-by: David Gibson <david@gibson.dropbear.id.au>
Reported-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/705dad54e6e6e9a010e571bf58e0b35a8ae70503.1701706073.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h |  9 +++++++--
 net/ipv4/tcp.c    | 22 +++++++++++++++++++---
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 19646fdec23dc..c3d56b337f358 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1460,17 +1460,22 @@ static inline int tcp_full_space(const struct sock *sk)
 	return tcp_win_from_space(sk, READ_ONCE(sk->sk_rcvbuf));
 }
 
-static inline void tcp_adjust_rcv_ssthresh(struct sock *sk)
+static inline void __tcp_adjust_rcv_ssthresh(struct sock *sk, u32 new_ssthresh)
 {
 	int unused_mem = sk_unused_reserved_mem(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	tp->rcv_ssthresh = min(tp->rcv_ssthresh, 4U * tp->advmss);
+	tp->rcv_ssthresh = min(tp->rcv_ssthresh, new_ssthresh);
 	if (unused_mem)
 		tp->rcv_ssthresh = max_t(u32, tp->rcv_ssthresh,
 					 tcp_win_from_space(sk, unused_mem));
 }
 
+static inline void tcp_adjust_rcv_ssthresh(struct sock *sk)
+{
+	__tcp_adjust_rcv_ssthresh(sk, 4U * tcp_sk(sk)->advmss);
+}
+
 void tcp_cleanup_rbuf(struct sock *sk, int copied);
 void __tcp_cleanup_rbuf(struct sock *sk, int copied);
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 288678f17ccaf..58409ea2da0af 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3473,9 +3473,25 @@ int tcp_set_window_clamp(struct sock *sk, int val)
 			return -EINVAL;
 		tp->window_clamp = 0;
 	} else {
-		tp->window_clamp = val < SOCK_MIN_RCVBUF / 2 ?
-			SOCK_MIN_RCVBUF / 2 : val;
-		tp->rcv_ssthresh = min(tp->rcv_wnd, tp->window_clamp);
+		u32 new_rcv_ssthresh, old_window_clamp = tp->window_clamp;
+		u32 new_window_clamp = val < SOCK_MIN_RCVBUF / 2 ?
+						SOCK_MIN_RCVBUF / 2 : val;
+
+		if (new_window_clamp == old_window_clamp)
+			return 0;
+
+		tp->window_clamp = new_window_clamp;
+		if (new_window_clamp < old_window_clamp) {
+			/* need to apply the reserved mem provisioning only
+			 * when shrinking the window clamp
+			 */
+			__tcp_adjust_rcv_ssthresh(sk, tp->window_clamp);
+
+		} else {
+			new_rcv_ssthresh = min(tp->rcv_wnd, tp->window_clamp);
+			tp->rcv_ssthresh = max(new_rcv_ssthresh,
+					       tp->rcv_ssthresh);
+		}
 	}
 	return 0;
 }
-- 
2.42.0



