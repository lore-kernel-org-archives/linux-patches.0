Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D24843B4B5;
	Mon, 17 Aug 2026 14:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976369; cv=none; b=LWDs/42/prDwphsFjR6dNkP1FtDPpNLUlKdhz1htnicPqoI862gS6tlPEfELf+dQc1x36TwTEs/7BFFCgYts16A/DqV+KRq2igVVD/wUlz986RpHS9nlZeV8oMNT7whQm9DWuFP/fRFleJ2NenBTPkboMrs/ar3ErKZ0AjfE/RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976369; c=relaxed/simple;
	bh=yLl5w/Bg10isvjXpqcfUuH05RXDdSaM57OGso1khPlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHykIprZJ08d4Pu/TPKRDYfF1z1GbPoNIz9H3tREOOPkhCLTiK+kEg+Gz5Yw6v/+8pKmhy/AVX2A09LHHnq/CfoRsKHuNMM/cvAXFi9oCIAMOk6UXAVp0AQ3ZpP/Xxb8bKF2/KlpCcjzOn0qYLM0zUQsczZsNB+BUicvGf+SlrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JdgZlRwy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JdgZlRwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FD21F000E9;
	Mon, 17 Aug 2026 14:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976368;
	bh=Zfi63MV50lTtD/nucccKmg1Isn79Uy5rh2w2EcdExU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JdgZlRwytlqLpx0rwr1M3sDG3tigHmgGqFPS8Ng9LhhvykpkABdFoAauxh5dSymyC
	 TI2gp9kDlssCwEgzxfcakmzbjVWGMBZ6yyxf8loE4DnC6kUgCx46+pLkL4C0yiG0dh
	 Q4zWdldLbs8K3qgyh2PBM/6/d675vfh5PHz+Ypqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 322/389] udp: fix potential use-after-free in tunnel segmentation
Date: Mon, 17 Aug 2026 15:32:41 +0200
Message-ID: <20260817132551.492072439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

[ Upstream commit d0f86fb36eb260abd10007b62c9dcc1028e03e61 ]

__skb_udp_tunnel_segment() gets the UDP header before ensuring the
tunnel header is in the skb head. If the pull reallocates skb->head,
the saved UDP header pointer is no longer valid.

Get the UDP header after the pull to avoid a potential use-after-free.

Fixes: dbef491ebe7f ("udp: Use uh->len instead of skb->len to compute checksum in segmentation")
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Link: https://patch.msgid.link/20260730093554.68127-1-xuanqiang.luo@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_offload.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 5d4413fe41952..4285d25d9982d 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -20,17 +20,19 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 	int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
 	bool remcsum, need_csum, offload_csum, gso_partial;
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
-	struct udphdr *uh = udp_hdr(skb);
 	u16 mac_offset = skb->mac_header;
 	__be16 protocol = skb->protocol;
 	u16 mac_len = skb->mac_len;
 	int udp_offset, outer_hlen;
+	struct udphdr *uh;
 	__wsum partial;
 	bool need_ipsec;
 
 	if (unlikely(!pskb_may_pull(skb, tnl_hlen)))
 		goto out;
 
+	uh = udp_hdr(skb);
+
 	/* Adjust partial header checksum to negate old length.
 	 * We cannot rely on the value contained in uh->len as it is
 	 * possible that the actual value exceeds the boundaries of the
-- 
2.53.0



