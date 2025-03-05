Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37FF2512C7;
	Wed,  5 Mar 2025 17:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197376; cv=none; b=tvisk2NQkvgY2YGl4oF+fQ2rIbTl2WblY3CqZds1I1Zv2hgjYwL7t09v994ow8UDGJcgldzQWO45XoNksBRdRMe9u+CV7dcb2CwaA8gA6dXCns/nsttQu1wx++a5e/AhgQlXIqwgBv0F5VGPjStJmS0sl7cCKKWKHn1gRqMTq/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197376; c=relaxed/simple;
	bh=nLAsvKCvk0Y9a/W6OHmsLFcG4HtowDTyW0UjR4ElKNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkbKEnI92IDAlmrr5inILvuJMRLtE84e3Z2kQWPMtt25BCCo1/kKSux6UAsCvrJszGT9Pn5Lcx7oKHqGlb79krLNer4IrC6hBIIx4nZ2ULKBkmnYtcpHhP90pXLr2N70LfJn4XeIhavo01T7/HbQrRDgEk2ugZR+rhJ/JoWZ6CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2TuKc3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2TuKc3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F15DC4CED1;
	Wed,  5 Mar 2025 17:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197375;
	bh=nLAsvKCvk0Y9a/W6OHmsLFcG4HtowDTyW0UjR4ElKNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2TuKc3fTLPZdfuaUr/I+qdi0ZpuHXMrIjhUA2gqwYk9djXGsB4NqpLX/tXDJ11ip
	 ivpvY7IYcd94itv2FyoNzj4LYLciUEVwwVbkhSzyBC/ej1pJo5c596CpRmXqc2h/J6
	 5US4PwJcioUxtZ/4eZccJmehftFBQXDd0nMt78+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philo Lu <lulie@linux.alibaba.com>,
	Julian Anastasov <ja@ssi.bg>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/176] ipvs: Always clear ipvs_property flag in skb_scrub_packet()
Date: Wed,  5 Mar 2025 18:48:22 +0100
Message-ID: <20250305174510.786401999@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Philo Lu <lulie@linux.alibaba.com>

[ Upstream commit de2c211868b9424f9aa9b3432c4430825bafb41b ]

We found an issue when using bpf_redirect with ipvs NAT mode after
commit ff70202b2d1a ("dev_forward_skb: do not scrub skb mark within
the same name space"). Particularly, we use bpf_redirect to return
the skb directly back to the netif it comes from, i.e., xnet is
false in skb_scrub_packet(), and then ipvs_property is preserved
and SNAT is skipped in the rx path.

ipvs_property has been already cleared when netns is changed in
commit 2b5ec1a5f973 ("netfilter/ipvs: clear ipvs_property flag when
SKB net namespace changed"). This patch just clears it in spite of
netns.

Fixes: 2b5ec1a5f973 ("netfilter/ipvs: clear ipvs_property flag when SKB net namespace changed")
Signed-off-by: Philo Lu <lulie@linux.alibaba.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Link: https://patch.msgid.link/20250222033518.126087-1-lulie@linux.alibaba.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 768b8d65a5baa..d8a3ada886ffb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5556,11 +5556,11 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
 	skb->offload_fwd_mark = 0;
 	skb->offload_l3_fwd_mark = 0;
 #endif
+	ipvs_reset(skb);
 
 	if (!xnet)
 		return;
 
-	ipvs_reset(skb);
 	skb->mark = 0;
 	skb_clear_tstamp(skb);
 }
-- 
2.39.5



