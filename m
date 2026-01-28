Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9451B23E358;
	Wed, 28 Jan 2026 15:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614269; cv=none; b=rzwP8Xm1RPyBvGkGeSdCC+h6WfhFjNmI41dDcRkAN8/vsUeEPVzMYgvIBhLQ4FBGtY7UuoO45JWUEFsD3T/8WpVum6Yi8Cs5qlVAV9hNnb6o6mH8U42Ic1q3WqYp5dspbqjFTaKOcnWiZ4pOdOjfU3RkGtEt+yCr5BcOhFgUxuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614269; c=relaxed/simple;
	bh=hJelbkardNo2xJdDILaiR9ed87y1F6Wz+vtoB55wuoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiuskUgFPYKAz7rdcDu29RhK8XwxdO9UKHZfNRAmuEPl7BAmiogkKWxXBSovmE/RvMHA1bRBjxHKrygN9KXzFA6po0W4lNuUoNTeHvm8E3l2P7EF22cMPMNiq+p4gl+3sh+eCF+Jpmrd+VHwsN0b9N6s6pUamD+xvv9Ed0ElLu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2ce1Na9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2ce1Na9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A609C4CEF1;
	Wed, 28 Jan 2026 15:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614269;
	bh=hJelbkardNo2xJdDILaiR9ed87y1F6Wz+vtoB55wuoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2ce1Na9ePfvW90+Ab7sLHsT0mCn/ZPEK1qhVC2EkOvweoD4/CFigZOm1soBwEXBG
	 l9AqIPS8VfYBFAvBIT4IO0XZAUpK59Hipv/ViKeIKnaCfFEI4EKTXgMIFbABLQcM/x
	 orzQsr/40nm8WF4Uch6KoxjYPx2ktBqoQm4r7kOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 086/254] dmaengine: ti: dma-crossbar: fix device leak on dra7x route allocation
Date: Wed, 28 Jan 2026 16:21:02 +0100
Message-ID: <20260128145347.794711704@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit dc7e44db01fc2498644e3106db3e62a9883a93d5 upstream.

Make sure to drop the reference taken when looking up the crossbar
platform device during dra7x route allocation.

Note that commit 615a4bfc426e ("dmaengine: ti: Add missing put_device in
ti_dra7_xbar_route_allocate") fixed the leak in the error paths but the
reference is still leaking on successful allocation.

Fixes: a074ae38f859 ("dmaengine: Add driver for TI DMA crossbar on DRA7x")
Fixes: 615a4bfc426e ("dmaengine: ti: Add missing put_device in ti_dra7_xbar_route_allocate")
Cc: stable@vger.kernel.org	# 4.2: 615a4bfc426e
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251117161258.10679-14-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ti/dma-crossbar.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma/ti/dma-crossbar.c
+++ b/drivers/dma/ti/dma-crossbar.c
@@ -288,6 +288,8 @@ static void *ti_dra7_xbar_route_allocate
 
 	ti_dra7_xbar_write(xbar->iomem, map->xbar_out, map->xbar_in);
 
+	put_device(&pdev->dev);
+
 	return map;
 }
 


