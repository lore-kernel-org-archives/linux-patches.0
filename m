Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF763D668B;
	Tue, 25 Aug 2026 13:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665039; cv=none; b=Y7ikNoDY5G+CT3/T5lgTXiEQizHkfu8lpeN992RxMvn2pbA03hDP6uk5bi6DflC//8UKKBCEOQJYWtk7V3WNS3xhcYoUXVXSR4wOJ3V62zgMMbyXigspNjWuTGG6A7IT7klFjYzfzXmTub3uKhnmFzBTfvvWZMnUASIYoBEV0Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665039; c=relaxed/simple;
	bh=NwItAT5tmniuBJykz7oKvhJaQWv2AMXu90ipi9RTE64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzxjRHPLvJtGjybDoaupOiqxP4GRw2NTahV/nun7YsX5ncr8mgZGhlsHKUeW1y79oIdMy//0lMdnHPD7Be5LOEkB31rC0pPYH4y82B4YOI41OUstfEBWlMhJRYp3w5Ybq0HG4WVtPeOvor9ziz+h7egQS58R0e+74AR5hcbhZqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPxZ2T2o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPxZ2T2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378EE1F000E9;
	Tue, 25 Aug 2026 13:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665037;
	bh=s0w93VEG7aORrIAk/0JENj1ZRMp/Lci/sf8+rqLhi0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hPxZ2T2oxQ1Ph+hg3V0OPW7mC59Z2Dyfntr3QDxv+ubKn6IMvIBM9McL2Z/h3TS6h
	 rBxu5lZwPCyqa17PRK/SKI59Ljs2ZotMW8mtokXnilY7E4wKPLoj/+0SLSAEp00yWT
	 UcPQaBO8MwyEg2trEhamdRZa175M79s51q5ysXPk=
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
Subject: [PATCH 7.1 050/101] ipv6: fix use-after-free in ip6_finish_output2()
Date: Tue, 25 Aug 2026 15:25:28 +0200
Message-ID: <20260825132543.974867916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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
@@ -116,6 +116,8 @@ static int ip6_finish_output2(struct net
 
 		if (res != LWTUNNEL_XMIT_CONTINUE)
 			return res;
+		hdr = ipv6_hdr(skb);
+		daddr = &hdr->daddr;
 	}
 
 	IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_OUT, skb->len);


