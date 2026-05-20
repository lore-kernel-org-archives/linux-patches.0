Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE463F4DF4;
	Wed, 20 May 2026 17:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299614; cv=none; b=d6afsJnTgzHT9ixzwrfihvndR3T7avZtm8YAkEwsD0eZT+iu/2BB74172eb8iXhJpCRpRlPjBIO4xAA/eIXeULL9Tt85y1uDMdm6iJmXmQ3g1EnoXIvYxNjRJcKxqNnZwbLW/R9l4b/Va22T40qjju0s5d8Q/YhE4G3dCfynQVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299614; c=relaxed/simple;
	bh=clhWToRkHOqfND8xEuUHKHHJZIa8tbAChe0kvPzQ+RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0bhLM0dXT/UOs2ux4Lv6f4PyzxtdN9rpqo0mMV8hoGH4w9EyLCUGhq8yXC4wUa6WSapn3sEOCNSV+kjrTfSJuWiTFNBm9Bx9yiojuNNRzKdCxWXsYTFp5CsnhJ1v6KvPtOwNDFsA7XeEtcpkK5oPGn/hefX58hG+HlDmnTBnlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihkLQOAw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihkLQOAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E38F1F00893;
	Wed, 20 May 2026 17:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299613;
	bh=OTdIjCO2IaBDelhEtPOBbdhnC5alBFuftfbkQeXJm1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ihkLQOAwF+v60RkntPDDRbd8nYWT0fo/DnnIv0+pFgB7np2ttYB8GMryieBq9+Ozq
	 i4LWQ7g99fRBmpDQ3tV19vQrlRYIJvOS7HdIB5zS9Wwx+5EcbTaQRl52yq1KYrizPT
	 MYcQZI0TYGncaPb3ouwhuD4Ohi/o26W829f8aekA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 837/957] net: airoha: Do not return err in ndo_stop() callback
Date: Wed, 20 May 2026 18:22:00 +0200
Message-ID: <20260520162152.714199502@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 4ca01292ea2f2363660610a65ba0285d7c3309ed ]

Always complete the airoha_dev_stop() routine regardless of the
airoha_set_vip_for_gdm_port() return value, since errors from
ndo_stop() are ignored by the networking stack and the interface is
always considered down after the call.

Fixes: 23020f049327 ("net: airoha: Introduce ethernet support for EN7581 SoC")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260428-airoha-ndo-stop-not-err-v1-1-674506d29a91@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 6742d0d9068df..81ecfc1a1094c 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -1769,13 +1769,10 @@ static int airoha_dev_stop(struct net_device *dev)
 {
 	struct airoha_gdm_port *port = netdev_priv(dev);
 	struct airoha_qdma *qdma = port->qdma;
-	int i, err;
+	int i;
 
 	netif_tx_disable(dev);
-	err = airoha_set_vip_for_gdm_port(port, false);
-	if (err)
-		return err;
-
+	airoha_set_vip_for_gdm_port(port, false);
 	for (i = 0; i < dev->num_tx_queues; i++)
 		netdev_tx_reset_subqueue(dev, i);
 
-- 
2.53.0



