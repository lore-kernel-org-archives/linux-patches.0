Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617885;
	b=1YMwNGTTbijcdl67356juUIUh9TMc6n6LGVxKu93Z4Da+rzVsutLxCtoxVXaJ+4UmBuR
	 OZAZFjyIg70FefkXd40n16JYJ5nsb0OT4aF9T4YSXilj1tSIEXksWl+xJdYX12WugkwDD
	 z9QOVqXrvsYAKtw2+XTVB+VQ1sn4x1vihFXJeelKRoLtgOn+Wkt/xICtJQ5xBs19LSaAL
	 +/AnI80LO1RUdMX7wFFJHBST33suxts/HMEh06EBsZHuEGkVGlkJGF/ky7Hc8gWs4dbIk
	 5zFTKNfBVea99Xvxq2+VMkBnZg2fs2r/5A+vtMuUfuQ1TJqbFcXROakiLa9OJTOylZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mKjWI448myqfdLeaiiWXdNyPr8lr8bFkykcSUIXQrpw=;
	b=Z9EGgmgHET9uJdI6BNvc+zACn8DD6+DBGN8OocssVb5dFWnaPAk4KE+GDBIFk9GEO6kM
	 ZfOeUvRr3YoFqQ9R2RBzrNlgGOCIHSewQ03xkuH4VYlMiOjoDChV89s2lftKDSoUk1tUr
	 0J9uT5bFO7z5vTjzElLO+iMUCjDU4tvlScGg+WSJdeLedYEkxokCBozShlY9980BPf/Sg
	 vX1IAqbBBya6YDqfyHtLZR2kD/cSk474H8PMjazpFsyC2TNS3urA33rLtMteRGLW1KNHN
	 I9ZMSbz4d98z7T3RH/RnmmhUtPDQGbwCme7OBy0EOfLgEEDCGIiECG6FtwML5vls4rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YN1jv30q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F521606A323;
	Wed, 25 Nov 2026 14:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YN1jv30q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758061F0093C;
	Wed, 25 Nov 2026 14:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617885;
	bh=mKjWI448myqfdLeaiiWXdNyPr8lr8bFkykcSUIXQrpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YN1jv30q8BJ9AAYZijtSjZVQYH6TpsMfclhgI6j6HmecdFjTDi2pU3+Ir6lzdh5T7
	 h9mWOcvXPTK1rRsv4RnfUMTOQUMGBheXj+yp04jM+UiZDKSSD45pCtf37qnXu1MQ8v
	 h6hEIQUOdfpVjtwCOra4sw3pAs07uutUiaDLqISg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0105/1005] bpf, cgroup: Keep the skb network offset signed
Date: Wed, 25 Nov 2026 15:24:03 +0100
Message-ID: <20261125143824.205456649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
index 84a3d9cc52b76..59326938a01ea 100644
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



