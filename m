Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F86133993;
	Thu, 15 Jan 2026 16:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496190; cv=none; b=ZTl7dMyXQon464njng4SDQEjg1CB8/soVzeXWJYtWYj0fI3SFfUwP+oSts3qBMF+0RuUrmc8nVejMJrBZKHm0bCkryWLpONmEF/+8Vv5+Gvqnx/DZKMueOSRpU1a+VZ7qZ7OEDgRbqRorascMQ4fMAwKoP4kCtXEKEMOvepm1Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496190; c=relaxed/simple;
	bh=IicjR46OeqvkVzlS5n6azbwW/ZJ8mZULQg9JMSRPUuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWOUq98j8ggsHLIsZxF6qGqE5JfwEwFy9pmj/AmgFdk2SSlabgoSDqrlFgLeo3EQ9mfQwuewNhO93gzqY87Nx7RcV0lKYGzgBfSbWd1pHkuaIDM7hP5XG+S8BmyYIb6j2z2+3l5R7KXPQrLnzb0T/DHY3YAsQm4Gyid4NJ0vrD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4gtDOpQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4gtDOpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00666C116D0;
	Thu, 15 Jan 2026 16:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496190;
	bh=IicjR46OeqvkVzlS5n6azbwW/ZJ8mZULQg9JMSRPUuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4gtDOpQQoJCyZgLbfLVHJoRYLF1V6558v5Oh4Y/NSKT2jW/D8oM+UAAchfBYPDum
	 zeC/Gy5Pea17jBahBTtZ6L+1rXEAqa4ffEY164EVlgg5+rgEJhNSrXU3GN4HGzjpK3
	 82ScKBuoZpBZithklK1SkmdXcWQfaiMwMvZ1Nh/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 077/181] pinctrl: mediatek: mt8189: restore previous register base name array order
Date: Thu, 15 Jan 2026 17:46:54 +0100
Message-ID: <20260115164205.109107755@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

[ Upstream commit fa917d3d570279dc3d699cbd947d0da0fde2e402 ]

In mt8189-pinctrl driver, a previous commit changed the register base
name array (mt8189_pinctrl_register_base_names) entry name and order to
align it with the same name and order as the "mediatek,mt8189-pinctrl"
devicetree bindings. The new order (by ascending register address) now
causes an issue with MT8189 pinctrl configuration.

MT8189 SoC has multiple base addresses for the pin configuration
registers. Several constant data structures, declaring each pin
configuration, are using PIN_FIELD_BASE() macro which i_base parameter
indicates for a given pin the lookup index in the base register address
array of the driver internal data for the configuration register
read/write accesses. But in practice, this parameter is given a
hardcoded numerical value that corresponds to the expected base
register entry index in mt8189_pinctrl_register_base_names array.
Since this array reordering, the i_base index matching is no more
correct.

So, in order to avoid modifying over a thousand of PIN_FIELD_BASE()
calls, restore previous mt8189_pinctrl_register_base_names entry order.

Fixes: 518919276c41 ("pinctrl: mediatek: mt8189: align register base names to dt-bindings ones")
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mt8189.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mt8189.c b/drivers/pinctrl/mediatek/pinctrl-mt8189.c
index f6a3e584588b0..cd4cdff309a12 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt8189.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt8189.c
@@ -1642,7 +1642,7 @@ static const struct mtk_pin_reg_calc mt8189_reg_cals[PINCTRL_PIN_REG_MAX] = {
 };
 
 static const char * const mt8189_pinctrl_register_base_names[] = {
-	"base", "lm", "rb0", "rb1", "bm0", "bm1", "bm2", "lt0", "lt1", "rt",
+	"base", "bm0", "bm1", "bm2", "lm",  "lt0", "lt1", "rb0", "rb1", "rt",
 };
 
 static const struct mtk_eint_hw mt8189_eint_hw = {
-- 
2.51.0



