Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8C32EA16A;
	Tue, 22 Jul 2025 13:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192027; cv=none; b=Pgi/vOxtum8iEMvKQMESjR1mvnpXwe6elzGP0G75AdanO6de2BXRsjwhKscHeyFVemyfOcvOA0EES4W+Pj5ouGFAjiMV29JzX/s6VPVLT2mEH8lhWTdiQnUZQ9s/sC4zrF11uHh8BoeyxALu1iZUKj/2fhq7XypHkHgE0BihQRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192027; c=relaxed/simple;
	bh=R9Zn5D5B9HUmqwGTgWxWHNDvDzFO5BobPVOAFHRO1mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzYCwB/vfucSu9E8vvqbVGp14I0GnfcH0KNazZYT+ISZbGcdfAHNHyV0MWDL+mvokKz/daLcIzdQUlVpjkSTV/19jxj9IvH1Kzs9eLVV2rnNYZ5GCfcc/ACoqyWKNjGM6L0hvgtb73TBQS4GCdUl6n7rOQ06P7xCdhGt+6QUvaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Da8W0J9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Da8W0J9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7788C4CEEB;
	Tue, 22 Jul 2025 13:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192027;
	bh=R9Zn5D5B9HUmqwGTgWxWHNDvDzFO5BobPVOAFHRO1mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Da8W0J9GzOUOQ21fu9tMzi5STUkp6sn57M2S6ysz5F7Keo/GfOX1QIAu2tVKjbybk
	 gRqPNyQHtSGtu0i5boGIPfHfK9vmkNMx93sFMLyRszvSVBU2L3sqktMjUJAOCMMrX3
	 KWAhRlQ8sKZ+bhfzfn83VyGiyl6TP2hPqc2z1C3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 23/79] mmc: bcm2835: Fix dma_unmap_sg() nents value
Date: Tue, 22 Jul 2025 15:44:19 +0200
Message-ID: <20250722134329.228682822@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


