Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E343469FC;
	Sat, 30 May 2026 17:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162591; cv=none; b=jJLy2imu/FKpu2H4P2qQOCX1/vviHLO/vMikhHcR5/0ysMe9EWiRzSu1+sBCDwVGT56n+ZXp/S+uoWcOh3LdXG+5Hz++Yb230HKKBTi1VI5KI5mVG3DYyKvzVPq1ikFtFOLU8YwjCRlu9NEkna9WMnaJznfbH/MAEVu+NqqKVYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162591; c=relaxed/simple;
	bh=UMBBRZJ7eH4DtoInnP0zPYZHX/SkdR7iZLvrIq9tfm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZmw0AmV68fiHmE9vUb8J2vDgboKCZFHryGCDx0E+4ZtqYlnec2/o5oJ27Nz2ywg+qA6MbpYT4y0qlFbJt6E/bMltAi08oAwI1OD6cMGcAYUySShIYVGDc3AdgHWFhPIov7dGyxkf8jia1ZmC1YquHBQ6a9klmpSZLq3dGal/tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbHSBGya; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbHSBGya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698C91F00893;
	Sat, 30 May 2026 17:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162590;
	bh=UlYfSna2xdFDdTiJZXmYZqTltDSQLFdNsCjO9+lVKBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GbHSBGya7+hooLx7p0v9VEgixK7JbLx18ZF7nsA667CGevwRpWBvKRuSGUHQtMXHN
	 8BMEsoFgA0RjEHxM7c4JgKG54iXyCUYDW+5gQMpo9LIQ6mb5h+pA7LMrSYohMMp5We
	 LENDfjguNtaLP+iF9NXl8GVy6Xo0PbTbXogoA8hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 967/969] gpio: cdev: check if uAPI v2 config attributes are correctly zeroed
Date: Sat, 30 May 2026 18:08:11 +0200
Message-ID: <20260530160327.484170208@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index 944aa0c1cd5c7..5d4646f0baacd 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1332,6 +1332,7 @@ static int gpio_v2_line_flags_validate(u64 flags)
 static int gpio_v2_line_config_validate(struct gpio_v2_line_config *lc,
 					unsigned int num_lines)
 {
+	size_t unused_attrs;
 	unsigned int i;
 	u64 flags;
 	int ret;
@@ -1339,9 +1340,21 @@ static int gpio_v2_line_config_validate(struct gpio_v2_line_config *lc,
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



