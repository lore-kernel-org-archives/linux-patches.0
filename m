Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF0944379;
	Wed, 21 Feb 2024 14:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525574; cv=none; b=fcqWvd5IENMV4vyxsnMBksHzv4x+dxcXhsK65JW0+xzMbdrDz39UGtzNz1Uw3UzidM0xu67esMIlGo8qaoaClENlKhqEknnsuShBLbplGSM+ymtIxhr9vxrPnGvVsyfCv6VDdzi6wvGqWMheH1OWT8I6AxhOEq5qNzyphbuMoDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525574; c=relaxed/simple;
	bh=qgYmNsGfSSH+RUA2i2/+ne6revzSY9WyZ5e47hhMgz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cl1K3Mcapm03nkE1PnibdpR+Z2kqFAC8Lxbm/0N4LO+jV+gazJMydIcry9qrCLwrobfdHylM8ndfFzddnbLbchryZwhu5VehgIX0h9NM5qeu8Nv5a9x/2s6I5zrAjOMtL4FJ6CgHBCj/zFR/0uSodQNtRacNhXWBBYxRNAPniLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iG+Te/MH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iG+Te/MH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBF8C433C7;
	Wed, 21 Feb 2024 14:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525574;
	bh=qgYmNsGfSSH+RUA2i2/+ne6revzSY9WyZ5e47hhMgz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iG+Te/MHyqGqFqiHHWuyTm+dDiUV2oVlueWlETHZhoWCmGi0WHZTvtBLO9Wyt4VBy
	 fdonoEmxFlHn80aOrMwDheWiEEIgEQe4r0IEHAjWrBj6Ufy5zIGYEkiEKTnUX3a4Sf
	 ueH10D3Wrnw/QiUX7QYz0mtvV7tm2tTald7c181Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 168/267] netfilter: nft_ct: sanitize layer 3 and 4 protocol number in custom expectations
Date: Wed, 21 Feb 2024 14:08:29 +0100
Message-ID: <20240221125945.405031272@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 8059918a1377f2f1fff06af4f5a4ed3d5acd6bc4 ]

- Disallow families other than NFPROTO_{IPV4,IPV6,INET}.
- Disallow layer 4 protocol with no ports, since destination port is a
  mandatory attribute for this object.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_ct.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 7e269f7378cc..9507f1e56107 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1174,7 +1174,31 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_CT_EXPECT_L3PROTO])
 		priv->l3num = ntohs(nla_get_be16(tb[NFTA_CT_EXPECT_L3PROTO]));
 
+	switch (priv->l3num) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		if (priv->l3num != ctx->family)
+			return -EINVAL;
+
+		fallthrough;
+	case NFPROTO_INET:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
 	priv->l4proto = nla_get_u8(tb[NFTA_CT_EXPECT_L4PROTO]);
+	switch (priv->l4proto) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+	case IPPROTO_DCCP:
+	case IPPROTO_SCTP:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
 	priv->dport = nla_get_be16(tb[NFTA_CT_EXPECT_DPORT]);
 	priv->timeout = nla_get_u32(tb[NFTA_CT_EXPECT_TIMEOUT]);
 	priv->size = nla_get_u8(tb[NFTA_CT_EXPECT_SIZE]);
-- 
2.43.0



