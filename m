Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9788E1DF258;
	Tue, 11 Nov 2025 00:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822729; cv=none; b=Oms+OYSRAATqByGO2eTElcKlr8rOEI5SjFSmKL6qI292ymZ55nblHu4h3Ou6+rNseFJYWpANCSlnmhMX76wkTqTSEjbD2YiXHmSoh+Iu1++4KZhz1fJR8PMU7LTh8s2S+u9XxEYRGih1zly8AHXRwPmRr1cAvqXogwtaeZso8G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822729; c=relaxed/simple;
	bh=veSxS2/p+4W52PS5nnNDJd6mepwFj2Qk19P0Y/6Bc4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gb3m8puWguFqGXhh4iiMkaR1KkIlE3bpGiiK/YZGCwaP+lUr4k3Q70FsLZtoDMCRzHZHZ5xlNQCkaN2d7E7Wp9wm5uzj/VHlGgncwYU6fC9zds689qYYbSxiAibbNAwGt9/yFyrOzdgKIMcDFnhAYCMn/2Q8X+hWHyPJ0/p0VaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cncpiU2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cncpiU2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D14C113D0;
	Tue, 11 Nov 2025 00:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822729;
	bh=veSxS2/p+4W52PS5nnNDJd6mepwFj2Qk19P0Y/6Bc4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cncpiU2/XwhG9WuafdXqvRYX9Y9HbONDbXaLc108+AcqdZp960dEVJkVIo0Ubc9Q9
	 0knR2WddpofA9jVJT2lCPNpWsIjc5eBcfCl2n2jLG/0A4raUpsptvLm4H7h28TthMM
	 u2p4rLJd3I8Q+oI93RrxmgCxULHTP6AcGlP/+mLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhang <chizhang@asrmicro.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/565] pinctrl: single: fix bias pull up/down handling in pin_config_set
Date: Tue, 11 Nov 2025 09:39:10 +0900
Message-ID: <20251111004529.076394804@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2ec599e383e4b..1df0a00ae1ee8 100644
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



