Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3881C7B9D;
	Tue, 27 Aug 2024 15:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771710; cv=none; b=YkMlKARQhYqLo2R1DZtBBlpLXzPRuI7JPn8Ac6QqNemF6VY95T3OI9Blna7qsxPkq93+sTNq42S4rNNmz99gPRRjA0v2C7gF610VWLmkquvp7mCbkcTJkitPyJZp5bq0obSnrQMNxK9xPNnY6aGufugrZ3WeT6yxzyNFJ4wEtq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771710; c=relaxed/simple;
	bh=LKUNx7yGZnz9rtjWebV7L9aFEag493cWfCJfngkmm8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRDqxfb9zl/+2p+69/0Yo7OxUp/uGL70AUkFXg/tIfqpPBnL+pvz/2VqCUuuSYoVYLL+OGZCzFZU4k5eygLE+sHwmEhtBZs5raRSCtjGVANVr0UZvpTnlIU6FXIIL2/TcWSzRTuha0Z70PoRa6fHPum4ORIQ29hbpYhyYSM3H4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+MLkera; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+MLkera"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B688C61075;
	Tue, 27 Aug 2024 15:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771710;
	bh=LKUNx7yGZnz9rtjWebV7L9aFEag493cWfCJfngkmm8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+MLkeraEhTpbYGIJ8HbKeDvKd18NqHhETceK+eu8iLzjQtUykU3bQNSk4xMzX1bF
	 PLE6QrNWic5VGtCHBnbESUZSHL4u7epO9PsmmkU82m+JxAC4g2JMyprU144Yp/GIMg
	 CrHRyIC53PFrWMfl8SKWOtQHIPiH8rUEDDV4KGhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.10 239/273] Input: i8042 - use new forcenorestore quirk to replace old buggy quirk combination
Date: Tue, 27 Aug 2024 16:39:23 +0200
Message-ID: <20240827143842.498275202@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Werner Sembach <wse@tuxedocomputers.com>

commit aaa4ca873d3da768896ffc909795359a01e853ef upstream.

The old quirk combination sometimes cause a laggy keyboard after boot. With
the new quirk the initial issue of an unresponsive keyboard after s3 resume
is also fixed, but it doesn't have the negative side effect of the
sometimes laggy keyboard.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240104183118.779778-3-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1150,18 +1150,10 @@ static const struct dmi_system_id i8042_
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
-		/*
-		 * Setting SERIO_QUIRK_NOMUX or SERIO_QUIRK_RESET_ALWAYS makes
-		 * the keyboard very laggy for ~5 seconds after boot and
-		 * sometimes also after resume.
-		 * However both are required for the keyboard to not fail
-		 * completely sometimes after boot or resume.
-		 */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "N150CU"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		.matches = {


