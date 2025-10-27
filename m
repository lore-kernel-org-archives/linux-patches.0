Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C44D2D7806;
	Mon, 27 Oct 2025 18:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590378; cv=none; b=Dp0L5YuAID+L0H9SySVU4OtAin+I1eippoUpqJcb8UW0y+/V9kTSc1454sQkXkbCW1FktyirwQPVxbqoQgIeTDk4ntbKI7jjPVdDutgrFiBdqMaoO0A21GGo9vrNUDLJN3rpqPBK8kcF2oqWSs6H+U90S5zpqSai/E+hseVeyRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590378; c=relaxed/simple;
	bh=mi/e7253Is5EBOAppi/hTIjXA4lnIKifZj9BP7ajkdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cF4S/4bQfEo8X/1iSvKr/plC167W9BX2+eFJnkE8NINMksC30r+5hoataLj3BuCX6mAKvmu6risHybVQdv1UVyyeVhHfMbJAF3uzaI1FaBNJbaNaI8WV/wQiTsPi7pT6KklwlDBVK28ABdCvNdAXHtMew9kXVpCXPqS5l5HTeCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7YzU8ZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7YzU8ZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C962DC4CEF1;
	Mon, 27 Oct 2025 18:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590378;
	bh=mi/e7253Is5EBOAppi/hTIjXA4lnIKifZj9BP7ajkdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7YzU8ZZwEA/kd61Oe+igTGrBuyPzAR8RG+dENxKJ43MB+0C5A+/FA69eM31jMWAr
	 Kq0yvUD16serxQfrEV8esfyT3skV00xwybFKFYeTxeB7y7XbN2MKrv/HZ0jfIRpU6j
	 081EgTfhNsU/eBcp3nj+7HLw6QPyqaAao5g/8Wgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sneh Mankad <sneh.mankad@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/224] soc: qcom: rpmh-rsc: Unconditionally clear _TRIGGER bit for TCS
Date: Mon, 27 Oct 2025 19:32:48 +0100
Message-ID: <20251027183509.596265128@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sneh Mankad <sneh.mankad@oss.qualcomm.com>

[ Upstream commit f87412d18edb5b8393eb8cb1c2d4a54f90185a21 ]

Unconditionally clear the TCS_AMC_MODE_TRIGGER bit when a
transaction completes. Previously this bit was only cleared when
a wake TCS was borrowed as an AMC TCS but not for dedicated
AMC TCS. Leaving this bit set for AMC TCS and entering deeper low
power modes can generate a false completion IRQ.

Prevent this scenario by always clearing the TCS_AMC_MODE_TRIGGER
bit upon receiving a completion IRQ.

Fixes: 15b3bf61b8d4 ("soc: qcom: rpmh-rsc: Clear active mode configuration for wake TCS")
Signed-off-by: Sneh Mankad <sneh.mankad@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250825-rpmh_rsc_change-v1-1-138202c31bf6@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/rpmh-rsc.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/qcom/rpmh-rsc.c b/drivers/soc/qcom/rpmh-rsc.c
index 8924fcd9f5f59..a89d78afc8970 100644
--- a/drivers/soc/qcom/rpmh-rsc.c
+++ b/drivers/soc/qcom/rpmh-rsc.c
@@ -265,13 +265,10 @@ static irqreturn_t tcs_tx_done(int irq, void *p)
 
 		trace_rpmh_tx_done(drv, i, req, err);
 
-		/*
-		 * If wake tcs was re-purposed for sending active
-		 * votes, clear AMC trigger & enable modes and
+		/* Clear AMC trigger & enable modes and
 		 * disable interrupt for this TCS
 		 */
-		if (!drv->tcs[ACTIVE_TCS].num_tcs)
-			__tcs_set_trigger(drv, i, false);
+		__tcs_set_trigger(drv, i, false);
 skip:
 		/* Reclaim the TCS */
 		write_tcs_reg(drv, RSC_DRV_CMD_ENABLE, i, 0);
-- 
2.51.0



