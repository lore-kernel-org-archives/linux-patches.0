Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF898136E2A;
	Wed,  3 Jul 2024 11:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004932; cv=none; b=gKtQEPKnGzxCCTJ0leaqUufGc2Q/SGF7TtGqaboPqlsM8wYrTiVphL+sDGQqoD+XCkzLCt1Uw3k2NQP7q2Ps0NZENdvowpksJcn73tV3KzMZCPgdNVsa46SeePSsNGuKmHB27pcFFcr5ATBXZuVvVosSEa52KKGcvtndB18U72o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004932; c=relaxed/simple;
	bh=p/pgbsExsB1URFbkpeY1vVLrjZPr4ShEZb9zcRCbx8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHzyWcuz4lP/JiZXLpl7PCfVe8RPENJpvPR44xVEFVDdk9zjH57U3fsdx3s02G6t6Zs1cdIFv45tXMTph/vYGFkXuST8/rinP7ftq9FaVU0LDrOeg7LzLz3LJUYeh2v0/hijYGJcovvaNQkBP0+aAgnjH/tMlJnIAeIkTvHlVKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ux0fYTQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ux0fYTQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB32C2BD10;
	Wed,  3 Jul 2024 11:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004931;
	bh=p/pgbsExsB1URFbkpeY1vVLrjZPr4ShEZb9zcRCbx8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ux0fYTQtwGcmshuoEWiZANA9TtZcBFCbVEv1/Ob11xrOvuAN23ePvIowiQHyq2LKa
	 AZ4VEm/fKbBHVN5hNSxnPp32cJQQoYwHL+I9q1QAiE6ifesBxdyPiUulHv7eR/yPLf
	 RcfnBo9r6rLby7toSfP1XMvaiu0mta2pj/PDYy+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	Hagar Hemdan <hagarhem@amazon.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 205/290] pinctrl: fix deadlock in create_pinctrl() when handling -EPROBE_DEFER
Date: Wed,  3 Jul 2024 12:39:46 +0200
Message-ID: <20240703102911.905519724@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ee99dc56c5448..3d44d6f48cc4c 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1092,8 +1092,8 @@ static struct pinctrl *create_pinctrl(struct device *dev,
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



