Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC82511187;
	Wed, 30 Sep 2026 15:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783664; cv=none; b=TuwlptXaCUb/ixaaB+Tt+2xzgjt5JBzutwdoCFNrdK2PicYzSJxWURs+2fbs66eIOZzI7fdOWAtoz2/3P5YGz1hTeaP07gET0eHSQMLeVrG3HyCnzSoDwUN/mMMcChpMmSXwvZrGDmKcJr7/Vn0kq1CRg2CxK2AoWwAKXlTTLZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783664; c=relaxed/simple;
	bh=kVrHiFz4gR9jKOe81sEa7mtl73VYotVmjCZJ5pfHkiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7c6ycwUYlDGdj9t3zfJ+jGdXOaa3hEsnXZMh0GV43+oXdTlFAaWeX6Oz6CeAPsZbkuVo0emtVB8sybkjAkKiguHJ9SVuyAcr6nrOa/hG34sV9fShxrxq8xN1F2qva14QIIDrwRtcjZLXfBNYFhQ+7adATSTbyUqRWimsx57iZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJiN1S4o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJiN1S4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1771F00893;
	Wed, 30 Sep 2026 15:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783659;
	bh=z+bTDaZuAmvDNdh0PM4Jh0TgY5HOK+LvVlIPtaVjfLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJiN1S4oYYPGWZl3jK6SQHL+/kA/p3xD2OHZ+EDrnv9wFh2OTr7/AMgW6/S6PZC7V
	 PiDkwHTZOIlq8m6XRIwILgKlVUK51cTgtCBznDxRGBYQTMnoLo9pH91oEGVwa2TrSR
	 VHyMtEu+GXkA99D1dTtk8cRR9A7b7hAzX+Q1m9hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Sommers <chris.sommers@icloud.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 450/595] Input: i8042 - add quirk for Acer Aspire Go 15 AG15-42P
Date: Wed, 30 Sep 2026 17:25:43 +0200
Message-ID: <20260930152357.358520471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -265,6 +265,13 @@ static const struct dmi_system_id i8042_
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
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire ES1-432"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_RESET_ALWAYS)


