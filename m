Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4F77263D;
	Tue, 22 Jul 2025 13:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192782; cv=none; b=bHjsiGAZOAcZpqwgHJq3HcE0dWmWZ7lyISttp0ziVCLkX9QoTV635hRxxzX1/HGKILx6Tv/sya5e0MRHITFKPBf1M9w/3ZNaTG4p9U24lz1nY0AOkZf0dxTIhe+z47CeknXZbUo3crhVJEkbDq2B3QWnjDHloW8InsDA9aJwJvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192782; c=relaxed/simple;
	bh=iwtGz6xFsWaCoBoFqdf9kTyL86aI9Y683ikCQBKcau8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzOY19OJGWtawcHV/JkR+U1QNS1HMBsA8wiPCTq/V/+0ULEPjE+p+7pSOlxMsYJhYedJ/WyzptKeLUmkcUjyUVeZsVeJUlix96AaTUxy86gEYI2r9Sun+GoaqJxjDCf55HPLQPGwjmrmqwEmxFUaCTbNYbqp2XHmC/mJkd1ufCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKty+S1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKty+S1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F404C4CEEB;
	Tue, 22 Jul 2025 13:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192781;
	bh=iwtGz6xFsWaCoBoFqdf9kTyL86aI9Y683ikCQBKcau8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKty+S1dH6Zd8pp3jyEOr1BMMZdaml96is3q/RWUFZHhy/xUYuvCKFsLdQguMMKxs
	 0GSmtV+nhvkRkV1jEVzvrdtuk/8XOGeAyxrP/XWdp1Qc1ILFuR1ErjLu+NlUqaZN9Z
	 j+Ip22wmmOyewbTmVGZHaK9ap+Aeso3jSV62Dx+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 055/158] mmc: bcm2835: Fix dma_unmap_sg() nents value
Date: Tue, 22 Jul 2025 15:43:59 +0200
Message-ID: <20250722134342.789504159@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thomas Fourier <fourier.thomas@gmail.com>

commit ff09b71bf9daeca4f21d6e5e449641c9fad75b53 upstream.

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: 2f5da678351f ("mmc: bcm2835: Properly handle dmaengine_prep_slave_sg")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250630093510.82871-2-fourier.thomas@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/bcm2835.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/bcm2835.c
+++ b/drivers/mmc/host/bcm2835.c
@@ -502,7 +502,8 @@ void bcm2835_prepare_dma(struct bcm2835_
 				       DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 
 	if (!desc) {
-		dma_unmap_sg(dma_chan->device->dev, data->sg, sg_len, dir_data);
+		dma_unmap_sg(dma_chan->device->dev, data->sg, data->sg_len,
+			     dir_data);
 		return;
 	}
 


