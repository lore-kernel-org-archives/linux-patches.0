Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1956237754D;
	Wed, 20 May 2026 17:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297008; cv=none; b=aJd6O0oup3QXi7ng2GrogH6Orbydz49wWUewrNxdfBziMoARl1jCmibil+/UWP9fE+MA+fiWnvITaG9OP6EOQjhE/gmBjQYsMg+xX61ZwhLMkdrnhY/BhpUZEq8TQK6WL/UTGrN7C9TD2E1t+PpdhTjjhs4MZro3KUdlgS+GKoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297008; c=relaxed/simple;
	bh=rhl8J+gdFckkB2ASt0QNPyHJcrtnnqS3XWWuY2Xl+n8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bmie4iPxQkENe8bvDqWfvgpkBWP8notVg59Gb3H5Rkv/jyZvVMZVzOi2vKKeR/qcHY+3wyBN23vmoJ9CELVh24laVV2jOS3wYqRV/poF1Dj06k+U5kHiswbbWDB9NaQIeLYxhQzJ8dgiF/v/H3j5eMG5i7nZ+mEa5NXc4QIbbjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=koXyIttP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="koXyIttP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E96F1F000E9;
	Wed, 20 May 2026 17:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297007;
	bh=PN1qVFhplEa7qeCXqbNezYug1dUrbKGmyDCnRB/Tdyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=koXyIttP+wPzMFkJCBnXFAvlNqHIuXeT5EXxAzLgMzIMNtFmR9jM4yv5J3Sufhhen
	 80O+HbSVbc+is1+fSlwFp3sbaBGsRbrhrhw4axefbsr/u5ZpKVJIz52K39KI5x6DQ4
	 hMdZ0TP770plp4zufApNVUssEif4nO+Vn9WRMoCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1016/1146] net: airoha: Do not return err in ndo_stop() callback
Date: Wed, 20 May 2026 18:21:06 +0200
Message-ID: <20260520162211.227031449@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 3e406d880c0cd..83882a8953d25 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -1738,13 +1738,10 @@ static int airoha_dev_stop(struct net_device *dev)
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



