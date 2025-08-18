Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1BC225397;
	Mon, 18 Aug 2025 13:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524810; cv=none; b=DEp8dXnQUj/m1l4ZRMGOfLJIBj0Ilb0K/z6bro5J9iscLd4w69+aarCgHzuKWLI8iQzo8uZt8Bbl5WTpGaIKZAYe7gs1/pib1hC2i/kJXM1frt6Q6NoTrpBB7kRDHtIEiHx9Nl0xkDJCoA1xxB35V3TlSxLoTCGW4oGnCWGlYtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524810; c=relaxed/simple;
	bh=GCaOvX7vSgoE3sBrAwW4/3+F31CP9eyNrwUWKpVaSns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAkwCQ+/7sbfbZE0KBhu7PFqkYO350g0cOS4EdK2B+h+Ph90AmX1q6eSvfk/d+bSiPuMPT9eNqc7kug0Am9CMCPjv/k973z7SeJW4S4Ulwmc6GhhFd5fsXfXwFWX21Yv1nxPPkqwbvfZWNGUW8Q9kKE7ZgELOeG/WNxni5mQNHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ByTbuNjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByTbuNjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E1AC4CEF1;
	Mon, 18 Aug 2025 13:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524809;
	bh=GCaOvX7vSgoE3sBrAwW4/3+F31CP9eyNrwUWKpVaSns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ByTbuNjJ9LlXgq/tyupiC2YbJkfLAMl2GvYThSuIyrW/WB3/66Jy8JLwkp6SSVLSp
	 9x/lEHDvdaHCxsMGIxIUQpkSxI3ZD9r8tW7lm1elV7zE99Sc+O9xJjiZFPdJsqUgKv
	 psKcjUkaTURSx1tjRuyrYA02W8ivlpylRZMsGE34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Leon Romanovsky <leonro@nvidia.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 062/570] xfrm: restore GSO for SW crypto
Date: Mon, 18 Aug 2025 14:40:49 +0200
Message-ID: <20250818124508.208178502@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 234d1eff5d4987024be9d40ac07b918a5ae8db1a ]

Commit 49431af6c4ef incorrectly assumes that the GSO path is only used
by HW offload, but it's also useful for SW crypto.

This patch re-enables GSO for SW crypto. It's not an exact revert to
preserve the other changes made to xfrm_dev_offload_ok afterwards, but
it reverts all of its effects.

Fixes: 49431af6c4ef ("xfrm: rely on XFRM offload")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_device.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index d2819baea414..1f88472aaac0 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -415,10 +415,12 @@ bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 	struct net_device *dev = x->xso.dev;
 	bool check_tunnel_size;
 
-	if (x->xso.type == XFRM_DEV_OFFLOAD_UNSPECIFIED)
+	if (!x->type_offload ||
+	    (x->xso.type == XFRM_DEV_OFFLOAD_UNSPECIFIED && x->encap))
 		return false;
 
-	if ((dev == xfrm_dst_path(dst)->dev) && !xdst->child->xfrm) {
+	if ((!dev || dev == xfrm_dst_path(dst)->dev) &&
+	    !xdst->child->xfrm) {
 		mtu = xfrm_state_mtu(x, xdst->child_mtu_cached);
 		if (skb->len <= mtu)
 			goto ok;
@@ -430,6 +432,9 @@ bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 	return false;
 
 ok:
+	if (!dev)
+		return true;
+
 	check_tunnel_size = x->xso.type == XFRM_DEV_OFFLOAD_PACKET &&
 			    x->props.mode == XFRM_MODE_TUNNEL;
 	switch (x->props.family) {
-- 
2.50.1



