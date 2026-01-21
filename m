Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817F535E535;
	Wed, 21 Jan 2026 18:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020062; cv=none; b=USa91TyaOm5IpYMWT0wQOv+dlAAh9WPKmhlEsmpv3lvWXlODoaR70bW5F956GaeGs/cDwk1rAobSOE5dl3utTSsYVkEGJGioQGh7DjtA6BO3oVpwTHcYMHgVKGHO7vEE8v4MSXEoz9sJmUk70/npSWptJnktHPPOrGbz7eK820c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020062; c=relaxed/simple;
	bh=VWQ6hCldWCHc3pnSqR2ol/CEyxwmuCBNQLwnjmB1aaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIvwi9l97Rh54icMdJ1u3iCsgBDH5SAyycGCFDgT8l1JnfrsRNCZRFHxpr7gcGlXa+avQITyD61rpaEObDHzTrFu7Ypxt3mZt8kTBMT9qSnCLHVWb4AFnpUcrj5KzzuwuVg4P3CKCc8svPD24ryn9f4Cl4RFOFYNTJsFWWB+/bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+3GK2Jx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+3GK2Jx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4C9C4CEF1;
	Wed, 21 Jan 2026 18:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020062;
	bh=VWQ6hCldWCHc3pnSqR2ol/CEyxwmuCBNQLwnjmB1aaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+3GK2JxgV0QrpXj7SFt8GS1kXu8kiklEhajPXe+R9i1chV6PIBHBEh9Kta/a35v6
	 5Gme54TXPSjq7oJZtciX/kSXD6cekk9SCu5k9K5w/SYz2Am+SOFAJIq6XekhqSVGpV
	 vRhv3JjceeRfnYwyrKlVEFZKkwn24oQTxF5Z+PV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 048/198] ALSA: hda/cirrus_scodec_test: Fix incorrect setup of gpiochip
Date: Wed, 21 Jan 2026 19:14:36 +0100
Message-ID: <20260121181420.284319119@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit c5e96e54eca3876d4ce8857e2e22adbe9f44f4a2 ]

Set gpiochip parent to the struct device of the dummy GPIO driver
so that the software node will be associated with the GPIO chip.

The recent commit e5d527be7e698 ("gpio: swnode: don't use the
swnode's name as the key for GPIO lookup") broke cirrus_scodec_test,
because the software node no longer gets associated with the GPIO
driver by name.

Instead, setting struct gpio_chip.parent to the owning struct device
will find the node using a normal fwnode lookup.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 2144833e7b414 ("ALSA: hda: cirrus_scodec: Add KUnit test")
Link: https://patch.msgid.link/20260113130954.574670-1-rf@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/cirrus_scodec_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/side-codecs/cirrus_scodec_test.c b/sound/hda/codecs/side-codecs/cirrus_scodec_test.c
index 3cca750857b68..159ac80a93144 100644
--- a/sound/hda/codecs/side-codecs/cirrus_scodec_test.c
+++ b/sound/hda/codecs/side-codecs/cirrus_scodec_test.c
@@ -103,6 +103,7 @@ static int cirrus_scodec_test_gpio_probe(struct platform_device *pdev)
 
 	/* GPIO core modifies our struct gpio_chip so use a copy */
 	gpio_priv->chip = cirrus_scodec_test_gpio_chip;
+	gpio_priv->chip.parent = &pdev->dev;
 	ret = devm_gpiochip_add_data(&pdev->dev, &gpio_priv->chip, gpio_priv);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret, "Failed to add gpiochip\n");
-- 
2.51.0



