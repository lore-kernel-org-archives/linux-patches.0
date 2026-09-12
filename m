Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6361390212;
	Sat, 12 Sep 2026 19:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242648; cv=none; b=WN+mc1E4OQS+9aR4IdtZLMfADRLvscIoBYHLRg76BBlu40XzYRbL0O02F36nisgjXa5lSm58K657fUhDNceoXunynle3/Hs8bKw3Bj0xTl9zElMqSSo9z4ZU4FbXQAkGi6Cf5YlirtAR2KpkwfX4IKk5WxLJv+k2QsHyiewWRUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242648; c=relaxed/simple;
	bh=WzGzlFGwfIKX16PGWPc4zJjwNfvI1G61D/6IpDbbPGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glOgegjOu4q2g4aBiR0qpYqJgrT1BqmTdSAHczH7qIodWlXliwQ8T+8uEgEhiteaY5q5y+HYk7/7bdos+z1a39njTLPhwKimTPuzRQqnMjU8ZY4FjsVP9WBdrXOFJmvdjro2MxU2Iss5VwO3SCu3IenVeITamxARd7uuTn2mOuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTW02OZH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTW02OZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA36E1F000FF;
	Sat, 12 Sep 2026 19:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242646;
	bh=53uBKg5ZG+AE6y8jTj/m2piWIv0WhoTZ8hrWOktyrH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sTW02OZHOBWTY9kjdv8qhwBwaCQ+1sq5TLHIS0AnCBRK4PVmauPLiY8dv5+xFtZjR
	 Tu4nioCXCJET5ky0Mqu5Tm0b1e+tFzCA7pOxxVDb1tjP63lqkZ4f5RNYhsQYiga3AS
	 ywuO/+cE6NbADBEqj8IYihKGbgM1JX6jjB2GuU+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 478/798] dmaengine: dw-edma: Clear stale requests on termination
Date: Sat, 12 Sep 2026 09:01:46 +0200
Message-ID: <20260912065528.098485440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5de7586b2b601..4320844909307 100644
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



