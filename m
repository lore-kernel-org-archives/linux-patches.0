Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B559423152;
	Wed,  4 Feb 2026 15:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218007; cv=none; b=kyi8UChvlurjNBS50bxBmx+UmGijoTMlpZgJVq+22FXGBO54+hJ2/xE9xg81GEgp+9gRZ22eoS6hzP5UakqbQr94dQCsdyqHloo6rBuWEpBFZBQE42CLNQXT+/MUa1YvnQwkCBCzDuESdpE6XMSitEcwnyPYmLrgjRhsWh7nh/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218007; c=relaxed/simple;
	bh=7oRpsxN8uojkCK3kB9cBFX9IGGiE7U7O5mmstAHSwZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMxsUVtme0atGN5ipM1bOcrmkvp3P9S7OFMYhjOta47xZOX3wWPq0mpnMb4/kLZVCRPZUQOoMR/jqbqOJDmyI8WG5VphIPJtULAr3HGK+yeehS53axZAUeMnnS0eaL/pbYyJAgTz9r+G8NtP0uPWAm2bc8HDpjQwE2l5bUNKRkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQA1r/nj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQA1r/nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC392C4CEF7;
	Wed,  4 Feb 2026 15:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218007;
	bh=7oRpsxN8uojkCK3kB9cBFX9IGGiE7U7O5mmstAHSwZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQA1r/njYdXWWpaziEp+Wk7felekwZ70rxtgTHMJLPi165DYHVTGPkp9B+zPjUDos
	 qaFdQP6BVeHSz836gPb3Y1Q4Ge7daYSV9LRV6j2Cs66L+x/53Tw/+l5IR3P2RQUIN/
	 nabEX0zHuSAApfe+8AzvcGBNGqx3FOnCiwz961B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Kaiyan Mei <M202472210@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.1 184/280] bpf: Do not let BPF test infra emit invalid GSO types to stack
Date: Wed,  4 Feb 2026 15:39:18 +0100
Message-ID: <20260204143916.234396600@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

commit 04a899573fb87273a656f178b5f920c505f68875 upstream.

Yinhao et al. reported that their fuzzer tool was able to trigger a
skb_warn_bad_offload() from netif_skb_features() -> gso_features_check().
When a BPF program - triggered via BPF test infra - pushes the packet
to the loopback device via bpf_clone_redirect() then mentioned offload
warning can be seen. GSO-related features are then rightfully disabled.

We get into this situation due to convert___skb_to_skb() setting
gso_segs and gso_size but not gso_type. Technically, it makes sense
that this warning triggers since the GSO properties are malformed due
to the gso_type. Potentially, the gso_type could be marked non-trustworthy
through setting it at least to SKB_GSO_DODGY without any other specific
assumptions, but that also feels wrong given we should not go further
into the GSO engine in the first place.

The checks were added in 121d57af308d ("gso: validate gso_type in GSO
handlers") because there were malicious (syzbot) senders that combine
a protocol with a non-matching gso_type. If we would want to drop such
packets, gso_features_check() currently only returns feature flags via
netif_skb_features(), so one location for potentially dropping such skbs
could be validate_xmit_unreadable_skb(), but then otoh it would be
an additional check in the fast-path for a very corner case. Given
bpf_clone_redirect() is the only place where BPF test infra could emit
such packets, lets reject them right there.

Fixes: 850a88cc4096 ("bpf: Expose __sk_buff wire_len/gso_segs to BPF_PROG_TEST_RUN")
Fixes: cf62089b0edd ("bpf: Add gso_size to __sk_buff")
Reported-by: Yinhao Hu <dddddd@hust.edu.cn>
Reported-by: Kaiyan Mei <M202472210@hust.edu.cn>
Reported-by: Dongliang Mu <dzm91@hust.edu.cn>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20251020075441.127980-1-daniel@iogearbox.net
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bpf/test_run.c |    5 +++++
 net/core/filter.c  |    7 +++++++
 2 files changed, 12 insertions(+)

--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1047,6 +1047,11 @@ static int convert___skb_to_skb(struct s
 
 	if (__skb->gso_segs > GSO_MAX_SEGS)
 		return -EINVAL;
+
+	/* Currently GSO type is zero/unset. If this gets extended with
+	 * a small list of accepted GSO types in future, the filter for
+	 * an unset GSO type in bpf_clone_redirect() can be lifted.
+	 */
 	skb_shinfo(skb)->gso_segs = __skb->gso_segs;
 	skb_shinfo(skb)->gso_size = __skb->gso_size;
 	skb_shinfo(skb)->hwtstamps.hwtstamp = __skb->hwtstamp;
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2444,6 +2444,13 @@ BPF_CALL_3(bpf_clone_redirect, struct sk
 	if (unlikely(flags & (~(BPF_F_INGRESS) | BPF_F_REDIRECT_INTERNAL)))
 		return -EINVAL;
 
+	/* BPF test infra's convert___skb_to_skb() can create type-less
+	 * GSO packets. gso_features_check() will detect this as a bad
+	 * offload. However, lets not leak them out in the first place.
+	 */
+	if (unlikely(skb_is_gso(skb) && !skb_shinfo(skb)->gso_type))
+		return -EBADMSG;
+
 	dev = dev_get_by_index_rcu(dev_net(skb->dev), ifindex);
 	if (unlikely(!dev))
 		return -EINVAL;


