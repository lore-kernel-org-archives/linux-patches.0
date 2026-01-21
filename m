Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E827123AB98;
	Wed, 21 Jan 2026 18:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019830; cv=none; b=lDl6dDt/1bMYhKKU6YqYOg5Y9xaq6HFKr3W4w7jHyOdZIqiLOd9qeLZLAngsVGp2xi6PEGBfbOo8y9ykB9Kp5GdPcO95DTKbVJG34Lh0iCSFUbct8sSXx6w08Tpk9Yv2/ShaITImAplXhp/WPkZelqUZ90CsxjC90hGtzWFRf6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019830; c=relaxed/simple;
	bh=Jnwrns+idDmj0xMB70oOgi1ER1Q1LHt1O3qCnErZ6Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTKCOHIyR11pMt0e7bsIoTmreERw0eh40CBmoBkAld587N80mHAR4n8U+e1RBHFuLGm3j0a9RZ5s8cFc4xmzluKD0aW/bC+lprF/ZWicvTCibHMskJx6YKz1RmnYQBOLXdfZEDH+05V51jRsr5dZ5ouvHtiagxyKphDGgq4tn/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQaYGOel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQaYGOel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C64C4CEF1;
	Wed, 21 Jan 2026 18:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019829;
	bh=Jnwrns+idDmj0xMB70oOgi1ER1Q1LHt1O3qCnErZ6Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQaYGOelJFbkttFHPRwQFRpWi8y8EyPEgg5WcL1zPBMCFdsPhgRf3yP6tECEjsu3T
	 WdkEs4tu8aDUJhKriMePp4roOGTCsAJXd8g1WkJo8Tv6CLR+62Z5JsCUTQ7d9yju9A
	 WjioDkKfSm4jpaHMFVJMbBxSbssbPd3NFfAnZqRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 119/139] dmaengine: ti: dma-crossbar: fix device leak on dra7x route allocation
Date: Wed, 21 Jan 2026 19:16:07 +0100
Message-ID: <20260121181415.734927251@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


