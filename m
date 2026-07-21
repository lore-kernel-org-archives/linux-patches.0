Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16219175A81;
	Tue, 21 Jul 2026 23:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674840; cv=none; b=eZx+Bicp6EZp9TDuxYBoUIbVycjYR84IPWJALjE/27LlCpVCuLGLZyNRi3KQtxaogGQivwcyA/uOuBuFwA4jsTTm0YJSIV95YNHIV2thtB4bcYjqCeRvel57ih1uMAb4fB9CtsFRVN15nvlNnEe1lGYf6WUFLwk35ChdfqwcR6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674840; c=relaxed/simple;
	bh=YL+EM4jg5AedUJhl8277U8BJbj7DCg398+w4FMa8dfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1wSLiZUpK89VUqi0Pf3AZksVpEECzy3ZExAoU27iA2JwnstuBmQVUFZcbuLvi7xTKUQN4RXlhQ5XNe3yiiiwAO+6IUg8RYLh8YCGGM1zf4WEF4pNpXqCSgmtAtWnwsUvzaA6Gecd+ysKpch7IdB7nR488HBcV5/A6zIjzDHyK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZDQ1baq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZDQ1baq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB521F000E9;
	Tue, 21 Jul 2026 23:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674839;
	bh=I0rcU0bF8AS6MZ7ATACF46MNlh4MRmvfOCYrxJkOuqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZDQ1baqXzYkIIXGaQufjfVK6iCfVT8xW5pevi5R7QHCDSDc5iyzEDEY1DKZvBXCL
	 v3DjjvMjLzBAiaP4wkP5yih9vacOwHcBxWfHkTC0gGvOO0sGYYPDJnsJZog1p9+aT0
	 bnYjn/ElEAAwmfje4HDMuI6ae8aAU2c+bWbw6blU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kristian Evensen <kristian.evensen@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 693/699] net: ethernet: rmnet: Always subtract MAP header
Date: Tue, 21 Jul 2026 17:27:32 +0200
Message-ID: <20260721152411.410676765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Kristian Evensen <kristian.evensen@gmail.com>

commit 8b8701d0b4925807a6d4dc4699cb80a1e16218ad upstream.

Commit e1d9a90a9bfd ("net: ethernet: rmnet: Support for ingress MAPv5
checksum offload") broke ingress handling for devices where
RMNET_FLAGS_INGRESS_MAP_CKSUMV5 or RMNET_FLAGS_INGRESS_MAP_CKSUMV4 are
not set. Unless either of these flags are set, the MAP header is not
removed. This commit restores the original logic by ensuring that the
MAP header is removed for all MAP packets.

Fixes: e1d9a90a9bfd ("net: ethernet: rmnet: Support for ingress MAPv5 checksum offload")
Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -88,11 +88,12 @@ __rmnet_map_ingress_handler(struct sk_bu
 			goto free_skb;
 		skb_pull(skb, sizeof(*map_header));
 		rmnet_set_skb_proto(skb);
-	} else if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
+	} else {
 		/* Subtract MAP header */
 		skb_pull(skb, sizeof(*map_header));
 		rmnet_set_skb_proto(skb);
-		if (!rmnet_map_checksum_downlink_packet(skb, len + pad))
+		if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4 &&
+		    !rmnet_map_checksum_downlink_packet(skb, len + pad))
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 


