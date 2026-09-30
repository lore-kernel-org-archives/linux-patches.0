Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F813AFB11;
	Wed, 30 Sep 2026 16:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787011; cv=none; b=E8UjaymDEZWr6k3Dq2C9nBsDZVl3pczNIeYSZsDi+k3vXRs8sd3ViCF778Y1ZvL3WiOa5oxf2unY2GpKUPCgdDLcQBHM8ttbUM5Wnarv8+D2oh9Dhn2VxF+VwW4TCuJahHzb0/vAyY8NCKf1+waLjOtJpzLHgw/yc/m5ic4Bcco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787011; c=relaxed/simple;
	bh=zQk7xwpgJhh1+V8rjv5zSqUtfSqH2nRTcx230eM1EdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvu5Tq3WfGGcfaCUsWQRUSPeo1pxizitxP+M9YdTLiAO44yfVSxgOvRjbri3KE7uN/3c+hn0SpTJzmQJXyswBUoyjR4q4qnSwzbLa4erk95O6FBFDir8Ovs5Xe7C90lknxQDV1ta33oKyOuCQ5KXqzvlcd5iIYYn0+6Cymj/mj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HPupm35p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HPupm35p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527721F000FF;
	Wed, 30 Sep 2026 16:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787009;
	bh=SjB6BP9NKDWwbbGt572vM30LqfG8cGGKJ0JpoWhLkuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPupm35pWoMDeZg4lUY2bYk0xeEkNSElNHpnOeXPEDQZhn9uXg0niCO4DY1BXKW6f
	 yjjpxXjgpewH7QQKaIP47Vid7hwln0aDNxts3l+8no6v3NlYOHF6NfM+veCFNO8mQt
	 W3Ot1X1Xn2PB9HGSM384eJXMO+sp4SVMGIT7Avo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 080/457] gpiolib: use of_node_name if line-name is missing
Date: Wed, 30 Sep 2026 17:23:05 +0200
Message-ID: <20260930152347.778078176@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Wunderlich <frank-w@public-files.de>

[ Upstream commit d54a489c8c4b627775445d54a6cbd32f209bda8f ]

Until v7.0, GPIO hogs inherited the DT node name when no line-name
property was specified. This was implemented as a fallback in
of_parse_own_gpio().

Commit d1d564ec4992 ("gpio: move hogs into GPIO core") moved hog parsing
into the GPIO core and removed this fallback.

Consequently, GPIO hogs without a line-name property are now displayed
with a ? in /sys/kernel/debug/gpio. Restore the old fallback.

Fixes: d1d564ec4992 ("gpio: move hogs into GPIO core")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260917153712.134367-1-linux@fw-web.de
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index ef8ccaf17c9ce..28f7265c5d569 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1029,6 +1029,13 @@ int gpiochip_add_hog(struct gpio_chip *gc, struct fwnode_handle *fwnode)
 			ret = of_gpiochip_get_lflags(gc, &gpiospec, &lflags);
 			if (ret)
 				return ret;
+
+			/*
+			 * If no line-name property is present, fall back to the OF
+			 * node name as in the previous implementation.
+			 */
+			if (!name)
+				name = to_of_node(fwnode)->name;
 		} else {
 			/*
 			 * GPIO_ACTIVE_LOW is currently the only lookup flag
-- 
2.53.0



