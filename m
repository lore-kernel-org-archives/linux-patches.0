Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211507;
	b=k5vGLEpOIJW5oTUYgBlB6HLEn7pO1Z4ufalEVKGkT56v56wT/bm0tLEwG0JJGfnraDvr
	 aXMR00Izi6mUk7EC9fU3XrCT5/K/pnDq7y0SfYMtION1HhFHUvQ4upI1k7R+MNktBhSDs
	 DsMPKqfW9FkEuSr54CGY18BKehMd9AA6hjM7Bf38oqcuYwqen5xUOFZpkRcx+ot+mXFXZ
	 XaRmxmMJWgIU5avs7wnMzVYkeb/K9hmrguQaRdYSeUeFkSVl1HDU9cwVRT84Gbqg54A6t
	 deZqTvJY9tFuSJ2O4fJCGHqgvP25ladFEHegUiLyN6F0jbYOmbrVq6mFTwk68ybFjsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4QqPAzbAe3uZNpIJzunsyCN+RTidlntwZcbNHwB9VJw=;
	b=gDVrM7Hk4odukSs95b1YAV753JpWpcUorpVJD8LxghKXglZyjQnsyse+oWu+otkwIpUz
	 +GPsO2PHzu5F6oVyf2Bym6DLi4LAEYNdcWCc4K+5Yu+VKCWE+QeZXEAJGiVQixsdT1Y6Z
	 NhrVXG6nF3tyeuMgSDw5YeJXXczGk0vrRc6ii5bX07d9pvjHs1C73D+xa0pdaQnatD3/B
	 DjVc3F0EV4QBgOxicRUa5Y1w+bxK++tLS03YnhXla2EYgo0JJiXySytucQACqai+nDzCf
	 uV+s/OnuQfeFvz7KxArlCiUBB/eZq8dt7Y9libnPAcbhsFCLkh4NRDNTkjpOsk6I13Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igzbYFWr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6669E606A31D;
	Wed, 28 Oct 2026 18:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igzbYFWr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F631F01825;
	Wed, 28 Oct 2026 18:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211507;
	bh=4QqPAzbAe3uZNpIJzunsyCN+RTidlntwZcbNHwB9VJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=igzbYFWr5tqeHK6HfTMPkQINGeHeqd70CFBy+Bh4bp2K5RCZ7P5GU058Vp6Ft2XIV
	 rV1obKbOpB8kDkl2ynG0WVj+oh4/rjeipjN3daCqlRnyw95pumQgCK+6OecZDWH2mM
	 +wkyv0k7e77ToIoJsZ0ye1pcyNgG936auivkfKHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 401/571] flow_dissector: avoid u16 truncation of hlen in bpf_flow_dissect()
Date: Wed, 28 Oct 2026 17:59:08 +0100
Message-ID: <20261028170017.526969348@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b23f37aea1fb5..d1b975818bc94 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -895,6 +895,8 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
 
 	result = bpf_prog_run_pin_on_cpu(prog, ctx);
 
+	/* bpf_flow_keys offsets are u16: do not let @hlen be truncated. */
+	hlen = min_t(int, hlen, U16_MAX);
 	flow_keys->nhoff = clamp_t(u16, flow_keys->nhoff, nhoff, hlen);
 	flow_keys->thoff = clamp_t(u16, flow_keys->thoff,
 				   flow_keys->nhoff, hlen);
-- 
2.53.0



