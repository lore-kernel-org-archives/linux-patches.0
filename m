Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5F42D238A;
	Thu, 15 Jan 2026 17:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496575; cv=none; b=GiZvv8WviWsNhIPpDZSEhf2v8g5gtoQDZTAK5SfvVCSz6hLLN3WpcvvvQv34MwtLsEGFYLe2SfK8LE4AtVYXpKNvZgwGyyz5m+4pzx2+2gtRwmuOBhMb7Y6xkoXaDMWfifTu2rzPcMmguYykxiQZVK1m0WuA90QpWPHhWq/oxUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496575; c=relaxed/simple;
	bh=CR5neT5MyYywNiUnESM8lILbBnkAxvb47GunNZ/GsnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXCxW9LIOeNvu4/Y2+q8+nAAg1iSN5DOfmoDq+zuJ/CdaeKzaNPd6bKv57RnCK4D+rZo5Fn7oh9Zd26opEpJ7PRek4CwGPgAg7guUmp3eJIuvHEsqFavvOKBccEmARmdiJ39+ZHggR8uub2I/T4q87bHCs5r5BGKjb32XXO9ILY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPindOvV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPindOvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB515C116D0;
	Thu, 15 Jan 2026 17:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496575;
	bh=CR5neT5MyYywNiUnESM8lILbBnkAxvb47GunNZ/GsnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tPindOvV7iqoOAYLacDyCWmT1MnpYE6nYnSiC/Q4QMOoecMqqGxoK6OfoEJ1Rgkco
	 ueJvdhPPRw7NTJUohoW+l4S0YKhLxz8YRA+Ko4Zw1uk7QrHDv1MQtPfkN1V6QrYN/v
	 Olt763FW8h5JWTjypPzq5aSEs/bjVYBPGGJiX6ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/119] netfilter: nft_synproxy: avoid possible data-race on update operation
Date: Thu, 15 Jan 2026 17:47:54 +0100
Message-ID: <20260115164154.088285394@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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
index 5d3e518259859..4d3e5a31b4125 100644
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
@@ -340,7 +340,7 @@ static void nft_synproxy_obj_update(struct nft_object *obj,
 	struct nft_synproxy *newpriv = nft_obj_data(newobj);
 	struct nft_synproxy *priv = nft_obj_data(obj);
 
-	priv->info = newpriv->info;
+	WRITE_ONCE(priv->info, newpriv->info);
 }
 
 static struct nft_object_type nft_synproxy_obj_type;
-- 
2.51.0



