Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89ED412E63;
	Sat,  3 Feb 2024 04:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933717; cv=none; b=H1glWwvyf8sywOYJZraxz5F2s4kjqIWLrq3RGAq7JM+cKK3JpwSPUFuABD7Y9Gys/jp092JodGFscKOH6kvMIsL4MI+8NwVZc0Egg4h/PU10ZJLvZbB0HWEnygP+8fSZFl9Zdf4uj5D+T0q+9lOf9wEgjuQPZwmJowoBY7eZPnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933717; c=relaxed/simple;
	bh=OyaFB2EUWqXO4ikR/AqkTKBTAXcqCJAXWZoAESsx2Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jW8kbq88BtVkl1JTcn/k4Yt2hIK5kRqVy9mkACef3TH000auealbFJvD6ZMVo+UbDnBvukX/2Jr2Pdnco4oh4biqP4+i9m3HnoW2I/wD3MINynGFf7RZeNEYSedwZAbadIR8CP48mdaPIWNUSCYKO0IKJeE4es6S8UTee8YFDBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vmwxnHDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vmwxnHDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B036C433C7;
	Sat,  3 Feb 2024 04:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933717;
	bh=OyaFB2EUWqXO4ikR/AqkTKBTAXcqCJAXWZoAESsx2Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vmwxnHDG9SlQZnr9Tw1tOV7SuMFFSqLSH+ze1fXFc/u0nDRwHGunmsgIY0ZYr35Hi
	 Is+uRsnYuhNgpMMCR7XNFUrAN7xPhXjPU9QoSfOomUQYxULk2HU2ZYyYY3FXu1KRcI
	 aBAsUDztic88/uKv9vdiQe5YqDrvjJWWDCw1dFNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 297/322] netfilter: nft_ct: sanitize layer 3 and 4 protocol number in custom expectations
Date: Fri,  2 Feb 2024 20:06:34 -0800
Message-ID: <20240203035408.657491456@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 86bb9d7797d9..aac98a3c966e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1250,7 +1250,31 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
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



