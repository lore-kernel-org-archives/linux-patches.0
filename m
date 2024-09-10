Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9178B192D6D;
	Tue, 10 Sep 2024 10:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963418; cv=none; b=Cstfqo7NQvAjdZXoiG3Dk2+h8LR2hd8t1sem5mnCNqGZkoPiRxAqhlCfwd179Qu4SYwxDcJNVObIq26RyEViGpqAPXr0pDMeQ7An8slBNpd4zjNFPHEf8OhRcSBTbbx/6+HW8psS7eOxPOhFldLoBy6t6F2JcfXe60eBUWtAdL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963418; c=relaxed/simple;
	bh=wDwkZoxsFg/zVfRxSKt1dW8Epso7WGxAVMMz8iVzasQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhXmZGT4DZF8j1eoFOpWs2pSdM7SHtyJsPTgv/0Yr8qcpIMx9eCA1iGxXn3/r1c7UWv4YuN7uXU8pu0uS3Uw1vkbBy1QoGMcVvcTKal5XAkSENSBppczpCftLZrSspAvTnjkkmn66NKkwgmbsElp0/BUeTh/vid7MPjDDh1qyEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=baEX9RqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="baEX9RqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2156C4CEC3;
	Tue, 10 Sep 2024 10:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963418;
	bh=wDwkZoxsFg/zVfRxSKt1dW8Epso7WGxAVMMz8iVzasQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=baEX9RqL9A4O0Cn9umk4vo3sOBMD4tG57sEBO9Q645K0H1DrDXnynlZ2UVJCI4nWa
	 J4eHW0agFQg/NcQemHrCLzTiTpp1lkxYn9/eic/eRFSallHy5ohnSf7gR718DePWsL
	 RbN5dA5jWbmZKILF5w6NAk6Hc1ttA1JdC2zQIn7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/214] drm/bridge: tc358767: Check if fully initialized before signalling HPD event via IRQ
Date: Tue, 10 Sep 2024 11:31:12 +0200
Message-ID: <20240910092600.814663922@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4c6f3052156b..3436d39c90b4 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -1527,7 +1527,7 @@ static irqreturn_t tc_irq_handler(int irq, void *arg)
 		dev_err(tc->dev, "syserr %x\n", stat);
 	}
 
-	if (tc->hpd_pin >= 0 && tc->bridge.dev) {
+	if (tc->hpd_pin >= 0 && tc->bridge.dev && tc->aux.drm_dev) {
 		/*
 		 * H is triggered when the GPIO goes high.
 		 *
-- 
2.43.0



