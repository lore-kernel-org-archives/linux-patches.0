Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5908A257854;
	Thu, 28 May 2026 20:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999726; cv=none; b=YFyhxstK+4OIjRIn+JDiWSP99Y/FDGhZTap4HSEBvlLnyfZyGm1jL9FCEef1dLhG1AJ9aLcHAjsxB6RWmSlA2P73oNANc3OIkuZpMZEa3cXrqq6xwdUeQ6aPW/8O1Yq5Lvwmsv+IcsCNf5KOPJchMoXKl5AuBpeLhc1qkIZ2QvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999726; c=relaxed/simple;
	bh=/HrN/Ql9nNuJukmOePSbnpipZvWvExzyKR6FZ7DuO8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7GUXq7DmmRjlTN9996QlSBpGMJS+K4kuD/Hv7O/9kQvqJSlEkF1xy+vibmKAt/V8+F1TRMMIKQVk6UKYg5FKOqojLLUt+U2WAPdeJucgfP2X9s3d8Salyo/kHyDfXKF4ltZxnY+dNGf0wStLeCqWQjFljG+/KH7eyywzwLGnD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dC25Q62q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dC25Q62q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69E71F000E9;
	Thu, 28 May 2026 20:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999725;
	bh=3aAHhNuUOUfBxJTXI2f0V3pXscXWm8pHzC3/JZjqKP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dC25Q62q0ih3UDRO2Q03DVdxh5eRLVSDwVkHBKSCQc5ZGHXF7F/NCZ9s+SLA4HagT
	 SZtNHv03casIn6ALwwuEteKiXl5K01ZZgm+xGU2GqgOG9IP+h6Ke6WozYJT38kO361
	 0O4SmXsPuoRZZFoyhEDnuo9hsPAK3DnDWXIjo4i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Til Kaiser <mail@tk154.de>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 170/377] pinctrl: qcom: ipq4019: mark gpio as a GPIO pin function
Date: Thu, 28 May 2026 21:46:48 +0200
Message-ID: <20260528194643.353109235@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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



