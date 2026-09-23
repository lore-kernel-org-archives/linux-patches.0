Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE50311C32;
	Wed, 23 Sep 2026 14:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173834; cv=none; b=TmP/EGGWo6Au6RX78j0rZkl9asx4XSe4G0f8Bf/ud1TxN3J+3YNVq/NQyJ3w74eV8zZVkIT4Y/XtJHXYO83W60wx+X+ibDPvwr1v+5/PAWovL9JvaixwKLdHYPbZvsyY8pIOemJLaey10jJrs7KyyDQDZJ8CuTCOdsB1N8mQlAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173834; c=relaxed/simple;
	bh=BqyYxBzSVaTlfUhGhnCjot4xwOr/nduvkFYAuJN1M2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFTgOYYJbyPakwUvA8mJalPY9v/DiPmwCJotGVlGLpTV4SSdDi/Z8RXPP2rOeJ5B4sPQU0X9XGH7AarnYY5wcDuVk36cBspOxpGCDufu13H5BsiBqRc1s9cHCj61ft/A+MXizzsdVK8Rj62S6omeDGlxEhXAjScFIoWiPl9DM6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smcgyl/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smcgyl/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F9C1F000FF;
	Wed, 23 Sep 2026 14:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173833;
	bh=AiGWxramReKwHYe0RY0GNAp+Z+I2f7RCgavw/g5OxcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=smcgyl/C9MLtF3tDelC1nuzZ/q6GAjccg18ccupS/wdGQx6lPT0PTtMMbj4gGQcEe
	 gzXU75q9zsJb1xawfM/SzSvK9D7YNwEhlC0p4ageSjgWb0C0vK3c9eeriOv9TDhWyj
	 N9ugu3U9RFIFuZhOKdZj3fh9t8rwJTN4nUbYhYgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Sommers <chris.sommers@icloud.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.2 358/438] Input: i8042 - add quirk for Acer Aspire Go 15 AG15-42P
Date: Wed, 23 Sep 2026 16:06:19 +0200
Message-ID: <20260923140654.130192963@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Sommers <chris.sommers@icloud.com>

commit 25e424eb4ae1a662d9c3573218d06ac32f797fc5 upstream.

On the Acer Aspire Go 15 (AG15-42P), the internal keyboard drops out
~5 seconds after boot on both Linux and Linux-LTS kernels. Keystrokes on
the built-in keyboard stop registering while the trackpad and external
keyboards remain functional.

Testing confirms that booting with the i8042.reset kernel parameter
resolves the issue and keeps the internal keyboard responsive.

Add SERIO_QUIRK_RESET_ALWAYS to i8042_dmi_quirk_table for the Acer
Aspire AG15-42P to automatically apply this quirk on boot.

Signed-off-by: Chris Sommers <chris.sommers@icloud.com>
Link: https://patch.msgid.link/20260907182723.2709981-1-chris.sommers@icloud.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -261,6 +261,13 @@ static const struct dmi_system_id i8042_
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire AG15-42P"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire ES1-132"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)


