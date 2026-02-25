Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D611B18DB2A;
	Wed, 25 Feb 2026 01:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983135; cv=none; b=DPDj8hpP8/z0ZxxcpKe5Q38ZC02k3p435vhExmkgeL0Fl7MA2uTHbaU1vW9w39EJi15/cEyHIh/BqttHrN2e0F32II6QrVV1hgKYC5cRU/zXDKqVtLgyTo46aLQNnr7QZY9d/5wlBBApJ6GeTR/WvQfsQQQ3w+xHJLwTNy5gyFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983135; c=relaxed/simple;
	bh=zys1Z+FfYxjFohj+t6VLvff/D30RPm9p2fs3VM1YvBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KjoZldCLZ0GFith2r/Y625ZWD/7TREQsNm0d7tFhwDBEUGBatv2mti/unXaDxKPBAhxO1EcMCuI4RU+tf74NdMr772BvWELtR2XexfFEQDL7bR6mKMnrSDDBhFxyc7xWngLCaU0WZbcXJ75g9f1w5M4ZuLRGRxXge8K/lGOhRd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRGv4Bv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRGv4Bv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9530EC116D0;
	Wed, 25 Feb 2026 01:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983135;
	bh=zys1Z+FfYxjFohj+t6VLvff/D30RPm9p2fs3VM1YvBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRGv4Bv+TkoVe2E8rWT1JeEgPn1T/dmyHevRolGm674+L4d6wvaeGipb/giX4xrws
	 UugwEFYzE4uZuLbWyRsW6Oi+b6mFUd7sma/5bGIuNtd9MwZY+blo9gvO2FiXo4XT9E
	 q9jwHwSlF6+gbymp00FAAlVXRp46q7BK+S0xoCrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 256/781] regulator: core: dont ignore errors from event forwarding setup
Date: Tue, 24 Feb 2026 17:16:05 -0800
Message-ID: <20260225012405.984691512@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

[ Upstream commit e23c0a59dabae9166bbea26fc05d08e7d9e900b7 ]

Receiving and forwarding critical supply events seems like they're
important information and we shouldn't ignore errors occurring during
registration for such events.

With this change the supply is unset on event registration failure,
allowing us to potentially retry another time.

Fixes: 433e294c3c5b ("regulator: core: forward undervoltage events downstream by default")
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://patch.msgid.link/20260109-regulators-defer-v2-6-1a25dc968e60@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index d0140227fcbdb..8ee33b777f6ce 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2273,10 +2273,21 @@ static int regulator_resolve_supply(struct regulator_dev *rdev)
 	 * under-voltage.
 	 */
 	ret = register_regulator_event_forwarding(rdev);
-	if (ret < 0)
+	if (ret < 0) {
+		struct regulator *supply;
+
 		rdev_warn(rdev, "Failed to register event forwarding: %pe\n",
 			  ERR_PTR(ret));
 
+		supply = rdev->supply;
+		rdev->supply = NULL;
+
+		regulator_unlock_two(rdev, supply->rdev, &ww_ctx);
+
+		regulator_put(supply);
+		goto out;
+	}
+
 	regulator_unlock_two(rdev, r, &ww_ctx);
 
 	/* rdev->supply was created in set_supply() */
-- 
2.51.0



