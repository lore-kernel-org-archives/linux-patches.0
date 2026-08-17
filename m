Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B49638D415;
	Mon, 17 Aug 2026 14:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976434; cv=none; b=Xk8DhVntWcrJ9rrt4zZT+32bqm9rIBR1KEqRbDwKV4t3H4nzH3haDb/sRdZQxK23XSTsm5XDVMGV68AXuYSG61GG0YYUXzjgdgyy4tN1WnjnmWSzWvBxQ46Q+YWD6t100tELIBKhQ86D5woCZg+Jljm7c3rD3zZq5eA4DJE1LIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976434; c=relaxed/simple;
	bh=s7cPKZz6MPrbLwQ/HbpHK55UQwvjYDGm0GndJZ3TqA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPYskaG2FyD1SLFT1sFybjO0ePnr50Tbj4hSiuu5oPaK6Ww5ugPSiMOEigrws4JUEQEv6u9OFFjYrkiKPHjvjL2McVgBCfJFo87maf3Y2vZNyzlEE4WWAPpHiCNGXs+t9Xqj4Q99mms915U5Zzu78A0nr1hXB5LZ7tRKErm303o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGmLK5eo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGmLK5eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AB71F000E9;
	Mon, 17 Aug 2026 14:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976433;
	bh=+MryMcHXYoXACys+OFI97iw5qDnmR/OqzIN7a9jMH1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XGmLK5eoj4N3s0Fs37HhqAR0Uxzen6/EPIrN4E1e1iPyFb/UgCWUMhn6viRdr02cL
	 LuWF5C2e5OSc8RX+l2sWbiwjaxH08ZLofx4VDZOGuwnqLp+JD4qH7rf7L8Yb7OKHYy
	 TMTdmGJpoYQvF+K4ZqC+i5znfQdKlW/i1L735MgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 372/389] netfilter: bridge: release template ct on non-IP path
Date: Mon, 17 Aug 2026 15:33:31 +0200
Message-ID: <20260817132553.200793592@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


