Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1B972624;
	Mon, 23 Jun 2025 21:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715597; cv=none; b=H6leOdGH4HZYYZlzjRTso/AaoHSXezZddwVbXPq1qywsv+4XSwSEJjsg0CIib8/4RLaiGOcURmXPmd3XRynAzwwT9AZE8xacmxVJRYHJizYzsox2G0E3jDB9rZFVEl4SdbKJ8pgjHoRvnY/dRgOFJutu/EKnjelzofpa4XrgfKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715597; c=relaxed/simple;
	bh=sF8Fj2WHluooAeFDLW7Oi0Qa13u7UBA7yOEvtzDYXOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8y486jqk2QR3Vdo+aiuIkoudpElehpwwbtatwu1mHJpouI7sBTS6bCxHUrpUDpQ8OcEceDhWD8HENMFLwKM8xQQFOB4slrtC3ffRcSuFJjBXjwAyRfZTU63RbO0Sl45x0Pi1I09rfFMoP1DrY5juxsSJosAsZLB8bKB2WvRPeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OLYMNPFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OLYMNPFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8697DC4CEEA;
	Mon, 23 Jun 2025 21:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715596;
	bh=sF8Fj2WHluooAeFDLW7Oi0Qa13u7UBA7yOEvtzDYXOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLYMNPFz/jrLRdF9VvQ564tA+Y6ZYLDIlY21N88eFcd6kvlO036woSNyxKbYt7KKK
	 dqBg+qr4YgiWvXbkMkUWSGmkL/nfnndBJZKyx/8pwSXnkJgsqTZHQRHWgzaSO9XAWI
	 CzcGn+SqU0oDgCMxiUx4e1SiAGtI7Cv+xteydhmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 209/290] platform/loongarch: laptop: Get brightness setting from EC on probe
Date: Mon, 23 Jun 2025 15:07:50 +0200
Message-ID: <20250623130633.214398175@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


