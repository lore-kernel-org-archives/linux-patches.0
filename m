Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8951E327786;
	Wed,  3 Dec 2025 15:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776944; cv=none; b=qhwbBt64K8wFmtHpOaMgHPwFBZj7EyZM2LYPjxQpgCMZ/Q3s13CX8Z5d6z7VgAtkA3KeKbfDoAeFxCeGejEGnsmV56Ow1KJlRShAZZiw82e1Lqet/a0T4lv5F6Uf4tv7ppFayYnG77wwtv6rUEAqM4w9kE6NCOx4kx5XkLWbH24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776944; c=relaxed/simple;
	bh=BPNtiShjntkyi3IjkPnn4Z5jl3al0oge6sl5hkKN09A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNQR7Y8fSbbmnVkHFjHGcnZhuxP0QKu09ERQ0p550EAeehoefMpr8IRQ96epKO66TS0d13NgAEYWqgXxX77qA92LOEHDHhiVs5YveF+fYYs4Xe0WFEFMUzydx5BgNXbipek2lroDsbbukJ9rAWe8AUBKWgcpVuYissie8w0v3OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zmq7tk5R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zmq7tk5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A16C4CEF5;
	Wed,  3 Dec 2025 15:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776944;
	bh=BPNtiShjntkyi3IjkPnn4Z5jl3al0oge6sl5hkKN09A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zmq7tk5RxnOcplPBf6wHJL83DSQgFWRjMQx2RLt0V0tydniGYDco3gJYHJ3HRUu9g
	 2ABGSb05Rw7C/IRg5ifdIsVOYVjd+fWUI1Qnl3CsD3yVC+uEpkfK6nDMLziQabW1ld
	 h40lgbo7JVBlhX+DifbuEBDA912gQAoHNy44+aW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 033/146] net: fec: do not register PPS event for PEROUT
Date: Wed,  3 Dec 2025 16:26:51 +0100
Message-ID: <20251203152347.685621396@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index ed5d59abeb537..4b7bad9a485df 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -718,8 +718,11 @@ static irqreturn_t fec_pps_interrupt(int irq, void *dev_id)
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



