Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF8F3E63B0;
	Mon, 17 Aug 2026 15:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980463; cv=none; b=pJ5UKeawfEFyp6N493W1Zr1Vl3Pyl0yDQVtgi8D/djK4ZLGvI5wf0/8otTMyh6VtyG4+Zj9U+jHGW0BQvCLE9BxYS/fmx8cwqMhdfEOD/eEIGUFk8BZqUxnC/+vuBbzP5Hr6/bgOpXtncKGa6wFpGjWl831OkRgfHOeoSZn4bmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980463; c=relaxed/simple;
	bh=w4Gwxj5UK88VtBWPevLVGheVW5wplLl403uLy3+tP50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQmqvMqgwidS61rJ3y2bUH3ivCT3NPQ9qGmb4Esbrpm//mqITSpVTomsBH7qPsOhlmCIPle+65sbWBFQObM7NQPIcWCSIuiUWpJsUEdCXYnwok4Tk7yCjsXlt6CdwNjAibswLRpN4yDiz0u4C0/qyuaWRw6EPYxoRCq1/1stYQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j19DMNQ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j19DMNQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225BF1F000E9;
	Mon, 17 Aug 2026 15:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980461;
	bh=X9Fi7Gm3X+uO80emajw+wo1R6TN3SzBkAupUUiV+B7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j19DMNQ4qUBswpcGI1ISq1RKmROWkNa8qvACK691Pph4Y8x8hnwA4ckbG0Ho+Sj/1
	 7waZffFMbRB7saHd+X1RfmCtD0P3g4v1GIa4Y4pynpIgjgqdKKP7yMaQIZGP+IXMj4
	 w9NIQpAzgzGJalgsoP+FDMT0cOTbwuxgCYwaSobo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 582/609] netfilter: bridge: release template ct on non-IP path
Date: Mon, 17 Aug 2026 15:34:38 +0200
Message-ID: <20260817132603.164624192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


