Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E866359F84;
	Wed,  3 Dec 2025 16:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778895; cv=none; b=MUsor4IhYMPTbCgl6hjd2Pi5b7dBmxeRM5jPp6jHh4gANAKQDqzEzCwOhzhIJEByQDnSAVImEJhsc+VWS6mOHnFSmwea++kw5NN+yOt0N/mXlOO6acookKJVOKACjw084VOYQo/TqaLz2fsPKsa/GRzB9oXSHbAl4rj9xM+JZ1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778895; c=relaxed/simple;
	bh=50c5H/v3mifslGFAaqls1z7kFSake5Bo5V6aYrM5GV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S75spk+/jih4A3QOhFW0fWpAuqY6ZvoZKsv2VE/k+NCKwqYGWnyfPI8B1qESx60H1PjMa33jaG3mnGVPwg/HHkhXKvUFPZf/i6yo5wM5jhsNunqAJuEvvkZD9rlkMH0RNc7JMCjOFvDpE5AfIExtetFSqvdGhHKW0sLKUrg7HKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osCEiTXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osCEiTXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE79C116B1;
	Wed,  3 Dec 2025 16:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778894;
	bh=50c5H/v3mifslGFAaqls1z7kFSake5Bo5V6aYrM5GV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=osCEiTXwsfQlRzAm1+BrOIMvdPV7an8srIHTOxdmHbMjqkFXlnGdYNUBzEE++So6o
	 L8JvVBinvUKdNIN4LfGnikzOy0yftCmfkYHYFdiuIMRab1aZ5G4TZlhxH4wyxp5MVq
	 3KNQIhSb/GLfR4Mn95Bxc6dUDfkJ/x0cLIv0eStU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhang <chizhang@asrmicro.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/568] pinctrl: single: fix bias pull up/down handling in pin_config_set
Date: Wed,  3 Dec 2025 16:21:34 +0100
Message-ID: <20251203152444.107555143@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 28f3fabc72e30..a72911e8ea82d 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -588,8 +588,10 @@ static int pcs_pinconf_set(struct pinctrl_dev *pctldev,
 				break;
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



