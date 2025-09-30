Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADFB2FCBFC;
	Tue, 30 Sep 2025 15:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244534; cv=none; b=iAqaPyjKVm7MqeCD7Tttndb6bZ6KjMutoUxHZLxYqeockfU5Ek+ftCr1d/p3pZC3A4HpaK5Py8ayi8SoB/zWYz3ohd54nT8Ab0D8/Q72d8HSmtYBjumQlqlPwn2vpC5V4404+wQkHX3ZzbMJRH9tX588hHPxbw6Vk97o6eHeL/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244534; c=relaxed/simple;
	bh=40qdXbUqlFv2Dqnl2+0ijBe+DlQ1nmGuypY3aWTsVkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O8KHj38+y7+9afg7qJxqoFe5b6I4Jz1emimgDbmpOtpWk1tOL7nx4Z9wkxAiWgKeGRtfWrBXMrtNzBvFuYCwxuFygK03gJlxrtTaG+qW1IpPPkd3kVoQY+IurHrlN9umFe2xnW+Q7YTELQ0byN+tNmkJ14J59P6hedQD8qdyT2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3N7Ex1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3N7Ex1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCCCC4CEF0;
	Tue, 30 Sep 2025 15:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244531;
	bh=40qdXbUqlFv2Dqnl2+0ijBe+DlQ1nmGuypY3aWTsVkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3N7Ex1UtDVYjGXc0Os/wrJzb7lD6bF9W2K5RV8V3w/M9yPb0NTQSeX4ay/5b+IaC
	 SHAIYoEIvlXynUvDJSuzyGMB0LSj1j3Ql1l6Rk73nA/oigu0T/iPeMHs1Bnb8i1n/J
	 MABz2ZLgNSAIiD8DXtbSGJGGAWzbu2DYTEH62Oqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?S=C3=A9bastien=20Szymanski?= <sebastien.szymanski@armadeus.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 036/143] HID: cp2112: fix setter callbacks return value
Date: Tue, 30 Sep 2025 16:46:00 +0200
Message-ID: <20250930143832.681310511@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sébastien Szymanski <sebastien.szymanski@armadeus.com>

[ Upstream commit 2a5e76b9a0efc44807ff0e6b141649fac65a55ac ]

Since commit 6485543488a6 ("HID: cp2112: use new line value setter
callbacks"), setting a GPIO value always fails with error -EBADE.

That's because the returned value by the setter callbacks is the
returned value by the hid_hw_raw_request() function which is the number of
bytes sent on success or a negative value on error. The function
gpiochip_set() returns -EBADE if the setter callbacks return a value >
0.

Fix this by making the setter callbacks return 0 on success or a negative
value on error.

While at it, use the returned value by cp2112_gpio_set_unlocked() in the
direction_output callback.

Fixes: 6485543488a6 ("HID: cp2112: use new line value setter callbacks")
Signed-off-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-cp2112.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
index 234fa82eab079..b5f2b6356f512 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -229,10 +229,12 @@ static int cp2112_gpio_set_unlocked(struct cp2112_device *dev,
 	ret = hid_hw_raw_request(hdev, CP2112_GPIO_SET, buf,
 				 CP2112_GPIO_SET_LENGTH, HID_FEATURE_REPORT,
 				 HID_REQ_SET_REPORT);
-	if (ret < 0)
+	if (ret != CP2112_GPIO_SET_LENGTH) {
 		hid_err(hdev, "error setting GPIO values: %d\n", ret);
+		return ret < 0 ? ret : -EIO;
+	}
 
-	return ret;
+	return 0;
 }
 
 static int cp2112_gpio_set(struct gpio_chip *chip, unsigned int offset,
@@ -309,9 +311,7 @@ static int cp2112_gpio_direction_output(struct gpio_chip *chip,
 	 * Set gpio value when output direction is already set,
 	 * as specified in AN495, Rev. 0.2, cpt. 4.4
 	 */
-	cp2112_gpio_set_unlocked(dev, offset, value);
-
-	return 0;
+	return cp2112_gpio_set_unlocked(dev, offset, value);
 }
 
 static int cp2112_hid_get(struct hid_device *hdev, unsigned char report_number,
-- 
2.51.0



