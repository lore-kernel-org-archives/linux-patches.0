Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2700D12C46E;
	Tue, 30 Apr 2024 11:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475414; cv=none; b=hLtch0u9x9VE+4DBFrbO5XFvMo4/ndI7GoZ7fypLWlK+ir67vwQ4lAtEVrxOYYrbb6t2txF6UuHu0mAk7MI9/wgaBo2FBS0K+HA9ksG2OCObBp6Kt7N7ITBNATzNJtynMRhF8ePUg0lZzn/x/DjR1oNikJXQb1EePtPCsjLXQT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475414; c=relaxed/simple;
	bh=X5ozm7nw+7sCi/XqNl1WqpacrqUoihbfuzfmA+0C1G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYYnVD/CgSaF2x+X1piKf34fP5xvn+Rp5WNZk13skthwjmemTlTeWsA7Rzasfk53+uhjaZINoqLSUAFONfyMtms+vt+yvL11MAlkWfD0qts5GUe6BcwevD0bo6d/ndIyUpX2gKNu6N0kIDg3D3m50jk80UmfiOIjwQui05XbGo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1qpJb3uZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qpJb3uZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4409C2BBFC;
	Tue, 30 Apr 2024 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475414;
	bh=X5ozm7nw+7sCi/XqNl1WqpacrqUoihbfuzfmA+0C1G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1qpJb3uZDpc3OIkcDW7BLgKWZ092rQ3cbLrI8YqJ3GI4RI1w6ukknik38xhHAitI4
	 mddFz+j2Djly2bP27JWS+LTA4KcTwU8R1FYZOYuxZF8ca+SJTKsT7SoHdPf+SkasSa
	 iUVUAh91Cno3cFSk3DfHSlxOJpgmmdFIZmrkXDLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Roger Quadros <rogerq@kernel.org>,
	MD Danish Anwar <danishanwar@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/186] net: ti: icssg-prueth: Fix signedness bug in prueth_init_rx_chns()
Date: Tue, 30 Apr 2024 12:39:00 +0200
Message-ID: <20240430103100.587928278@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 4dcd0e83ea1d1df9b2e0174a6d3e795b3477d64e ]

The rx_chn->irq[] array is unsigned int but it should be signed for the
error handling to work.  Also if k3_udma_glue_rx_get_irq() returns zero
then we should return -ENXIO instead of success.

Fixes: 128d5874c082 ("net: ti: icssg-prueth: Add ICSSG ethernet driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Reviewed-by: MD Danish Anwar <danishanwar@ti.com>
Link: https://lore.kernel.org/r/05282415-e7f4-42f3-99f8-32fde8f30936@moroto.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_prueth.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_prueth.c b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
index c09ecb3da7723..925044c16c6ae 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
@@ -421,12 +421,14 @@ static int prueth_init_rx_chns(struct prueth_emac *emac,
 		if (!i)
 			fdqring_id = k3_udma_glue_rx_flow_get_fdq_id(rx_chn->rx_chn,
 								     i);
-		rx_chn->irq[i] = k3_udma_glue_rx_get_irq(rx_chn->rx_chn, i);
-		if (rx_chn->irq[i] <= 0) {
-			ret = rx_chn->irq[i];
+		ret = k3_udma_glue_rx_get_irq(rx_chn->rx_chn, i);
+		if (ret <= 0) {
+			if (!ret)
+				ret = -ENXIO;
 			netdev_err(ndev, "Failed to get rx dma irq");
 			goto fail;
 		}
+		rx_chn->irq[i] = ret;
 	}
 
 	return 0;
-- 
2.43.0



