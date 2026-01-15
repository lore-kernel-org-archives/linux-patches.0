Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D0A3E9F61;
	Thu, 15 Jan 2026 18:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500026; cv=none; b=lLa5nBw7HkxMZfg9a96sKGSOdb0exx7tv+4rWqqwbjyZ7LjQECuKFo9a6lB9un32rwnHzbjKR9QH1byJEt+ygDnqV5ZcTBdhYc5m+5VrRMDLwP0hTwNOTiEh3zHpLLX5gQI99Te1Fw1UNMaVZ7j3eJc9qhtKJ+2M7kglAKOuTqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500026; c=relaxed/simple;
	bh=I5RQrRxDrQ/ct3jCd+NkSoqgBuC6LTKHP1iCfSrxWQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OD4425iGl8OUdC8v2BBbYBuwFdikG1g163fYn+T3RlXdhi8Lylc6+ZkqqDvLB8JFRUn7B+QH6gSF8e102NOW4KyiiqwhpPomychu/TISui2CnF4jsTb/I/xbCjMkJr8Uj7J01Y1p3Q12qoumrYnqDGYgoDg+6AvGJt+WZF84tMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJ5/RjHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJ5/RjHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66A3C116D0;
	Thu, 15 Jan 2026 18:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768500026;
	bh=I5RQrRxDrQ/ct3jCd+NkSoqgBuC6LTKHP1iCfSrxWQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJ5/RjHZKcQ3CFbwT94v9SGxMYCwTG5j5mybd9vYwM/sThpPbcd0pjp+H5iCH1w2C
	 CO2LFfUj6X8ixTY3Wo4zdI8I05FGgddjDoTtV3QCODlbPA6CAwlrRRgq4058pgnj0h
	 UfAov2DzyBOV66G76/uzaokQDUUQ78WU+9f7igy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 432/451] netfilter: nft_synproxy: avoid possible data-race on update operation
Date: Thu, 15 Jan 2026 17:50:33 +0100
Message-ID: <20260115164246.573861002@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 36a3200575642846a96436d503d46544533bb943 ]

During nft_synproxy eval we are reading nf_synproxy_info struct which
can be modified on update operation concurrently. As nf_synproxy_info
struct fits in 32 bits, use READ_ONCE/WRITE_ONCE annotations.

Fixes: ee394f96ad75 ("netfilter: nft_synproxy: add synproxy stateful object support")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_synproxy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 0806813d3a767..46d2eefb0b218 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -48,7 +48,7 @@ static void nft_synproxy_eval_v4(const struct nft_synproxy *priv,
 				 struct tcphdr *_tcph,
 				 struct synproxy_options *opts)
 {
-	struct nf_synproxy_info info = priv->info;
+	struct nf_synproxy_info info = READ_ONCE(priv->info);
 	struct net *net = nft_net(pkt);
 	struct synproxy_net *snet = synproxy_pernet(net);
 	struct sk_buff *skb = pkt->skb;
@@ -79,7 +79,7 @@ static void nft_synproxy_eval_v6(const struct nft_synproxy *priv,
 				 struct tcphdr *_tcph,
 				 struct synproxy_options *opts)
 {
-	struct nf_synproxy_info info = priv->info;
+	struct nf_synproxy_info info = READ_ONCE(priv->info);
 	struct net *net = nft_net(pkt);
 	struct synproxy_net *snet = synproxy_pernet(net);
 	struct sk_buff *skb = pkt->skb;
@@ -339,7 +339,7 @@ static void nft_synproxy_obj_update(struct nft_object *obj,
 	struct nft_synproxy *newpriv = nft_obj_data(newobj);
 	struct nft_synproxy *priv = nft_obj_data(obj);
 
-	priv->info = newpriv->info;
+	WRITE_ONCE(priv->info, newpriv->info);
 }
 
 static struct nft_object_type nft_synproxy_obj_type;
-- 
2.51.0



