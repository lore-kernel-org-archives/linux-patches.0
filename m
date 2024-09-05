Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BBA1494DB;
	Thu,  5 Sep 2024 10:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530629; cv=none; b=MoG8Gn/LDTVeRayhv6i2jToeOYYsznLtN9eq+6DbfiwkzDfZdWtVxJDBAWqRCzMbZVUhmMo0h4GfXm3+o2MphNe/wrTPgIvF0WF/AEnAiD/KzCFucS3RgBHg0V2onRt0cPe2/PaPJ2PyxuW0GcakhXu1qHVEsxqCsG1qwhT2Mtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530629; c=relaxed/simple;
	bh=WC7nOt0OIUFnjGm+k+XKQpNJwIIMG9wqf+j3bAeZmTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpaHqh8/WEwmhtJoHxGqV1YMjacBBOimGDwVtgyqiEd7dfBioyPKjTbHdWqvwn8+V8MS6quSVt9UqikSzFzRUKAnPYZWiT2O/mETmU98AWFob6ogxD+txrj2wkCpXP2cesjUtn0mVBHwgd0GdzbzpXxjotMPb7Ro+UNujBUlOIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMNfwuhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMNfwuhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F561C4CEC3;
	Thu,  5 Sep 2024 10:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530629;
	bh=WC7nOt0OIUFnjGm+k+XKQpNJwIIMG9wqf+j3bAeZmTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMNfwuhh1t/KDHhbJrJGhOVcKBPdTKThTbphP8c91oC4n44NbyU+/TJoqL2nhu5dv
	 Vn6EhVRFbV0ZueTpsCktvmiJahnOhmUM7z38Brghntw5Xio8ZvjmB/DZsHsL0Gz9Uk
	 27rE+ztvRD/o9i5fEnuwd9KVugq5Ppx19DmJnPNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/101] drm/bridge: tc358767: Check if fully initialized before signalling HPD event via IRQ
Date: Thu,  5 Sep 2024 11:41:55 +0200
Message-ID: <20240905093719.376454919@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 926ab5c3c31a..0af2bd8706e4 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -1841,7 +1841,7 @@ static irqreturn_t tc_irq_handler(int irq, void *arg)
 		dev_err(tc->dev, "syserr %x\n", stat);
 	}
 
-	if (tc->hpd_pin >= 0 && tc->bridge.dev) {
+	if (tc->hpd_pin >= 0 && tc->bridge.dev && tc->aux.drm_dev) {
 		/*
 		 * H is triggered when the GPIO goes high.
 		 *
-- 
2.43.0



