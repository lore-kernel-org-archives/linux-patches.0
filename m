Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A3E1DE4CD;
	Tue, 26 Aug 2025 13:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215401; cv=none; b=UmuFctprl1IddRF8NTUvRXIrKfoYeEEwPcc/tzRdtBf2GlUCC2gH/QA0nK/4LC25gv1wMYsC+YAirMJanSgEKo124rc+GXnZQEoPR4j3NcxJwNH4wzFZzazM2UKJ3rWalnVd/N36XoXhc4tBhm0m+zK6EOzNyir8C+CbEHw/iz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215401; c=relaxed/simple;
	bh=BlYFEzyDVeXDDavbozNKZ0kcr5TbB7ORSJGU2H+1YZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fn+PRCliWKAMWS7Yo08GsB8en7gge0bwSP98xPGyOntJ+4VOsLWHqB2DQWtW+FG8Tj7mvduzL18xCvZfk6fITVdT7QMj7HgQbk6gMtR4xd/Ep88WxG/w/WD8n4dr3I0RrRNqun23h6MOfm7sm3imrJYMdD4/ZQjE8aoLCsbZSyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pgj1w/JM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pgj1w/JM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11A8C4CEF1;
	Tue, 26 Aug 2025 13:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215401;
	bh=BlYFEzyDVeXDDavbozNKZ0kcr5TbB7ORSJGU2H+1YZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pgj1w/JM6kSMxifr4MviolUwZhW50Awy5beskT4w79RiJFfvJNQKrMDWE8gk5HK4f
	 T8Cwz9N6EOnaPhQdRuugn6Ia5kukKvt3X97v9PD9jB+7h/xYhYiB3k8VfAlmYOO4Gs
	 Kiq1TE8Xmb3i+320ew9Ea8q2i/IPj51P++CHNVgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 020/644] mmc: bcm2835: Fix dma_unmap_sg() nents value
Date: Tue, 26 Aug 2025 13:01:51 +0200
Message-ID: <20250826110947.008595559@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


