Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65B41922CC;
	Thu,  5 Sep 2024 09:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529814; cv=none; b=K0biTVihHEArup+xrnqvZKL9xDfdHu8NJMVXH0mFGrUI/+fdUb1WjfiEFHqEn9W9CbCPgQ2/+pFGycVVgggF1oSkjCnllfDDWylyDmLxxx9BPDmjGbnIqmXMx62QFhJOBlUaW6pJfpMUslvoCNP/vQ4s3PMr3t+B8FneLA1t21g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529814; c=relaxed/simple;
	bh=FICoyUyyH4x5npgZ4BF4bcc7FBsQoIzWobl10jb12Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/B7H1SSv9wLaEHup1qM73dxAaxWZntJJxP7sD1rtjtiwuRwhhTjz96SUswbWmzVqSqatGZXPf/F27HI/w8FxxxsoZCCRTWmIUpFfwZFmoRKmqEFIVByVcDYVBw/MkNT+m2AGuU3CMdyj10+2U0qD11WLwx8RZW+aLMaUI3+5Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdGsHdNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdGsHdNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14652C4CEC4;
	Thu,  5 Sep 2024 09:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529814;
	bh=FICoyUyyH4x5npgZ4BF4bcc7FBsQoIzWobl10jb12Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VdGsHdNXUKxLrihMKg/+X72bz12TML0cZcRd/BfnHLr5QnCsv/ygXjBW01WQYHcb0
	 AOllSv+TijD/TSoW+uqybXH3ZTOQksZnwOFMhILlQnjgSXUIZBZKr+SigNlmg02lpB
	 Q6WMtcXCGdVZbfo48o6S3Sbn0mjgFwFXxMMhj/RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 150/184] drm/bridge: tc358767: Check if fully initialized before signalling HPD event via IRQ
Date: Thu,  5 Sep 2024 11:41:03 +0200
Message-ID: <20240905093738.194702269@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 162e48cb1d84c2c966b649b8ac5c9d4f75f6d44f ]

Make sure the connector is fully initialized before signalling any
HPD events via drm_kms_helper_hotplug_event(), otherwise this may
lead to NULL pointer dereference.

Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240531203333.277476-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358767.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/tc358767.c b/drivers/gpu/drm/bridge/tc358767.c
index 166f9a3e9622..332f0aa50fee 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -2135,7 +2135,7 @@ static irqreturn_t tc_irq_handler(int irq, void *arg)
 		dev_err(tc->dev, "syserr %x\n", stat);
 	}
 
-	if (tc->hpd_pin >= 0 && tc->bridge.dev) {
+	if (tc->hpd_pin >= 0 && tc->bridge.dev && tc->aux.drm_dev) {
 		/*
 		 * H is triggered when the GPIO goes high.
 		 *
-- 
2.43.0



