Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDFB477980;
	Tue, 16 Jun 2026 16:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626769; cv=none; b=MvrYSyZi0VsHq04MXt/coe5s68bbhyeV0LIBTpTeX4XqSuNivX9NGYEFgPNC56KFdbeLk7BE3so0lvOsqeoS7VELLF0ACTVHvet0xA6mKaqX5eup6YXqvDfXxk4wpEsb06FObWmR2TK2mGFl8RGfbh6FMtqcFVrOKtFyAw/jKYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626769; c=relaxed/simple;
	bh=SDRzk7OGQKCz7M7MHAImrOD8R6krBm6WXBS/WVRPPHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILAxmjRxwUIJnMHXhAka4EPrCxX7PZjQT4TNNxRSfqUsyYDDM9MmQ1ZvE21qReX61AP27zOtol9ooq9Ve35+eqRn6fhQ4IpwRCWxNnfyEnCtMcG8FI4BKZHBTYljQKvVe7KQj/7rgUtrBCTSjz8DJqj03YPjEKz4onZPd5mrmk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9IsXmB3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9IsXmB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07C11F000E9;
	Tue, 16 Jun 2026 16:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626768;
	bh=35gSvAlbR93GT8ks9M2WN0VHkugxRZysdxxxvGNowlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9IsXmB3gyEkIF1gv1sOMy47FdGnsGpldqo3pYI4iy5sdU1aUt3QNnKKbUNsvaQnK
	 uop81nl3mWAS61oMkfu/teOqltqpN70pm69n7cBGjpmi3l+CcjDim0WsFw7UXm5YFe
	 30pj3FFLi6+h+79BKiVzqzGUlyzxkRnp7610ULEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/261] netfilter: bridge: make ebt_snat ARP rewrite writable
Date: Tue, 16 Jun 2026 20:27:41 +0530
Message-ID: <20260616145046.065640664@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Yiming Qian <yimingqian591@gmail.com>

[ Upstream commit 67ba971ae02514d85818fe0c32549ab4bfa3bf49 ]

The ebtables SNAT target keeps the Ethernet source address rewrite
behind skb_ensure_writable(skb, 0).  This is intentional: at the bridge
ebtables hooks the Ethernet header is addressed through
skb_mac_header()/eth_hdr(), while skb->data points at the Ethernet
payload.  Asking skb_ensure_writable() for ETH_HLEN bytes would check
the payload, not the Ethernet header, and would reintroduce the small
packet regression fixed by commit 63137bc5882a.

However, the optional ARP sender hardware address rewrite is different.
It writes through skb_store_bits() at an offset relative to skb->data:

        skb_store_bits(skb, sizeof(struct arphdr), info->mac, ETH_ALEN)

skb_header_pointer() only safely reads the ARP header; it does not make
the later sender hardware address range writable.  If that range is
still held in a nonlinear skb fragment backed by a splice-imported file
page, skb_store_bits() maps the frag page and copies the new MAC address
directly into it.

Ensure the ARP SHA range is writable before reading the ARP header and
before calling skb_store_bits().

Fixes: 63137bc5882a ("netfilter: ebtables: Fixes dropping of small packets in bridge nat")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebt_snat.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 7dfbcdfc30e5d2..c9e229af0366b8 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -31,6 +31,9 @@ ebt_snat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 		const struct arphdr *ap;
 		struct arphdr _ah;
 
+		if (skb_ensure_writable(skb, sizeof(_ah) + ETH_ALEN))
+			return EBT_DROP;
+
 		ap = skb_header_pointer(skb, 0, sizeof(_ah), &_ah);
 		if (ap == NULL)
 			return EBT_DROP;
-- 
2.53.0



