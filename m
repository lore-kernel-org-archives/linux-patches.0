Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8161D435F;
	Mon, 17 Aug 2026 14:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975352; cv=none; b=E2aEEcuQkR5bJ/xh/sBTASaL/kSrmvN9x4yUtqVzTUDvF9Q2Q3Y9yNw4+KYRUNR7f9JSP+F1m1EA2nQVHDqBxH7n6LeLxhZSmH9A8UOppih/kV5ELIiM2pGOyp9yZ3Mki62m7ArAE/JUerMQ5ANfnIoHbr5wiBDWCYodpRkMIfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975352; c=relaxed/simple;
	bh=004zfmmMqupHm2dUrZnhxNFyTda+gDYVdHXUcq0FLcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DeoEUYXh5LGQsV9qkgvZyMdBhr8YKwvTgpmH9eKvSEyJUv5lZnMZYX4rjODwwliWTAeJtaue3f6BU7WQk0N7V/Z2I3aP1f+8362NtcUQL/N+i0kbSElhWhYVNrL6dCKEA5H8ev2gN1WQPvnYX3EJNPoOJt918HS0VPKIY4vNY4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePhOGiFL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePhOGiFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FE61F000E9;
	Mon, 17 Aug 2026 14:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975351;
	bh=eGe4VnbMSg6gnDW6sF3quMkBmUUphRwyVDYzhAdR2kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ePhOGiFLpb6xBXDXnvmhe16Y8RekgvMXuWmTkCop9ujuAtteQoiS0hx87rMgAghS2
	 Vd+6Gli/jA84TGnrmcBUWAW4inu6+4xr5VQulSWi+hwlHCW++YGzNmM9a96B1INiVR
	 YR2KNlLh1bcwKEm7VjDs7ID24SNS71HNCPgotdOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.18 250/250] netfilter: flowtable: ensure sufficient headroom in xmit path
Date: Mon, 17 Aug 2026 15:33:31 +0200
Message-ID: <20260817132546.699182613@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit ef4f741e8627512cb8c82f59a1fc7aacd854aadf upstream.

Check for headroom and call skb_expand_head() like in the IP output
path to ensure there is sufficient headroom for the mac header when
forwarding this packet as suggested by sashiko.

Fixes: b5964aac51e0 ("netfilter: flowtable: consolidate xmit path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_flow_table_ip.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -343,8 +343,17 @@ struct nf_flow_xmit {
 static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 				       struct nf_flow_xmit *xmit)
 {
-	skb->dev = xmit->outdev;
-	dev_hard_header(skb, skb->dev, ntohs(skb->protocol),
+	struct net_device *dev = xmit->outdev;
+	unsigned int hh_len = LL_RESERVED_SPACE(dev);
+
+	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
+		skb = skb_expand_head(skb, hh_len);
+		if (!skb)
+			return NF_STOLEN;
+	}
+
+	skb->dev = dev;
+	dev_hard_header(skb, dev, ntohs(skb->protocol),
 			xmit->dest, xmit->source, skb->len);
 	dev_queue_xmit(skb);
 


