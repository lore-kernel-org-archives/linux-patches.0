Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424C620125F;
	Mon, 13 Oct 2025 14:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367009; cv=none; b=V8TAA2y5lF/+Y1RmgZif7GwyxfOv93l6ySMK2fkGwi+Iq1sr3nvPt3kqI3AgSL0zXt/onnKIKSb15ztcMbLsFuvzAs+DQFlA618+tsLBMLix/FIvCTkwlHwG4lRe0sIBSkBf7Lxi0oq6gbhYRtEXMDW4hRSPinmfLF4XbqhbKZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367009; c=relaxed/simple;
	bh=DwWMSEfQ5di+7rGEe4TpdOXWGE+6oeYyIE9k13HIXCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMXGq3BX6pR8UezpPVLzpySIoZextMyZQJ7ABOMn5BMPGw571hUkSPGlUFmkGU6kvJ6kDxZwENSLDr2C1wSidMfU6iyouJJd3CLh3fRzaTr6bpCUcyEpv1x9/BmzK0QaZS79DBZ7rPWADqGKlWzOymVnyqKNdAeUhFrAWy3b+a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cua2fUT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cua2fUT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DB1C4CEFE;
	Mon, 13 Oct 2025 14:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367009;
	bh=DwWMSEfQ5di+7rGEe4TpdOXWGE+6oeYyIE9k13HIXCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cua2fUT6WRIOdX5wskoAH0EdMawBVnhFT6taT6mqGUeQDGP+EpiLCDcBchyKxAYNR
	 2KgPKlZSebdEO1iSK8NNHRfy8ShFyoc7rBskIPyXdBb4JYhC8S6leV07sZ5+XzuEtQ
	 Ra6ytnNUVRT6k4G6rQRQNxcId3I6Yw2fTOYIdZVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sneh Mankad <sneh.mankad@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/196] soc: qcom: rpmh-rsc: Unconditionally clear _TRIGGER bit for TCS
Date: Mon, 13 Oct 2025 16:43:54 +0200
Message-ID: <20251013144316.788388789@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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
index ff2b9eb9f669f..5797d95705417 100644
--- a/drivers/soc/qcom/rpmh-rsc.c
+++ b/drivers/soc/qcom/rpmh-rsc.c
@@ -415,13 +415,10 @@ static irqreturn_t tcs_tx_done(int irq, void *p)
 
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



