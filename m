Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A458178381;
	Tue,  2 Jul 2024 17:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719939970; cv=none; b=fa1MpLVfDXjC0O1s/CV+rp8zkl03vV/tUK3Md88Dx8+Alrs8XUlFFyOU6xLaENGo1y4MFCWAh8WwlkWVaRhlStWVIDsnAmD0QtrepwFY0KtMtuWuJDw4WCaGKDznso21uZ9kwAFnT7YfZsIDo/GQwnc5g6f45FY+KQmVw2iteDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719939970; c=relaxed/simple;
	bh=ZvhtFvmwyyUhEvR5aoZZ1LLs/ov4Vzgu6MwGIrhUqWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHruE4UaAi8hqw28HkvnTgGrRhJ0+8MdMd1QSAhLM2VxHDu/bC/BV0Vj8oHC/cmolb9mMch7Re55b0+FMOSWjYuNa2+JtSM5yLhVrQWE1ylwYLwG+mkVUq62oXZ5merJ6sNYXiskYKtCwqlLUFbr1B4lxnaLgiEulEiej5cg9UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6/rcnjY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6/rcnjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDA5C116B1;
	Tue,  2 Jul 2024 17:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719939970;
	bh=ZvhtFvmwyyUhEvR5aoZZ1LLs/ov4Vzgu6MwGIrhUqWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6/rcnjY2rfU/4PsIGuiy3emvxYFyOVM5gc/GlD3FtcL7koIVDdnHdj6UdqHouBNG
	 UAsizcHYRs9S4OKXEAP0IJ4duR7qTPFCpQ/jeF5bBkGRQeUE5RaE58feIXlVJWZjlS
	 t5gWgKEDx9U4XfY2TNJSHDx8DYA7FoJSuX/Aej0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	Hagar Hemdan <hagarhem@amazon.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 005/222] pinctrl: fix deadlock in create_pinctrl() when handling -EPROBE_DEFER
Date: Tue,  2 Jul 2024 19:00:43 +0200
Message-ID: <20240702170244.175627168@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hagar Hemdan <hagarhem@amazon.com>

[ Upstream commit adec57ff8e66aee632f3dd1f93787c13d112b7a1 ]

In create_pinctrl(), pinctrl_maps_mutex is acquired before calling
add_setting(). If add_setting() returns -EPROBE_DEFER, create_pinctrl()
calls pinctrl_free(). However, pinctrl_free() attempts to acquire
pinctrl_maps_mutex, which is already held by create_pinctrl(), leading to
a potential deadlock.

This patch resolves the issue by releasing pinctrl_maps_mutex before
calling pinctrl_free(), preventing the deadlock.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Fixes: 42fed7ba44e4 ("pinctrl: move subsystem mutex to pinctrl_dev struct")
Suggested-by: Maximilian Heyne <mheyne@amazon.de>
Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
Link: https://lore.kernel.org/r/20240604085838.3344-1-hagarhem@amazon.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index cffeb869130dd..f424a57f00136 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1106,8 +1106,8 @@ static struct pinctrl *create_pinctrl(struct device *dev,
 		 * an -EPROBE_DEFER later, as that is the worst case.
 		 */
 		if (ret == -EPROBE_DEFER) {
-			pinctrl_free(p, false);
 			mutex_unlock(&pinctrl_maps_mutex);
+			pinctrl_free(p, false);
 			return ERR_PTR(ret);
 		}
 	}
-- 
2.43.0



