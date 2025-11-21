Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6E8349B14;
	Fri, 21 Nov 2025 13:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732365; cv=none; b=KHI/CNOK7lESEB813V6n8BbUBzBZZLwgBFv6CffO0u3tueJbW9yWLEfG7bhU/ME292cvvLzf6WgxnAfUsA3NwhkWj5YDfHaFYs+lRv0w5JhQ9JCpDBbRUQgMtMBVOeARt47m2/HN9tKvipWmuEirWT41qMQCs4UnN78vi3SP3pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732365; c=relaxed/simple;
	bh=BCkXS3W59Y7Ioe0nLk1PIRk/97Cn2FD9MXu0Qvoq3ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkAQ97n8P0+hybIjHDkSqZ1XmPLvqZfyMrTcaqX6b9mStf03G0BiJJ/cL9TJ7I+lJ4Evxjjdb4QpsZQ/j4WvZ2CA7mx6S5RD/3It884fKdRiUv0QHfDx4UzcbOMWYGhQvIlfPZVEHdMUCA5ddhS1tFSgv/+eV8m4tqQ2M9kaEHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qrunLXKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrunLXKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C9CC4CEF1;
	Fri, 21 Nov 2025 13:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732364;
	bh=BCkXS3W59Y7Ioe0nLk1PIRk/97Cn2FD9MXu0Qvoq3ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qrunLXKZ0gc7yjNKj5CezwCHqoDGykPsL+AjAQAuR39hL6QqFWq8TmS+fg9rVgPkr
	 FQFvtx8lPqICxXuDZChZzn8OCqKQE4JwBxDmGzHrWlAKNE7m2/Cjmm/FBVz3EAYh8O
	 V8KrGhhFsh0xEylBzVrsykzuOmikEoSsei3139z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhang <chizhang@asrmicro.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/529] pinctrl: single: fix bias pull up/down handling in pin_config_set
Date: Fri, 21 Nov 2025 14:06:01 +0100
Message-ID: <20251121130233.231624613@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6c670203b3ac2..7684039be10cb 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -587,8 +587,10 @@ static int pcs_pinconf_set(struct pinctrl_dev *pctldev,
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



