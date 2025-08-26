Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF71352060;
	Tue, 26 Aug 2025 14:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218564; cv=none; b=G2l6ydbmUuoBXxbjiNlNRgxlqfQiyXnKhj+/PpMW8QxHqli+Y0ta46icsw8fV7TVmuJKH2JnUGA4XNkehhlX4hiZ7wQt86uiPjDbjQTMwROOQ8za+Kwtese3n777qU2y11b73u4y47HdYzaifWyuoNRF2F7qj3NUlXgUVyWSboQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218564; c=relaxed/simple;
	bh=8H2C+UkANpHaCfmq/8yT7wgzwyAGjinqozPhIMX2+gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmy07eoM0EriVrHfoyrseYdwZg/lGLdP4HkXbym3BSfrfnbbP11fDMBYmEe97/CVHp3y3G9BKO7jf9J4MV6TMdxkKC9946EcV87LPYXCYLZaCXlUaw08hbmAP9pbxIHiD7ZJCcQKSY2tsif4FiRMVDc5KKgC8DI3xH+HBja4KR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcyOL7xo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcyOL7xo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6411EC4CEF1;
	Tue, 26 Aug 2025 14:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218564;
	bh=8H2C+UkANpHaCfmq/8yT7wgzwyAGjinqozPhIMX2+gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jcyOL7xocvlrL9wOw9wwAlyJlMr7pZsz2cfBZGNDSDA5gqmnYFKOShA+Xl8rJDHj+
	 DmCnJutDwN/U/EtuCxkMU/XlWC1P5UaSXuJA3qA+XFIy6lCzwTb0d1aPiysYknQx1M
	 3+/iwCwxkd82qgKBSqK7mLBramA1HLPeeSj3uCgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 017/403] mmc: bcm2835: Fix dma_unmap_sg() nents value
Date: Tue, 26 Aug 2025 13:05:43 +0200
Message-ID: <20250826110906.241271742@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 


