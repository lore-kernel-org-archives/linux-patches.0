Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E485398F9B;
	Wed,  3 Dec 2025 16:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781135; cv=none; b=vE20okiWeGKRTsK1tTKpaNdk2gnZEQ4jggbpM9Q6vwdEFHO7OnWHZ2WF08KgsqpWtxEGnMLDkH8s7f9l2S+3SL39Tf9XU1YS5li47cDwY17gKi24Rx0B1akyJ5FQFiqkb/V9uVyNw/y/EqMLNadEVhkjt2QejbqcRKgoEb6Kd8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781135; c=relaxed/simple;
	bh=l5E5WdZNG9BR3ZMrpej7gLujfYobZxy5xH4P1afD4+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXtQ9iVgZoglIlKC3TnNOhwjeQxhL/EFvKYuFfUXEyD9fsvuk1I4/V+aDWYBByl0UvNeuqx8Lg9xD8TmXYR9cdRt1mjmmkk3oDAI5zbibrB1BTlbe9qoygfaYX7xSt9WL0kbutvgYIjbFMRDhq+wqXAAuhXrw+9ETbAL6ikktlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qs94F5d7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qs94F5d7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28842C4CEF5;
	Wed,  3 Dec 2025 16:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781134;
	bh=l5E5WdZNG9BR3ZMrpej7gLujfYobZxy5xH4P1afD4+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qs94F5d7qqaopSFZNLBu2w041JV/5odD7N0VkJQxoi9yrOn+hN5jYlErsIK9+Q5Nb
	 vO9jfB2Iu8KIH428wWfbDj1CWzXjgWcm+c8UopTWObMOMNKqFZQLsdAC/upi8VPyxc
	 UhqqH14qhieRLjDXRMZkBrCRWhgXqzeHeWnz6BsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 17/93] net: fec: cancel perout_timer when PEROUT is disabled
Date: Wed,  3 Dec 2025 16:29:10 +0100
Message-ID: <20251203152337.148279531@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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
index 7f6b574320716..cb3f05da3eee6 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -498,6 +498,8 @@ static int fec_ptp_pps_disable(struct fec_enet_private *fep, uint channel)
 {
 	unsigned long flags;
 
+	hrtimer_cancel(&fep->perout_timer);
+
 	spin_lock_irqsave(&fep->tmreg_lock, flags);
 	writel(0, fep->hwp + FEC_TCSR(channel));
 	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
-- 
2.51.0



