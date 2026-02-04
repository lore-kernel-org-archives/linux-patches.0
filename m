Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBD32C21F2;
	Wed,  4 Feb 2026 15:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217636; cv=none; b=dPKtLIAAJSH/q/BmGJAh0QVDNKSXyAxshlLiWvcyMiTJuIVJsMcH+dmUo34tN6toxVtwwdMmCHLnCdWvAgtpgAL+q2Z3U9ltEBsWjoPxknkyBRJNJnIWtfgffm+Lp3qtjtPHtTtFb/t5iRk9TngKKz8ckf1HW8V7RI2djer/c0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217636; c=relaxed/simple;
	bh=SRFdl22lsYmS/l7HRwTyUOqRBRfpsC1Q17vtKQnOBCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkwjoL2Ak94+tyAQJyxu4TOWs3phTe6rsRDaealKE+T+hqOepN270wyo/vo1Civf24sRI0uaFnRHVr2hSpfpNKecNK2iSbuNQxeLe1UD6j1PeuNJ/h6po6tcVA8VZuZBt2wpsFLw94R46MeC46JyRsVoV/8g9aFjtztwz9iI9tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3vqsrmK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3vqsrmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18523C116C6;
	Wed,  4 Feb 2026 15:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217636;
	bh=SRFdl22lsYmS/l7HRwTyUOqRBRfpsC1Q17vtKQnOBCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3vqsrmKTdWaQ61BXbaton/NJQLBMbsXnTP++zO30RJNOi1DCpqmwU8x+b4GGyQar
	 unCipWBFjBYddnKy6OV2b1aCMdjpOVeQMHo2ReZFUHODrAduDwQ5BeZHI1Mke9aTow
	 YDTC8fMfUiP2JdPaII4AY6MeP4eUSK54k8jPNuQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 074/280] dmaengine: ti: dma-crossbar: fix device leak on dra7x route allocation
Date: Wed,  4 Feb 2026 15:37:28 +0100
Message-ID: <20260204143912.318340004@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -287,6 +287,8 @@ static void *ti_dra7_xbar_route_allocate
 
 	ti_dra7_xbar_write(xbar->iomem, map->xbar_out, map->xbar_in);
 
+	put_device(&pdev->dev);
+
 	return map;
 }
 


