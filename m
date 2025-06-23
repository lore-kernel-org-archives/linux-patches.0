Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE6C3FD4;
	Mon, 23 Jun 2025 21:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715272; cv=none; b=iVH1WSFC2HAPMzBjVFCHSVArFXXTc+rtPJZ5P5CQ0nOeAl1ks6l1GQmwrbT9nLUx0LiijFmsegGR2PFrrDD2CJn3E060xJ0r8uznxrSQTkzCtkejZo6Um+fabbaSGOA8jreKUeNIVl6IWsD5ytP99GQOszlrTQoYBcX2Zj8HX4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715272; c=relaxed/simple;
	bh=CrMtvfuYVA5OJUPJ2/KA+jpGbhoCHCDev9rfe5Oa4Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wnfub9hd4A5rLX38MGRRS7oHf+1kzzsJ79ynV4FywrOCrF99+pdOp1cYFqyn9zjOKp3qb6YATcxRY9Je0hdSKYeWEifUxpr/7TXeCeaUvqI+Vlz+dptFP9C0DYujyIu2O04Yv6McKk360RRIpx22TYFWyr96LzZT9Iwml2YjcPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajv7cZZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajv7cZZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9831C4CEEA;
	Mon, 23 Jun 2025 21:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715272;
	bh=CrMtvfuYVA5OJUPJ2/KA+jpGbhoCHCDev9rfe5Oa4Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajv7cZZxOhXJotAWMvPZ9oWLxq++2mZ/NKG+rCXLDFPNmO5P+4ARjFv/C+dMo3n0e
	 ocMjKObr49RksZIEOF+qCRRdDjlWXP7pI1x3utUOI60JfWuhEXyFZLqU/WGKxZDQ4g
	 yWibQsbToTMJ7p0HpIl70A0/TxNOHbUQnf0H2JxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.15 448/592] platform/loongarch: laptop: Get brightness setting from EC on probe
Date: Mon, 23 Jun 2025 15:06:46 +0200
Message-ID: <20250623130711.085198960@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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


