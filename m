Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA24E2DC32B;
	Tue, 22 Jul 2025 13:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192451; cv=none; b=g5ldjT9vzl6pjpobk8YjvG8R9nkuvwhhgGmySx6/bOM0wmbBloK/CRK8Qf3A4NX0JSjcftae1oShBM1gf0k6TSzudXWgXgjd0HqZx29W742GLBbtSQOwKDpP7VTtlx/pbJU3jg5LUE+6p40neP66xF6kwbrYmxWFGWbs5S0VJeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192451; c=relaxed/simple;
	bh=WXYg98jXLnoWy1T9kwbMnEF61qzqJ7pLRSDvtWKUSU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uh6MNRg6MtMA6fKFtpUpwOfeshYxivDEUjjVAW5YJaZWLNSdCPsVjfK8L6zlo7L4klyPXzH8yhCjz61jPN7vOE7if1SgnPOs+9YOV6nx6vYyQYER9rN0a7fSdaDh2uEhoey7mPwsasbQTofn1v5bNCZIKswXPZW3BcJeSN5rmAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RV2SLEWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RV2SLEWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAFEC4CEF1;
	Tue, 22 Jul 2025 13:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192451;
	bh=WXYg98jXLnoWy1T9kwbMnEF61qzqJ7pLRSDvtWKUSU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RV2SLEWdJzUAguMphWTMveuKZn49kGljcH3XKaGa2DDRiltEnrkRdannSHH+jIiM9
	 l1p2dnLQXUUdFAfSNoOn93QqBqrrcAGzrm3QpO6KoECjOAWbDlsEDBkmCZyQfYW54H
	 mZUWwTiUw33KjBJ/A+K0UWp0XJWIFiLT39LiToaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 036/111] mmc: bcm2835: Fix dma_unmap_sg() nents value
Date: Tue, 22 Jul 2025 15:44:11 +0200
Message-ID: <20250722134334.749071674@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


