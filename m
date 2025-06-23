Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E052192EC;
	Mon, 23 Jun 2025 22:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717509; cv=none; b=Sd8T6Tah1i7RPvLVQby0Df/n+fmYhZSXV8pNS7eGpjiCvqxzFPRh4AuCNEFmvOPP/XtXAF9PTQAYR0bkuRCO7tShRwucLceRCyYHBM/+bk5kKplIYzsnEM8D0V5UebyfsCyzvzp5dnLBLRFMBjIScxVJOBLA/W84mRXpxPLc5AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717509; c=relaxed/simple;
	bh=5UOhQfG6d6R/LsqOJbM8I5VJIrOf6P8oQV724GNE9bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hkcj8/NMwGoGeQ8JpoKxDyHXnfKI3EVlGuQLVXLE8S5KpvN5pRrXkx4ZIpO4hFDpwSxtIBnjGW1l3FBXpRcmTlwb+1x+NSHT/widL78ZcKUazRFmEtKtE+UexIC41KNzWW8V5MN40s9sl9z3drnHOH3j5iYtsxdOktPYH9iEyoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4BowUZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4BowUZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949FDC4CEEA;
	Mon, 23 Jun 2025 22:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717508;
	bh=5UOhQfG6d6R/LsqOJbM8I5VJIrOf6P8oQV724GNE9bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4BowUZIRT2XJqv/bdKJ64aCN7uIK0ylVSDGSUzuUITcZaiZhk84Yyq2tuLSzDqvE
	 LLeA50dH3e197EbVAWfZpCX8W471N7Kajb09rxLbwheQNPsGCN5tadLweMe4D1xFmj
	 bEGDfZQHpGTY5haoaQ/TVq1IlsCfR/NmPT/dtlDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 443/508] platform/loongarch: laptop: Get brightness setting from EC on probe
Date: Mon, 23 Jun 2025 15:08:08 +0200
Message-ID: <20250623130656.061787012@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


