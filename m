Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE2E329E79;
	Tue, 13 Oct 2026 12:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896055; cv=none; b=sPMBgt+gb08tohkfpbqbYTLdt4v4d4p6CTdLBeX2zgXuOg+ktIIt6i8Ex5GvbAKr3MzWvaH+PC1tpATDLaWxsVqTgDUUXWSIfiKvh8bTRa2oVOD287eJTDy/zxlBIWURa4u8kqQ7CiPCRnJKprybcSNA3aKjK/m0ZlSdUkgiEw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896055; c=relaxed/simple;
	bh=ZaFE0uVWMQhoWhxlrPqnr3IfsNvqKWxcvONaBwavA+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guINuCyiVaarR0zIB8SXNNdJmrQIKnR7KuQMvl7YAiJmaYv4menOK3XaIr1I/fFXBGRn3gFCHrDNCdpM/NTpzAI8gpaeup54Lox3HpPOaKbKX5exh06QlkUJMCNOW0xmZlfUJBAPO2GDE4Jmtf6lxTNptF7qAhUrn9WFW/qVeYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFkn5m/7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFkn5m/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441171F000FF;
	Tue, 13 Oct 2026 12:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896053;
	bh=ZcLElSIshGAXoYIgjwnify2E6FxH+jHg0Ty4qCtUdks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wFkn5m/7lRHLu1q1z2GnTJm3uHFgeVcyBh114bIFoqpJjiGpovQyiqV1kcN8IZzX7
	 S+jRdROXjgIMhtSeIcACOM7W7ywJOQlKg+6y8OFg6PEJyHgoX/800aM+Xyx+oyQRCv
	 oghkxo0Tiw3mDAlOSABdXRlZ4CifWIZMFn+hj9mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 482/497] flow_dissector: avoid u16 truncation of hlen in bpf_flow_dissect()
Date: Tue, 13 Oct 2026 13:40:49 +0200
Message-ID: <20261013112919.316337536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c212f77499fb3..dc43742d881b3 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1023,6 +1023,8 @@ u32 bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
 
 	result = bpf_prog_run_pin_on_cpu(prog, ctx);
 
+	/* bpf_flow_keys offsets are u16: do not let @hlen be truncated. */
+	hlen = min_t(int, hlen, U16_MAX);
 	flow_keys->nhoff = clamp_t(u16, flow_keys->nhoff, nhoff, hlen);
 	flow_keys->thoff = clamp_t(u16, flow_keys->thoff,
 				   flow_keys->nhoff, hlen);
-- 
2.53.0



