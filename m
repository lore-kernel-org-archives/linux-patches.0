Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C110A423782;
	Thu, 30 Jul 2026 15:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426270; cv=none; b=G9BgT8lJ/78z53xmwdXrRMmaCe2ytF0H0QZNZceQquMhGf8iDgjvu8nv/5xCMaA6CGxu1hbEMUwkhY2XBEkPjCA4659B7nQFFIpB8spe0H8Ay+F8JEws+UutlQusJKyHSTHjKk9wmu85ZojHY3f6GGSPdg6jU6IhUbKsAPK4b6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426270; c=relaxed/simple;
	bh=uG+SL6ciR6UgB5JA7DSJoi/Ya+/7Jk80j+moaM2ecss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGtcy1Ji0pmPrGbfDTad0JY/unbRAq50OxRZTfLbmq7exzt8Os82OQcss/7eGH31rqPpWhCgl2oqoI5Z7kWRrw3KrKN+N+v0saaXA1B53way7UsrZaz7PiLLypo1pnR+zJcZZyQlWmHjBY2jOyzZC2iMKN+acDGY6npqRbTmVUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLU1fLQY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLU1fLQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA11F1F000E9;
	Thu, 30 Jul 2026 15:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426269;
	bh=jw9uSBEgEzJqcCw9OoW9zyDaloNNvNWzWetMWn1XF4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QLU1fLQYyPCWjL+qUaZ0Te+GYD6/BLGmwdbyOG3Md/6HaJQmbxyyLiBVUWqbD9Ism
	 CbIafMLMiZGvpYxtjM3RDDidHT/O0JAa9hb8+Dy6UxMRvHpUMd615LUpWjaZfpST4j
	 tmJHVJybTZUXd9he3uYG+u2GgIvEtFvFBE2oNhcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <me@ziyao.cc>,
	Xi Ruoyao <xry111@xry111.site>,
	Zixing Liu <liushuyu@aosc.io>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 359/602] platform/loongarch: laptop: Explicitly reset bl_powered state when suspend
Date: Thu, 30 Jul 2026 16:12:31 +0200
Message-ID: <20260730141443.505048321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Zixing Liu <liushuyu@aosc.io>

commit 91a70492c03040d51b36f595530d6491d5d6c541 upstream.

On EAECIS NL60R with EC firmware version 1.11, resuming from S3 has a
very high chance (>90%) of causing the EC to lose the previous backlight
power state. When this happens, the laptop resumes normally from S3, but
the backlight remains off (when shining on the screen with a flash light,
we can see the screen contents are updating normally).

Since there is no generic way to query the EC's backlight state on
Loongson laptop platforms, assume the worst-case scenario and restart
the backlight power inside the kernel each time the system resumes.

Cc: stable@vger.kernel.org
Fixes: 53c762b47f72 ("platform/loongarch: laptop: Add backlight power control support")
Tested-by: Yao Zi <me@ziyao.cc>
Tested-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Zixing Liu <liushuyu@aosc.io>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/loongarch/loongson-laptop.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/loongarch/loongson-laptop.c
+++ b/drivers/platform/loongarch/loongson-laptop.c
@@ -189,6 +189,7 @@ static int __init setup_acpi_notify(stru
 
 static int loongson_hotkey_suspend(struct device *dev)
 {
+	bl_powered = false;
 	return 0;
 }
 


