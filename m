Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E663E1AA1D2;
	Thu, 28 May 2026 20:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998444; cv=none; b=XqY9OqbtpeiUI/5fWAD63pBlfvHYsq6+HJWA3P4UDcVJrRSbDugVkDC1QxGlU66xRMQcoXdE1JadS2ACW0Z73G1B8VIUh+jy7RWC/aBDKpYwk7j76WXQmdtBthoHM4aemhSa+kkanx/R+ALqW/aOP85DRJTZWy37LOz+mj2LiLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998444; c=relaxed/simple;
	bh=sEfST1AVBUhaAy43ezAfOaL3UQ1jGajjdAD9kBCKteM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RImWKNnt9M1AK5uAcbHqmsnWc2byVJHfYyY2CzbWQQDrM0yItkOLHz81Y+8Q85uXj2nm1jhxBvP8eL3+EHKyt7e3V9zIDdEpG5xLPJwKpqXbuzlz+u17ZY2zjx6u/2Qn/9V2+Y34zhyk4Dz6eXnk8Rg9WrbyrU6DGko1LLji31M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUeFy+cy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUeFy+cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511D91F000E9;
	Thu, 28 May 2026 20:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998442;
	bh=F/8I7RS9OyfKT1dHCAplJXrStvUM6uSE8ielEEktq/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NUeFy+cyJySf5SZSEpSvhKxTvJO0a4RwAvvUSUUhiBk2T3H7ovfapDIscIj4NwRck
	 9Jhddk8MRimmZ/+7gQ2vYBfHci05KfwRx1w4UKndn9NoOsxbuFtYvizKG8rpfSBZi9
	 ZINFkEEItw1ydwiLNV73XftQP+hRvhMsjTiAWyro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Til Kaiser <mail@tk154.de>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 175/461] pinctrl: qcom: ipq4019: mark gpio as a GPIO pin function
Date: Thu, 28 May 2026 21:45:04 +0200
Message-ID: <20260528194652.137153056@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Til Kaiser <mail@tk154.de>

[ Upstream commit b51d33ea8a164bb5f0eec8ad817fa9730ac2b577 ]

The qcom pinctrl core supports marking functions that represent GPIO mode
via PINCTRL_GPIO_PINFUNCTION(), so that strict pinmuxing does not reject
GPIO requests for pins that are muxed to the GPIO function.

ipq4019 still describes its gpio function with QCA_PIN_FUNCTION(gpio),
so it is not treated as a GPIO pin function. As a result, GPIO consumers
can still conflict with pinctrl states that select the "gpio" function.

Add a QCA_GPIO_PIN_FUNCTION() helper and use it for the ipq4019 gpio
function, matching how the msm-based qcom drivers handle this.

This allows ipq4019 to keep the GPIO-related pin configuration in DTS
without tripping over strict pinmux ownership checks.

Fixes: cc85cb96e2e4 ("pinctrl: qcom: make the pinmuxing strict")
Signed-off-by: Til Kaiser <mail@tk154.de>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-ipq4019.c | 2 +-
 drivers/pinctrl/qcom/pinctrl-msm.h     | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-ipq4019.c b/drivers/pinctrl/qcom/pinctrl-ipq4019.c
index 6ede3149b6e17..07df812fb7282 100644
--- a/drivers/pinctrl/qcom/pinctrl-ipq4019.c
+++ b/drivers/pinctrl/qcom/pinctrl-ipq4019.c
@@ -480,7 +480,7 @@ static const struct pinfunction ipq4019_functions[] = {
 	QCA_PIN_FUNCTION(blsp_uart0),
 	QCA_PIN_FUNCTION(blsp_uart1),
 	QCA_PIN_FUNCTION(chip_rst),
-	QCA_PIN_FUNCTION(gpio),
+	QCA_GPIO_PIN_FUNCTION(gpio),
 	QCA_PIN_FUNCTION(i2s_rx),
 	QCA_PIN_FUNCTION(i2s_spdif_in),
 	QCA_PIN_FUNCTION(i2s_spdif_out),
diff --git a/drivers/pinctrl/qcom/pinctrl-msm.h b/drivers/pinctrl/qcom/pinctrl-msm.h
index 4625fa5320a95..120217012a9f6 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.h
+++ b/drivers/pinctrl/qcom/pinctrl-msm.h
@@ -39,6 +39,11 @@ struct pinctrl_pin_desc;
 					fname##_groups,		\
 					ARRAY_SIZE(fname##_groups))
 
+#define QCA_GPIO_PIN_FUNCTION(fname)				\
+	[qca_mux_##fname] = PINCTRL_GPIO_PINFUNCTION(#fname,	\
+					fname##_groups,		\
+					ARRAY_SIZE(fname##_groups))
+
 /**
  * struct msm_pingroup - Qualcomm pingroup definition
  * @grp:                  Generic data of the pin group (name and pins)
-- 
2.53.0



