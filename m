Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D49C47ECD2;
	Tue, 25 Aug 2026 13:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665509; cv=none; b=b6efGFq9CHZUr+ByVMJKAl4E/h0GsthJL3/0Wn9/uxHjHwoSbeHM1MqTOVQ4h49jyakv5Y/mMJbXyOZ39Dpkg/+8fCl/+G3G0M9oGTZMTQq2ZMK1WGNrRFV6uu4g7kEPL1zLJJa7h7jTAAEBszuhSGBcukO8rib7LvBF6GX8GsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665509; c=relaxed/simple;
	bh=UI98w6pxIrRjEtx9meU7rekD4HR8EZQ6wyMFZSJpfuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpmmF3vNT/jT5b0i+eE0atkHsR2DyWWmsoNzIDoTKepMmM4fVoNQCIaKKb+e0njyUVXuvJKwSkHWPz+DfnDWiPvVjvFh45twgY7vjl8zPE4tiUnDHNz4++8sbBW45shDB/5buhUAYr1Lu9S9gfVd8r2EkRA3driUvax9/gkrES8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTvwS0X/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTvwS0X/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B13E1F000E9;
	Tue, 25 Aug 2026 13:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665508;
	bh=h/iPViu8oIPeIa9E4jRP94JzZvR6U7fyiGpZdGY2EOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jTvwS0X/n2v3x+vS4egI8F57AphL5kczvIMzA8xg33BG28187ef1QWuvQk8BuPP3l
	 bHkXUoRcMWQ6/5QCLGZhxBMpZw/HQt+oXNSCnY+svEih7k3hazh/fofQgkJgp9HJEs
	 I7y+IkrAWCSwR10esA+MSAV40d8WNLAOoty1T7L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 48/77] ipv6: fix use-after-free in ip6_finish_output2()
Date: Tue, 25 Aug 2026 15:26:10 +0200
Message-ID: <20260825132543.444753351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luxiao Xu <rakukuip@gmail.com>

commit d0d48d999b0eee6bb176ef4e39d9be868fa80f7e upstream.

ip6_finish_output2() caches a pointer to the IPv6 destination
address (daddr) before invoking lwtunnel_xmit().  The LWT-BPF
transmit path or other encapsulation operations within
lwtunnel_xmit() can reallocate the skb head, freeing the memory
that daddr points to.  When lwtunnel_xmit() returns
LWTUNNEL_XMIT_CONTINUE, the function continues to use the stale
daddr pointer to compute the nexthop and to look up or create the
neighbour entry.  This results in a use-after-free read, which can
leak sensitive kernel data, pollute the neighbour table with
arbitrary values, misdirect traffic, or crash the system.

Fix this by re-fetching the IPv6 header and the destination
address pointer after lwtunnel_xmit() returns
LWTUNNEL_XMIT_CONTINUE, ensuring that the subsequent nexthop
computation and neighbour lookup operate on valid memory.

Fixes: e415ed3a4b8b ("ipv6: use skb_expand_head in ip6_finish_output2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/4aa3f53bc44e79572c6dd2340ec7b68ef1a3d87d.1786516730.git.rakukuip@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -119,6 +119,8 @@ static int ip6_finish_output2(struct net
 
 		if (res != LWTUNNEL_XMIT_CONTINUE)
 			return res;
+		hdr = ipv6_hdr(skb);
+		daddr = &hdr->daddr;
 	}
 
 	IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_OUT, skb->len);


