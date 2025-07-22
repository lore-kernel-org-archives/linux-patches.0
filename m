Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0637DA32;
	Tue, 22 Jul 2025 14:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193356; cv=none; b=b8SJsFczfHUhJIrt16XINJhBZkh0f+tRRFZeR62eCUfCeqW+6dxKIm0kXyfJ4+24oPZnYK0PUcEpWxZ8KavsE2/NJoS8LGY/WVgOHCdge7jRky3+7PrUseYGKh1a+bhSGf1+pD0KDUntct4Psw8nInDbdDC8rMBwQkFJQaUfRps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193356; c=relaxed/simple;
	bh=SCheFc+i5xffdHKEW0jAy+WHWH/wEpf+aRQ8TMVFURc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4LvVUOckkHzrB+DMX3+OCBJPY/I2yGTk7g0vytRO4O50byskE4QHtnobt4IOuzNZMjgbAtOIRIVZ4B2NXjfKMHWn2u/V8PfiL1reqX+hQ1aKe96l+tI3WC52lQ0jrNqK6nqvIkm82uaRWvXUH8YDyUFbIMcMRolBOFlfb7neDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IK38GTRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IK38GTRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7862DC4CEEB;
	Tue, 22 Jul 2025 14:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193355;
	bh=SCheFc+i5xffdHKEW0jAy+WHWH/wEpf+aRQ8TMVFURc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IK38GTRaMj1VArCxqSPB+Angs5ZXM+FqqsOqLgbti6A+I76IHm2p8QHDNyjlPhHMF
	 hl/ehPQj3dULSacERW9dRhAwWZf0zx5dy6twgWRqlLWgaLwFE3HuUCfoZpdLRTYViG
	 IH2+kg1f6ePaOuv7HUkPkn/Ze3oKkxam3oXojwHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.15 065/187] mmc: bcm2835: Fix dma_unmap_sg() nents value
Date: Tue, 22 Jul 2025 15:43:55 +0200
Message-ID: <20250722134348.169575160@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -503,7 +503,8 @@ void bcm2835_prepare_dma(struct bcm2835_
 				       DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 
 	if (!desc) {
-		dma_unmap_sg(dma_chan->device->dev, data->sg, sg_len, dir_data);
+		dma_unmap_sg(dma_chan->device->dev, data->sg, data->sg_len,
+			     dir_data);
 		return;
 	}
 


