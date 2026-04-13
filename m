Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484A632F765;
	Mon, 13 Apr 2026 17:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099723; cv=none; b=bkwMZwKzAwSEq4wQ2zf7IGpX7LetLUAUWH4WOzXn/sPFdMyW4ZXQTK7Lmpb1+8npA2zy3Xi0/vnBON5VpzNsy5pvR6WZA4g1hra9rfg9uqgdLtM/5VmLQEt08uISqYJCe374WZ3C4KxchtGFwpxMg2RTnQxmJ55WWFtdk6smr68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099723; c=relaxed/simple;
	bh=dQmsnGScVXzNOyJJPq8yrx13qcX+L1MuylqPZeILY84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZM0t9/Nt8vO3PVCnerzPj76kcstWqOhY661Y1f1hFpfHzd6D/YDkY9GgboY9fd0UE/w/CHxYi+TktrqGNxGpEXBFFIPrm2p3d7bfenzCGUOsjlUJUDDYuysl7g2MnxR1BTlM2+RBcasWHLfXBIrNY2t8P2DHJ+8/JZ+Tj1ZX6Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMIxvlEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMIxvlEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21B7C2BCAF;
	Mon, 13 Apr 2026 17:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099723;
	bh=dQmsnGScVXzNOyJJPq8yrx13qcX+L1MuylqPZeILY84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMIxvlEKBBBh3KMflEILgVX3k1y8/EopIKtM9OaqOUkB7LL4rDy8NHTZtOAXjDzoZ
	 6YVn5HHD1JvAzZ8SzJT1ZWg3yHFau4dzILA0NSkaBbnlCo1zHCHtQ9d9brbmnT6KGN
	 JPzgj+57SDmjMQnximyYH+Qjtx6p9m444IuBLx+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 448/491] net: altera-tse: fix skb leak on DMA mapping error in tse_start_xmit()
Date: Mon, 13 Apr 2026 18:01:33 +0200
Message-ID: <20260413155835.800803345@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

commit 6dede3967619b5944003227a5d09fdc21ed57d10 upstream.

When dma_map_single() fails in tse_start_xmit(), the function returns
NETDEV_TX_OK without freeing the skb. Since NETDEV_TX_OK tells the
stack the packet was consumed, the skb is never freed, leaking memory
on every DMA mapping failure.

Add dev_kfree_skb_any() before returning to properly free the skb.

Fixes: bbd2190ce96d ("Altera TSE: Add main and header file for Altera Ethernet Driver")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Link: https://patch.msgid.link/20260401211218.279185-1-devnexen@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/altera/altera_tse_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -591,6 +591,7 @@ static netdev_tx_t tse_start_xmit(struct
 				  DMA_TO_DEVICE);
 	if (dma_mapping_error(priv->device, dma_addr)) {
 		netdev_err(priv->dev, "%s: DMA mapping error\n", __func__);
+		dev_kfree_skb_any(skb);
 		ret = NETDEV_TX_OK;
 		goto out;
 	}


