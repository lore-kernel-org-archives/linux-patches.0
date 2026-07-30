Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F63397937;
	Thu, 30 Jul 2026 16:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428275; cv=none; b=G5WuiskCFRgZAbFbL/0HZ7aYrYCroKplbF+oimaCwi2QhT3UNo77AFjVEys/bqRy67/PaO/YoQA2BgjUM/hBZ9amQQzD3m+XOrfDWk5rDi7D/Qw8nwuzuQ1qUC8NViIvNpxGVKLNyJ9EiZ9BGO1zmI7sJfZz9BtyFH+BbMr5Hw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428275; c=relaxed/simple;
	bh=rSNNUPnrEBlB8UvdD4+0GPVs6e+ubMhFl4yPnnUwq68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDic3uDTVpXKM+xM1VP3Kkf+OG98Fzu6nF806CUd7frO+CnC/PYd3/ByXO13QLStQ2QgtFJ2iX/PmC5CMWNnFSoe1N8LxACc2lod63tqyHbcEuCfkrYmdlJ0eBX597kPCYJVhTZG6HB6/6aQSRA5jImgB60Bvmp1hX+h8k/tcf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSQgyjWX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSQgyjWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201EE1F000E9;
	Thu, 30 Jul 2026 16:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428273;
	bh=anRwxFPWbpcaBk2tTwOyRPK8d6F1NC7EPTq3yvPncqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mSQgyjWXugjuWfQC2ogYq63gFUSzdMr2YwQIKuzsuv278AzlV4fMxd2pwWc84s8PJ
	 fmbDoUSKD0QSB5k9o9MzXVGfeaaRRpo4ST9QdOhHl5WsBm/fAnD6qudMV6GT84ULeu
	 LvrbXYWcOsQCruYev7VQYzuaUPMDiW8KpsaqURU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 462/484] gpio: tegra: do not call pinctrl for GPIO direction
Date: Thu, 30 Jul 2026 16:15:59 +0200
Message-ID: <20260730141433.521819593@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit d3e91a95b2b0fc6336dbf3ec90d831a1654d2720 ]

tegra_gpio_direction_input() and tegra_gpio_direction_output() already
program the GPIO controller direction registers directly. The additional
pinctrl_gpio_direction_input/output() calls do not add a Tegra pinctrl
operation, because the Tegra pinmux ops provide GPIO request/free
handling but no gpio_set_direction hook.

The extra call still enters the pinctrl core and takes pctldev->mutex.
Shared GPIO users can call the direction path while holding their
per-line spinlock, so this otherwise redundant pinctrl direction call can
sleep in an atomic context.

This was found by our static analysis tool and then confirmed by manual
review of tegra_gpio_probe(), the Tegra GPIO direction callbacks and the
Tegra pinctrl ops. The reviewed path has a default non-sleeping
struct gpio_chip while the direction callback still enters the pinctrl
mutex path.

A directed runtime validation kept the same non-sleeping chip registration
and drove:

  gpio_shared_proxy_direction_output()
  gpiod_direction_output_raw_commit()
  tegra_gpio_direction_output()
  pinctrl_gpio_direction_output()

Lockdep reported a sleep-in-atomic warning with the shared GPIO spinlock
held and pinctrl_get_device_gpio_range() plus tegra_gpio_direction_output()
on the stack.

Do not mark the whole chip as can_sleep to paper over this: can_sleep
describes whether get()/set() may sleep, and Tegra value access is MMIO.
Remove the redundant pinctrl direction calls and keep pinctrl involvement
in the existing request/free path.

Fixes: 11da90541283 ("gpio: tegra: Fix offset of pinctrl calls")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260619152439.1239561-1-runyu.xiao@seu.edu.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-tegra.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

--- a/drivers/gpio/gpio-tegra.c
+++ b/drivers/gpio/gpio-tegra.c
@@ -174,18 +174,11 @@ static int tegra_gpio_direction_input(st
 				      unsigned int offset)
 {
 	struct tegra_gpio_info *tgi = gpiochip_get_data(chip);
-	int ret;
 
 	tegra_gpio_mask_write(tgi, GPIO_MSK_OE(tgi, offset), offset, 0);
 	tegra_gpio_enable(tgi, offset);
 
-	ret = pinctrl_gpio_direction_input(chip, offset);
-	if (ret < 0)
-		dev_err(tgi->dev,
-			"Failed to set pinctrl input direction of GPIO %d: %d",
-			 chip->base + offset, ret);
-
-	return ret;
+	return 0;
 }
 
 static int tegra_gpio_direction_output(struct gpio_chip *chip,
@@ -193,19 +186,12 @@ static int tegra_gpio_direction_output(s
 				       int value)
 {
 	struct tegra_gpio_info *tgi = gpiochip_get_data(chip);
-	int ret;
 
 	tegra_gpio_set(chip, offset, value);
 	tegra_gpio_mask_write(tgi, GPIO_MSK_OE(tgi, offset), offset, 1);
 	tegra_gpio_enable(tgi, offset);
 
-	ret = pinctrl_gpio_direction_output(chip, offset);
-	if (ret < 0)
-		dev_err(tgi->dev,
-			"Failed to set pinctrl output direction of GPIO %d: %d",
-			 chip->base + offset, ret);
-
-	return ret;
+	return 0;
 }
 
 static int tegra_gpio_get_direction(struct gpio_chip *chip,


