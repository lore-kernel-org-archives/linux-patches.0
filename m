Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5433B19DB;
	Sat, 12 Sep 2026 18:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238934; cv=none; b=Xd2gvXcAFyRQYAOISPOZ+lUcwFx0O9qGLfL/sYVIsq967TV59dxoo8Wabt0BWVGkSRWIvWNDp+rtVasyXc+sHKB0rhykkMxqIMQmLmbmddCHfLbB69zp4XCOgmhJ6ph1EbDMLOjwOCI9V0oeTh+XfCBtmFxY5HG4uUIRA8Zz6ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238934; c=relaxed/simple;
	bh=VWxWo8x0pts4MLDN4mXlEk0NDHWviHs4/8va7ELdSK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbbFGQH2mOkQ01kJ6M3zKOeXXUrfR5eZmEQKNlB7TK/VNY1TYDDudNGvTv5qc+D+ZzFvdXGajNTyiLo/kttGIC5Y2Z7V7xCAsIufRvdX52pKZn6Dn5hiBzn/XsNKLn/T+03zzPxa6lBgVthmhgkb8Fxb3jAm6tIQitMdHxNzL2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1qNkzR9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1qNkzR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058621F000FF;
	Sat, 12 Sep 2026 18:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238931;
	bh=D4nuhhmDV8WID2xmon0OSwFC00fUtXcjS7CU7ruJ0Ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1qNkzR93lgrcwyqgFN6tI48qxnTt1rfFsKHGe8ke+OCxxy+ONdazXj5vPBeGmAsN
	 gK0C8lgmj6kfMh3Ae42In5Flq/MAUnBq4DKcebtUh4qlj48kj1nfaRRlKcY+R47Ote
	 YPX4A8DYCA+sFg+0QCur36tUUtQU49h2mve6070I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 562/935] dmaengine: dw-edma: Clear stale requests on termination
Date: Sat, 12 Sep 2026 08:59:52 +0200
Message-ID: <20260912065539.721755880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4e3402e1e99f2..b6ebbc210682c 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -277,6 +277,8 @@ static int dw_edma_device_terminate_all(struct dma_chan *dchan)
 	} else {
 		chan->request = EDMA_REQ_STOP;
 	}
+	if (chan->status == EDMA_ST_IDLE)
+		chan->request = EDMA_REQ_NONE;
 
 	return err;
 }
-- 
2.53.0



