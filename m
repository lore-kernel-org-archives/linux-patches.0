Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2491B149C4D;
	Tue, 23 Apr 2024 21:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908691; cv=none; b=GagNaeKI0gzpDZ+OsbFzgW7O5grUEc0TdPEENIDsChc3AIXDKYjXUN2Jkn7FI1EcwZKiE/v+2asaz3vbAJ6ysdaNzJZliWCjn63ScFRcjohGH/kYB4DddAAPRkTMZUOkwQMGJOwUJ+bDq+c36HzWFNRU5XtW50LRVzTl3Pf2Gwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908691; c=relaxed/simple;
	bh=fs7tQUjhRGSc4McIEZ9CmFMlphNI3UTE1x9l9E9z1Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMebP9KIyEN+feqMNvWcFazVHeyIDJa5Kuyhdospuhr9+a8GNCgd+8Q2PER+moopctdjOS1Yo04zpAR9VLu2SZb71C+ykr9t3CIXJ1C3Zx28KDPC2vBAomDlBgX6b4sID13TIvkuHNtO25o24amwO3jw85huExB5g0Xm4Kulrio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QD7CuUtT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QD7CuUtT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91A1C116B1;
	Tue, 23 Apr 2024 21:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908691;
	bh=fs7tQUjhRGSc4McIEZ9CmFMlphNI3UTE1x9l9E9z1Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QD7CuUtTsfQcWaVv4Z6m+p9p+viO3kre4Eg0jw/ExCeTljkSWoccdQvZMeAhWGY01
	 BPIT1Gz26Lt5IgRT2x5JFuAeJMrRQr4gAzHfolBRwIT2T/d2azFph5JmLMoOVJYhm4
	 G/3ioAqwH/5LKWyzmbLS6jjXbM0YqOwJsTo4Ztls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/141] netfilter: flowtable: incorrect pppoe tuple
Date: Tue, 23 Apr 2024 14:38:27 -0700
Message-ID: <20240423213854.549957738@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 6db5dc7b351b9569940cd1cf445e237c42cd6d27 ]

pppoe traffic reaching ingress path does not match the flowtable entry
because the pppoe header is expected to be at the network header offset.
This bug causes a mismatch in the flow table lookup, so pppoe packets
enter the classical forwarding path.

Fixes: 72efd585f714 ("netfilter: flowtable: add pppoe support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 306e1ba6012e2..22bc0e3d8a0b5 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -156,7 +156,7 @@ static void nf_flow_tuple_encap(struct sk_buff *skb,
 		tuple->encap[i].proto = skb->protocol;
 		break;
 	case htons(ETH_P_PPP_SES):
-		phdr = (struct pppoe_hdr *)skb_mac_header(skb);
+		phdr = (struct pppoe_hdr *)skb_network_header(skb);
 		tuple->encap[i].id = ntohs(phdr->sid);
 		tuple->encap[i].proto = skb->protocol;
 		break;
-- 
2.43.0



