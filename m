Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB444431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3328DC433EF;
	Wed, 15 Mar 2023 12:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883182;
	bh=exJWNM5wercgRre0R2OEL6UJcxStHpLt792cNugqMeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkYXsmWvemIMN6wk0RxINcb1CgjwAuOI9VDMnOzIpaks+/m9hWpsqYyoUMVkQWWeG
	 yPnrNdKWtkUE+s1Xl/eCfJ12uMUFys1yquDYdbxcqS4xRRpAHSJBuQdrqyLmHrtt48
	 PPZXRbYQ7LI32HBc78mmXehqB9cKScKS5OZNVcow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/145] regulator: Flag uncontrollable regulators as always_on
Date: Wed, 15 Mar 2023 13:11:45 +0100
Message-Id: <20230315115740.364794202@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 261f06315cf7c3744731e36bfd8d4434949e3389 ]

While we currently assume that regulators with no control available are
just uncontionally enabled this isn't always as clearly displayed to
users as is desirable, for example the code for disabling unused
regulators will log that it is about to disable them. Clean this up a
bit by setting always_on during constraint evaluation if we have no
available mechanism for controlling the regualtor so things that check
the constraint will do the right thing.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220325144637.1543496-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 80d2c29e09e6 ("regulator: core: Use ktime_get_boottime() to determine how long a regulator was off")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 3eae3aa5ad1d2..450aa0756dd8c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1521,6 +1521,24 @@ static int set_machine_constraints(struct regulator_dev *rdev)
 		}
 	}
 
+	/*
+	 * If there is no mechanism for controlling the regulator then
+	 * flag it as always_on so we don't end up duplicating checks
+	 * for this so much.  Note that we could control the state of
+	 * a supply to control the output on a regulator that has no
+	 * direct control.
+	 */
+	if (!rdev->ena_pin && !ops->enable) {
+		if (rdev->supply_name && !rdev->supply)
+			return -EPROBE_DEFER;
+
+		if (rdev->supply)
+			rdev->constraints->always_on =
+				rdev->supply->rdev->constraints->always_on;
+		else
+			rdev->constraints->always_on = true;
+	}
+
 	/* If the constraints say the regulator should be on at this point
 	 * and we have control then make sure it is enabled.
 	 */
-- 
2.39.2



