Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0540186E4B;
	Tue, 10 Sep 2024 09:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961462; cv=none; b=fR21aSYRi6fS+7b/b+afKGOw3wfPMa+e2zrz3PJvLPVJ+GsOiBEZniDLaVWzQaikSMjb4BBkPIGxZC6S5I8kqqv2hvWMLoMqtm0YhSFG9b/CRi7YriO/aYUe0AToVYkxc0rgSBOI7Mq2nSDkuPsonwaH4G9ZVpKXQiPemacfDAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961462; c=relaxed/simple;
	bh=iMmmk7j12qrZtUQHGeO/HluJ7znfWYu8kY+H4nXz8M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqmNV/TW186juuvNO8do6jJpbS7bYRp8ei34i9xU7QeK7JiMwMamwmFGJm6hZd+7nQ/HuKR1XPhnSXMWPxgkZWe/Dr4KG7Sj8LVgato4eF1kTUgHG9z7b7qwpp6AYz7OhIfmepZuGUcDGac9WyP8y5rlVpRpCaQA8Yqc3byl1SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmXaSO3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmXaSO3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A52EC4CEC3;
	Tue, 10 Sep 2024 09:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961461;
	bh=iMmmk7j12qrZtUQHGeO/HluJ7znfWYu8kY+H4nXz8M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmXaSO3nQt7qBW2htwa8Aw+xBFejJW91lMa/Dc7CJWEvmRiLS0eqi22HIL6+ju1nb
	 57kTGnVMRPiSrNxDnpwPtuGoNzVslCvERSpMbqyX8hTdUCC+4a18bdAwO0/hsg81Rx
	 0j8xTMQ+FOpxLbMNA/mYGhs9H0tTDuQr154vu75Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.10 051/375] pinctrl: qcom: x1e80100: Bypass PDC wakeup parent for now
Date: Tue, 10 Sep 2024 11:27:28 +0200
Message-ID: <20240910092623.953986727@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 602cb14e310a7a32c4f27d1f16c4614c790c7f6f upstream.

On X1E80100, GPIO interrupts for wakeup-capable pins have been broken since
the introduction of the pinctrl driver. This prevents keyboard and touchpad
from working on most of the X1E laptops. So far we have worked around this
by manually building a kernel with the "wakeup-parent" removed from the
pinctrl node in the device tree, but we cannot expect all users to do that.

Implement a similar workaround in the driver by clearing the wakeirq_map
for X1E80100. This avoids using the PDC wakeup parent for all GPIOs
and handles the interrupts directly in the pinctrl driver instead.

The PDC driver needs additional changes to support X1E80100 properly.
Adding a workaround separately first allows to land the necessary PDC
changes through the normal release cycle, while still solving the more
critical problem with keyboard and touchpad on the current stable kernel
versions. Bypassing the PDC is enough for now, because we have not yet
enabled the deep idle states where using the PDC becomes necessary.

Cc: stable@vger.kernel.org
Fixes: 05e4941d97ef ("pinctrl: qcom: Add X1E80100 pinctrl driver")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konradybcio@kernel.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/20240830-x1e80100-bypass-pdc-v1-1-d4c00be0c3e3@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/qcom/pinctrl-x1e80100.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-x1e80100.c b/drivers/pinctrl/qcom/pinctrl-x1e80100.c
index 65ed933f05ce..abfcdd3da9e8 100644
--- a/drivers/pinctrl/qcom/pinctrl-x1e80100.c
+++ b/drivers/pinctrl/qcom/pinctrl-x1e80100.c
@@ -1839,7 +1839,9 @@ static const struct msm_pinctrl_soc_data x1e80100_pinctrl = {
 	.ngroups = ARRAY_SIZE(x1e80100_groups),
 	.ngpios = 239,
 	.wakeirq_map = x1e80100_pdc_map,
-	.nwakeirq_map = ARRAY_SIZE(x1e80100_pdc_map),
+	/* TODO: Enabling PDC currently breaks GPIO interrupts */
+	.nwakeirq_map = 0,
+	/* .nwakeirq_map = ARRAY_SIZE(x1e80100_pdc_map), */
 	.egpio_func = 9,
 };
 
-- 
2.46.0



