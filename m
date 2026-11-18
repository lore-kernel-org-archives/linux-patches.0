Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058778;
	b=IBbJ8Ai5Kg8iqldOhFlFCRBHlbCDaxqgQFJr/+7FozaO46+57fHMZDzUDqJFCouI5aE8
	 Dw4/hq0g5A6+Y85VjSomhm18jhPzkeBpo9v6Rf70yg5c49udCzO6/3sE0g1E3LZCOE43A
	 3vMjS5VxwDsl6Qwe9jx13FPnw9hV4J0hm48bknWL2wYOMiZDL2rVTJixNFwGRr+Rq5dyG
	 Fm94Bli+f1PP4mDDw+6YenAwBQuFubUL/PqZP4cn4UCvJPFfG8oF+3cGb5Zv1dR430u+Z
	 wwP/PMUhTz2o2O96igK6ALOLzA3/UcPCS6BM32OauamS8KWCni1/pLJjs0SqqInNWHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nQilw2os/jhT1PAKjppudb7pBCnfWqm6KwKdOcaBZiA=;
	b=C9crmjIqTc0sP2ifWZBHDUh/eIdQWVIYqoSc9FyG5QQL81ACZCiHGk9QF5/UXzX6P4Nq
	 9pPbBdEH4wzqI3Lopl0clnNojns+CZ6Qg4TYSa0VOF/wT1JOHkwlOktSmV/l6DzpShl+I
	 Z6XKnoxjoNaOLffQlyAzOA/nQhamK3HfY4qPIGlNKugVAIlzHymT/nit1TGoNG+566Te2
	 QUiiXb+aFdH9LR3pqiU6IpC+6X2ZxXg0fDhtfU+ygA3aIFIMV5vR7OgeZtL0c+z+WmY//
	 cOqHSKvv2eR8gKQNdHCO7kJY9i5sX8luQXUY+T3J0yt24E9WhMFbmWKAYJp+jCU7cEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZH7tJl9O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3BA606A31C;
	Thu, 19 Nov 2026 03:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZH7tJl9O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D701F000C4;
	Thu, 19 Nov 2026 03:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058777;
	bh=nQilw2os/jhT1PAKjppudb7pBCnfWqm6KwKdOcaBZiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZH7tJl9OsT4pVmxRx3RTTw0fYadDxnhCNbSw5CZZgMkWdvheHpmjAcvWzT/KEi8lc
	 4dpDkK7tgwjkzT/POBh7huhg0E6DxrdkD3FMGpiwvSVuFysEx3jfSY31iImMxXxmsW
	 cgr55cqYqfoIOHtC3MumTcDe977pDZMbKHLA4kQQ=
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
Subject: [PATCH 5.10 0606/1848] tcp: fix reordering addition overflow in MTU probing
Date: Wed, 18 Nov 2026 15:44:04 +0100
Message-ID: <20261118145940.719180743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6bde4c463a893..36f089f793def 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2367,7 +2367,7 @@ static int tcp_mtu_probe(struct sock *sk)
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



