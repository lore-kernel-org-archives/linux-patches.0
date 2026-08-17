Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344B23EA979;
	Mon, 17 Aug 2026 13:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974478; cv=none; b=gOORHmrFiR5qqNoGKIpwb3IOunwfB4u/ubgvq6Jee4LQ9wqfx4N7bClZVRQJOTaGkQ7fLZi8DTsCP/gBr9PkhKkzYty3zCD7oksvHY/lBBYA7puVVbiqCDXgrX9Ne1M7jDH7eoT3w0hoTxZpWx7iBD2BmaJ2meMmTxjIw4cYGlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974478; c=relaxed/simple;
	bh=10pdNGn6N09DdAefvwR9bR8m/AXwyr4AF2hKxDVP3GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sh5mNc7NGYQs/SiicmiU23GtIGxczKialm34KNDVOenZqyuQrG4DNDSxuOi+et5qQEeixcu9zSg/MbRFm5EBKQT/QnmJQoFvIvkTp8mvcZZpLL9TbbUgrI5pAXO0biCJb2dTU7hA84rpWPFgzfrvDPx6QDyqMF48ToTmG6qF0K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ozFFc8Rh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ozFFc8Rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DDC1F000E9;
	Mon, 17 Aug 2026 13:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974471;
	bh=Ij7iqqfUJsbphNLHvYoglR/A8uU/ADjVCyZvhwba8lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ozFFc8Rhec4i6WXzmYIni39nge3d/qQUqb7X40iSvIlmmmtUoCqHCpX1YSPcgOj6C
	 UgLBwPFaZJxttrxNJHbPIkuBtD2fsll8stDaxy8GkQhMVngxL9+YaApYaUApiLuDzi
	 LC1QD2gXepxQJo4E6CRrRsQu1UA3/P/OrZH5YjXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.1 218/271] netfilter: bridge: release template ct on non-IP path
Date: Mon, 17 Aug 2026 15:32:23 +0200
Message-ID: <20260817132545.742607118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


