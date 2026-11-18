Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045917;
	b=GuHG2026xuO9rfoF/U9a7Fyt5U/tVT+U0Rzu753R7HEnhzBI/3sZSQZ5J6Tb0c278Nnl
	 VMScpaq2aEHkfsy0Xbi1D9nK/1CrRgrnNHpaOoolVraMHrSBAyfMMrBDbD+LVuuQQnq38
	 PowKd7JIxfYNrF0M3VCXM4kUy8SA8BEpVV4InScNGmhg+n5vLLjXNBLx9dVNx3/k8VAFE
	 YRQZLyK/rozWb5vui4ZtiqrLKdt//LGyOKjCt/sly0dCYHnYGz0FR+I3R38ca7zOZ8k9m
	 UyGLt6Ps3hB7JiwqCkgdRA2Z7nK3VP+IdQlb0xz7Zigl7KqM137k0MEp8/9ixxuOUow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LT3Kh1PTtMwsetUVXklzyC7LT28quVvBprg2kguFK4o=;
	b=zprhsRxHP8pLQdvuHgbZxPltRFUCQqaujSg6FkZ5vSgG56MUKxE191/Wq5KDIZl4mQLA
	 UN8dLQrk+H5Nb2b/u0xpev/6bs3alNRqGqH2y5I0KxbhQKB3r00E+1RG64yWlsV0LhpCg
	 ItgV9nF5yNOvee/CdPrNdoZycVooInVOFeh0nvS+FW+tXQQrA86ePzSXWofIIZ7ApDcOu
	 cksoBMcuihkL3PoLh4LF5r+tc0iaN4YHXvzT3ACi81F6kJlEjKKvXYJWJ0bGu2vMXsekV
	 Bnx5ifAMJukS55RcvbCe/KbP2I/DgSVCAMcFeoxd/VqANbiofSHZtWyeBQ4oqIM1Pww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnoVTMR5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAE8606A31C;
	Wed, 18 Nov 2026 23:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnoVTMR5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346701F000C4;
	Wed, 18 Nov 2026 23:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045917;
	bh=LT3Kh1PTtMwsetUVXklzyC7LT28quVvBprg2kguFK4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnoVTMR5Q0gESKP+rQdNRikTxo0xBwuv7NGl2qScTUiAlNBmJxeKDA1S0WShC93C7
	 XZaNrOyuQiitq0V5S7gIfiYNwSlCgMXjRm4PDl7TaLQA4wdfXmOOeUOKx7fP6/YhZe
	 zB5MkywnsFc7lbI7o/RRABXu6yZbwbWFNmYDux7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wyatt Feng <bronzed_45_vested@icloud.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1095/2857] tcp: fix reordering addition overflow in MTU probing
Date: Wed, 18 Nov 2026 15:35:29 +0100
Message-ID: <20261118150241.049658869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit c1df9c0c0536393de43310f84ca4f8b217271a00 ]

Commit efb8763d7bbb ("net: ipv4: bound TCP reordering sysctl writes and
MTU probe sizes") widened size_needed and the MSS multiplication, but
tp->reordering + 1 is still evaluated as u32. RTAX_REORDERING accepts
an unrestricted u32, and tcp_init_metrics() can install U32_MAX.

In that case the extra-data requirement becomes zero. A write queue
with probe_size - 1 data bytes and a FIN satisfies the sequence-space
check. The coalescing walk can pass the queue head to
tcp_skb_can_collapse(), and tcp_clone_payload() can produce an skb
whose advertised payload exceeds the data in its fragments. Local
delivery followed by TCP_ZEROCOPY_RECEIVE can then walk beyond the
fragment array. KASAN reports a slab-out-of-bounds read in
can_map_frag().

Cast reordering before incrementing it so the arithmetic handles the
entire u32 metric range. For U32_MAX, the required size exceeds the
32-bit queue and window limits, so the existing checks skip the probe.
The calculation is unchanged for all other reordering values.

Fixes: efb8763d7bbb ("net: ipv4: bound TCP reordering sysctl writes and MTU probe sizes")
Cc: stable@vger.kernel.org
Cc: Wyatt Feng <bronzed_45_vested@icloud.com>
Cc: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20261028160226.2170244-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5117de7afc24f..f0a4ce8f3dd1c 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2376,7 +2376,7 @@ static int tcp_mtu_probe(struct sock *sk)
 	mss_now = tcp_current_mss(sk);
 	probe_size = tcp_mtu_to_mss(sk, (icsk->icsk_mtup.search_high +
 				    icsk->icsk_mtup.search_low) >> 1);
-	size_needed = probe_size + (tp->reordering + 1) * (u64)tp->mss_cache;
+	size_needed = probe_size + ((u64)tp->reordering + 1) * tp->mss_cache;
 	interval = icsk->icsk_mtup.search_high - icsk->icsk_mtup.search_low;
 	/* When misfortune happens, we are reprobing actively,
 	 * and then reprobe timer has expired. We stick with current
-- 
2.53.0



