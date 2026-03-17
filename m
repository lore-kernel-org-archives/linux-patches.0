Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F52F26FD9B;
	Tue, 17 Mar 2026 17:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767543; cv=none; b=U1492A3BMV9PLD5gz9zF2h0UAEybcY9002eLfdNREcPzUwEs/G/+4syPy3U9RnsAMq8blHvy/H2NrzQz0lOAaT+zb5QMTN2WqPP8MiLBYYpxzgXqFRYoy5biOUxDm+NN5dbtcH4CATaVZtorikP803giGZ6CIFxOLfNBGL0Pq3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767543; c=relaxed/simple;
	bh=oIHlO5seluAAMt7wP1wYHN6caZD609WhZPYQ2ePjS8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QObT9ZVooq5KxxZ27swLu4k08sWCNy/35KV7kSFpSgegU35g8ZISrANuimEpHej110K3hjQ0ZvZcyIStrNC5RTndv8wVzXUUiwf47Ao1j7i1zW4sV3QOmGKco/xIsWsRuKrfqXLXJxhB27Cs1iyGXzF20+yge6unrpp7A8jpM7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rCwFcZky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rCwFcZky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D22C4CEF7;
	Tue, 17 Mar 2026 17:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767543;
	bh=oIHlO5seluAAMt7wP1wYHN6caZD609WhZPYQ2ePjS8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rCwFcZkyn3694s82NUPwUcc+7GHG3S8ZWYUEiuXfPl9fXIX0i/8tXeilW6MZj5JPa
	 26qr3gFgbPRypSmCBMjraA0npMxcM+4wWYoxGuNcTtRIWHdcc71a9Tk8awAiYImDpm
	 OQlsDHBgh8+TZziL/gKH1s5A49CjJ6s/IKWXP4hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/333] regulator: pca9450: Correct probed name for PCA9452
Date: Tue, 17 Mar 2026 17:31:45 +0100
Message-ID: <20260317163002.194584338@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 21b3fb7dc19caa488d285e3c47999f7f1a179334 ]

An incorrect device name was logged for PCA9452 because the dev_info()
ternary omitted PCA9452 and fell through to "pca9450bc". Introduce a
type_name and set it per device type so the probed message matches the
actual PMIC. While here, make the PCA9451A case explicit.

No functional changes.

Fixes: 017b76fb8e5b6 ("regulator: pca9450: Add PMIC pca9452 support")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://patch.msgid.link/20260310-pca9450-irq-v1-2-36adf52c2c55@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pca9450-regulator.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/pca9450-regulator.c b/drivers/regulator/pca9450-regulator.c
index 95632b1e8ce4c..f991dc9365f18 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -1263,6 +1263,7 @@ static int pca9450_i2c_probe(struct i2c_client *i2c)
 	struct regulator_dev *ldo5;
 	struct pca9450 *pca9450;
 	unsigned int device_id, i;
+	const char *type_name;
 	int ret;
 
 	pca9450 = devm_kzalloc(&i2c->dev, sizeof(struct pca9450), GFP_KERNEL);
@@ -1273,15 +1274,22 @@ static int pca9450_i2c_probe(struct i2c_client *i2c)
 	case PCA9450_TYPE_PCA9450A:
 		regulator_desc = pca9450a_regulators;
 		pca9450->rcnt = ARRAY_SIZE(pca9450a_regulators);
+		type_name = "pca9450a";
 		break;
 	case PCA9450_TYPE_PCA9450BC:
 		regulator_desc = pca9450bc_regulators;
 		pca9450->rcnt = ARRAY_SIZE(pca9450bc_regulators);
+		type_name = "pca9450bc";
 		break;
 	case PCA9450_TYPE_PCA9451A:
+		regulator_desc = pca9451a_regulators;
+		pca9450->rcnt = ARRAY_SIZE(pca9451a_regulators);
+		type_name = "pca9451a";
+		break;
 	case PCA9450_TYPE_PCA9452:
 		regulator_desc = pca9451a_regulators;
 		pca9450->rcnt = ARRAY_SIZE(pca9451a_regulators);
+		type_name = "pca9452";
 		break;
 	default:
 		dev_err(&i2c->dev, "Unknown device type");
@@ -1383,9 +1391,7 @@ static int pca9450_i2c_probe(struct i2c_client *i2c)
 					  pca9450_i2c_restart_handler, pca9450))
 		dev_warn(&i2c->dev, "Failed to register restart handler\n");
 
-	dev_info(&i2c->dev, "%s probed.\n",
-		type == PCA9450_TYPE_PCA9450A ? "pca9450a" :
-		(type == PCA9450_TYPE_PCA9451A ? "pca9451a" : "pca9450bc"));
+	dev_info(&i2c->dev, "%s probed.\n", type_name);
 
 	return 0;
 }
-- 
2.51.0



