Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046662;
	b=FsT5IqqZzZYj+hl23mNlA+/BhlvyanVeNSFi+lunUMFrLmE5vAcZ4vUCmckOFOJ4K1hj
	 mkvRRjJpmwiuzWlK2xM7fkiRUU6T/C9BCSH/v8uKM2G1+gpzeJ0LAwPV5uCMnt6ggP1V/
	 4Ac/81DoVG3fUvFFrnIvolr/jHy6gv5ZND37DMGvTd8HbLBvZ8/jugLI/iOOPsIVECgUF
	 DYJP5ImtohHxdFhgqI0qAVCn4QUUDlS/FFka6HW8BlBHCQ5docc8oVv4Yu9aVc6vLGt4l
	 GgTtPodBUM/sDcwv/HMzTPRR42vb3ZObiq5JPsoDmQEK/265nD3/p4S40yY5o0a7w7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cEAzHVLtFIDDDFB7O0T0GT4pCWlLVd8/yfm7NZlPoFw=;
	b=Su9ABm9MrN4zIjvHeWFTetp9cJqPBH0mQcJslyr9nSaS5uosd/1nFXMO2nMy1Qj9YCUW
	 1glmrpPO39617pdWnKz/mbpKI9SbhkoaDlMt18VWzF+i9yvO3TksZb1xBkcGJPgVl9Sdd
	 BBgIG/JSS0N5XbyboV1pk5+cT0H6AFOsVp86G+hSsiEQItEMJBInXhorSsZFRIkmigPLA
	 WyxgFLQwtz9ejWJZ3+DosHduGCCN/AGvQ4KDZfcnDZ08DMUVsMjKADsG3tJ9PT25VUgls
	 Y6q3GYNOmLmqzztrQxzxCoJXSYrHU7jBnQFzNIwI4CM9Et2CHN5aLJPd5ie1oj+uYEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gTmnq+tf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CFF606A325;
	Thu, 19 Nov 2026 00:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gTmnq+tf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F871F000C4;
	Thu, 19 Nov 2026 00:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046661;
	bh=cEAzHVLtFIDDDFB7O0T0GT4pCWlLVd8/yfm7NZlPoFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gTmnq+tfk4rjYj6e28qG4SOiREZv/zz1ys8/ZmMMvs0tM3Z0tI9SS7mZIgM9UYBJC
	 C8lGsSnmWwzHXrXxeqKGdLJkUKHt/nGArtccEeCIpHQbtvDb9wh10kDXBPnWtb0+Ay
	 fafpKzbPeCdCoRGQHfXKH5qtVsvrdaLIYIPV+5Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1361/2857] media: microchip-isc: synchronize the IRQ before disabling clocks on stop
Date: Wed, 18 Nov 2026 15:39:55 +0100
Message-ID: <20261118150250.409990049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit 19fa5407da5ef3e605cacfcd90f70d8b2c121cd7 ]

isc_stop_streaming() masks the DMA interrupt and then drops the runtime
PM reference, which disables the ISC clocks. microchip_isc_interrupt()
may still be executing on another CPU at that point; it reads ISC_INTSR
over regmap, and touching the unclocked registers triggers an external
abort.

Store the IRQ number at probe and call synchronize_irq() after masking
the interrupt, before dropping the PM reference.

Fixes: 106267444f12 ("[media] atmel-isc: add the Image Sensor Controller code")
Cc: stable@vger.kernel.org
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: adjusted context for existing Atmel driver names, including isc_interrupt ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-isc-base.c    | 3 +++
 drivers/media/platform/atmel/atmel-isc.h         | 1 +
 drivers/media/platform/atmel/atmel-sama5d2-isc.c | 2 ++
 drivers/media/platform/atmel/atmel-sama7g5-isc.c | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/drivers/media/platform/atmel/atmel-isc-base.c b/drivers/media/platform/atmel/atmel-isc-base.c
index c2939078c205c..7ebd2f1cad9ae 100644
--- a/drivers/media/platform/atmel/atmel-isc-base.c
+++ b/drivers/media/platform/atmel/atmel-isc-base.c
@@ -423,6 +423,9 @@ static void isc_stop_streaming(struct vb2_queue *vq)
 	/* Disable DMA interrupt */
 	regmap_write(isc->regmap, ISC_INTDIS, ISC_INT_DDONE);
 
+	/* let a running IRQ handler finish before the clock is disabled */
+	synchronize_irq(isc->irq);
+
 	pm_runtime_put_sync(isc->dev);
 
 	/* Disable stream on the sub device */
diff --git a/drivers/media/platform/atmel/atmel-isc.h b/drivers/media/platform/atmel/atmel-isc.h
index ff60ba020cb99..7d2e7825cfb00 100644
--- a/drivers/media/platform/atmel/atmel-isc.h
+++ b/drivers/media/platform/atmel/atmel-isc.h
@@ -269,6 +269,7 @@ struct isc_device {
 	u32			dcfg;
 
 	struct device		*dev;
+	int			irq;
 	struct v4l2_device	v4l2_dev;
 	struct video_device	video_dev;
 
diff --git a/drivers/media/platform/atmel/atmel-sama5d2-isc.c b/drivers/media/platform/atmel/atmel-sama5d2-isc.c
index 629bb9ada4698..bbb6b62743eb5 100644
--- a/drivers/media/platform/atmel/atmel-sama5d2-isc.c
+++ b/drivers/media/platform/atmel/atmel-sama5d2-isc.c
@@ -430,6 +430,8 @@ static int atmel_isc_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
+	isc->irq = irq;
+
 	ret = devm_request_irq(dev, irq, isc_interrupt, 0,
 			       "atmel-sama5d2-isc", isc);
 	if (ret < 0) {
diff --git a/drivers/media/platform/atmel/atmel-sama7g5-isc.c b/drivers/media/platform/atmel/atmel-sama7g5-isc.c
index 2da0f7282d015..6fa60310ff45b 100644
--- a/drivers/media/platform/atmel/atmel-sama7g5-isc.c
+++ b/drivers/media/platform/atmel/atmel-sama7g5-isc.c
@@ -419,6 +419,8 @@ static int microchip_xisc_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
+	isc->irq = irq;
+
 	ret = devm_request_irq(dev, irq, isc_interrupt, 0,
 			       "microchip-sama7g5-xisc", isc);
 	if (ret < 0) {
-- 
2.53.0



