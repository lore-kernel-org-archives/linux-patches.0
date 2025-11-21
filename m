Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547B92765FF;
	Fri, 21 Nov 2025 13:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731017; cv=none; b=OBHgEqHPxOGwkGWrMG2xpIBBD5bGq8ouTta015qdp2pEhXArEdr9jR2grN1ZJj6PXZxawa1zy3WhtDzcBaTweoyRS9OZT4dHEbogE+i0nxVLUwYU5yjkuauf4z+l+FyOEQ4xj0v+VD+U7fvFvziHWrpH8zA37TfMxVqTqm+I0do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731017; c=relaxed/simple;
	bh=JSf3zAIhAvHzXaLV4Y7h12E0Fi6AdWtNtd2JnFS0/WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bE3FSMbvrycbTrugc3aA4fhKTc7ING80PFlVW231pGPygwjuULAiJ7BG85DgwG1mvMzXdfWpF+iZS/AopDA3vHxhzVWhdQ+PqRqRqh9DKZQG6eMiCG14squzAGJ6Vz8F7l85cxJZyi8M+a75Qc1Oczz7p0nbAy4GFAm3pLO8ktw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRl9wL8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRl9wL8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE2BC4CEF1;
	Fri, 21 Nov 2025 13:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731016;
	bh=JSf3zAIhAvHzXaLV4Y7h12E0Fi6AdWtNtd2JnFS0/WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRl9wL8qj000bwX/pp56fp+b8WI0mjzy3xjQBGYtqKuPF9A4SmkAbH7N0IV/hA2Tu
	 mq3TfHAey1auuUYZaBZxKNuPlOe84cVM83gfZLhcEPq+mo1dcNBSAIryseVJJcNORi
	 Y6W3qz1sM0hFhkUv7KEkFeNjILhRZ68kwr2UVseQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 062/247] net: dsa: tag_brcm: do not mark link local traffic as offloaded
Date: Fri, 21 Nov 2025 14:10:09 +0100
Message-ID: <20251121130156.828482482@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 762e7e174da91cf4babfe77e45bc6b67334b1503 ]

Broadcom switches locally terminate link local traffic and do not
forward it, so we should not mark it as offloaded.

In some situations we still want/need to flood this traffic, e.g. if STP
is disabled, or it is explicitly enabled via the group_fwd_mask. But if
the skb is marked as offloaded, the kernel will assume this was already
done in hardware, and the packets never reach other bridge ports.

So ensure that link local traffic is never marked as offloaded, so that
the kernel can forward/flood these packets in software if needed.

Since the local termination in not configurable, check the destination
MAC, and never mark packets as offloaded if it is a link local ether
address.

While modern switches set the tag reason code to BRCM_EG_RC_PROT_TERM
for trapped link local traffic, they also set it for link local traffic
that is flooded (01:80:c2:00:00:10 to 01:80:c2:00:00:2f), so we cannot
use it and need to look at the destination address for them as well.

Fixes: 964dbf186eaa ("net: dsa: tag_brcm: add support for legacy tags")
Fixes: 0e62f543bed0 ("net: dsa: Fix duplicate frames flooded by learning")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251109134635.243951-1-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_brcm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index d9c77fa553b53..eadb358179ce3 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -176,7 +176,8 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 	/* Remove Broadcom tag and update checksum */
 	skb_pull_rcsum(skb, BRCM_TAG_LEN);
 
-	dsa_default_offload_fwd_mark(skb);
+	if (likely(!is_link_local_ether_addr(eth_hdr(skb)->h_dest)))
+		dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
@@ -250,7 +251,8 @@ static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 	/* Remove Broadcom tag and update checksum */
 	skb_pull_rcsum(skb, len);
 
-	dsa_default_offload_fwd_mark(skb);
+	if (likely(!is_link_local_ether_addr(eth_hdr(skb)->h_dest)))
+		dsa_default_offload_fwd_mark(skb);
 
 	dsa_strip_etype_header(skb, len);
 
-- 
2.51.0



