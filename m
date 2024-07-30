Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5809E1A76B7;
	Tue, 30 Jul 2024 17:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359664; cv=none; b=D/fjfav+6uz6ugG4paht7oAkGOb835z9/Oi/xNDwTRl2hZ95E++lcQ+DXXebLrhSPb8yVrbpzj3T1p67FhkbjgeGHnyaSuJCM0Krp8tij9UOD7v4VFcEGVHGJ4uc+jMYA0Xg4QwHR2YTj7XOCO8pdw3sKyaWa8TfejFoM41cSrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359664; c=relaxed/simple;
	bh=r+N9EOuiIx77UOvE9Rd/vnWdnFfyN9NMJoMbH9elISk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iV7JRArrXUyfVkQqcJEnZYzVTZxN+1l+20FTcRsPSPWOgfCwdYQhNbM/2PFkojel4mqqI+4l0tpKV2IpJF5/CT2EgjwsfQRzbSRp7xufRD38SEsKIX4DwqI9I+kXaBR+tViO5/aCP83LvQquMnF8E2lQwnzCt48nROhh3qzS/o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmoHMWdj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmoHMWdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0876C32782;
	Tue, 30 Jul 2024 17:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359664;
	bh=r+N9EOuiIx77UOvE9Rd/vnWdnFfyN9NMJoMbH9elISk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmoHMWdjEWEHHstsCMY8VjP9rM+U5YXkmrCs726icUB5g0Zbev+/qh4gmYgLrN4eZ
	 XlGLLrVgt0T9tkP0qmE3qFMhgS837ax+BuUTkvQl0zrSWNOpDAe0IXZTfUCKTtBYBL
	 Ymdh2RJ8Q/FVIu6Cq65wDDgzLZhxbNQ7XIpFSjJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Jai Luthra <j-luthra@ti.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 519/568] dmaengine: ti: k3-udma: Fix BCHAN count with UHC and HC channels
Date: Tue, 30 Jul 2024 17:50:26 +0200
Message-ID: <20240730151700.442372981@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit 372f8b3621294173f539b32976e41e6e12f5decf ]

Unlike other channel counts in CAPx registers, BCDMA BCHAN CNT doesn't
include UHC and HC BC channels. So include them explicitly to arrive at
total BC channel in the instance.

Fixes: 8844898028d4 ("dmaengine: ti: k3-udma: Add support for BCDMA channel TPL handling")
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Tested-by: Jayesh Choudhary <j-choudhary@ti.com>
Link: https://lore.kernel.org/r/20240607-bcdma_chan_cnt-v2-1-bf1a55529d91@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index 037f1408e7983..02a1ab04f498e 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -4470,7 +4470,9 @@ static int udma_get_mmrs(struct platform_device *pdev, struct udma_dev *ud)
 		ud->rchan_cnt = UDMA_CAP2_RCHAN_CNT(cap2);
 		break;
 	case DMA_TYPE_BCDMA:
-		ud->bchan_cnt = BCDMA_CAP2_BCHAN_CNT(cap2);
+		ud->bchan_cnt = BCDMA_CAP2_BCHAN_CNT(cap2) +
+				BCDMA_CAP3_HBCHAN_CNT(cap3) +
+				BCDMA_CAP3_UBCHAN_CNT(cap3);
 		ud->tchan_cnt = BCDMA_CAP2_TCHAN_CNT(cap2);
 		ud->rchan_cnt = BCDMA_CAP2_RCHAN_CNT(cap2);
 		ud->rflow_cnt = ud->rchan_cnt;
-- 
2.43.0



