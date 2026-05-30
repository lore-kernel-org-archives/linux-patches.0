Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E243AB291;
	Sat, 30 May 2026 18:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164275; cv=none; b=uWj8UZUaAagfvNCb429j/VU9Gfx1fa3gXO85m9FL7PiDMuu7Qw7MVKKBRR1GSuRbq/No+MMTMRrkzmY92ufmCFsgYzf1tQEUAyP8VvILtC1wWRYvisdbsvC2sDnM5ml4EV8r54ErGx4jXkbDrVVxYH9sIR8B2dPg93K+yhibriY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164275; c=relaxed/simple;
	bh=/9GqUJNeM8upjZFzywJs6p4cI8TOwmGld1oTXqkTILg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+Jv6Ye8+mWTRy0hjf/dwtR+MkT7iRBbsgiEmj98ODrLNOyI9bUoaepC2cm55X9whhvFntSMLTa26eH3zfgubc5kgwqnAVU82siLtEH/q7VONgk80Ulnhv27UPTLFrBzOiG4i5tpkp6g0+JmI5ZTs7GtS2hsDGiW3nUAHEb6tcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4AstRDr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4AstRDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6312B1F00893;
	Sat, 30 May 2026 18:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164274;
	bh=Ye3/V/mp1UFXuwXg6N7Fi8wBe6rM9ElhMqDPraxtB6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I4AstRDrdRgGuJ3lMUKBPMBzLsAdhsr+0HWDK/LQKTEKXk3qezODGegIqfCi3V863
	 dfbUrmkTJRZ6lzay5le9lWaQqR/+MizqVMxo8TkXmV8M5fC9sOg3Z1lMHyREsAaOn0
	 DBP8CLuOiY29SAb9EgL0tm8j6cLYNx7UzZlHwB+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 506/776] mtd: physmap_of_gemini: Fix disabled pinctrl state check
Date: Sat, 30 May 2026 18:03:40 +0200
Message-ID: <20260530160253.355454979@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d4a46e159d38f..8d5b791dd08d4 100644
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



