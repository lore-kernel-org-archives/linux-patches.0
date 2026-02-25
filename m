Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202BD248881;
	Wed, 25 Feb 2026 01:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983493; cv=none; b=dbzmRcw9xzJORfxIby87WYQS+R+gaHtCgoprSv/MykLxyeI18x5d6/Fmnwag1wsPhrrl/NOSUo/LXRtwBLQT72oEBcITch9rINTvzem8tySsRRYU7Jx/jOByjNEp0E6bLFmG2vOFg9FHU92SKtugD2y3GusRPChaECr5/Os+cvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983493; c=relaxed/simple;
	bh=dcBV2UW8xpJAtLJy8HaUd/F9MVmlThlMNB/4ak7hAts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=peG+71g/d8Y163b2dY7HVNqfTgbKUmXMNEKbMSYCZNVkOjHNa31XsDVdsHuC4sWaQpgcGxsZjGUR/0sZlqZJ+Y+ONFBOZeNEW6Ut4QGqWR9fzy8ZadbrB9rg7S0V6+sILyVcc1d8k5bG9zFpI/a1CCtpCqaZ5Jw9BCQ3oSvMjkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6Suiud5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6Suiud5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD506C116D0;
	Wed, 25 Feb 2026 01:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983493;
	bh=dcBV2UW8xpJAtLJy8HaUd/F9MVmlThlMNB/4ak7hAts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6Suiud5rEov/afi0M4iXKK87uOJUSVez4oz7bnYSSDS3D//u80zLKvT/yJJ4I2CI
	 V9L1n3lwFVfpFx+68PAJBGfU51GsfSt34WIMtyLD2VU1VlhCwodG0JvznvHP3RT33d
	 kWeit47lz0mQ6omW53GeEiG4Vs33IWhPym91AeCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 603/781] pinctrl: meson: amlogic-a4: Fix device node reference leak in bank helpers
Date: Tue, 24 Feb 2026 17:21:52 -0800
Message-ID: <20260225012414.584476367@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit e56aa18eba32fb68ac5e19e44670010095bb189c ]

of_parse_phandle_with_fixed_args() increments the reference count of the
returned device node, so it must be explicitly released using
of_node_put() after use.

Fix the reference leak in aml_bank_pins() and aml_bank_number() by
adding the missing of_node_put() calls.

Fixes: 6e9be3abb78c ("pinctrl: Add driver support for Amlogic SoCs")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/meson/pinctrl-amlogic-a4.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/meson/pinctrl-amlogic-a4.c b/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
index d9e3a8d5932a8..f05d8261624a4 100644
--- a/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
+++ b/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
@@ -725,8 +725,9 @@ static u32 aml_bank_pins(struct device_node *np)
 	if (of_parse_phandle_with_fixed_args(np, "gpio-ranges", 3,
 					     0, &of_args))
 		return 0;
-	else
-		return of_args.args[2];
+
+	of_node_put(of_args.np);
+	return of_args.args[2];
 }
 
 static int aml_bank_number(struct device_node *np)
@@ -736,8 +737,9 @@ static int aml_bank_number(struct device_node *np)
 	if (of_parse_phandle_with_fixed_args(np, "gpio-ranges", 3,
 					     0, &of_args))
 		return -EINVAL;
-	else
-		return of_args.args[1] >> 8;
+
+	of_node_put(of_args.np);
+	return of_args.args[1] >> 8;
 }
 
 static unsigned int aml_count_pins(struct device_node *np)
-- 
2.51.0



