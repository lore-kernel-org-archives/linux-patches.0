Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC18A2C1A5;
	Mon, 12 Aug 2024 16:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480385; cv=none; b=F0zMVpnE1FzgI4ltTJQyq1XSC17AVFOhtAyB43/pUte7fOlsbheljQB01sd6IdtMIY2w7M7NL51AS3zkxGxS9rtS3O8RRk9RfTb1p0R/180r8xyAyy2BpYZ2I/JNONUzKdKQJ9z4Mi71+nrSAA/qddevA/Is/ZuXXoxcERSdg/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480385; c=relaxed/simple;
	bh=N/y839FUMLnWyJA7Lc1b5zKBpGNDKC3Lz0YtzrbQizc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gkrus4ftzCfVfeuNTbsM1AJaCZgfma9rvoBncmkil+fKNoJV3CXQMnTJIkZPRhip0BYMUXVrTKGjcPlNQLarDeSO48Ck6H14Jg0OXdHHYhDNeWvIudiUiXHdOqOBaNZJPOdqesS6uAXehlEUxzB9/loMzu1ddnfaasioEKIpzdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYBxx0zd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYBxx0zd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA87C32782;
	Mon, 12 Aug 2024 16:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480384;
	bh=N/y839FUMLnWyJA7Lc1b5zKBpGNDKC3Lz0YtzrbQizc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYBxx0zdzrZH3jwY6J+/qJUeY/l4oGlpXGSxygI79sk8DN4jx0GsCk4JlWoZeSg6+
	 CKqrKBhWyyXaIbsxXx/rBSH/08M3X465WXs86txL2Z2eK3EgyhJreBd/k7ybQFgGh9
	 N0VVC1SSvHPh6goEkuCfbhjZA589eQe/tsCc3D9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 152/263] ASoC: cs-amp-lib: Fix NULL pointer crash if efi.get_variable is NULL
Date: Mon, 12 Aug 2024 18:02:33 +0200
Message-ID: <20240812160152.365329941@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit dc268085e499666b9f4f0fcb4c5a94e1c0b193b3 ]

Call efi_rt_services_supported() to check that efi.get_variable exists
before calling it.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 1cad8725f2b9 ("ASoC: cs-amp-lib: Add helpers for factory calibration data")
Link: https://patch.msgid.link/20240805114222.15722-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs-amp-lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs-amp-lib.c b/sound/soc/codecs/cs-amp-lib.c
index 287ac01a38735..605964af8afad 100644
--- a/sound/soc/codecs/cs-amp-lib.c
+++ b/sound/soc/codecs/cs-amp-lib.c
@@ -108,7 +108,7 @@ static efi_status_t cs_amp_get_efi_variable(efi_char16_t *name,
 
 	KUNIT_STATIC_STUB_REDIRECT(cs_amp_get_efi_variable, name, guid, size, buf);
 
-	if (IS_ENABLED(CONFIG_EFI))
+	if (efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
 		return efi.get_variable(name, guid, &attr, size, buf);
 
 	return EFI_NOT_FOUND;
-- 
2.43.0



