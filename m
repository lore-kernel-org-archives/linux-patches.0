Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209125;
	b=4HOk7s1WYf3QiFzzOdK9OnnZCy0CqUhAFEZYSfxsOc73awIXJ4zHFcUWoN1H4FoUev1l
	 CRUefArvK7HRALJuqOxAz8M1ZzzZAx1EsErpc0L6h5iruuueUpHaxVC74vjUNlRP2w0Xa
	 0Fl6ED8ALMQOuLL2rBce1VpTh7poxi6YAWWU29dowhnkd1nt8dZD7J7gQFkWunOtLpPph
	 djbkVFrkb4+LkHAOfYlq9fF7hKTRKh9dS9k6GaR0lTznBoYGsdTzaLUaNG8Gyam+1YyE7
	 jKK90OmYMffzZfw2aRtUWhBw9B3Rvn2sgQV8SrXMHgjeezPCyrCvVJ3F1Lfh88OMb4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=63KvAiyuqX7FY1BDGB4/wjqVn3bgUllgP7lt5l4p4p8=;
	b=nehx6zVPsYPidVDFrN6PqSkiY2ofX76NMzcTqHAWVTUoe9n4paJShXi9g2BdbJYgjzC7
	 DJmHh24P0BqFKxoDe7LhqnNcN6Me/cBtf5mhXeb4mwE1W/w8joV6PuuqcEqqHvTyW9ifF
	 XfRZ7CrvimWrw0e/Vi5NdL+i0MsGEhYjVuVEsFcNIDW/MKJYviA1DUzOK+vG42RFroMTD
	 er4L3ZCG5Xnn1c8q4/QM8BKxEIcmX437bMbj+MLtJ2nZMGjG3kNXhvfC/dBXVnTiQEa7r
	 KhKg4PIN7GQMbVYyzfyw0p6ZVxcU0NPtBAaFXvXPIRQPxtLmoINQKxk7jqj2kgaNWpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CW7tKyIr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1C1606A31F;
	Wed, 28 Oct 2026 17:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CW7tKyIr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6E11F01825;
	Wed, 28 Oct 2026 17:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209125;
	bh=63KvAiyuqX7FY1BDGB4/wjqVn3bgUllgP7lt5l4p4p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CW7tKyIrV8NjsbhGl/SDGK+K4sWVQGDs+wpIJXM9zsipLEmuhrOPXJLTnEoW5BxNG
	 JEHGGA84/+s4P0QJi/+iWuxPbNuH0cf1xo1ne/YGGfwWWYd3g5ilvHXz9RinN3uHcD
	 J+zmOKa4aL1ghzhQLFdUBA3bwvI0+irqNQ9CDzUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 360/516] flow_dissector: avoid u16 truncation of hlen in bpf_flow_dissect()
Date: Wed, 28 Oct 2026 17:58:32 +0100
Message-ID: <20261028170012.015367572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit f202578efc738b883cfa04889eb97328914265a7 ]

bpf_flow_dissect() sanitizes the offsets returned by the BPF program
with clamp_t(u16, ..., hlen).

If hlen is bigger than 65535, the upper bound is truncated before
the comparison. For instance, with hlen == 65536, both nhoff and
thoff are forced to zero, even if the program returned sane values.

This is the same class of bug as the one fixed in commit 99bda1ecbd56
("flow_dissector: avoid u16 truncation of skb->len when computing
thoff"). That fix does not cover the BPF path, because
__skb_flow_dissect() returns early when a BPF flow dissector
handles the packet.

struct bpf_flow_keys stores nhoff and thoff as u16, so cap hlen
to U16_MAX before clamping.

Found by sashiko while reviewing the commit above.

Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261007045616.445596-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index e93b674d4afef..365d5d049c0d0 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -884,6 +884,8 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
 
 	result = bpf_prog_run_pin_on_cpu(prog, ctx);
 
+	/* bpf_flow_keys offsets are u16: do not let @hlen be truncated. */
+	hlen = min_t(int, hlen, U16_MAX);
 	flow_keys->nhoff = clamp_t(u16, flow_keys->nhoff, nhoff, hlen);
 	flow_keys->thoff = clamp_t(u16, flow_keys->thoff,
 				   flow_keys->nhoff, hlen);
-- 
2.53.0



