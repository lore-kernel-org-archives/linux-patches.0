Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F1A11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53A1C433C8;
	Mon, 11 Sep 2023 14:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444178;
	bh=6IwC37zs6/w+vkJF06kZHTuFe11SfxBHIItmmCSmFiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZLLthkHXOE6DmCIUbppyxx8OdFgYGTG7WmT1G/uCgQoavgiH7Qdt4NAl+spu8/hW
	 5iq7VKRbxT1IlS3If5UsvhzgudacjdjqjF05/6l4t79UxQi0VyIATW1lyLOC1RLt4C
	 QDNtXHz/z4y85EBEykJDsYSSIi8+QmAxzaWELgJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.4 637/737] netfilter: nft_exthdr: Fix non-linear header modification
Date: Mon, 11 Sep 2023 15:48:16 +0200
Message-ID: <20230911134708.325928970@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Liang <shaw.leon@gmail.com>

commit 28427f368f0e08d504ed06e74bc7cc79d6d06511 upstream.

Fix skb_ensure_writable() size. Don't use nft_tcp_header_pointer() to
make it explicit that pointers point to the packet (not local buffer).

Fixes: 99d1712bc41c ("netfilter: exthdr: tcp option set support")
Fixes: 7890cbea66e7 ("netfilter: exthdr: add support for tcp option removal")
Cc: stable@vger.kernel.org
Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_exthdr.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -237,7 +237,12 @@ static void nft_exthdr_tcp_set_eval(cons
 	if (!tcph)
 		goto err;
 
+	if (skb_ensure_writable(pkt->skb, nft_thoff(pkt) + tcphdr_len))
+		goto err;
+
+	tcph = (struct tcphdr *)(pkt->skb->data + nft_thoff(pkt));
 	opt = (u8 *)tcph;
+
 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
 		union {
 			__be16 v16;
@@ -252,15 +257,6 @@ static void nft_exthdr_tcp_set_eval(cons
 		if (i + optl > tcphdr_len || priv->len + priv->offset > optl)
 			goto err;
 
-		if (skb_ensure_writable(pkt->skb,
-					nft_thoff(pkt) + i + priv->len))
-			goto err;
-
-		tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff,
-					      &tcphdr_len);
-		if (!tcph)
-			goto err;
-
 		offset = i + priv->offset;
 
 		switch (priv->len) {
@@ -324,9 +320,9 @@ static void nft_exthdr_tcp_strip_eval(co
 	if (skb_ensure_writable(pkt->skb, nft_thoff(pkt) + tcphdr_len))
 		goto drop;
 
-	opt = (u8 *)nft_tcp_header_pointer(pkt, sizeof(buff), buff, &tcphdr_len);
-	if (!opt)
-		goto err;
+	tcph = (struct tcphdr *)(pkt->skb->data + nft_thoff(pkt));
+	opt = (u8 *)tcph;
+
 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
 		unsigned int j;
 


