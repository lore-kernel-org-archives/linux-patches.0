Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621231;
	b=zyuShXqktpf4e8ToSXW/eP7ttiXBa1umWavpOyeKGf5efnwHO/i3etgmn4jX5AryabOC
	 pYw+JKhbeH0uv9vw6w81ayjBNN8UuC3Z/gU7aJ8Mv6Bhdv40Y8AzR5moGJJ/IBH25rOie
	 gsUdzKARQ7K0ARNV06oobN2vFeGuHUZVD0ZS+jaL4ZPpZKXN7qcJnBWWUdyhrxJ72hn0+
	 UFEyw1w3Pe3EZqdmcbJ4q0M2iu9mfC1xWyOWjhzAUaCB++Vqyz9ROV2EXpk+a/5yarDkA
	 eF7K+CdRPOrJheFbpNF8eM4Fi0rjkKxExuvBxSj9HeArGqQVroacy4m3h6pOHLWp9hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621231;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/ALD9iVFxkaTjGLISXtbJncN7Cj7Y9yJmrKLgsqN1ZQ=;
	b=hJwX9Wx3dTbW6uwdQ0DGi5KtIQGRrS1hS3KR2CWE4yWIkbbaatOI4lYwZ3zT9bvpUvOE
	 1hwqZZANPP+kQ9XUXV+3wy8rJhuF36OIPuT8lKL6FS3elHMH5kbdQvnWRCUgx1pkqWhHl
	 ZUGT5+CilkG7NnqIBvEDtfsd2idFfDLajSntTZltZKYn0xTY3DPthwXQwpXcWJSiXYYRK
	 aqMgLpg2Mc5KQIyDaaq7q+HKHxSxG5Ql5F6UmjGdEEc3PP7m/yN7kzqqFNUKwmOxIqnK1
	 9vTMpgMtzkM1iMrRzQRaf1HLfSZ2MXClyqNqGKTQ0PW/lRS/9Ts0PJTWpwAEpYEypqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kgjgZXvv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480AB606A321;
	Wed, 25 Nov 2026 15:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kgjgZXvv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292971F008B2;
	Wed, 25 Nov 2026 15:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621230;
	bh=/ALD9iVFxkaTjGLISXtbJncN7Cj7Y9yJmrKLgsqN1ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kgjgZXvvOhbHOcuudOYnzeLJLR41TSloltWqUz3t74G+0CYWsbzfjq7JiklyqzimS
	 vxDfER2BGNIeR/gExR+GGJdnYIRzmMZwKmCjE0kNHE6JO+Ci79UkzOWbXdV0s1MitE
	 nTuGVmDvLMbxJxWaogtg/Bd0PWLAzK3r3/lKQLr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 117/990] bpf, cgroup: Keep the skb network offset signed
Date: Wed, 25 Nov 2026 15:24:44 +0100
Message-ID: <20261125143824.827657144@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit 3f9780d62dd1112ca15b5ae73568d29d42ccc950 ]

cgroup_skb progs see a packet from its network header. While they run,
__cgroup_bpf_run_filter_skb() moves skb->data there. It assumes that the
network header is not after skb->data. It negates skb_network_offset(skb)
and pushes skb->data by this offset. The offset is an unsigned int.

But ip6mr_cache_report() and bpf_lwt_xmit_reroute() can pass an skb that
has data before the network header. Then the offset wraps. On a 64-bit
kernel skb->data is then far below skb->head.

skb->len has 32 bits and wraps to the correct value, thus only skb->data is
wrong. A read of packet data faults or gets other memory.

Keep the offset in an int. Pull skb->data when the network header is after
it. Otherwise push it, as today.

Fixes: 3007098494be ("cgroup: add support for eBPF programs")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-15-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 9223d76774f21..14521bd99c7a8 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1630,7 +1630,7 @@ int __cgroup_bpf_run_filter_skb(struct sock *sk,
 				struct sk_buff *skb,
 				enum cgroup_bpf_attach_type atype)
 {
-	unsigned int offset = -skb_network_offset(skb);
+	int offset = skb_network_offset(skb);
 	struct sock *save_sk;
 	void *saved_data_end;
 	struct cgroup *cgrp;
@@ -1642,7 +1642,15 @@ int __cgroup_bpf_run_filter_skb(struct sock *sk,
 	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
 	save_sk = skb->sk;
 	skb->sk = sk;
-	__skb_push(skb, offset);
+
+	/*
+	 * The program sees the packet from its network header on, on
+	 * whichever side of skb->data that header lies.
+	 */
+	if (offset > 0)
+		__skb_pull(skb, offset);
+	else
+		__skb_push(skb, -offset);
 
 	/* compute pointers for the bpf prog */
 	bpf_compute_and_save_data_end(skb, &saved_data_end);
@@ -1684,7 +1692,10 @@ int __cgroup_bpf_run_filter_skb(struct sock *sk,
 			ret = -EFAULT;
 	}
 	bpf_restore_data_end(skb, saved_data_end);
-	__skb_pull(skb, offset);
+	if (offset > 0)
+		__skb_push(skb, offset);
+	else
+		__skb_pull(skb, -offset);
 	skb->sk = save_sk;
 
 	return ret;
-- 
2.53.0



