Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065581;
	b=bYxKjp5pkbeF6NWiBW5IhSe/BXz0BQPJoWfw3jCBXjcFI88hrhlqG7tvop/2b3nr5PnD
	 VemYLMf7apl64XAdTBUYgSpe6lGjzw5y4plp0cRc5DUyD6PYvVzE9exkPWfrDCqYlQkty
	 U9lvi4VvDTkplKh2u0upc4MOCdnxpbm7J0oA7yV4AYUgpKCWEsxmOZOvSMJpq3A/F21Lv
	 FmDOeFXOTaD/QvgeM7Imrv278J3n3vD05+mdw8pAg29bKm97nF0lCAIH4UEdQZ9YFpXK+
	 AL2N7xw9g7iZlyD+I7KKOOiMgKZV7he+hdKbW6fXKEUCCWMdxvhVojBItfOBPlltfuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0MiKwfTVEN8AuI04Tv/fzmDttg/QuUusirPZuDUgRR0=;
	b=WoAgXDeCudUSRDNSZH3ciWDEIRE35+w5pmwhSCXThcKETV/kZDuiUD4et/wFethU0UzX
	 7hsRCVTjeOFLt2g+O0FtU4IN/YuOoajlTscOxfnCBxboP3+4a+q8sCCXr1PIwhZrzMP0v
	 bI3Jdt+i46yoGm2kHFiuTiMWQxKxkd8rlBSNl4UyvJVK1kvgSiz/KRFgCHU6Tfng0Q+kF
	 PiaXIXbFrTBx3Xwsv+ekARiLtyP5wbRNXg8oe0/nQefS/69LwBQBLeDZEeTcTfZr95nK3
	 Tf9Ts1SlOOp4uPMdMArvNuvFZnaILfPbmmbxTxk54kPjZsTDz0tewwoYmFNG9UuGlrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ILxWZe/T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2E9606A32C;
	Sat,  7 Nov 2026 15:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILxWZe/T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10FB1F0089F;
	Sat,  7 Nov 2026 15:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065581;
	bh=0MiKwfTVEN8AuI04Tv/fzmDttg/QuUusirPZuDUgRR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILxWZe/TsMmZdlGzwqW+lOEqgJqDFGk7i3cT44PkyMeaT2/2YVXvS79RrWSdVi3rh
	 oFrlONuWvIxHlnJy3eT5HpMJ0cQbCEzm2Ql5vszM2B9fFmFDtNExXZXZ7LdKeZUrTW
	 8hy8ayoKM/bP0yoIwKtftDBrt7LDFQ6ATh6M1+5E=
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
Subject: [PATCH 7.3 1240/1257] tcp: fix reordering addition overflow in MTU probing
Date: Sat,  7 Nov 2026 08:58:56 -0500
Message-ID: <20261107135013.583576118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e0c392e29de5a..9f47b6644ed4d 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2712,7 +2712,7 @@ static int tcp_mtu_probe(struct sock *sk)
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



