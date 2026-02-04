Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB4C2D593E;
	Wed,  4 Feb 2026 15:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217247; cv=none; b=FlK+cf3rW3ngxJ6faqnYAQpYlznsMOD7kQaKP+qZ46QVjA2xZgcoSapmZsa7bGwWfQrXugWkWHLF7UFj8x4erUwlJq+HfOBVRrvDwBV6FZCHuFBMWtEk0C/K97n0GpSE1mf6q+xPbn9HLiuHfJfWrMTJL2jZptn/5rH1OA37m/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217247; c=relaxed/simple;
	bh=bRGnObyINSiXA7dtdlHTFN11t2aC9UWr4/IryL6yjG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1hE3RJsQQDMPrNIJ6a/J9KBFQr5OssARSjoTcKDQ35lnAUkHfyzwGlFmiLUa0ZbIfbQopj3weIGYSZt1wv1WnEb22UygX0P8P2FqETfrMBkEGxHAnItppL4B8+qr9+btZn5I+6curpqVTWf6AacMXi5jIjxfTbp0fgyZ6IK2dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8PtfpnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8PtfpnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EDDC116C6;
	Wed,  4 Feb 2026 15:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217247;
	bh=bRGnObyINSiXA7dtdlHTFN11t2aC9UWr4/IryL6yjG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8PtfpnNbCec/Iw8iKpHBkjJ1QyJgi1G+ymZN1T+zV36LI2o40WEJnibh9za6jpVa
	 hDsqTlVxFQc1pu7/Z0YwH2wABu2CIeFKrxfvixPbP2Xyg9fi+tClx4vX8M8hdvfTdh
	 DxikcznFmcaRmVEOBrWgTSW14oHe0O0XJph4ltoA=
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
Subject: [PATCH 5.15 133/206] bpf: Do not let BPF test infra emit invalid GSO types to stack
Date: Wed,  4 Feb 2026 15:39:24 +0100
Message-ID: <20260204143902.988046357@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -537,6 +537,11 @@ static int convert___skb_to_skb(struct s
 
 	if (__skb->gso_segs > GSO_MAX_SEGS)
 		return -EINVAL;
+
+	/* Currently GSO type is zero/unset. If this gets extended with
+	 * a small list of accepted GSO types in future, the filter for
+	 * an unset GSO type in bpf_clone_redirect() can be lifted.
+	 */
 	skb_shinfo(skb)->gso_segs = __skb->gso_segs;
 	skb_shinfo(skb)->gso_size = __skb->gso_size;
 
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2433,6 +2433,13 @@ BPF_CALL_3(bpf_clone_redirect, struct sk
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


