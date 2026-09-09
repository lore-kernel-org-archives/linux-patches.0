Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73846563FA1;
	Wed,  9 Sep 2026 14:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962764; cv=none; b=R8WB2WKMLbpOYHoczcK94HaYNyEzb6sCdV/GdCuT7Rd3CpfnSYR1wRJQDcatabpPq82qIr8dOWkWnvorgkzU01SQByqbS6PzS5lod91EVuT1TWckosaouNoQUL4O1QJB6aqlJITyWlO6FdEd8Eznu3Yuk1RIt9l6O/74DQNMxXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962764; c=relaxed/simple;
	bh=rqZekxxqqWq5BWib/g7/BUzgoZLHO1I2LeO93fJkqSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GalsZ9MGQ16S4w68p4JdrHiMgLjfxdktrBElZmqaqnTo+Y4pb8R7jCvULHTzDa0wt6KQZYpDbcj4YiHPj/mhmzTVFf0d4R6Jpj233QE/tAowae6TAkV6kIEVbSfTKJCmVCffMVkhjUt/9SAIe5E0Ry+1Q2P1t33+6rw2q6Xdb7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfVZrchc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfVZrchc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B64F1F00A3A;
	Wed,  9 Sep 2026 14:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962763;
	bh=ZYHEIb+niLg20mH6D9vQEUTSiqx9DYpb1zAb1rnDsvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jfVZrchcNJRtoS5oezh6L1vCItxVHa2fFJnc5H5Lt6Zmt2QHAF4aVLd0fU4jBOK6E
	 RJf0mr4z50kscmnMOu0XqUH2VcIycC/9c5e5rhNe6t8/097YzLBTcnviS8jYj+aKuk
	 cFSY6pcTbfH9FslSH6rM9thwqMInUdKU4Ji9ZOGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Narasimharao Vadlamudi <ahmisaranrao@gmail.com>,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 386/556] media: rkvdec: Propagate platform_get_irq() errors
Date: Wed,  9 Sep 2026 15:41:06 +0200
Message-ID: <20260909134244.252484907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1818,8 +1818,8 @@ static int rkvdec_probe(struct platform_
 	vb2_dma_contig_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0)
-		return -ENXIO;
+	if (irq < 0)
+		return irq;
 
 	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 					rkvdec_irq_handler, IRQF_ONESHOT,


