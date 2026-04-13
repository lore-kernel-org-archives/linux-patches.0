Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4573090D9;
	Mon, 13 Apr 2026 16:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096295; cv=none; b=O2+WwkFH8Vmx30emJJQaSuwDNoVa9njkBZ2nNyNeUHtzT95RTuc3ny55gIx7SpWEq3sb7etZ/RNiBZjNhQT4F2uxINIQ9l0RuYjMnz0c4T3jGfAipEmNjpYFvuJbACyRpBtXymok31rUgMBKg7RFjMcws3YuBlL5nfCp9updZoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096295; c=relaxed/simple;
	bh=f95cszdhb9Xiif7u6KrZp4kt5VUmc9L99ouzg/x6TFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m64xw5X1QtLEbuohCVxvkolggMLvXkAk98FFD4Bte/WPcqULzGozsqwAC1xsLTm7K6S0V5bYUw+zfpj8l5OWC55gGi6Kt7DlpTQBqZFiWQpkl/HjjirFdK2Tj/pEJc6ydD0v06bPXdeEn9Qq76m+haqqFONvyuYrdGUCXthzWN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHxJrNfj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHxJrNfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A00C2BCB0;
	Mon, 13 Apr 2026 16:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096295;
	bh=f95cszdhb9Xiif7u6KrZp4kt5VUmc9L99ouzg/x6TFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHxJrNfj8he2OG0pt4uythYEqSBFkJmvrOFudqRzrQ4JqeJTkHSIq+OL75l/4HxBZ
	 fOR5Qz8dfessVN4U6xCXl8vHz7EF3AQQQ3GN54iCnu/DcXA+tlB7m7v4nkSpu9Wnfm
	 ryhe1jMnnQ26bF8xJX5rguiiTp0Hjs3qMF+K6M/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 43/86] net: altera-tse: fix skb leak on DMA mapping error in tse_start_xmit()
Date: Mon, 13 Apr 2026 17:59:50 +0200
Message-ID: <20260413155733.174878337@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -572,6 +572,7 @@ static netdev_tx_t tse_start_xmit(struct
 				  DMA_TO_DEVICE);
 	if (dma_mapping_error(priv->device, dma_addr)) {
 		netdev_err(priv->dev, "%s: DMA mapping error\n", __func__);
+		dev_kfree_skb_any(skb);
 		ret = NETDEV_TX_OK;
 		goto out;
 	}


