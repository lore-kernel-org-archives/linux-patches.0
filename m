Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFA4427F89;
	Sat, 12 Sep 2026 10:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209612; cv=none; b=WyB/li3WorNUk2UeRY6B6KZjsORQl9SZoAXXc8V00Dce+aiiHmgRDCTiv4+26ZpQPQtZ4PsnfHDsOoeIZtZ1OnjVeEZT3Ueot5oNiyzyhdlYQZC8+mO13u1zo5BlAFbyi0NcQM5AVK2/jbTJexJE85md1XvA7IqxGdGupXb/wv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209612; c=relaxed/simple;
	bh=L57r5WsOsoNdrQh+EmA+ZJg6J3OAQQxq3y/Wa5DBTwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kB27T0Cr3IQVB8EHwUjpLNZJjqd688jz8FBnHHi0PCKfBCwQ1LynErZWSPt4sp3OggoHCaHZXi/r5kYFn3TaFV2veZgtZW2iUvhGBREedfcGIV2CN3QnZt0qZ7C4abWiJhDhd/GNVFdspMZJbT/BuNSTctv6de05KNB51I9UdZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rc5U9FlW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rc5U9FlW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720291F000FF;
	Sat, 12 Sep 2026 10:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209610;
	bh=/U7d6z9WDA1hC8E8LraafEgclCV2K0KrK2+F6EOIVkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rc5U9FlWZe2c13bRYHS+xeSQ+LkrKubOjxbKsBZE8oumk2+qACanXdcOxoluF89RD
	 C0fAwM59IKFVQznISTcOKYW4fVXs7m2MwFrQsc+KmwskyPQX6TxBQf6vZ7P1AiGQq8
	 TIltVGSOKI1mVe/O1AStFZOMRsLn1jobuhqM+FbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Yixun Lan <dlan@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0829/1518] pinctrl: spacemit: validate pins in pinconf callbacks
Date: Sat, 12 Sep 2026 08:49:58 +0200
Message-ID: <20260912065642.192817798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Troy Mitchell <troy.mitchell@linux.spacemit.com>

[ Upstream commit 41c59b22370d2e1785e0e80f8ad7bd9946a1ca82 ]

Pin 0 is a valid pin ID, but spacemit_pinconf_get() rejects it by
testing the numeric ID rather than the result of the descriptor lookup.
It also fails to reject nonzero IDs absent from the SoC pin table before
computing their register addresses. Check the descriptor and use its pin
ID for the register lookup.

spacemit_pinconf_group_set() validates only the first group member when
generating the configuration. If a later member is invalid,
spacemit_pin_set_config() returns -EINVAL, but the callback ignores it
and reports success after partially updating the group.

Validate every group member before writing any registers so malformed
groups fail without being partially applied.

Fixes: a83c29e1d145 ("pinctrl: spacemit: add support for SpacemiT K1 SoC")
Signed-off-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/spacemit/pinctrl-k1.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/spacemit/pinctrl-k1.c b/drivers/pinctrl/spacemit/pinctrl-k1.c
index 8d797bf24b778..813f86865dcd6 100644
--- a/drivers/pinctrl/spacemit/pinctrl-k1.c
+++ b/drivers/pinctrl/spacemit/pinctrl-k1.c
@@ -475,13 +475,14 @@ static int spacemit_pinconf_get(struct pinctrl_dev *pctldev,
 				unsigned int pin, unsigned long *config)
 {
 	struct spacemit_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
+	const struct spacemit_pin *spin = spacemit_get_pin(pctrl, pin);
 	int param = pinconf_to_config_param(*config);
 	u32 value, arg = 0;
 
-	if (!pin)
+	if (!spin)
 		return -EINVAL;
 
-	value = readl(spacemit_pin_to_reg(pctrl, pin));
+	value = readl(spacemit_pin_to_reg(pctrl, spin->pin));
 
 	switch (param) {
 	case PIN_CONFIG_SLEW_RATE:
@@ -654,6 +655,11 @@ static int spacemit_pinconf_group_set(struct pinctrl_dev *pctldev,
 	if (spacemit_pinconf_generate_config(spin, configs, num_configs, &value))
 		return -EINVAL;
 
+	for (i = 0; i < group->grp.npins; i++) {
+		if (!spacemit_get_pin(pctrl, group->grp.pins[i]))
+			return -EINVAL;
+	}
+
 	for (i = 0; i < group->grp.npins; i++)
 		spacemit_pin_set_config(pctrl, group->grp.pins[i], value);
 
-- 
2.53.0



