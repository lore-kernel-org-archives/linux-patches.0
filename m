Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E6F19E7F9;
	Mon, 23 Jun 2025 22:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716923; cv=none; b=l16TbzVmWNqBlgNFETRlUuPdRtkoRAL0V2iT0aSk+LFCQpnTHZj6fxxBDxNAVt8VGYhn76GLXA4ZBFJTtdOIVKExpWTXvVJpkoIfFq+66g15xtULmoUhi5p+z7IT12MYposACs1iX8GS09Mmm7OkWTCJ1evNenzYj3Mb94i7tp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716923; c=relaxed/simple;
	bh=FNA9rsWXSMdEIhLUB6VL8MZgxX/akA5FaVTz6aAC07w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0fUW1YKHKLkSjZUAEuxkFxg8lPnh76/OBQNbGQauXhUwvbjWtFu1JBEHXCAPdZ/WeVv5YJCWViehRGG61+aqFeXodV+5I2NlXncVKGUnvkjuqoskXNiU+bBQ8gbF+3e4r/Jz4T0La/f2hA7lGJdXgQUCN/FKSzMmF7p3VkbeJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7FX7Vu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7FX7Vu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA8AC4CEEA;
	Mon, 23 Jun 2025 22:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716923;
	bh=FNA9rsWXSMdEIhLUB6VL8MZgxX/akA5FaVTz6aAC07w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7FX7Vu3Nl8Gk+JsOZWklh1HBcUKNgAYqj0+lJS68sn96QrM+cQzyuizQYKlS7+mB
	 rmfIFSu/jWCqUiesVT0yS1PA1fh1mgFA2QxTwpwcZDbSSM+qLJjUggdlEG/Jff1uc1
	 x0WXj/smVS6FGOpku6YMzz6nfJhV0mJFCSCludEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 298/414] platform/loongarch: laptop: Get brightness setting from EC on probe
Date: Mon, 23 Jun 2025 15:07:15 +0200
Message-ID: <20250623130649.458444624@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

commit 1205088fd0393bd9eae96b62bf1e4b9eb1b73edf upstream.

Previously during driver probe, 1 is unconditionally taken as current
brightness value and set to props.brightness, which will be considered
as the brightness before suspend and restored to EC on resume. Since a
brightness value of 1 almost never matches EC's state on coldboot (my
laptop's EC defaults to 80), this causes surprising changes of screen
brightness on the first time of resume after coldboot.

Let's get brightness from EC and take it as the current brightness on
probe of the laptop driver to avoid the surprising behavior. Tested on
TongFang L860-T2 Loongson-3A5000 laptop.

Cc: stable@vger.kernel.org
Fixes: 6246ed09111f ("LoongArch: Add ACPI-based generic laptop driver")
Signed-off-by: Yao Zi <ziyao@disroot.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/loongarch/loongson-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/loongarch/loongson-laptop.c
+++ b/drivers/platform/loongarch/loongson-laptop.c
@@ -392,8 +392,8 @@ static int laptop_backlight_register(voi
 	if (!acpi_evalf(hotkey_handle, &status, "ECLL", "d"))
 		return -EIO;
 
-	props.brightness = 1;
 	props.max_brightness = status;
+	props.brightness = ec_get_brightness();
 	props.type = BACKLIGHT_PLATFORM;
 
 	backlight_device_register("loongson_laptop",


