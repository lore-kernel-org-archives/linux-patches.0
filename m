Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED5E2571C3;
	Mon, 24 Feb 2025 14:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408893; cv=none; b=MaFgE2YSGWz3TtqAy9FA3vm/RYh2SgCHXKC8WAmCGrHVp7+VoRJ+noyBgigVR+R1GuojQ/zNwmUE8Ba8o41ro0YrvdPCNebCNV2uTk7IWTbqCYa7vvqisjSVw+rINF7YVHGKV1noNXrYcNT9t6MN9t7a92WnjdQAbDyPBnAXaXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408893; c=relaxed/simple;
	bh=3+n2OYQTiDRxegDghafz3yiltuXBe/3wSL53Yp0bQqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4ftEoybXu4ZsL5t7PlfM1omeaqv1UbPLUCihT1wP0d6qoV9K5DFUH3TM+6XvyR4LNxK50GjFuIqf/A3b+R0I/ocUtWQ4abld1txmTwfBHxKZZKWlAe8KnzdUvczslvl3keWY9symj4LQVv+J7O54LiAiElfcj9+iC4g/oZCYbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIiV1vGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIiV1vGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58AEAC4CED6;
	Mon, 24 Feb 2025 14:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408892;
	bh=3+n2OYQTiDRxegDghafz3yiltuXBe/3wSL53Yp0bQqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PIiV1vGOeoa6lVCTMgPA5ptHphNXemMgspvarv4nguFohme85a6MlDUCwd40QrecL
	 2BSpbdLEdMSkSJTqEklZRh0Ky8SJqWCdRQfcnCdw8DljrB++Ji4krmxbqv5Gg6/Ecu
	 P8w08t7/mq3wUdrmulUEcwR19NVct2vMJ/8npJ1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 037/138] net: pse-pd: Avoid setting max_uA in regulator constraints
Date: Mon, 24 Feb 2025 15:34:27 +0100
Message-ID: <20250224142605.925273575@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit 675d0e3cacc3ae7c29294a5f6a820187f862ad8b ]

Setting the max_uA constraint in the regulator API imposes a current
limit during the regulator registration process. This behavior conflicts
with preserving the maximum PI power budget configuration across reboots.

Instead, compare the desired current limit to MAX_PI_CURRENT in the
pse_pi_set_current_limit() function to ensure proper handling of the
power budget.

Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: f6093c5ec74d ("net: pse-pd: pd692x0: Fix power limit retrieval")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pse-pd/pse_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/pse-pd/pse_core.c b/drivers/net/pse-pd/pse_core.c
index 2906ce173f66c..9fee4dd53515a 100644
--- a/drivers/net/pse-pd/pse_core.c
+++ b/drivers/net/pse-pd/pse_core.c
@@ -357,6 +357,9 @@ static int pse_pi_set_current_limit(struct regulator_dev *rdev, int min_uA,
 	if (!ops->pi_set_current_limit)
 		return -EOPNOTSUPP;
 
+	if (max_uA > MAX_PI_CURRENT)
+		return -ERANGE;
+
 	id = rdev_get_id(rdev);
 	mutex_lock(&pcdev->lock);
 	ret = ops->pi_set_current_limit(pcdev, id, max_uA);
@@ -403,11 +406,9 @@ devm_pse_pi_regulator_register(struct pse_controller_dev *pcdev,
 
 	rinit_data->constraints.valid_ops_mask = REGULATOR_CHANGE_STATUS;
 
-	if (pcdev->ops->pi_set_current_limit) {
+	if (pcdev->ops->pi_set_current_limit)
 		rinit_data->constraints.valid_ops_mask |=
 			REGULATOR_CHANGE_CURRENT;
-		rinit_data->constraints.max_uA = MAX_PI_CURRENT;
-	}
 
 	rinit_data->supply_regulator = "vpwr";
 
-- 
2.39.5



