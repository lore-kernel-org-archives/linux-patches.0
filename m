Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E917815492
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HblqDSBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656F6C433C8;
	Mon, 23 Oct 2023 11:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060025;
	bh=pjUgO5ZoGqRej2UG6QOY7L1x9c489feiLFz85n+k964=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HblqDSBefolg4WpLRgjQKX4XqXeFrWnDTgLeXXI4whSafNdjTXiMZblfjLKgMBRcw
	 GPbbaH8O1DXw7RM/phX1YeTbK3ZxHywUzfEd4b5SgaBjXl9UadfwLJBSf3hc2UBXM2
	 nENQCZJcBqJyWiX6lJE9ovt1rbW22yu6s7tgwA38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bla=C5=BEej=20Kraj=C5=88=C3=A1k?= <krajnak@levonet.sk>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.1 034/196] netfilter: nft_payload: fix wrong mac header matching
Date: Mon, 23 Oct 2023 12:54:59 +0200
Message-ID: <20231023104829.452753698@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit d351c1ea2de3e36e608fc355d8ae7d0cc80e6cd6 upstream.

mcast packets get looped back to the local machine.
Such packets have a 0-length mac header, we should treat
this like "mac header not set" and abort rule evaluation.

As-is, we just copy data from the network header instead.

Fixes: 96518518cc41 ("netfilter: add nftables")
Reported-by: Blažej Krajňák <krajnak@levonet.sk>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_payload.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -132,7 +132,7 @@ void nft_payload_eval(const struct nft_e
 
 	switch (priv->base) {
 	case NFT_PAYLOAD_LL_HEADER:
-		if (!skb_mac_header_was_set(skb))
+		if (!skb_mac_header_was_set(skb) || skb_mac_header_len(skb) == 0)
 			goto err;
 
 		if (skb_vlan_tag_present(skb)) {


