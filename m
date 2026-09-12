Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F6530568E;
	Sat, 12 Sep 2026 14:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223699; cv=none; b=XNoHY7Zg26bvqOjJ17fxBVyeYIA1TrST8z6KY0pZHoZi9WKIAQzHQUDanf+etZrf9kipmXHG0ePKIwcykJf2umn0iSiZTbgFTdpTuMsMhmXLc5ls0Ca60ziPSRAi7pp+jeiEA3quJIbHPoTc5rXtsZCvB5j/C/GEswpdfcKKUP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223699; c=relaxed/simple;
	bh=K2V+VZ9oAuNYlQTLOeujTjcbUD98muNhc6VoNA0Lw0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWtrGRiy+f2eqUAbD0NP15TcJtqQ02g84lrHxBrTVcvQCRjWYmMVU5b9zrt2N5iN5Q9Q5hkI+gt+EiyjcTCNHEjBQ5XlKFJq3+MrLmALZNkoCRkVUT5YMnH1TRzjpV6bnJcnWuWkXLIhehCP+SHaaHmvwRDlt5lyaJA6swlLPTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtE3IAR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtE3IAR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4091F000FF;
	Sat, 12 Sep 2026 14:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223698;
	bh=bcRTRuYfm78d2jAZivEyr2WfzkLEfv9xSU2uqrFHXi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MtE3IAR/q/d9yHOs6ZdwYoHz0OIhw7VYiZ3B0oYOcsPSWnIQIWA3+tKWyFj1/un6s
	 23HMO+/OCEhpx2geZlIWGJZEkdV7cTLtipWZXqQS31CEd/P3AZ0B0yJ72F9+WT8ZBU
	 6dAL1pHj7nLUuXO16oXbh9Y9AqKU+2w3vxvGSc/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0815/1424] dmaengine: dw-edma: Clear stale requests on termination
Date: Sat, 12 Sep 2026 08:54:07 +0200
Message-ID: <20260912065625.552903348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit c0d9c6275adcca7c0ca5f4270bf88026f9864bd1 ]

terminate_all() can finish immediately when the channel is unconfigured,
paused, idle, or already stopped in hardware. A pending PAUSE request can
survive these paths and block issue_pending() even after termination.

Clear the request whenever termination leaves the channel idle. A running
channel keeps its STOP request until the interrupt handler consumes it.

Fixes: e63d79d1ffcd ("dmaengine: Add Synopsys eDMA IP core driver")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Link: https://patch.msgid.link/20260717180639.2643243-7-den@valinux.co.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/dw-edma/dw-edma-core.c b/drivers/dma/dw-edma/dw-edma-core.c
index 2526dad096332..1fd2dbc5d7178 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -338,6 +338,8 @@ static int dw_edma_device_terminate_all(struct dma_chan *dchan)
 	} else {
 		chan->request = EDMA_REQ_STOP;
 	}
+	if (chan->status == EDMA_ST_IDLE)
+		chan->request = EDMA_REQ_NONE;
 
 	return err;
 }
-- 
2.53.0



