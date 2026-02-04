Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC5E27FD56;
	Wed,  4 Feb 2026 14:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216484; cv=none; b=swc1uOjS2Rqpeoj7XThBclvn/geZCGZj734157HvXupROgJ+5lFczOwff5p4U07r8lqlxVwWuNpRZrwpCbZCximDhUSVYz+/J0JdIQdhawgfRc1Rk2fEYfYj7tveOZ/0oaVonjz6XWohgdPcbX0Li3amsPgI+j3T5Q3KAC/ajRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216484; c=relaxed/simple;
	bh=tsJfvpBtZmMnGDfQZT0gQVJr6MtDh1//gDP/AgZ+ju4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAIlHpK49FrGxbmRZlRhS5xseGL3nEvrNAA+83Tuk+i7y/QmMq8jcd4/r3Up1pa97FXA8Kv1YfbxwtSA0AISptUYJO6SiLgyOtqsZ312j633Lc5VUP6NlRjxqtoEx9AFQIIODgoHd5qBH6jPuRZB1OyuhpZ1FFEUDY+iLY6Berw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RuMThTPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RuMThTPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD16C4CEF7;
	Wed,  4 Feb 2026 14:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216484;
	bh=tsJfvpBtZmMnGDfQZT0gQVJr6MtDh1//gDP/AgZ+ju4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RuMThTPVZ8UMN2ugg+kU7fEgMeMDkS5PxFX2LMSDVi+0Dibt9oFi9WRWgipNyzuD+
	 p3Xm0Hoc6yZeNpwaDxh+YT5XySdtBs7MREA3QlPGu5G7tJ8IAYLxqcppmwqwfefKUb
	 1ChmJOTHUpiHZIvlVfCbiw8hTJix52eIgxXlvvFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	feng <alec.jiang@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 068/161] Input: i8042 - add quirk for ASUS Zenbook UX425QA_UM425QA
Date: Wed,  4 Feb 2026 15:38:51 +0100
Message-ID: <20260204143854.204812439@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

From: feng <alec.jiang@gmail.com>

commit 2934325f56150ad8dab8ab92cbe2997242831396 upstream.

The ASUS Zenbook UX425QA_UM425QA fails to initialize the keyboard after
a cold boot.

A quirk already exists for "ZenBook UX425", but some Zenbooks report
"Zenbook" with a lowercase 'b'. Since DMI matching is case-sensitive,
the existing quirk is not applied to these "extra special" Zenbooks.

Testing confirms that this model needs the same quirks as the ZenBook
UX425 variants.

Signed-off-by: feng <alec.jiang@gmail.com>
Link: https://patch.msgid.link/20260122013957.11184-1-alec.jiang@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -114,6 +114,17 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_NEVER)
 	},
 	{
+		/*
+		 * ASUS Zenbook UX425QA_UM425QA
+		 * Some Zenbooks report "Zenbook" with a lowercase b.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Zenbook UX425QA_UM425QA"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_PROBE_DEFER | SERIO_QUIRK_RESET_NEVER)
+	},
+	{
 		/* ASUS ZenBook UX425UA */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),


