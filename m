Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66338322DC1;
	Wed,  3 Dec 2025 15:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776934; cv=none; b=KvGIMnKvcRg0zX/u7ldwA7RJvXqHvxKeiI6In08VowZ4w4ucEQ7hjps7ozD6/svfP9h6Gr0IlHxdVDA0T+dkCdTCiwo1balfzCLo8u8d9IlF29PMy9M50fj8OF48rLOAaPAXmPzYYVDdum71hEBEYa7yi0GGZyJFXHuILW90/Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776934; c=relaxed/simple;
	bh=AjoLlZSoTVgDACbFArqUhx5sp52D4JGntT4T4REfv5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6oqmR+CiUP3ZIerwiQuKMxBkxELMuOlbZoBw9pK7/JTo8QcLq8oXJurFeptCKhjatEAjZlUHU2sEArInKex1/XquO0KbmQe9WirktEZz5nry0kzY7m9dOp59ujlwmXJjQtTyeln6GpbxqQHOgHK/pqWiStbqT+2yc7Mn8aAbg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmTdtGEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmTdtGEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85212C4CEF5;
	Wed,  3 Dec 2025 15:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776934;
	bh=AjoLlZSoTVgDACbFArqUhx5sp52D4JGntT4T4REfv5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmTdtGEUGsZdR4O99+7sYCWMRNkgJISOU3fRh5nvlqg6U/IJjdWH0W8BtTV56TqYY
	 rVoTnK6nw9Z2ggRCSWuZOuWt4Q800lFfLC1GWZD+L1i5NC8KpVxRi9BwLmRMw8Kuw6
	 wISKWWXJzPruXWG2T5Q3RGmKWgcHncceZAzpvIy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 030/146] net: fec: cancel perout_timer when PEROUT is disabled
Date: Wed,  3 Dec 2025 16:26:48 +0100
Message-ID: <20251203152347.576513408@linuxfoundation.org>
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

[ Upstream commit 50caa744689e505414673c20359b04aa918439e3 ]

The PEROUT allows the user to set a specified future time to output the
periodic signal. If the future time is far from the current time, the FEC
driver will use hrtimer to configure PEROUT one second before the future
time. However, the hrtimer will not be canceled if the PEROUT is disabled
before the hrtimer expires. So the PEROUT will be configured when the
hrtimer expires, which is not as expected. Therefore, cancel the hrtimer
in fec_ptp_pps_disable() to fix this issue.

Fixes: 350749b909bf ("net: fec: Add support for periodic output signal of PPS")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20251125085210.1094306-2-wei.fang@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index fa88b47d526c0..7a5367ea94101 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -497,6 +497,8 @@ static int fec_ptp_pps_disable(struct fec_enet_private *fep, uint channel)
 {
 	unsigned long flags;
 
+	hrtimer_cancel(&fep->perout_timer);
+
 	spin_lock_irqsave(&fep->tmreg_lock, flags);
 	writel(0, fep->hwp + FEC_TCSR(channel));
 	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
-- 
2.51.0



