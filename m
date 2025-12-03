Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC90F15ADB4;
	Wed,  3 Dec 2025 15:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775969; cv=none; b=tgPdbrnZb0I5NErEm6CxTuyXfEt5NXeV08v0UdOl0aoI2iWBjGjHrHtpObl+HzyVlPjx2n4hb2J8s2HixOQ1+0HrXzaRIAkVCPBAidH7+o8MMRfFmamLyrn4XUA2B7dz8q5GeEA1YmCBoAi5rueknlNZsxQdJsfA7UiBm2RZMds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775969; c=relaxed/simple;
	bh=8yrLxUipeICx4ofQkiWhICISu8NtYbTCzNOThM3VdZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2zEv/beMdPFRkb8WBG+3FC71KBs2x9U9haUJQIli8H5B9kdPkyw+qPTquYa/akREY8kPe1fp45egUpmP6t/2HdjMusFXmgLfaH2torVbYjVltiqgKjbT9QsQ7Sxn6oIKCyuwtPHMOnbyjFW27gjg29jMepQl2SiA59DO5Vj1Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WEnzQA8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WEnzQA8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C592EC4CEF5;
	Wed,  3 Dec 2025 15:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775969;
	bh=8yrLxUipeICx4ofQkiWhICISu8NtYbTCzNOThM3VdZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WEnzQA8CkV5xG4qgOI1hT9acOq9UPTyqD1E19y+XI3ghdfXlnTpVRiYyDpqZzKy8+
	 mimffJCk0p4cx0vAZyucKrgfZ1rl83t4N577py/c6L/xOqybqxrbnUdvv6e9sFsGpT
	 RssePj4aV9yYlR1VvdW7mUdOimcokcSyDR/bnTu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhang <chizhang@asrmicro.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/300] pinctrl: single: fix bias pull up/down handling in pin_config_set
Date: Wed,  3 Dec 2025 16:24:06 +0100
Message-ID: <20251203152402.171444507@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 22fd7ebd5cf3f..9485737638b3c 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -586,8 +586,10 @@ static int pcs_pinconf_set(struct pinctrl_dev *pctldev,
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



