Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063764;
	b=LAGRoiI5m32cWYvX1s4cGY23yzB3V2RUL7I5ryLvVglbmxXqY6vnBwnKEyrzIBzyrP2q
	 MrJst5cJ71S/e5OGt1lL8GUNPuqUaqKst4qPiX8v4nGh5YrLYZU1NMiufDlV35AgPfLV0
	 Hn+AKgrZWbUZ5aSLCxDG5jjRge6UFtQpaBXmnvT7JH5qhUkQ8NRl2cxUmN+0cVWbOV5dF
	 si/qdzIpANRK/fpKcOrIscbW0E2SFRXNOiZsmC51bNn4Y/ZKN2n6jsM6S8D0Ygllx/i9x
	 U+muQIYGNfPb6CN+tgfXBEIp96uZkkVxJAZOttaNQKzs1kUt5mjKYYYdzqvCvOWFQWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SDU4H1VCpf2bWTSOolc2qHv9PeJnn0uFAVfzuP9nQm4=;
	b=oj5OvMqyl2oAnAjaSZPOsjZPxkfKu9I7tPtcs/kVVa+R8XD6ZEs9Pw1M/dwmAffvfPd5
	 Bvwslh/OCfsdj4CBQzPoI4SyvDgrDSeauCrP3Id+DWLOQfyivViSMsOqvBUE7jHD82QjH
	 k2awzFjz7GUReL1K7aUiLlc4FUzjuF4zU+mSrqrl/Y1vDkD75bJc41CAwgnOKQp/QBLIM
	 eqGwSRw0mVxgFMhqTtaVZczUE4VgxYuOFP0Pr9/L0JSFQhuYEsgFB7y0XIRgDgJCTZgwI
	 QXOBWYuFc/5QrLyh8TcounOBXc+H5k9U6PBuz/x9JY26FNV+CUC+u04exdf6eGwKQHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wcBssUKY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF2B6083638;
	Sat,  7 Nov 2026 15:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wcBssUKY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CE71F008A1;
	Sat,  7 Nov 2026 15:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063764;
	bh=SDU4H1VCpf2bWTSOolc2qHv9PeJnn0uFAVfzuP9nQm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wcBssUKYX9nupVkiPG0e1NlDJOupwSaLMvP7Qgv1YoFUn6QfcqRUir8R1HHbyhe/e
	 cqmHNNq9VXsSA7qCIR8zHC7+2bZgatNfKRT44AWshGGOnuZbdEqdBTK9Bo3HSujRtA
	 sMlp+EmdCp1EZKwtIIxK8hd6rqRgVcPLT4A8zjJ4=
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
Subject: [PATCH 6.18 857/869] tcp: fix reordering addition overflow in MTU probing
Date: Sat,  7 Nov 2026 08:58:59 -0500
Message-ID: <20261107134921.810445675@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f6210d4a3408f..b39ab081e3a66 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2631,7 +2631,7 @@ static int tcp_mtu_probe(struct sock *sk)
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



