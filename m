Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C9036A377;
	Sat, 12 Sep 2026 16:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229809; cv=none; b=i/A3fYPK8Vdh7Gg7SIQ5rHE2POGtGlsLbLwcQFPwbGPhFZNxy712jO9tg7XZNrbUnkcx8HMxFAGpnyZGrOTCJbQ+weiIbEZsFeBCpxITQi2ZtTwDTT/GAfhg4MV9624Q2WKKOtIKzKCJDVxr8bYYy+nt0Ynpo7vFMR+Yd6+anbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229809; c=relaxed/simple;
	bh=D2QitbzoR0ff/9XEZW/nKkN9o4ndSF3ihEeW72L2s7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzQhLtkDvp542Nq7UURuhKCrNkf3V9/gb9qswKdE/0W596awRwzcpltgPETNUCkuHtifKtqGbZWjDArqBUxp9K7hnWY61/OoCDA3VndVCkm35LxOzYJcIrBCUCuuAeLcJYCcW9mTpQQDQ/6NKLNGRY2W403CaCErMN8fAi9bmLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ny4BaaFX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ny4BaaFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334991F00898;
	Sat, 12 Sep 2026 16:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229806;
	bh=ye2Xfc89NG1/PU7XVtlJ4TuLG+Y55a+lxo9wCZWc7gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ny4BaaFX7THOJgPOXXs29Sxaifdw4ZlS7GwFn5PPOahpN3iq/OxOw5xilSFDUGhPb
	 8fJ/2Zg3TmO/V6zRaPVBa6c8Ziq3a3Q9uOmaA3Jn2bUc89qA8FBk87v/i0FK4RRkMP
	 NcCplCugqU/qgMi4kq+NoX4/d6JkvlEvGk7CkoVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0665/1191] dmaengine: dw-edma: Clear stale requests on termination
Date: Sat, 12 Sep 2026 08:56:33 +0200
Message-ID: <20260912065603.193594119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index c687b7f7e5105..e68cb0ea76977 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -275,6 +275,8 @@ static int dw_edma_device_terminate_all(struct dma_chan *dchan)
 	} else {
 		chan->request = EDMA_REQ_STOP;
 	}
+	if (chan->status == EDMA_ST_IDLE)
+		chan->request = EDMA_REQ_NONE;
 
 	return err;
 }
-- 
2.53.0



