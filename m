Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4189F23C5
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lx3u37QH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBB5C433C7;
	Mon, 23 Oct 2023 11:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060677;
	bh=LBUuZXbk+IhQ20p6FQb3Do44494ME5muQsdkxOmsnR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lx3u37QH4NgDRb6tXXSZ5NteZMYcV+8lU4J/kFmoCnr5nBSfuOQl1dNtZ5ZJLbZ86
	 BhqSPqfIz7qOrGjHcpcyaDUZ49mhG/8OIWTqomT/kmJ2MhKPMD4v3jhTni0ZGeISK9
	 W5WrwJyQGZu9R1O8FwzY/2Fh0WdSrAXJUYewWeks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bla=C5=BEej=20Kraj=C5=88=C3=A1k?= <krajnak@levonet.sk>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.4 056/123] netfilter: nft_payload: fix wrong mac header matching
Date: Mon, 23 Oct 2023 12:56:54 +0200
Message-ID: <20231023104819.579819126@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
References: <20231023104817.691299567@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -84,7 +84,7 @@ void nft_payload_eval(const struct nft_e
 
 	switch (priv->base) {
 	case NFT_PAYLOAD_LL_HEADER:
-		if (!skb_mac_header_was_set(skb))
+		if (!skb_mac_header_was_set(skb) || skb_mac_header_len(skb) == 0)
 			goto err;
 
 		if (skb_vlan_tag_present(skb)) {


