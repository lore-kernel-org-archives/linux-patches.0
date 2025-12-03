Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6231B3451B4;
	Wed,  3 Dec 2025 15:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777506; cv=none; b=IyLOvQmsxHdnVbJ9HzFuxmU1aJeHc+2cXjxSUYpifKqXSIBeXQABdy46NL+5tnJPtBkoaOU4CUI6Q2wplz+yM7R3c3IVqaaVi/i7WqY6BA1enbfxjPl7T5s+pkfmf3wVDWkj2dfnykDpQ5lk4Hu6Qv5B/7w4mvC8CIcvJ7sXmDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777506; c=relaxed/simple;
	bh=9CJd6JsUM+v+N7mHRCUEm4O6TxZ4NdAo0g6H99jIhOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQQk0IUPvVy+pyrr96uaxBwNAbiLJkmBPDx8kptBmgIFBi5vkh2D7Yp+CAzoG0W+KYC0BIJGAfQ+78l/bwT9V7CdYaJgKCB36Yk3mUA497L+I+8u6aQRvG/glCCDZrkcxWbESVPfy6gqMKJC8tFSjsgxhQWJseV1c8HuGI78QrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WosGoDR2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WosGoDR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8055C4CEF5;
	Wed,  3 Dec 2025 15:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777505;
	bh=9CJd6JsUM+v+N7mHRCUEm4O6TxZ4NdAo0g6H99jIhOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WosGoDR2UM0+BYm+qt/pg5GH2blNGvZQnkdZJi1rPR+LMvpk1S8gX5SuPMaUIJ4Bm
	 SS3OOjWTGKgqGO6JYb4C1aSz/ldeFFoSK+KkduszSJlIOz/6L5ExLnAV1yZSdO0Zy1
	 m1TWvHMe/Sd1N0/kktnlLSI4BK5jID4ErK9+eRmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhang <chizhang@asrmicro.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/392] pinctrl: single: fix bias pull up/down handling in pin_config_set
Date: Wed,  3 Dec 2025 16:23:28 +0100
Message-ID: <20251203152416.249657279@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



