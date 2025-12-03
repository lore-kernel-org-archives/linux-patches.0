Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC53393DF0;
	Wed,  3 Dec 2025 16:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780699; cv=none; b=i5HzdDHn7iCMnQY2R5iA33sPFbtXjaZnF/IgDwSS1cm/k0IHiYlF6z+ixm8HKU7xYK8m8P2IsUIWq00DWiuHjKgNMMXYzhvNYUcxkdsLSvh/RWgfEsdoOI/GvcMcb1ugnRA0U/sFUGkeqbD56oRG75GyxI1dXUrGYgmEKv3l/TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780699; c=relaxed/simple;
	bh=CXKt8HYbcFD7IsSbd4zBv/RIHnrMPvJYhZNSZSFYuZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUi/8HgYG0MsonQj/j0tGPUkh/QtTxYMcBFhgNRTmJxTfklJTV+XmMAfgqENfCy+J48Rxc61CvxBBUPGXfYcgBtO9tWcRxvbNB8oR0shgyQosBmwBFrKUxg4ZIWqLKLiJtuPRoHGsydymcSrArxL2mM7kHIswawLF2jiht2Lyz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjQeObeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjQeObeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A177C4CEF5;
	Wed,  3 Dec 2025 16:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780698;
	bh=CXKt8HYbcFD7IsSbd4zBv/RIHnrMPvJYhZNSZSFYuZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjQeObeEKIuOXXaiBDibsyZ2zSrpiz9xEXeVKue1AftsvbOabP64NCJKwihp2p74B
	 WnneFeG5R3/ZyBJf0UvPMZU0b6XxAVRWO2FW722wZEgYAZRPj7BhLcqNXbkaaC52+t
	 ehMhFj4L+vuj2dE6sPmeLbWGe8YzRkD/o+CwCFtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/132] net: fec: do not register PPS event for PEROUT
Date: Wed,  3 Dec 2025 16:28:30 +0100
Message-ID: <20251203152344.453001630@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 9a060d0fac9e75524f72864adec6d8cdb70a5bca ]

There are currently two situations that can trigger the PTP interrupt,
one is the PPS event, the other is the PEROUT event. However, the irq
handler fec_pps_interrupt() does not check the irq event type and
directly registers a PPS event into the system, but the event may be
a PEROUT event. This is incorrect because PEROUT is an output signal,
while PPS is the input of the kernel PPS system. Therefore, add a check
for the event type, if pps_enable is true, it means that the current
event is a PPS event, and then the PPS event is registered.

Fixes: 350749b909bf ("net: fec: Add support for periodic output signal of PPS")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20251125085210.1094306-5-wei.fang@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index beb1d98fa741a..4bb894b5afcb9 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -719,8 +719,11 @@ static irqreturn_t fec_pps_interrupt(int irq, void *dev_id)
 		fep->next_counter = (fep->next_counter + fep->reload_period) &
 				fep->cc.mask;
 
-		event.type = PTP_CLOCK_PPS;
-		ptp_clock_event(fep->ptp_clock, &event);
+		if (fep->pps_enable) {
+			event.type = PTP_CLOCK_PPS;
+			ptp_clock_event(fep->ptp_clock, &event);
+		}
+
 		return IRQ_HANDLED;
 	}
 
-- 
2.51.0



