Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C900C1D435F;
	Mon, 17 Aug 2026 14:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975320; cv=none; b=JVWKLoW+uS+plDe5VWyqA7FGALSkKSKESG7GsH5ajB1JtzV5l1Q1ExOYza58mT3fHz+oKHQs2DHd3gClufEdw136n6roVLzkd9I67gImdV5D+BLJ9vyEp61VAFqu5eYo3qjGxOOdSrIX45+69drUJ5aQJ8tQF9GslmCJWwL5bG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975320; c=relaxed/simple;
	bh=c31QdEctwAO3qEbuWhRfjeRbb7Nnax6h94VeJS9E+D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhbEqgGp1LEULdhmvn2pd43uCWdVpoKnZEJPkPIc+I1Ry0/SA/Go7RBnT47XxBRSDpuQIiNmNz43KWF4MyGr94BDK36ta9DJkR2Ac8ECB9txSAcEEupRQ5TWnRXeb4MkkDeEQLROAko2++D1A0gjf8GBCWf6f9nTBSLqFf2MXEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUQPp2eD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUQPp2eD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8651F000E9;
	Mon, 17 Aug 2026 14:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975319;
	bh=va2r/6kWXSbiU5UE/tTgm+Ct9nIIacH0B1dh7q3/ccU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rUQPp2eDJumbmYIIyo/JzmMMGphBPIbU7w3yky5WVb8pol/Xay2rpg9mN/IwVjhz3
	 8PMiD86IUKoIbSF/QGgKNiy3uQPFbJTWVD/u5U7Mhf4WmY9WR/FRfUj9xcq2PWnQiT
	 9JLh0J8y9iTD3F4eXg9M9XoYCkPHYi+ZXCZJX06Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.18 201/250] netfilter: bridge: release template ct on non-IP path
Date: Mon, 17 Aug 2026 15:32:42 +0200
Message-ID: <20260817132544.761154999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

commit d45cc8020d7c0a9f01dee42ff5c40bc14c9af72f upstream.

A bridge nftables ct zone set rule can attach a conntrack template to
an skb before nf_ct_bridge_pre() sees it. For non-IPv4 and non-IPv6
EtherTypes, nf_ct_bridge_pre() currently overwrites skb->_nfct with
IP_CT_UNTRACKED without releasing the existing template reference.

That makes the per-cpu template, and any temporary templates allocated
for concurrent use, unreachable and leaks memory until the host runs out
of slab.

Reset the skb conntrack state before marking the frame untracked so the
existing template reference is dropped on the non-IP path.

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/netfilter/nf_conntrack_bridge.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -281,6 +281,7 @@ static unsigned int nf_ct_bridge_pre(voi
 		ret = nf_ct_br_defrag6(skb, &bridge_state);
 		break;
 	default:
+		nf_reset_ct(skb);
 		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 		return NF_ACCEPT;
 	}


