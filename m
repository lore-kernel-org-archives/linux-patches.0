Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D578515961;
	Wed, 30 Sep 2026 16:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786558; cv=none; b=urPVDQzBZ9hiQXs/GSpZkHg8brLjsjRiC0KlW01B32z/a32oW/g+S5uJX7LiwDkGeDrcyzON+YVJtj/kS9ncLz+5SljcCFJptWwdkArv+/8NNIEXgO0TluwHSuTtGdZP+z7grQVNx9tSoHy2A0WZXjj2jylxAkpDZWTHmzXgjws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786558; c=relaxed/simple;
	bh=RpWgqJ4Dp57bNUu+fFbDSdQyEtsOb7dLa1UcWmPMfsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gf5YhoH4wR2nrNiMd7NWquFyOVUrC3xV9EValjlAroK1keRDFrgpRhEYMEZBT7Ug/LK12lK106ElGqToK8z6/5p9SQuUW4JvuVIbwxCqAvsqdXImxT42166CKOiDR8ibw/8lG6+6/ul1bl+h7+NgeNnxWzeNKurOx5dt8LPkLKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZRuFWvz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZRuFWvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D154F1F00898;
	Wed, 30 Sep 2026 16:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786557;
	bh=uJsI+s4nhmPDkGEBFJeDNbHhSj158W6HG0mt0akpP0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZRuFWvzeD74tMfAn0h1tHhgGS8yDCh81UQtraqAjZyTLM6nP9GLCv/Exe6TQLb5k
	 vB1rUTMQ9wgSrAiGO2PZz+VAQ4VE2P0DyuCeBbVJyVsBx5JCYQzXbm6CtwFRtVwJGi
	 KIFV63TqfzY0yEG85KsmtMlJh4Wj44emHNuQF5yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 904/982] net: bcmgenet: mask DMA_TIMEOUT_MASK when reading DMA_RING0_TIMEOUT
Date: Wed, 30 Sep 2026 17:27:20 +0200
Message-ID: <20260930152436.158591152@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit d64e277b955be4506931802837499b62c8f3968a ]

bcmgenet_get_coalesce() reads DMA_RING0_TIMEOUT to calculate
rx_coalesce_usecs without masking out bits outside DMA_TIMEOUT_MASK
(16 bits). If upper bits are non-zero or contain status/flags, the
computed value of rx_coalesce_usecs returned to userspace via ethtool
becomes corrupted.

Mask the register read with DMA_TIMEOUT_MASK before computing the
timeout in microseconds.

Fixes: 4a29645bfe6c ("net: bcmgenet: Implement RX coalescing control knobs")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260921220021.281418-6-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 6b6a3465c07fb..c729da84a19bb 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -837,7 +837,8 @@ static int bcmgenet_get_coalesce(struct net_device *dev,
 	ec->rx_max_coalesced_frames =
 		bcmgenet_rdma_ring_readl(priv, 0, DMA_MBUF_DONE_THRESH);
 	ec->rx_coalesce_usecs =
-		bcmgenet_rdma_readl(priv, DMA_RING0_TIMEOUT) * 8192 / 1000;
+		(bcmgenet_rdma_readl(priv, DMA_RING0_TIMEOUT) &
+		 DMA_TIMEOUT_MASK) * 8192 / 1000;
 
 	for (i = 0; i <= priv->hw_params->rx_queues; i++) {
 		ring = &priv->rx_rings[i];
-- 
2.53.0



