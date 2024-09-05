Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6159D15574C;
	Thu,  5 Sep 2024 09:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530288; cv=none; b=TRg9bgO4uGlKkJapNvAKuBSeoo30YiDy3j6xPaaIXUT5Z48E6z5k+B9f7w3qGYkjg7nQF/Uaq4WeegZXT/goW8dQdZXIqRnPIMksEEf9RrxqAs55H1DSW2svcN492gScJQ0MbInBuer1qd6r7PROFB2QuqHNLuJ0eRqxRC/KXS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530288; c=relaxed/simple;
	bh=ndJtuwdSrhxoYnHIUPeIZ8qg+GDKu4rx27iS76CR1Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuKWGtJkevkuD1vNBprcABr35Rxcqc6xKsF/Ob7UfPerIdJdM49B3sRgGo+dy3x/WzytSGBnwXxIW8GSaDOFldnTTc8uTcYegZpIWoFfSgu39uj6pmXjFhKSOYwhhSbOt5WDXo4f/1PxWKY0MLY0nyUozrVeqeJVyK/lzAbsl7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KyYJGxuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KyYJGxuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1084C4CEC3;
	Thu,  5 Sep 2024 09:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530288;
	bh=ndJtuwdSrhxoYnHIUPeIZ8qg+GDKu4rx27iS76CR1Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KyYJGxuyJlQyigijouDBu9af/bsz3/zWnNa2yQNLTDlrRk/C/FKfT6dXZoFutBEaJ
	 q9VoeDCS/459iw4TNrRdX2e0wu2iSKeGkST36WEPP17YxZ/3l63Jk/Kh9B2Sm4bURH
	 msZPiooni75CIZQzbBy+vKrOm8hRfYdDVeYA65jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/132] drm/bridge: tc358767: Check if fully initialized before signalling HPD event via IRQ
Date: Thu,  5 Sep 2024 11:41:39 +0200
Message-ID: <20240905093726.583360424@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d941c3a0e611..7fd4a5fe03ed 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -2034,7 +2034,7 @@ static irqreturn_t tc_irq_handler(int irq, void *arg)
 		dev_err(tc->dev, "syserr %x\n", stat);
 	}
 
-	if (tc->hpd_pin >= 0 && tc->bridge.dev) {
+	if (tc->hpd_pin >= 0 && tc->bridge.dev && tc->aux.drm_dev) {
 		/*
 		 * H is triggered when the GPIO goes high.
 		 *
-- 
2.43.0



