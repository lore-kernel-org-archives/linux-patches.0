Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFA5374EA;
	Mon, 10 Mar 2025 18:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630717; cv=none; b=vFOK+U+1nWfUzivMjcVS/mTvqtOXlh+c4L8HdfgE+cX4Uzdamel8ZzQm0dZhRzGs1N4XGuCZXLRTRqT9p0bRYRdCO+6PqQAl/17qGBchnvfW61MZKYNQDbzTl5Q8trFhBTNnz2dK2GC+XN96UHaD0XAeUVyMj5oJsBYjKZI1KFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630717; c=relaxed/simple;
	bh=P5pASNILi0xSrIrsy9L5jVJUfSFDMTZx9acZrJDeVyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpItjfpujtXwPLu/E07itRygY7X3nOpOXXnLyBcmHPzl2gBIMDyCNCRo9gbhB49SDwnU+T3nfmfg0b4y8yxXX2WIjSpmyblJKFT8Ecm5HHwVr+63f1+593eY54Z1j+e/bmOzJ0fhR0Q6IY31Mf4rCfuMWE4jkZoP76rTA6yFqg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0eF+4LD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0eF+4LD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A912C4CEE5;
	Mon, 10 Mar 2025 18:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630717;
	bh=P5pASNILi0xSrIrsy9L5jVJUfSFDMTZx9acZrJDeVyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0eF+4LD6SScQ9ai8kmrOdNNTVAu7fo3YkoXEXNnutToTsK+Yh5iWox8l//gKRnS0
	 98vbZ5Zv2UVQE1uHs+fPHbqgr3pbDVYBv2ka1xsmtdb9xd6g5atEzVp6BEOZ3Dvn/M
	 LoSolkUZ2itpoXJ5NodUhnhI5wlWLTvo2hFRyr6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lebrun <dlebrun@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 510/620] net: ipv6: fix dst ref loop on input in seg6 lwt
Date: Mon, 10 Mar 2025 18:05:56 +0100
Message-ID: <20250310170605.686461142@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Iurman <justin.iurman@uliege.be>

[ Upstream commit c64a0727f9b1cbc63a5538c8c0014e9a175ad864 ]

Prevent a dst ref loop on input in seg6_iptunnel.

Fixes: af4a2209b134 ("ipv6: sr: use dst_cache in seg6_input")
Cc: David Lebrun <dlebrun@google.com>
Cc: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_iptunnel.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index c161298c8b335..b186d85ec5b3f 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -472,10 +472,18 @@ static int seg6_input_core(struct net *net, struct sock *sk,
 {
 	struct dst_entry *orig_dst = skb_dst(skb);
 	struct dst_entry *dst = NULL;
+	struct lwtunnel_state *lwtst;
 	struct seg6_lwt *slwt;
 	int err;
 
-	slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);
+	/* We cannot dereference "orig_dst" once ip6_route_input() or
+	 * skb_dst_drop() is called. However, in order to detect a dst loop, we
+	 * need the address of its lwtstate. So, save the address of lwtstate
+	 * now and use it later as a comparison.
+	 */
+	lwtst = orig_dst->lwtstate;
+
+	slwt = seg6_lwt_lwtunnel(lwtst);
 
 	local_bh_disable();
 	dst = dst_cache_get(&slwt->cache);
@@ -490,7 +498,9 @@ static int seg6_input_core(struct net *net, struct sock *sk,
 	if (!dst) {
 		ip6_route_input(skb);
 		dst = skb_dst(skb);
-		if (!dst->error) {
+
+		/* cache only if we don't create a dst reference loop */
+		if (!dst->error && lwtst != dst->lwtstate) {
 			local_bh_disable();
 			dst_cache_set_ip6(&slwt->cache, dst,
 					  &ipv6_hdr(skb)->saddr);
-- 
2.39.5



