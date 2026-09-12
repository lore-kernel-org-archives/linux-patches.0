Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F79247ACFF;
	Sat, 12 Sep 2026 12:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215788; cv=none; b=LFuY2OkHMT7kvaOywJ17VKfzcA+C4Y1v+RC5lzASabXJGyxA8AvkV2w1HGmMcmoPzjizqxRkALlotAs3iZLSonE8JUbSOTBc+cmZZHm6NgGtzOl1qXs7W0ke1+qG8ZKdIMjBE/+LGiMF4/NOny7ZVqL4FDGCsfwUm2P4Crs/yBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215788; c=relaxed/simple;
	bh=a5C8bo8hgUqqWc5CgPaRWzADufXqR8xmuMDC3ExLEGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cN3cEeWiLbwEgl65pCrvDJERydI7Dr7HHYIVilASE82rMMZDVgka4ZSqNZO9HiGzcHnGtNxdoj6wb8PyhXFBUmgYXYo5xo5bDMI3+unE1vjHbaaEqK7epWd84aqTNp+/HVcMFTN88mZ1Cq+xonOPmsSilEk8MwGstihVoU9nA6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4eW2Y+b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4eW2Y+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE3D1F000FF;
	Sat, 12 Sep 2026 12:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215785;
	bh=d/LfBiZh9K5c97nOtPmH4GtqQonq22DyezkYmYI0P3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4eW2Y+bd8W5/sGoUjmdtz470g1tr3I3rtqt2iIpZ2gBTu/UtqqOgWTIvnUSrqhZf
	 txNNAjspuhCHG5OS6DyFUWc/cbCCRHM5c96b6Ny3aioIXKwvBmw/3LGidG9/KzCyVZ
	 SW0uMjrhgyIwC3y1rima4SpEH6a6Qjy2vMCnXAMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0601/1376] dmaengine: dw-edma: Clear stale requests on termination
Date: Sat, 12 Sep 2026 08:50:27 +0200
Message-ID: <20260912065620.929734816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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



