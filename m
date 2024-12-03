Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989471F7561;
	Tue,  3 Dec 2024 15:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241289; cv=none; b=qtELNSiGZW9voWmXuMVhCXfLe0jPYWvbl4rbMx/uEM3DwFsYSzABA4jBLoGIAYgDztnnHLkp/pgDoaPcTVklMWTqeNkUUb/DBanWr85cQ+/J95kS5nTY7NprbCsuiIjkXUYtqAXbT2MZmcFEut9rsJTyQZJVwXYayYz5lRcrbqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241289; c=relaxed/simple;
	bh=Baoa1T3Yx3iSrcipyIUkBiBjVxr5/2GfwBcuwHX/YcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kyXKHXQivzza26u/+OGjwC/j6Ynx6gdpBANQlgET/X3l69ClsAf50yk49ie6ceI+78I6ymY+i1z8NeQfmd3BlugW2s93NieRjuncnmQzqcH4aAJMmOdudgkJcZPfIs5hgyj/GGUWL5zgV9reFJw1GVNeTGtWLjFEQB8nDtKiClo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1XdMn9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1XdMn9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EC2C4CECF;
	Tue,  3 Dec 2024 15:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241289;
	bh=Baoa1T3Yx3iSrcipyIUkBiBjVxr5/2GfwBcuwHX/YcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z1XdMn9sjXlArjIUDlxClVkDHwCaBpdNGNwup5Fcl3ObwJac+ropQkA1GemCV+Pvt
	 rbVGnSMkm1aB6skoWi4fPjZJVhPYEB11+2ukDqIr9CM8VN5Wxv2y0k2LnSlWXtl+30
	 g6RMDYXq6kxs4t4USFO6MoNp1iB8Mledhsv379RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Felix Maurer <fmaurer@redhat.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 346/826] xsk: Free skb when TX metadata options are invalid
Date: Tue,  3 Dec 2024 15:41:13 +0100
Message-ID: <20241203144757.257556510@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Maurer <fmaurer@redhat.com>

[ Upstream commit 0c0d0f42ffa6ac94cd79893b7ed419c15e1b45de ]

When a new skb is allocated for transmitting an xsk descriptor, i.e., for
every non-multibuf descriptor or the first frag of a multibuf descriptor,
but the descriptor is later found to have invalid options set for the TX
metadata, the new skb is never freed. This can leak skbs until the send
buffer is full which makes sending more packets impossible.

Fix this by freeing the skb in the error path if we are currently dealing
with the first frag, i.e., an skb allocated in this iteration of
xsk_build_skb.

Fixes: 48eb03dd2630 ("xsk: Add TX timestamp and TX checksum offload support")
Reported-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Felix Maurer <fmaurer@redhat.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/edb9b00fb19e680dff5a3350cd7581c5927975a8.1731581697.git.fmaurer@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 1140b2a120cae..b57d5d2904eb4 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -675,6 +675,8 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
 		len = desc->len;
 
 		if (!skb) {
+			first_frag = true;
+
 			hr = max(NET_SKB_PAD, L1_CACHE_ALIGN(dev->needed_headroom));
 			tr = dev->needed_tailroom;
 			skb = sock_alloc_send_skb(&xs->sk, hr + len + tr, 1, &err);
@@ -685,12 +687,8 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
 			skb_put(skb, len);
 
 			err = skb_store_bits(skb, 0, buffer, len);
-			if (unlikely(err)) {
-				kfree_skb(skb);
+			if (unlikely(err))
 				goto free_err;
-			}
-
-			first_frag = true;
 		} else {
 			int nr_frags = skb_shinfo(skb)->nr_frags;
 			struct page *page;
@@ -758,6 +756,9 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
 	return skb;
 
 free_err:
+	if (first_frag && skb)
+		kfree_skb(skb);
+
 	if (err == -EOVERFLOW) {
 		/* Drop the packet */
 		xsk_set_destructor_arg(xs->skb);
-- 
2.43.0



