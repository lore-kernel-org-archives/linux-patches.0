Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78AD15C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D299C433C1;
	Mon,  5 Dec 2022 19:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268180;
	bh=mO4+0MV9ypLmcFQnzSlGrOJoQoVyQmjx2f/8zZZnomw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0nJgwLPTaGMljcujFXsZDwiekqdftGJeNNzY3pW5ynWamBCi3mBDAvnwWo9CPXuVm
	 EaHGw60CgmHKNXu3Q6EVWmjHVaatWp5hPkV55GHD5QexmOZ7FiGiQ7jK44oyPT+iya
	 dCBzvCKqbAFIOGZLeVFaxp91YJ4cpNJ1Q+FNwSjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 010/124] clk: qcom: gdsc: add missing error handling
Date: Mon,  5 Dec 2022 20:08:36 +0100
Message-Id: <20221205190808.735986082@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit eab4c1ebdd657957bf7ae66ffb8849b462db78b3 ]

Since commit 7eb231c337e0 ("PM / Domains: Convert pm_genpd_init() to
return an error code") pm_genpd_init() can return an error which the
caller must handle.

The current error handling was also incomplete as the runtime PM and
regulator use counts were not balanced in all error paths.

Add the missing error handling to the GDSC initialisation to avoid
continuing as if nothing happened on errors.

Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220929155816.17425-1-johan+linaro@kernel.org
Stable-dep-of: 4cc47e8add63 ("clk: qcom: gdsc: Remove direct runtime PM calls")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gdsc.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
index d3244006c661..4b66ce0f1940 100644
--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -439,11 +439,8 @@ static int gdsc_init(struct gdsc *sc)
 
 		/* ...and the power-domain */
 		ret = gdsc_pm_runtime_get(sc);
-		if (ret) {
-			if (sc->rsupply)
-				regulator_disable(sc->rsupply);
-			return ret;
-		}
+		if (ret)
+			goto err_disable_supply;
 
 		/*
 		 * Votable GDSCs can be ON due to Vote from other masters.
@@ -452,14 +449,14 @@ static int gdsc_init(struct gdsc *sc)
 		if (sc->flags & VOTABLE) {
 			ret = gdsc_update_collapse_bit(sc, false);
 			if (ret)
-				return ret;
+				goto err_put_rpm;
 		}
 
 		/* Turn on HW trigger mode if supported */
 		if (sc->flags & HW_CTRL) {
 			ret = gdsc_hwctrl(sc, true);
 			if (ret < 0)
-				return ret;
+				goto err_put_rpm;
 		}
 
 		/*
@@ -486,9 +483,21 @@ static int gdsc_init(struct gdsc *sc)
 		sc->pd.power_off = gdsc_disable;
 	if (!sc->pd.power_on)
 		sc->pd.power_on = gdsc_enable;
-	pm_genpd_init(&sc->pd, NULL, !on);
+
+	ret = pm_genpd_init(&sc->pd, NULL, !on);
+	if (ret)
+		goto err_put_rpm;
 
 	return 0;
+
+err_put_rpm:
+	if (on)
+		gdsc_pm_runtime_put(sc);
+err_disable_supply:
+	if (on && sc->rsupply)
+		regulator_disable(sc->rsupply);
+
+	return ret;
 }
 
 int gdsc_register(struct gdsc_desc *desc,
-- 
2.35.1



