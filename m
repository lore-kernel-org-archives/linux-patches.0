Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1F93AD538;
	Mon, 23 Mar 2026 13:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274177; cv=none; b=Qmw/OoH2KcXufth2+CVbhfjumVO2vROGyPbTBOd7VlNVDJITx2N9uPl6EFd3G/HsL5+wAVgKS/gYsv5NgR0IOlzL9Jbg4iB/AFI4KEAaYFZyovF/s/Ni+8LSbm4d49hXR/VXbZNhlGu0+qOTQfKOZPB8ibZHIeoJlYBsmk84wlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274177; c=relaxed/simple;
	bh=NU9EVJ6F20fk0AI+hbK8amLfA42q3rUBj5LlWdDb1+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cX1vemsM3tzEjv1pV3Fq2vWPoTpcxlGn2465asb/u256UmL1vXqD/WJzkd362alglpAcMSylbG3IgvRRpaKaQQtx/JqFDMneWFFShxLQ9DhnjHwhgFCGM/Ulbs24C0DngmkLeyNxBMazshBlBLPZvMjoIxtB1lEM9AkjZUr3GzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ujlish38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ujlish38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9492CC4CEF7;
	Mon, 23 Mar 2026 13:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274177;
	bh=NU9EVJ6F20fk0AI+hbK8amLfA42q3rUBj5LlWdDb1+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ujlish38uv0HR0k/Kn6Ig8MvoDXdJjaDj5D7quhg83FivzMMsSoB/O+Il8U1vU02P
	 E6+VAq/6rCb70QSKgUPnJ6hpMNfGOwN3VRIw+Mfc40vMagYWu7u1a0bZGc4CGx/p8T
	 0IZa+c9M/clxnpUEZIQZ3B3pZt0u7GfjMlXgwMWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 135/220] netfilter: nf_flow_table_ip: reset mac header before vlan push
Date: Mon, 23 Mar 2026 14:45:12 +0100
Message-ID: <20260323134508.844777689@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Woudstra <ericwouds@gmail.com>

[ Upstream commit a3aca98aec9a278ee56da4f8013bfa1dd1a1c298 ]

With double vlan tagged packets in the fastpath, getting the error:

skb_vlan_push got skb with skb->data not at mac header (offset 18)

Call skb_reset_mac_header() before calling skb_vlan_push().

Fixes: c653d5a78f34 ("netfilter: flowtable: inline vlan encapsulation in xmit path")
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 78883343e5d68..458895e9e1f85 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -576,6 +576,7 @@ static int nf_flow_encap_push(struct sk_buff *skb,
 		switch (tuple->encap[i].proto) {
 		case htons(ETH_P_8021Q):
 		case htons(ETH_P_8021AD):
+			skb_reset_mac_header(skb);
 			if (skb_vlan_push(skb, tuple->encap[i].proto,
 					  tuple->encap[i].id) < 0)
 				return -1;
-- 
2.51.0



