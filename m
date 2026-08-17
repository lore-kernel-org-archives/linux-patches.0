Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799E12AEE1;
	Mon, 17 Aug 2026 14:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977774; cv=none; b=LuP1b2fYPbgaB6fs92+l1wAgaXSmT3m4CBW3dLtM+tGkE/OIImMo3qIgltg3Gt2qv3FFNdzLyvoA6PQeCY9slpX5Q3sP017LI+mJc2WzUjzsPuegI6N20EHFbBToI6rM4lqC7kLqIp0ySv2nBDh1dbVEfH7k3mWStd8scjrE4LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977774; c=relaxed/simple;
	bh=9fzEWrtODeO7XvA7ZOCByhU402QDVE3lDMOhPfa0bJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UeU6CGOwO2lJnl2DJlrOzrkADL4Ij6fs8SJBsN3T1OS5dg/sDYaPdkTJil6f9MxT8xljVczk7MnIg5khRyLxzVxtGNLNctSYrgno7CEq8ADaDscTC6Qe8sfJar/aAY09U0f72JOvjIB7x7Qb8Ph7iZ63f+do10et0vf5Ounawpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+nmEHm4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+nmEHm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29751F00A3A;
	Mon, 17 Aug 2026 14:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977773;
	bh=7tZVCyciHBFSjkR8sKFY8xbZrVIHZZuyBcmxJ60vWrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k+nmEHm4FpGTrupgDPbtp6Pa56yY4cZhlTGbyHu7u06QHo0b63UlCMg0ckpiI2MdL
	 corzGhxDHQh5B5HqRbNpcRGfWOreta8Z8jCIFfd1srInCTXXrQHymokqiv3vaDyghk
	 +SQVBEA6ij2iKws5/FlhUA7jepXFdkZf2GS7q790=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 438/456] netfilter: bridge: release template ct on non-IP path
Date: Mon, 17 Aug 2026 15:33:48 +0200
Message-ID: <20260817132556.240420852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -280,6 +280,7 @@ static unsigned int nf_ct_bridge_pre(voi
 		ret = nf_ct_br_defrag6(skb, &bridge_state);
 		break;
 	default:
+		nf_reset_ct(skb);
 		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 		return NF_ACCEPT;
 	}


