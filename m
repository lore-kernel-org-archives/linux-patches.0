Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DB543E066;
	Mon, 17 Aug 2026 14:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978700; cv=none; b=QLaIh4SVU2z+wRP+LFEfXQcfDPJ9rXqN3PBuNmzwEiG4Q81RAeSiA3zk0cVIjU48lmXQkRytJWqNxoaCmGAjD6pxkt9r6Lh5bRdlgmsL9GXz1r0My/bBGqHK4Vlnsu5BOAuN9j9JQcmErIyEHHLH2YlIPHkcGEnFjsK53AF6agM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978700; c=relaxed/simple;
	bh=9E5O1zDdGknFc9rSx5KXcCN7BeDMK/QET+vGMuy4hEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGiLylq4v3MRHrI4WtsREpDTc/XbCtC/V6EUH9BYe9cCAyr8iYijdMs2+pkPzMJKBTQypS3vJ9+DI70w72/h8wqXu6xdnzWTg7ds2p/7fF1AvdVRUkAowjVR6VorUmcgmBos3VMOcKnTCf17qJnrw+4k0wTehPMgjELH7J9IE5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcciKH77; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcciKH77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281291F000E9;
	Mon, 17 Aug 2026 14:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978699;
	bh=QcCwPD3tnAqKgct0yJ40l/3YcHpu3WG1bAS3gEFxZlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wcciKH77d/8FHFo/AoYCGLBsu9FSwKSIakpsgPjQ0VPdDV2k/WZQlU67U1zFlpmzU
	 hcjSNWW9PUL4Bfy2Wd0EQSFtS19O4QOE/bmCw85o0Jrq4BePJi4gjdv9O2SGBniWgS
	 e+fmTdvhe3k6mTS/yUxQ01l0jwtbAxgdMZAP/19Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 120/156] netfilter: bridge: release template ct on non-IP path
Date: Mon, 17 Aug 2026 15:34:14 +0200
Message-ID: <20260817132539.343580752@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


