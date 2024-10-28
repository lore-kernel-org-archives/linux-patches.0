Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728002AF07;
	Mon, 28 Oct 2024 06:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098446; cv=none; b=lGShoMgmHADqJ0AkahaAa1e0Sy/1zcgbil7O1Cx5arb+UVBl7PLfdkmDz5MYatpjdG56jT0KpZ8FR4g4pDcjSyk+NQ2lgNw33tt2/uOwDUxbt+dadnDuJbEowCE+iUfrPKAFhrBINlQ4VlnyP4iIDQhLokwAzSKRawa+fI4Tgp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098446; c=relaxed/simple;
	bh=UNv5+VE6Loord1qzOajspQESLguwubLerwfrn976vG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tg7b56eHsGKq2Xdk6rfK5VyGlMu1LN+UZDp7YTWz6ua75FEp99bT78XKPYMV9acIQQF+ebDhkv216Fb1T31Yu4Y+UyioCUSSvvjf4os3QikoDxh9CdmmtWE6jtxn7GzPZ/1FV/lU8AbFBJ+5CTQzbOk67VCXKXR3W9HY1e/uth8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oy+2OCIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oy+2OCIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A1DC4CEC3;
	Mon, 28 Oct 2024 06:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098446;
	bh=UNv5+VE6Loord1qzOajspQESLguwubLerwfrn976vG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oy+2OCIws2e9Opy1EFnN7zEcpz3avhf5erec5fM1CA2WflTjFPLU9W1ILL6uGAWu6
	 HiADbEH5JHEXv/zgB8JTbwoHAGAYetlJoJcVQT355x2/QSyQ2ajPoLJrhY5VMajweE
	 /zRaTy3sMY/CT2WzM+yx6Mz8nZcbrp/d0jX7C/lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubham Panwar <shubiisp8@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.11 213/261] ACPI: button: Add DMI quirk for Samsung Galaxy Book2 to fix initial lid detection issue
Date: Mon, 28 Oct 2024 07:25:55 +0100
Message-ID: <20241028062317.426308539@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shubham Panwar <shubiisp8@gmail.com>

commit 8fa73ee44daefc884c53a25158c25a4107eb5a94 upstream.

Add a DMI quirk for Samsung Galaxy Book2 to fix an initial lid state
detection issue.

The _LID device incorrectly returns the lid status as "closed" during
boot, causing the system to enter a suspend loop right after booting.

The quirk ensures that the correct lid state is reported initially,
preventing the system from immediately suspending after startup.  It
only addresses the initial lid state detection and ensures proper
system behavior upon boot.

Signed-off-by: Shubham Panwar <shubiisp8@gmail.com>
Link: https://patch.msgid.link/20241020095045.6036-2-shubiisp8@gmail.com
[ rjw: Changelog edits ]
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/button.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -130,6 +130,17 @@ static const struct dmi_system_id dmi_li
 		},
 		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
 	},
+	{
+		/*
+		 * Samsung galaxybook2 ,initial _LID device notification returns
+		 * lid closed.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "750XED"),
+		},
+		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
+	},
 	{}
 };
 


