Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E0036493C;
	Wed, 30 Sep 2026 15:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783873; cv=none; b=XhbwVt7us6xFWX46wuxMD2wSOvDhFf73t8DZV7wVytSJpzjAYlBfQ83P+DtUzF3ha6yuIgajh/wrP4RmquHt156Ip9/z9O2pfJD+ptWtmwRnJzyuh2MUzUSrVk9NBmyL5FwRsTVi3wtn3vfs1ksVwmZpkrTJsdCsR443OVaVNr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783873; c=relaxed/simple;
	bh=JRmKDqtRkDVjjrqnuUKvjEB7asozbkZhpBA6IqZQi/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUIpy5rbfJm+G6Tk+9/wtkox1n7s9UXq7ZrEDJo3DN7SJ4GUmYS2UZ3CFudjEPDxgcsg7xpNVau0jeeo+uw/eYYLauURMcLuYV3bGKMgudv62PMbEqF2Z5up6A15TsOqRn1XKm53Cb/UEtif+kECIeKp9xA1WE9fZrUHjDQGirM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ka6O1mvo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ka6O1mvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F801F000FF;
	Wed, 30 Sep 2026 15:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783869;
	bh=UgEOv1xFI0Ffp4+7igtzOGbmYUBcuav0pyabuRJ6L2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ka6O1mvoYBPX5gcZLYQbfV07wSktlAbL14Pqw3fqTFrUT6xb8gs3TxqM4JUYM+5ik
	 Pd1/KG/VjlPgFSFVCuk06vvUd6kuXvm8pR9EMd6HQjpdJxQmCdPr5ISlIFG3dmhn1T
	 ofqHQCydWzB/urLJJaEQxzsFUGjpTmR7SZlkcIXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zixuan Chai <petalzu987@gmail.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 544/595] vlan: ensure sufficient headroom in vlan_dev_hard_header()
Date: Wed, 30 Sep 2026 17:27:17 +0200
Message-ID: <20260930152359.413955033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cd5dd68267c4238795fadaf02b3575ca3f8a6500 ]

Callers that only reserve ETH_HLEN or less (such as llc_alloc_frame()),
or skbs allocated before dynamic device/headroom changes (e.g. toggling
VLAN_FLAG_REORDER_HDR or bonding/team switching slaves), can reach
vlan_dev_hard_header() with insufficient headroom and trigger
skb_under_panic().

Use skb_cow_head() in vlan_dev_hard_header() when VLAN_FLAG_REORDER_HDR
is not set to ensure sufficient headroom for the VLAN header(s) and the
underlying device hard header.

Use READ_ONCE() to read dev->hard_header_len and dev->needed_headroom as
they can be updated concurrently under RTNL (e.g. in
vlan_transfer_features()) while vlan_dev_hard_header() runs locklessly on
the transmit path. Also avoid LL_RESERVED_SPACE(dev) here so that the
extra HH_DATA_MOD alignment padding does not trigger unnecessary
pskb_expand_head() reallocations on inner stacked VLAN devices after the
outer VLAN header has been pushed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Zixuan Chai <petalzu987@gmail.com>
Closes: https://lore.kernel.org/netdev/cover.1789987105.git.petalzu987@gmail.com/
Link: https://lore.kernel.org/netdev/179022851638.2160803.1808206741379444999@kernel.org/
Cc: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260924082951.1599377-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/8021q/vlan_dev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index c134f8210b21b..9949369e3633b 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -53,6 +53,11 @@ static int vlan_dev_hard_header(struct sk_buff *skb, struct net_device *dev,
 	int rc;
 
 	if (!(vlan->flags & VLAN_FLAG_REORDER_HDR)) {
+		unsigned int hlen = READ_ONCE(dev->hard_header_len) +
+				    READ_ONCE(dev->needed_headroom);
+
+		if (skb_cow_head(skb, hlen) < 0)
+			return -ENOMEM;
 		vhdr = skb_push(skb, VLAN_HLEN);
 
 		vlan_tci = vlan->vlan_id;
-- 
2.53.0



