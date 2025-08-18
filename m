Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2EC321443;
	Mon, 18 Aug 2025 13:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523053; cv=none; b=s4yeIRjKb2q37M2mKKYdwCwNa2+CsHOsEsYhPgIXlagdXKTdUTkzmuvBiQo9//iMqYQmy/4d2vuPr9lsnYMLZZTRpjF+i7jt3Ill4KE9dSPhWE/sW7d68Rkmz6SbeWDW/rODodQ0j5EMKlYr4S3z+nhHQ8Ti9we5Od1eEU4Sj0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523053; c=relaxed/simple;
	bh=W5mB8yaVXdXgdKkoWSJG45k7L60Oj8SDmdzdldpK2PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjQczjOdAU2/n0sCGnI1nVBm13krGH0vTs1ucFd5zvCRLA5p+e/B2D+Wj0lykxjt0GkAMIDcBdqdDaYW7I3V4uQxizzUbApF0lqzDdmCovTEgucUVmftfQReYT9T5KENQqV0vHEOhUvciP+1scAfc6GrOWKw6FTiHONIZFlQrfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1YSeFaoO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1YSeFaoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DD0C4CEF1;
	Mon, 18 Aug 2025 13:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523053;
	bh=W5mB8yaVXdXgdKkoWSJG45k7L60Oj8SDmdzdldpK2PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1YSeFaoOShknYTdHBrQgZn4kObnEAYr57mimQ3xcm5KngaORYvjHxMDu/AcHV30dE
	 szqmMuA0gJOH9Vp3L8m5Cvdi3abRDduuxS2sQLRArQjVZmPxLJq104k5L/7oiu91wY
	 jDb62c1FsdrwAdv/uVO24N/LysSiz+hsIHTEtYRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Leon Romanovsky <leonro@nvidia.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 057/515] xfrm: restore GSO for SW crypto
Date: Mon, 18 Aug 2025 14:40:43 +0200
Message-ID: <20250818124500.614131206@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index a2d3a5f3b485..a6c289858401 100644
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



