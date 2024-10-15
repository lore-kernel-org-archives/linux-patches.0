Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5831EABCC;
	Tue, 15 Oct 2024 12:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994403; cv=none; b=QYpyChAZOQgpNX76eVNZFuqEq2YhrNMrA8nBxY7EsA5NA1zZeohIByTVRiDdWlbSy/N2GV6LfwLfSs/vML5LQHDFSWX/gSxWPA7WwizaO7m/qwlsbNZDRMYVJnDc21AlclL+LUxRNCJezodEo1ARPf0BrZmO8ntg5iE4dQjdszg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994403; c=relaxed/simple;
	bh=ZUdNEbBcBYzs0UrjeR39UxdOFjgIYidpN/aEuo49IAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qn5phz2eC2sP1K/kdoa2FAVVLiLDBOpdBq5I1s+SG7NJQEGlJWPsiPFD95UqVtp2CsLPrWuk8DGjhaEw75w3QSyKfJBLtoEYw+LN8szGKJaRPUkSiKYdx5kdNGMoziguCEcqDwNoF8rCI468off2y3Pa+3LtTYL8VPwQq9eJMBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpOvR/D0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpOvR/D0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B78C4CEC6;
	Tue, 15 Oct 2024 12:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994403;
	bh=ZUdNEbBcBYzs0UrjeR39UxdOFjgIYidpN/aEuo49IAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpOvR/D0hOyRKieBXZ7bcGNi5wc99w+Fi3dcyf6JsmpIvCFAOHQbTBZBCEpcPmvlA
	 mwEAHF6Nhft+glQVAQ7Mac9EMYpYDN32tBvVjbroa1NTBXsTrw7g3DZg5Q9gq/xdPe
	 x/RGaWDCTXW26ASvFECNevmZYDBZIdPeq5UDQX2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	David Ahern <dsahern@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.15 683/691] xfrm: Pass flowi_oif or l3mdev as oif to xfrm_dst_lookup
Date: Tue, 15 Oct 2024 13:30:31 +0200
Message-ID: <20241015112507.430422547@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: David Ahern <dsahern@kernel.org>

commit 748b82c23e25310fec54e1eff2cb63936f391b24 upstream.

The commit referenced in the Fixes tag no longer changes the
flow oif to the l3mdev ifindex. A xfrm use case was expecting
the flowi_oif to be the VRF if relevant and the change broke
that test. Update xfrm_bundle_create to pass oif if set and any
potential flowi_l3mdev if oif is not set.

Fixes: 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif reset for port devices")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_policy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2593,12 +2593,14 @@ static struct dst_entry *xfrm_bundle_cre
 
 		if (xfrm[i]->props.mode != XFRM_MODE_TRANSPORT) {
 			__u32 mark = 0;
+			int oif;
 
 			if (xfrm[i]->props.smark.v || xfrm[i]->props.smark.m)
 				mark = xfrm_smark_get(fl->flowi_mark, xfrm[i]);
 
 			family = xfrm[i]->props.family;
-			dst = xfrm_dst_lookup(xfrm[i], tos, fl->flowi_oif,
+			oif = fl->flowi_oif ? : fl->flowi_l3mdev;
+			dst = xfrm_dst_lookup(xfrm[i], tos, oif,
 					      &saddr, &daddr, family, mark);
 			err = PTR_ERR(dst);
 			if (IS_ERR(dst))


