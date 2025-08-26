Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DE434AB0D;
	Tue, 26 Aug 2025 14:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217107; cv=none; b=MfbWDHxvW0B9V12HlVuvnZuhblCiBumG6Zot4MzwjDzJTZl+NkehoLTkOKQXlpPKBpXh3jOtMTIUEfO3HkHxStv17W6w3wjwjH+Bqm66aa3aG9rtNx1fgBlH7ebacfHoIYBA+k/45VfhHEQnq7pPWaZmDAB0BrDQ0g/yKqSYDpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217107; c=relaxed/simple;
	bh=PwCL8JlytYqAnqkUsWNiCFUwH4A69rgWpLdNEJpUu7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZ7xlIJNFX+Y8ZO1rUnVLuCdklLZl1dB4CIjMPuYoXuphDlaiFeKRjEd4qAGiH+1T64D0OAA+V2oJQlRd1edkYVdhKX3skn5jnam8juifdjzOTC4dPfyheXt4hWJ/LDhMna+/LFuIrvJAJoMGKG1EnCQs0HvX5oXwpPVtES/cKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tjpFvft4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tjpFvft4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B22C4CEF1;
	Tue, 26 Aug 2025 14:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217107;
	bh=PwCL8JlytYqAnqkUsWNiCFUwH4A69rgWpLdNEJpUu7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjpFvft4CQzeDCHiK/KkCT6CSKZ+c72PfHunhodq5GF7KitfZbfaRGBxY9RKBZUEf
	 1PN8xZVdH2ZyyiWl5ef5nFF5HIJCqaKnmux51jdLJ0jqe5fTp4VzGmabUmwRjP1Ux/
	 S/+15PAvRjyhGjYY9SbxYLDlMvxhxclKi7e1zpdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 019/523] mmc: bcm2835: Fix dma_unmap_sg() nents value
Date: Tue, 26 Aug 2025 13:03:49 +0200
Message-ID: <20250826110925.066704096@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -507,7 +507,8 @@ void bcm2835_prepare_dma(struct bcm2835_
 				       DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 
 	if (!desc) {
-		dma_unmap_sg(dma_chan->device->dev, data->sg, sg_len, dir_data);
+		dma_unmap_sg(dma_chan->device->dev, data->sg, data->sg_len,
+			     dir_data);
 		return;
 	}
 


