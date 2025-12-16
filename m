Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC749365A01;
	Tue, 16 Dec 2025 12:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887011; cv=none; b=fwuNJPOUldSDimj0NrKcOAx/iescy9jxdguSUMP36PcDhtpDgLcbhpW0Ie5vRlER911iF/t/tWTikSd2W5JnUyybRc2s8h3vtTKvbD28CE87+5eysNflpvXBIIwpOdph44kcc6VPzlBkqDNzE4lKOxIyR6IXEE2c1gp9+UWokqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887011; c=relaxed/simple;
	bh=gGFnOyha6WBcOOc0wA7RfpoeBcBYKxtN8aUxiCJzB+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MszwMokTfXiIb0HRHWWRpe6b2EhwJ1pqm+VuJGge3f2su98lrdRVckp2Eh48ieNqwYf6R+qdzHEHNVjOAEXcGbKQyMvFb4eSEBe/JerAywmbuaXVfOlWoov0Lhavxi4QumeUNOf0SOp1IFSDmZ9kuDSnmYDsAFGdGykI+bGUkMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVORCDBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVORCDBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32168C2BC87;
	Tue, 16 Dec 2025 12:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887011;
	bh=gGFnOyha6WBcOOc0wA7RfpoeBcBYKxtN8aUxiCJzB+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVORCDBe3cBnLbyPYuzJfLVAfNVKpyOgdT1f2R+/3y9Vvw64Ez7rWeVcAJ3L51LQY
	 Osw+o3TCId5Vce78vnstLdgcYggeLasUs5G4v86x1DVucvanXzDtsaPrr5lgQDPtyb
	 fFt2Bcsy/Q7iR4GKrFELQ/jXMKb7olVx5opJcJig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Kaiyan Mei <M202472210@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/614] bpf: Do not let BPF test infra emit invalid GSO types to stack
Date: Tue, 16 Dec 2025 12:07:14 +0100
Message-ID: <20251216111403.742467803@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 04a899573fb87273a656f178b5f920c505f68875 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 5 +++++
 net/core/filter.c  | 7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 8b7d0b90fea76..55a79337ac51f 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -939,6 +939,11 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 
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
diff --git a/net/core/filter.c b/net/core/filter.c
index fa06c5a08e22f..1efec0d70d783 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2458,6 +2458,13 @@ BPF_CALL_3(bpf_clone_redirect, struct sk_buff *, skb, u32, ifindex, u64, flags)
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
-- 
2.51.0



