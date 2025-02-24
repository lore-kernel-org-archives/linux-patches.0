Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBD523BD1D;
	Mon, 24 Feb 2025 14:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408561; cv=none; b=Q67J5mCrN1fip8/ksT84YiZZV3UNU8owgHIBM/zsoaKrJPj8dZ11wLK5HY63akLnieEL9skd1PkS4vQcR91NWWK7WPL1x9/700pvM4qYusT1l35jmfvxiMOCwplnidR3UcTWP21tOIEyRhiO/KwMQNtEq+qIWydyNHuXOPkLGEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408561; c=relaxed/simple;
	bh=mbxhS6qxmAW4KQoQIOSDnRI8ezUe8bH6F+X2mIlIZnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfCHTw5IRUjoqTHuU/d9GhcF70plog29UfszT473K0Bn2GoMAesjHKIGN1fEpvoJwiqjrh6u4/2WzxuqCBp1E32YJ8L3+YTxh2OEOE7xNufuHNqDRpKhsVCBytSrLubD6XJAy0m2239qKJSkBtFqLejLeZnzAy+74bfgB15alCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vu8foTG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vu8foTG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F107C4CEE6;
	Mon, 24 Feb 2025 14:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408561;
	bh=mbxhS6qxmAW4KQoQIOSDnRI8ezUe8bH6F+X2mIlIZnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vu8foTG3J5iTQgloRekl3TyAEbro0C04OZpD5oBUmX6NF2e5fd6DAzcLPKucCIYSx
	 5nmpxeBKu2rQUG8P6AlSpTNHjq4YCZ1JcPEHxOkYkt2x/Usi81VnTz4++6CVPFOP6W
	 7q55VOxg4Qt6ubD3YxdE/5yqfZGycEbjwyvDpbjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/154] net: pse-pd: Avoid setting max_uA in regulator constraints
Date: Mon, 24 Feb 2025 15:34:21 +0100
Message-ID: <20250224142609.511909268@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



