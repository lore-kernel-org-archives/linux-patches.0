Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4D9246BCD;
	Sat, 12 Sep 2026 10:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207738; cv=none; b=LWit6r0D756fRTmwnGa+EUtzdj84UjslfzzGtXK0NaqAmDqpjkxEFS6IxlnXz6RaLAL2BhaaghynwUCQnmMQdkfQFi8np9aDOslO/TIe1ciO4UxmGzFBlzgBB2UQJrmrHfbx4t0Lgoon6N5b5ZAWyLpms+b293A6p5ylT3OxEtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207738; c=relaxed/simple;
	bh=//qj1GKpbwKIF3+EzYjoW1rjjTM4oMbp4x4ltIk5ykA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4Jaxu3WB34eo4fY3mGqukyZdJCkc/0Z/m3KOHJgLD9MrHdecHGG68SiTBePTh4tZhN0dbGaLUJ5DuxujYXLNrd6bTzeb9FIdCpDN2uYtJJpRAF9a/oy7yiOAs4/K32YD2lgpRdCkrceBCHRs1AFGWkRthghGVpNOkeSoDCCdLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmkKHgzC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmkKHgzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBC71F000FF;
	Sat, 12 Sep 2026 10:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207737;
	bh=IPRO+JGjtUc6mrANyEEr0zowKP7eUhCiTdoE/Aw7Gss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmkKHgzCBJEqsw028R92f8/SMfCZDEX3UsdkfWcV8wwogmJB+NzoNxMpZ15BjbSU2
	 xlj4OWKQXxV7zxAVsvbU0RZ+TbeqnZsV00TIrUYJt0SAEnnoP0/j9bstRHLzDtlkd1
	 0A8j2OpvKSgOHOyVXYvtp5O71l65bwisn/apU3zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0475/1518] dmaengine: dw-edma: Clear stale requests on termination
Date: Sat, 12 Sep 2026 08:44:04 +0200
Message-ID: <20260912065634.193035966@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 352c2f475ba03..cb34385d605e3 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -327,6 +327,8 @@ static int dw_edma_device_terminate_all(struct dma_chan *dchan)
 	} else {
 		chan->request = EDMA_REQ_STOP;
 	}
+	if (chan->status == EDMA_ST_IDLE)
+		chan->request = EDMA_REQ_NONE;
 
 	return err;
 }
-- 
2.53.0



