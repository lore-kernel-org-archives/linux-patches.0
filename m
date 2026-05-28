Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B525D2E7379;
	Thu, 28 May 2026 20:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001055; cv=none; b=RWZ5m6+ZGHXaDz6NeEX1FxJdoTMCEf0khCek14bdd7O4whMb+uWMfA+UU1o4mlQo/jh1fV3etKN/+Sw0J8E42qMsS++VB4ZTHyW0ep9bi3/m+y1HnC2o9kxZLKHufrisC+fYtqdQPsjm5wjrApA0wSsy8T4qp6RNd3CPh5cnAkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001055; c=relaxed/simple;
	bh=nhTtPaNsgyRLlOc65udxEFKk8KeSSRn5K6O9mdor8e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQJYdki1qLEazqP/mphGTwyM46l8e2UKIKghF1VjT9YFau2FyHw+GcjdU8dEEwy4vp5KMMDKoIwjdrIIMk+Q+YxUox8sAdn0RxyiPXHmeqOmjBtac71bwggtVmt9nOcf28BjFuFRn6Hyqt/t9l/dqJm2jJCyzdH3I84gq27tpfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2ilVjkt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2ilVjkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A271D1F000E9;
	Thu, 28 May 2026 20:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001054;
	bh=faIrnP6L5zskAGOQuhcxj0Q5lGOR2c4fgsLnoMXUp2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2ilVjktTNtGShaO4msJsgdzLzrZSDob0ESWSY2KiVUQXgrHwJyxoQ7HvSpRsU1xS
	 tzSZQ7rUj+CH07Frp8S63TNrtp7kUibeSq4sazAozbeYkdLG0IK50JNuDpl0I7eSgO
	 07Lii079kDqm3Gcomm+iQ0bTarxBJP4+60KLXYg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 264/272] gpio: cdev: check if uAPI v2 config attributes are correctly zeroed
Date: Thu, 28 May 2026 21:50:38 +0200
Message-ID: <20260528194636.478937808@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d44a3e4c2a09c..e77ec4b205f42 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1324,6 +1324,7 @@ static int gpio_v2_line_flags_validate(u64 flags)
 static int gpio_v2_line_config_validate(struct gpio_v2_line_config *lc,
 					unsigned int num_lines)
 {
+	size_t unused_attrs;
 	unsigned int i;
 	u64 flags;
 	int ret;
@@ -1331,9 +1332,21 @@ static int gpio_v2_line_config_validate(struct gpio_v2_line_config *lc,
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



