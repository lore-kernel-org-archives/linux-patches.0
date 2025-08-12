Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7837320E023;
	Tue, 12 Aug 2025 19:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026235; cv=none; b=O9Rzfk0Umlia7KFuKhLGyAv9laXwgCa7GMFLKeHQWyD89JzLX31cK8RlMeC9RoESJ1JtJ1pWdi08DNPRt6zwaiOhNOlB1F5geNu7YII/qMmN6MBH/qqdgWXP4q7CDA2n26hhPearTuvdKyU8usb6+FzExJGloWPI9yP3sd5FtLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026235; c=relaxed/simple;
	bh=y/2TLpQ2XRmeqgCBJoTYPykwyyWGXJLUvqcOrfMIXd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnD6LbWCH3SfkP+mVrGlY2wiIgLDqNviI2QnIOltX65SQQ9lbcymqL6adgmRJlqniOubC+9NLuHUyKrMmVXrSiv3izjrRuc4Ms7+QrmLRPDpA8rfbtjbPRLUnJ6Iu+OcDPSuPcsX7VR5Q7LJlDzz394LaVPsU7B1SLqdMbeQo7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9MjbyIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9MjbyIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC207C4CEF0;
	Tue, 12 Aug 2025 19:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026235;
	bh=y/2TLpQ2XRmeqgCBJoTYPykwyyWGXJLUvqcOrfMIXd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9MjbyIFWsWt7bLUi3Mdsy8VUEKNUTDroNwBzVEzn4vl5MFLtl2fzISLvFv77WNt+
	 3jKNrT2D4jfhnqXWAYM6Tds4tjFbLF69FSqqNgBGD+l2+BKiV+ZaBBOIN6Dg8GD0XP
	 5qpxm9AOlo4+EQD2sugv6NH533Dvemteolx9Qivk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 277/480] pinmux: fix race causing mux_owner NULL with active mux_usecount
Date: Tue, 12 Aug 2025 19:48:05 +0200
Message-ID: <20250812174408.862585767@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit 0b075c011032f88d1cfde3b45d6dcf08b44140eb ]

commit 5a3e85c3c397 ("pinmux: Use sequential access to access
desc->pinmux data") tried to address the issue when two client of the
same gpio calls pinctrl_select_state() for the same functionality, was
resulting in NULL pointer issue while accessing desc->mux_owner.
However, issue was not completely fixed due to the way it was handled
and it can still result in the same NULL pointer.

The issue occurs due to the following interleaving:

     cpu0 (process A)                   cpu1 (process B)

      pin_request() {                   pin_free() {

                                         mutex_lock()
                                         desc->mux_usecount--; //becomes 0
                                         ..
                                         mutex_unlock()

  mutex_lock(desc->mux)
  desc->mux_usecount++; // becomes 1
  desc->mux_owner = owner;
  mutex_unlock(desc->mux)

                                         mutex_lock(desc->mux)
                                         desc->mux_owner = NULL;
                                         mutex_unlock(desc->mux)

This sequence leads to a state where the pin appears to be in use
(`mux_usecount == 1`) but has no owner (`mux_owner == NULL`), which can
cause NULL pointer on next pin_request on the same pin.

Ensure that updates to mux_usecount and mux_owner are performed
atomically under the same lock. Only clear mux_owner when mux_usecount
reaches zero and no new owner has been assigned.

Fixes: 5a3e85c3c397 ("pinmux: Use sequential access to access desc->pinmux data")
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Link: https://lore.kernel.org/20250708-pinmux-race-fix-v2-1-8ae9e8a0d1a1@oss.qualcomm.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinmux.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 0743190da59e..2c31e7f2a27a 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -236,18 +236,7 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 			if (desc->mux_usecount)
 				return NULL;
 		}
-	}
-
-	/*
-	 * If there is no kind of request function for the pin we just assume
-	 * we got it by default and proceed.
-	 */
-	if (gpio_range && ops->gpio_disable_free)
-		ops->gpio_disable_free(pctldev, gpio_range, pin);
-	else if (ops->free)
-		ops->free(pctldev, pin);
 
-	scoped_guard(mutex, &desc->mux_lock) {
 		if (gpio_range) {
 			owner = desc->gpio_owner;
 			desc->gpio_owner = NULL;
@@ -258,6 +247,15 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 		}
 	}
 
+	/*
+	 * If there is no kind of request function for the pin we just assume
+	 * we got it by default and proceed.
+	 */
+	if (gpio_range && ops->gpio_disable_free)
+		ops->gpio_disable_free(pctldev, gpio_range, pin);
+	else if (ops->free)
+		ops->free(pctldev, pin);
+
 	module_put(pctldev->owner);
 
 	return owner;
-- 
2.39.5



