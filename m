Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243082AF0E;
	Thu, 12 Dec 2024 15:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016912; cv=none; b=WdmUWM96SR7KR2wCkGyhf3reyGN+ncxCWiIKGJkEjcdiiKeVcSZKCsQBgahxV/yPnV+PQkSxVZxH/y4iWmA8dk1pOz45SFrE+mAXKriYDGEmarRzHVTdaXHaXbrznk7245LWRQD4cBcSKj6uzo6tQjQBUSujKFnNO5o1yS5o2J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016912; c=relaxed/simple;
	bh=HGxTVeraG11XzHhT/zkkLuWkvFsClO5muHpMjG5UIFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQqd4wpGshjyfAW4K7qYif2X1Up+jwQ38hSelu7O8wMLSRwrFo9L8AhOwe3WVZWAzQA07TFCPzJOVnQnlcIfCabzIidxcS5k9w9ZT/F+cvKLmqcGsHW2TGXsj/2SV3oRrxdCd4d2RgBW2WGvr2NiKvneo2OFt8heltPGz2aiIn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfpiSB90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfpiSB90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDA7C4CECE;
	Thu, 12 Dec 2024 15:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016912;
	bh=HGxTVeraG11XzHhT/zkkLuWkvFsClO5muHpMjG5UIFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfpiSB90LaFhSdv/IgJRRWLuyeqDqJ8qS5y1liENIYHgbuS7sCYjTs0hCF1n93fPl
	 +WRIWmGnKlKrK039vcgqnEk2YrxXIRC37MIKoFn9p8Zx01RInP/1hYUAIloN0hJ5sO
	 RVW4+vr5Yg5qj7gFWGngMQfAZxIOGaOKoscn8ExI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@seco.com>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 323/466] fsl/fman: Validate cell-index value obtained from Device Tree
Date: Thu, 12 Dec 2024 15:58:12 +0100
Message-ID: <20241212144319.555901164@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit bd50c4125c98bd1a86f8e514872159700a9c678c ]

Cell-index value is obtained from Device Tree and then used to calculate
the index for accessing arrays port_mfl[], mac_mfl[] and intr_mng[].
In case of broken DT due to any error cell-index can contain any value
and it is possible to go beyond the array boundaries which can lead
at least to memory corruption.

Validate cell-index value obtained from Device Tree.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Reviewed-by: Sean Anderson <sean.anderson@seco.com>
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Link: https://patch.msgid.link/20241028065824.15452-1-amishin@t-argos.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fman/fman.c | 1 -
 drivers/net/ethernet/freescale/fman/fman.h | 3 +++
 drivers/net/ethernet/freescale/fman/mac.c  | 5 +++++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman.c b/drivers/net/ethernet/freescale/fman/fman.c
index d96028f01770c..fb416d60dcd72 100644
--- a/drivers/net/ethernet/freescale/fman/fman.c
+++ b/drivers/net/ethernet/freescale/fman/fman.c
@@ -24,7 +24,6 @@
 
 /* General defines */
 #define FMAN_LIODN_TBL			64	/* size of LIODN table */
-#define MAX_NUM_OF_MACS			10
 #define FM_NUM_OF_FMAN_CTRL_EVENT_REGS	4
 #define BASE_RX_PORTID			0x08
 #define BASE_TX_PORTID			0x28
diff --git a/drivers/net/ethernet/freescale/fman/fman.h b/drivers/net/ethernet/freescale/fman/fman.h
index 2ea575a46675b..74eb62eba0d7f 100644
--- a/drivers/net/ethernet/freescale/fman/fman.h
+++ b/drivers/net/ethernet/freescale/fman/fman.h
@@ -74,6 +74,9 @@
 #define BM_MAX_NUM_OF_POOLS		64 /* Buffers pools */
 #define FMAN_PORT_MAX_EXT_POOLS_NUM	8  /* External BM pools per Rx port */
 
+/* General defines */
+#define MAX_NUM_OF_MACS			10
+
 struct fman; /* FMan data */
 
 /* Enum for defining port types */
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 11da139082e1b..1916a2ac48b9f 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -259,6 +259,11 @@ static int mac_probe(struct platform_device *_of_dev)
 		err = -EINVAL;
 		goto _return_dev_put;
 	}
+	if (val >= MAX_NUM_OF_MACS) {
+		dev_err(dev, "cell-index value is too big for %pOF\n", mac_node);
+		err = -EINVAL;
+		goto _return_dev_put;
+	}
 	priv->cell_index = (u8)val;
 
 	/* Get the MAC address */
-- 
2.43.0



