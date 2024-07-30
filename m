Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD971A6166;
	Tue, 30 Jul 2024 16:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357984; cv=none; b=s1PLw4YLE1gIMEWgAHJ4kR0a5rH0/WIjaclvpbwdq7a2rv6a1/NZ3y/TpQmYqVy1/ktfeYiQ+2ghAeACQs2gegjRlXq/hkJ85OcVwmdVmUw5BhRPQWuOj9qLssA/MGiV3UDpsLNRmKpX85zSfvISBMGJD55TVxD5KknnXxKf9Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357984; c=relaxed/simple;
	bh=P762/xAjOH1mXKqlFEk08qIWWzUvv1zjRhPmuZxMd2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcMx1J2KfmFENDEMEs+0t/P8oxZQA4gBR9tU1izBhbZXl2inMAQVSyVNWYcYL/CaYkEpskLDZ58B2BUuubiUm8cMIGBbSZ6dHHQ/gBXaTcbnOKqm2NShB+geqgwoZsGcCEQBzIBpGBVmktYnai/RwovyLw7IHRsMGsjHO7Yvg/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVU35GQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVU35GQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DD5C32782;
	Tue, 30 Jul 2024 16:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357984;
	bh=P762/xAjOH1mXKqlFEk08qIWWzUvv1zjRhPmuZxMd2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVU35GQ+PVqk2xmjfJoQLHVfFM7S9JwpKJ2a5YkUTDykQvX0Wo8PK+RPOS8CO/b40
	 sW0q3/sAmxNxjikVM+9ADbJVfAPJRGz6QVKD3hL/WGlY+8KmWtLvtMoU+Rha+spqXq
	 Jrr9kkUfH2q6bYoskhXJZMsickKbShuTmPNPWpv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 314/568] net: flow_dissector: use DEBUG_NET_WARN_ON_ONCE
Date: Tue, 30 Jul 2024 17:47:01 +0200
Message-ID: <20240730151652.144187726@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 120f1c857a73e52132e473dee89b340440cb692b ]

The following splat is easy to reproduce upstream as well as in -stable
kernels. Florian Westphal provided the following commit:

  d1dab4f71d37 ("net: add and use __skb_get_hash_symmetric_net")

but this complementary fix has been also suggested by Willem de Bruijn
and it can be easily backported to -stable kernel which consists in
using DEBUG_NET_WARN_ON_ONCE instead to silence the following splat
given __skb_get_hash() is used by the nftables tracing infrastructure to
to identify packets in traces.

[69133.561393] ------------[ cut here ]------------
[69133.561404] WARNING: CPU: 0 PID: 43576 at net/core/flow_dissector.c:1104 __skb_flow_dissect+0x134f/
[...]
[69133.561944] CPU: 0 PID: 43576 Comm: socat Not tainted 6.10.0-rc7+ #379
[69133.561959] RIP: 0010:__skb_flow_dissect+0x134f/0x2ad0
[69133.561970] Code: 83 f9 04 0f 84 b3 00 00 00 45 85 c9 0f 84 aa 00 00 00 41 83 f9 02 0f 84 81 fc ff
ff 44 0f b7 b4 24 80 00 00 00 e9 8b f9 ff ff <0f> 0b e9 20 f3 ff ff 41 f6 c6 20 0f 84 e4 ef ff ff 48 8d 7b 12 e8
[69133.561979] RSP: 0018:ffffc90000006fc0 EFLAGS: 00010246
[69133.561988] RAX: 0000000000000000 RBX: ffffffff82f33e20 RCX: ffffffff81ab7e19
[69133.561994] RDX: dffffc0000000000 RSI: ffffc90000007388 RDI: ffff888103a1b418
[69133.562001] RBP: ffffc90000007310 R08: 0000000000000000 R09: 0000000000000000
[69133.562007] R10: ffffc90000007388 R11: ffffffff810cface R12: ffff888103a1b400
[69133.562013] R13: 0000000000000000 R14: ffffffff82f33e2a R15: ffffffff82f33e28
[69133.562020] FS:  00007f40f7131740(0000) GS:ffff888390800000(0000) knlGS:0000000000000000
[69133.562027] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[69133.562033] CR2: 00007f40f7346ee0 CR3: 000000015d200001 CR4: 00000000001706f0
[69133.562040] Call Trace:
[69133.562044]  <IRQ>
[69133.562049]  ? __warn+0x9f/0x1a0
[ 1211.841384]  ? __skb_flow_dissect+0x107e/0x2860
[...]
[ 1211.841496]  ? bpf_flow_dissect+0x160/0x160
[ 1211.841753]  __skb_get_hash+0x97/0x280
[ 1211.841765]  ? __skb_get_hash_symmetric+0x230/0x230
[ 1211.841776]  ? mod_find+0xbf/0xe0
[ 1211.841786]  ? get_stack_info_noinstr+0x12/0xe0
[ 1211.841798]  ? bpf_ksym_find+0x56/0xe0
[ 1211.841807]  ? __rcu_read_unlock+0x2a/0x70
[ 1211.841819]  nft_trace_init+0x1b9/0x1c0 [nf_tables]
[ 1211.841895]  ? nft_trace_notify+0x830/0x830 [nf_tables]
[ 1211.841964]  ? get_stack_info+0x2b/0x80
[ 1211.841975]  ? nft_do_chain_arp+0x80/0x80 [nf_tables]
[ 1211.842044]  nft_do_chain+0x79c/0x850 [nf_tables]

Fixes: 9b52e3f267a6 ("flow_dissector: handle no-skb use case")
Suggested-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20240715141442.43775-1-pablo@netfilter.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 272f09251343d..b22d20cc417b2 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1093,7 +1093,7 @@ bool __skb_flow_dissect(const struct net *net,
 		}
 	}
 
-	WARN_ON_ONCE(!net);
+	DEBUG_NET_WARN_ON_ONCE(!net);
 	if (net) {
 		enum netns_bpf_attach_type type = NETNS_BPF_FLOW_DISSECTOR;
 		struct bpf_prog_array *run_array;
-- 
2.43.0



