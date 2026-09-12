Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26C7416842;
	Sat, 12 Sep 2026 16:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228949; cv=none; b=BrLZrKtYcV1iEAFrwg5IqS8mUYsjacp+iwIuGgvxJ34WBvTxfFNZDgrZPVEFLFJSr/jNGQBNDtBn/WAw7QM2kkvebExN8UA7n+ikzMUNkQjczxcPY0YMCos1DFfH+6EhOcFfX2hUTueIhqYqrr+sLQYHu7exeKQ65/P/kUOubys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228949; c=relaxed/simple;
	bh=pwC0kbYPq77sNLbhPp8REr5u2gwSGJ320DP3uyGpcr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8EKGIM2q7MGmXGDrbAgbIABNJ+/heVuCoRmDpeHHWsmOWJnDyq0e7IGszEc5ir2/8pq//qtIbKmOJQ0MEfDZF03P6DhuoQtjoG0x7IxiQ/LSmrJZtGLCQwUiXTV8W4+8IRBICq1lkz4wItJ2BBHkv6rmv2FikmQe8M8xpUOe/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpyuiUnq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpyuiUnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60F91F000FF;
	Sat, 12 Sep 2026 16:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228948;
	bh=VDyPJwxaSudGhrj7gB1Rj6z7B7SQDjf9BMpPKT1TVNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BpyuiUnqsl64je4Iu43+0d61ldIgj+jF5iBwVdWfQGaioCPRMpcJFnEuWsP/soBf8
	 +UY/eGHy5upjSyDw7VrBfKogMbivQqUld/vkBpi/xhF6g84wjzQtKHzidFp7AnM+tr
	 vPPdFvgLDLGoBiMbs87ypRccHMPw3zFIwstrtuSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel McCarthy <daniel@dragonzap.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0490/1191] pinctrl: bcm2835: Dont remove an unregistered GPIO chip
Date: Sat, 12 Sep 2026 08:53:38 +0200
Message-ID: <20260912065559.235984829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Daniel McCarthy <daniel@dragonzap.com>

[ Upstream commit 32711f77db0641e57fd96fdc013bf1286b9f2514 ]

If the devm_pinctrl_register() function fails,
bcm2835_pinctrl_probe() calls gpiochip_remove()
before gpiochip_add_data() has registered the GPIO chip.

This means that upon failure the gpio_chip.gpiodev
 is NULL resulting in a null pointer dereference
inside the gpiochip_remove() function.

Remove the unnecessary function call to gpiochip_remove().
No GPIO cleanup is required because the GPIO chip
has not yet been registered. Without this change there
is potential for a kernel panic upon registration failure

Fixes: 266423e60ea1 ("pinctrl: bcm2835: Change init order for gpio hogs")
Signed-off-by: Daniel McCarthy <daniel@dragonzap.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
index fe8da3ccb0b5a..526465e1a8fb0 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -1280,7 +1280,6 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 	pc->pctl_desc = *pdata->pctl_desc;
 	pc->pctl_dev = devm_pinctrl_register(dev, &pc->pctl_desc, pc);
 	if (IS_ERR(pc->pctl_dev)) {
-		gpiochip_remove(&pc->gpio_chip);
 		return PTR_ERR(pc->pctl_dev);
 	}
 
-- 
2.53.0



