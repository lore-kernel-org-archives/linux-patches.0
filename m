Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A71E4C97;
	Tue, 11 Nov 2025 00:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822734; cv=none; b=tzwQ27diD6NoByI41qnOt22VNzSGaAgyW/vTCZzLMc+XrsJregDrjzTxk5gKqAAsGhd89wjuBz/8QAgnSTvaTCVBS1xvxE9/M/DqF2NIZlpThxV5Mq5Qhfvw3g020jI8CobKl8m0UdzCMS9Jez9SYW8I+3okazUW5XgesPEo7mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822734; c=relaxed/simple;
	bh=4kzeAaUcBpRCC+u/J2SFN6DVkbDQkxY2KAmL4kYpoFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWTQowAnG3dBFibTtX0V+9T+xFSmvIDQ9PJYTssoxmw4McmwllF+lCckqccap6E+DCVyh44nsAbgg/Smgo3Yv1IDUe5KB+G0XCE+YQykOEKWvniT5v+edABsaakzYOKyE1EZA+SiT3uKN9wqgzqUuivVXBumBynoeJ0QSHIxSbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BR/7H2l2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BR/7H2l2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADE7C4CEF5;
	Tue, 11 Nov 2025 00:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822734;
	bh=4kzeAaUcBpRCC+u/J2SFN6DVkbDQkxY2KAmL4kYpoFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BR/7H2l2vIupn3+AbXHvfbpvNvCt0djYcZQyxK+boZk36zlZWa19woS55bu15e81H
	 3TpoorGfC9afeV5mcypnXhuY9y7mMoXNRshCYx5HWntx3pbj54Lz2CWQKhv1B0S+a2
	 0LQUfnjJtV33aaFiStbEuhMPM8NyrmDc4DlsinM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhang <chizhang@asrmicro.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 126/849] pinctrl: single: fix bias pull up/down handling in pin_config_set
Date: Tue, 11 Nov 2025 09:34:56 +0900
Message-ID: <20251111004539.442149566@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chi Zhang <chizhang@asrmicro.com>

[ Upstream commit 236152dd9b1675a35eee912e79e6c57ca6b6732f ]

In the pin_config_set function, when handling PIN_CONFIG_BIAS_PULL_DOWN or
PIN_CONFIG_BIAS_PULL_UP, the function calls pcs_pinconf_clear_bias()
which writes the register. However, the subsequent operations continue
using the stale 'data' value from before the register write, effectively
causing the bias clear operation to be overwritten and not take effect.

Fix this by reading the 'data' value from the register after calling
pcs_pinconf_clear_bias().

This bug seems to have existed when this code was first merged in commit
9dddb4df90d1 ("pinctrl: single: support generic pinconf").

Signed-off-by: Chi Zhang <chizhang@asrmicro.com>
Link: https://lore.kernel.org/20250807062038.13610-1-chizhang@asrmicro.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 5cda6201b60f5..8aedee2720bcb 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -589,8 +589,10 @@ static int pcs_pinconf_set(struct pinctrl_dev *pctldev,
 			/* 4 parameters */
 			case PIN_CONFIG_BIAS_PULL_DOWN:
 			case PIN_CONFIG_BIAS_PULL_UP:
-				if (arg)
+				if (arg) {
 					pcs_pinconf_clear_bias(pctldev, pin);
+					data = pcs->read(pcs->base + offset);
+				}
 				fallthrough;
 			case PIN_CONFIG_INPUT_SCHMITT_ENABLE:
 				data &= ~func->conf[i].mask;
-- 
2.51.0



