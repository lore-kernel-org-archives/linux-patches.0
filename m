Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BC314389D;
	Tue, 23 Apr 2024 21:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908776; cv=none; b=IAFjlXhtRS6FYTWztxzA6QJFjW2GIzg9u4eiRj7u4IdTbVWGtm/XorYTH+RkxEnMzJGSdjf66emMusVdTl74GzKYYOiuE2mwwazgAmDWNFFT+Qm5YgTsKJQwGVr/6y5iLpnfmlIieCnkXBofHTbwam50YU8ROg7jbIDqi/Cea7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908776; c=relaxed/simple;
	bh=Vgfv3+JVBXsQhn0LFWIiOfUTpgDatVoYKdixJ2GhyLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0CmE7UkIaYAyDCwnVcmfmMYoiPJ71eRB0jXCNwDGNQcwuW6Z0iXAynBUITYVIxhAFAac24pOkoNylyYaRs7pOQrYJY8lteGIVxb71aNZs8LFUrC90wKoJ7pGguP8rcBFPpfkcb41+iWJR+9b/egHfLQ2+bwHlsLhal2ZPZ1oME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjRonUhF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjRonUhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC75C3277B;
	Tue, 23 Apr 2024 21:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908776;
	bh=Vgfv3+JVBXsQhn0LFWIiOfUTpgDatVoYKdixJ2GhyLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wjRonUhFGVfC348sQ6lubZ7wnIvZHhfvjpX0bIUqnvgS70/U9UxIG9kdNEBgJyJEi
	 FQ1KglFD4x7uCc5y6LESmvWr+vCVAA/gZWJvOnfY2S45DOPI4Phm3oX3suqJ9pvheU
	 ChJykMvuWwkxvzre4FFiZlSes+QyJSHRCS4LQFnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 21/71] netfilter: flowtable: incorrect pppoe tuple
Date: Tue, 23 Apr 2024 14:39:34 -0700
Message-ID: <20240423213844.860692888@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 448956fb52f69..f3227f9316969 100644
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



