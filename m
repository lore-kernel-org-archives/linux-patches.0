Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A522548549;
	Wed,  9 Sep 2026 14:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964094; cv=none; b=TQaoDHlBMzOZJn0nkTwsHcb3KPFoFXronsLBOmWxKb2Ct5yXXy+PbiowYfm/FwxfOLcgubyAyPdpRFwlvCsGia+pxMAsgcEkHRScVfYvhwSUkNM8VlE5zJtbV51Q13j7THXOanR9y1QlbtuP6CBAcdh/M7zP0j9oN8mvk8w/cds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964094; c=relaxed/simple;
	bh=I1Z+QEm03JbHWUznLmIQtmk8XReBQOWX2sXIjwLj9oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULv/LtuyuQ0nRGTIFZbJ4Kf6sn+QvcBXMFMuvefTbaeCedM4esZx/R6NMScxdJKomtn5I479xNjhQKauTpMBrMWmVuR+12JEhKSvK/WUrOYeLZRLvK8vakyf38gezZCO+igY4P41ArMjQ3JyratNvZNUWlp3lGt+7o3dFFQdflo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpCf08Jn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpCf08Jn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D731F00A3A;
	Wed,  9 Sep 2026 14:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964092;
	bh=3bszTvVlGY8AbBqnqxT4vwuPGKYr7l8uxmPul7asNKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KpCf08JnnZVxU9Lj6QHB0J3cu2tQgnVJoRb4hhu8Dq5+Dg8G6dMV+KaOJQQp77ElY
	 0WF+oVtjS1h1SwORRkqDEe8pbzfVTJIoSy11z5WXCKgmMe+/EZUc549o05/E+80L9F
	 R1RSocsAKxWslLTb3xnG+mVR/ZXGVymol5W9UHT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Narasimharao Vadlamudi <ahmisaranrao@gmail.com>,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 303/583] media: rkvdec: Propagate platform_get_irq() errors
Date: Wed,  9 Sep 2026 15:39:48 +0200
Message-ID: <20260909134248.521178212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>

commit c37aca64206fafe938119e801a3fd10a537a051f upstream.

platform_get_irq() returns a positive IRQ number on success and a
negative error code on failure. It no longer returns zero. The driver
currently returns -ENXIO for all failures, which loses useful errors
such as -EPROBE_DEFER.

Return the error from platform_get_irq() directly.

Fixes: cd33c830448b ("media: rkvdec: Add the rkvdec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Narasimharao Vadlamudi <ahmisaranrao@gmail.com>
Reviewed-by: Detlev Casanova <detlev.casanova@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/rockchip/rkvdec/rkvdec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/rockchip/rkvdec/rkvdec.c
+++ b/drivers/media/platform/rockchip/rkvdec/rkvdec.c
@@ -1160,8 +1160,8 @@ static int rkvdec_probe(struct platform_
 	vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0)
-		return -ENXIO;
+	if (irq < 0)
+		return irq;
 
 	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 					rkvdec_irq_handler, IRQF_ONESHOT,


