Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2EE2E7BD6;
	Thu,  3 Jul 2025 15:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555136; cv=none; b=hKZg7n9vL0iOkHzHlF8ia5n27kIDNKMLKmxE4XU2+KpX8rRBNA0sL+YnpWKw2A363z0o26dZO22yMrf3hNSfCo00rnedBcx0hs+v9w7vjz36nwpeZemPJ3pcyqQF0zbE/mjZ8yCShgQBN7wzneZ8tmpnkSNsW4BqwYH6Q0nQKeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555136; c=relaxed/simple;
	bh=gTRMkt/ZBojIGXMu3P9MJvsjKGy5XxLkCBTm9IobMr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rd33TbBT1QnWu49vWOyqK5AYQCKj/qAksQno+0xnwPuTaiPauJ7JdmIpfcsfP8/+GLHKiDU+MPUayCEFZoGHfINyjXHem+4YPnMQasGDvX9n+bildMrXRZUQlOF8iHb88bvYH5Ph5HN46U0s0zteQ0p1Uq87y5PzCP99vU2+bG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5wcm0Ho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5wcm0Ho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E16C4CEE3;
	Thu,  3 Jul 2025 15:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555136;
	bh=gTRMkt/ZBojIGXMu3P9MJvsjKGy5XxLkCBTm9IobMr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5wcm0Ho+5oseaSjTdQAqZ/s9ogcTdcp7am/4PmEeG6vmmVItzgVlG68Xwa5hK9kb
	 CETmY0RSrLBZ5C4NruswPEMe5OSFBgVH6lY4kvVPDw8dHYu/v5XGMw/Nvvg9EWr1Hw
	 zHVczYXrShk5B+fRRK/F7Z3ULkuTQRDydWMNEO8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 159/263] net: selftests: fix TCP packet checksum
Date: Thu,  3 Jul 2025 16:41:19 +0200
Message-ID: <20250703144010.735911727@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 8d89661a36dd3bb8c9902cff36dc0c144dce3faf ]

The length in the pseudo header should be the length of the L3 payload
AKA the L4 header+payload. The selftest code builds the packet from
the lower layers up, so all the headers are pushed already when it
constructs L4. We need to subtract the lower layer headers from skb->len.

Fixes: 3e1e58d64c3d ("net: add generic selftest support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20250624183258.3377740-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/selftests.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/selftests.c b/net/core/selftests.c
index 35f807ea99523..406faf8e5f3f9 100644
--- a/net/core/selftests.c
+++ b/net/core/selftests.c
@@ -160,8 +160,9 @@ static struct sk_buff *net_test_get_skb(struct net_device *ndev,
 	skb->csum = 0;
 	skb->ip_summed = CHECKSUM_PARTIAL;
 	if (attr->tcp) {
-		thdr->check = ~tcp_v4_check(skb->len, ihdr->saddr,
-					    ihdr->daddr, 0);
+		int l4len = skb->len - skb_transport_offset(skb);
+
+		thdr->check = ~tcp_v4_check(l4len, ihdr->saddr, ihdr->daddr, 0);
 		skb->csum_start = skb_transport_header(skb) - skb->head;
 		skb->csum_offset = offsetof(struct tcphdr, check);
 	} else {
-- 
2.39.5



