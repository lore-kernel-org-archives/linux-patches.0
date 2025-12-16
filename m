Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1970A3314B4;
	Tue, 16 Dec 2025 11:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884952; cv=none; b=c9Ju47/XV0+UYOE37yPFz6j2eDyyI+tb60wVRyPZ+raY4ty4u/aGgpBptvDiG2uhJlihp5ZkqySuT6CLx+VEE9hAGIyYnQw1wzUyRAHpIPVbPyCgTY4V/mAwdY6Dl21WZaDh58FdkqijVtL6Qwx4ZlpT5wz9So9uNM58FKK8gvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884952; c=relaxed/simple;
	bh=JkkmDVwlnvDCcBMDhnP9SCp3QVu7CJLgpWFrSvoqcKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InPTeq4mLfZTIzZVXm+BBjINxNIe7ZyaAt+nYut32QWLchQ7uN1JbCLCnHLBLDo7OuIU84/iTXzbgqCbG777+SqNFIL7v2l8bep+jD5GjTFERD9z/8U2qqzYg80QheX/Q6JrI3wc6oytnrAPi5JLOf9nkq7O44xvRPJksLJPdHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhvpHs9M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhvpHs9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B75FC4CEF1;
	Tue, 16 Dec 2025 11:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884952;
	bh=JkkmDVwlnvDCcBMDhnP9SCp3QVu7CJLgpWFrSvoqcKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UhvpHs9M99vGH5ddMvKBxCOiQj/tmYt2bs7/sB44GdBrKS64LkXnG7aZOxtSTWYKh
	 usTXjdTmgzsAcCAfxgxyBRWaoP0b/B9itrOxztjjUWIHYM7K9EU5LVN76BP7QJ6pmz
	 JjMVR404n5zmE8dKV3hWx83811I2EYjgNRMfCeX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Zhang, Liyin(CN)" <Liyin.Zhang.CN@windriver.com>,
	Thangaraj Samynathan <thangaraj.s@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 347/354] net: lan743x: Allocate rings outside ZONE_DMA
Date: Tue, 16 Dec 2025 12:15:14 +0100
Message-ID: <20251216111333.478696343@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thangaraj Samynathan <thangaraj.s@microchip.com>

commit 8a8f3f4991761a70834fe6719d09e9fd338a766e upstream.

The driver allocates ring elements using GFP_DMA flags. There is
no dependency from LAN743x hardware on memory allocation should be
in DMA_ZONE. Hence modifying the flags to use only GFP_ATOMIC. This
is consistent with other callers of lan743x_rx_init_ring_element().

Reported-by: Zhang, Liyin(CN) <Liyin.Zhang.CN@windriver.com>
Signed-off-by: Thangaraj Samynathan <thangaraj.s@microchip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250415044509.6695-1-thangaraj.s@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2494,8 +2494,7 @@ static int lan743x_rx_process_buffer(str
 
 	/* save existing skb, allocate new skb and map to dma */
 	skb = buffer_info->skb;
-	if (lan743x_rx_init_ring_element(rx, rx->last_head,
-					 GFP_ATOMIC | GFP_DMA)) {
+	if (lan743x_rx_init_ring_element(rx, rx->last_head, GFP_ATOMIC)) {
 		/* failed to allocate next skb.
 		 * Memory is very low.
 		 * Drop this packet and reuse buffer.


