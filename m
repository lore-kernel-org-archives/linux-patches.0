Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2A953CA8F;
	Wed, 23 Sep 2026 14:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175028; cv=none; b=ILGIv1FgvkNbH5pJ6ohF7DVqShQnWQwvDZr6SRWVR2QRdr2kRVdyvTtO0MLGTs5Bn/QSu3RzspmF/LL/DdmWX3yUQ7yhP+41ZoDV0+k4+F4guq44wlm9wts733gwz2bcnU+qbqqQQqK381yxUYSOOMXupLt6E20B/EmJqrlKNeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175028; c=relaxed/simple;
	bh=Zo6t+j+KSBzfdunhOM8MF8QvOPoM1bbj0rbM0UzW/aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyqo0+V0ULzNh6l3Ilj6qLSVJq4fFdO9N9JU5adrzfvdy0bjFtCr4nZ/pXEkGf8ke0pXaU7Slx4uEbud4AjCT9UmVdK9Om2M+2ffM4iPvk9wpLjcTUz9U5AdYYlaB6ZbKYT0clOpNU3xpvPe0kuUWhHSu/k4cFnTY7e9KWwYFMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgd0A3qD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgd0A3qD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F82F1F00893;
	Wed, 23 Sep 2026 14:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175027;
	bh=8b/Plks0OHFh5C8QaoRSow7/tfDNis1QzgwsBm49tP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vgd0A3qDJSbzR8USIxYNphEqG9DTmNRxgKk+ddn0DWa9Yj5Qacv5vj1DZ8EzKcoGP
	 6qyGqNvlWK8UyLhdpLapZCDKPyl8GLtfpKRQ3/bzcLI3yc4zM2FgjhxXa9tjOi3h/f
	 kXYwprPUfES2U1SZxVIq3d5CFReNcBigNULaQzRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Sommers <chris.sommers@icloud.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 299/398] Input: i8042 - add quirk for Acer Aspire Go 15 AG15-42P
Date: Wed, 23 Sep 2026 16:06:13 +0200
Message-ID: <20260923140651.172798753@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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


