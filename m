Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D67221D88;
	Thu, 12 Dec 2024 15:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018274; cv=none; b=EpXZ4nJ6c47D24f0sutBLcn9dVrLCm5P8She02EwYezlR+NtT1VsfZotBlUxjDYpZ4VPh+TCTKT9gvNpAo2lGLmZi7uaeZd+QZypgYNhUVBZkrzpJFZbEfXyHYjQ3CCjJqxVKXDih9DdFqZpRWB02dm7/tUlAenSXZUryUyHqS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018274; c=relaxed/simple;
	bh=S14lHRhFsNw24nA/hTkY9HKixPZ/McmjNAaMxoR7Gag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=equEjoFuELa2T7WU1cs1fH3sQjyhvwxxsV4qsNQNZ/AplgdCutHfR+fXWTS1333NhPux8ACV61j3XzQULhculnt3OsL3sNvjFs6312Z9zxs1qS5Kd+IRtniHEybjszqRauN4Qdn2zneTEMNShEB1l5BACqFO38U03S758JH5WyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/rSTk7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/rSTk7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9908C4CECE;
	Thu, 12 Dec 2024 15:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018274;
	bh=S14lHRhFsNw24nA/hTkY9HKixPZ/McmjNAaMxoR7Gag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/rSTk7ZQZKou1MXXFAdAT2VfSXibKuXBE4cHYGkd9v0Ef18Wv8GA9Llt8d43xsoN
	 NbtqkkvMGo8xJ3bVomtTIb4hFxH638QPhHejOOpprDjK7/KwWxxEaoxRK1mPFVudsM
	 i1KZajB8cPX9VHGKh0aWXzZpRmgJnBtAUed7Js8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@seco.com>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 247/356] fsl/fman: Validate cell-index value obtained from Device Tree
Date: Thu, 12 Dec 2024 15:59:26 +0100
Message-ID: <20241212144254.366497858@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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



