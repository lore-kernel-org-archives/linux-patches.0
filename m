Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB8E1BFE04;
	Tue, 27 Aug 2024 14:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770680; cv=none; b=DGp4SEe838iHRB1SWzDOGdy7jw0gDT5YF2s9nbJ6JbKadfdVNmntj/edTk+tzwIOnKRwKCBjwu1U8Qicvn4F+myl4IDCWiYNawgmWFi/L4avOPEN3c28UnReaUihp6tIS3M0W34/ch6C3FQPZAzxOMDAxKOuStslAUbYaGBzuxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770680; c=relaxed/simple;
	bh=GmNsm3d9DooaH/BB6fFUtCzUTYaP5+v6QHVBdWqd9EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llSr4SeE83O+h0Z+PQwtoI+wy8iLY1irsB1ZmgLMSiPQr8xKrZsa9FmKTcnQARhSeTlQW8zZDMwmEHti8dmbzAkLD4s4UW48q3pomz1rEPrOCIKsymw92t1rcD5fmdQ4nlMyc7/pVOwCsUX7yUSGtkTBNE1Yg/apA5Hptgq8JSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3yK6I4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3yK6I4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B01C61044;
	Tue, 27 Aug 2024 14:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770680;
	bh=GmNsm3d9DooaH/BB6fFUtCzUTYaP5+v6QHVBdWqd9EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3yK6I4kqZW3R/jERisEb80EgmC5aLyvu9JVOmwL2wNzC+BVKN5Pi3Y9GysXrAiyx
	 RUwz/Gc95HQHJ4Mxa3UKYScaGV4N9nyDpGKGfUTXbzCe2CrYe7T2MZa/enjavI+cZc
	 tI8MAc5j+vc1XUpKHfO7VqCMsuHzQFG3pooEzX0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 302/341] Input: i8042 - use new forcenorestore quirk to replace old buggy quirk combination
Date: Tue, 27 Aug 2024 16:38:53 +0200
Message-ID: <20240827143854.883360598@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


