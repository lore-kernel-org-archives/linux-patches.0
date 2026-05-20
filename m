Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C4A400E0D;
	Wed, 20 May 2026 18:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302323; cv=none; b=uu+TQCb9euuSLlDwbjBKLN3pOgxQwGvHrmnOdOPihFyTRwpxhs7uqohPj912ZEw46mbQgfox7I6SdxazF9jmhSsasfXSH8MlmhJLdkgbYcc7NaQgFoMbX01zwgGz8PWP9E1zzlTQ1fDCjyi7GguTH7rMlhE1dqCxg+xIZVn9jc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302323; c=relaxed/simple;
	bh=tSE3EDfcupH88Jj/9mZQyBQVZjvzMQpPxWcq9eP+Ohg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRQpG3G+2dsQ/hE5qGNe3umlcgIBOEmGzEStZhBR8OZLE4XkveQ5GPaULQlCZcSgetgxwDyeA6XbOUDlcsNUnBsgehVE5ZnpTgP/C9wLqlqWnJyXu174tFVzcxEzGDmf2gRUdLfgm4twqerMF2aakjwwlvQd1b/2xdtvKDehfTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjX3bASM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjX3bASM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1331F0089D;
	Wed, 20 May 2026 18:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302322;
	bh=YKHz7p94087UMWujWInz3rf1k0Or75l/Gjc8gJNyU+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjX3bASMV8ihZBg5y8Txh0IKnYRDt19LSAEtkjA2MxDUFowNKLyRXCH5i3dqDZU+6
	 AEiBUggids5MzldSK5m0ja5W9Xhm4LyPSSpUBM38E4zGo3HNVhHFgOcd+0iN9LWwOw
	 SFyx1TLUTQUSBCovwQYaYVDK30acuhLSSASM7ayI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 224/508] mtd: physmap_of_gemini: Fix disabled pinctrl state check
Date: Wed, 20 May 2026 18:20:47 +0200
Message-ID: <20260520162103.500239975@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit b7c0982184b0661f5b1b805f3a56f1bd3757b63e ]

The condition for checking the disabled pinctrl state incorrectly checks
gf->enabled_state instead of gf->disabled_state. This causes misleading
error messages and could lead to incorrect behavior when only one of the
pinctrl states is defined.

Fix the condition to properly check gf->disabled_state.

Fixes: 9d3b5086f6d4 ("mtd: physmap_of_gemini: Handle pin control")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/maps/physmap-gemini.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/maps/physmap-gemini.c b/drivers/mtd/maps/physmap-gemini.c
index 9d3b4bf84a1ad..1c34b4ef77ea3 100644
--- a/drivers/mtd/maps/physmap-gemini.c
+++ b/drivers/mtd/maps/physmap-gemini.c
@@ -181,7 +181,7 @@ int of_flash_probe_gemini(struct platform_device *pdev,
 		dev_err(dev, "no enabled pin control state\n");
 
 	gf->disabled_state = pinctrl_lookup_state(gf->p, "disabled");
-	if (IS_ERR(gf->enabled_state)) {
+	if (IS_ERR(gf->disabled_state)) {
 		dev_err(dev, "no disabled pin control state\n");
 	} else {
 		ret = pinctrl_select_state(gf->p, gf->disabled_state);
-- 
2.53.0



