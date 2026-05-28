Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A732533F5B4;
	Thu, 28 May 2026 20:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999261; cv=none; b=ScKrwoiNxQUox+0EWkn1oBMIKiO5pBou6JrKaLPOvqwxlktWw3Fleip0VmQ6hN3HJmCrp2WZKaaTip9sQ3c97a8NspbaB37qe+Bu3KgmXKTfhhqOf7Hk4ZQkbmdg/QSkCCgHf24yVMX0LnFAiXAnuRwfOjbJJAfwZ1ZC37QFU20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999261; c=relaxed/simple;
	bh=Ae2Vj5fitDAOURcT0WO67QrsRYSw6nzgbfxkPjRwGB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GE/B2qtALCrP5811Erpn4ZZT2DGKEbABSYX4XeOt03vvIH4IEtEDnvBbFW+qH3GtiH/3JviETcLuceu31j/qcltprzyYz9mlaw/f3mSTso5r9POE6w1fvjhfcyzT7ahgPoItZqmWjeLDmR4+IYr0YsYq98H47/KjMBZzCu3SoOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbhWz+RB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbhWz+RB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F121F000E9;
	Thu, 28 May 2026 20:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999260;
	bh=oPT+13V/1uD7zJ4rB+ZelOVjsjh8KubihD7lOPUS3Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MbhWz+RBjt7DUk9iB20XS9XUT54DHpbC0JdJ4Zkn9nhpYPpIR5pKPw2TZT+qDLwQ+
	 4ZqGQnaBdkUZ+xlhgXLa5SUJ/BOS+lvyDDsiTNoNowfyQBNL755N9MfMCvWSMjWj2f
	 E/9c0LcxDUHyRHqXxFQYziEJgu26B36XNWC5ZsL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 436/461] gpio: cdev: check if uAPI v2 config attributes are correctly zeroed
Date: Thu, 28 May 2026 21:49:25 +0200
Message-ID: <20260528194700.150560798@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit 3e6ccd790ed69bedd3d9626d01dd35cf9821c121 ]

We check the padding of other uAPI v2 structures but not that of line
config attributes. For used attributes: check if their padding is
zeroed, for unused: check if the entire structure is zeroed.

Fixes: 3c0d9c635ae2 ("gpiolib: cdev: support GPIO_V2_GET_LINE_IOCTL and GPIO_V2_LINE_GET_VALUES_IOCTL")
Reviewed-by: Kent Gibson <warthog618@gmail.com>
Link: https://patch.msgid.link/20260521-gpio-cdev-attr-padding-check-v3-1-ec3bcbe2e358@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index 73ae77f0f2133..78df6d517d307 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1184,6 +1184,7 @@ static int gpio_v2_line_flags_validate(u64 flags)
 static int gpio_v2_line_config_validate(struct gpio_v2_line_config *lc,
 					unsigned int num_lines)
 {
+	size_t unused_attrs;
 	unsigned int i;
 	u64 flags;
 	int ret;
@@ -1191,9 +1192,21 @@ static int gpio_v2_line_config_validate(struct gpio_v2_line_config *lc,
 	if (lc->num_attrs > GPIO_V2_LINE_NUM_ATTRS_MAX)
 		return -EINVAL;
 
+	unused_attrs = GPIO_V2_LINE_NUM_ATTRS_MAX - lc->num_attrs;
+
 	if (!mem_is_zero(lc->padding, sizeof(lc->padding)))
 		return -EINVAL;
 
+	for (i = 0; i < lc->num_attrs; i++) {
+		if (lc->attrs[i].attr.padding != 0)
+			return -EINVAL;
+	}
+
+	if (unused_attrs) {
+		if (!mem_is_zero(&lc->attrs[lc->num_attrs], unused_attrs * sizeof(*lc->attrs)))
+			return -EINVAL;
+	}
+
 	for (i = 0; i < num_lines; i++) {
 		flags = gpio_v2_line_config_flags(lc, i);
 		ret = gpio_v2_line_flags_validate(flags);
-- 
2.53.0



