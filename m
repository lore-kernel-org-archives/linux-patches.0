Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136941DF726;
	Wed,  6 Nov 2024 12:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895736; cv=none; b=AqP8DYTSQ8spTvRMJicIoLiwuTFE072nlvXk7SG83ecXVYpE2UGLKKZy5xxJM5dccGRopzn4wyikr42e6DIw4IhyDcSdWvUM4VuagDkjnw7m4GshHSmWyOQItxNCUjQ6Mq2hU/WdKQu2HERGz0PPLIwXzd4ATbF6gGxY9hXtDbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895736; c=relaxed/simple;
	bh=bnueWQi6aRinWlTh4inG235QBtP/TT9LbFZ7Jr6w0+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9BKh2zaFHTQPIzoUv6GZbuwHB0Bn4PSQUkIprCjr4xCtEk1AEaXv0pyYYhfnDUK0HdKteZa1PqsGvlWhN+oNt5xcVgCq91QfDTt77fT1yowh9w8TjjJf5gvezwYOUMvdbOfPwMEq7AueWQ9KbCoX4ROq7c9jSbkdOxtbribk7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XFepUazx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XFepUazx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F875C4CECD;
	Wed,  6 Nov 2024 12:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895736;
	bh=bnueWQi6aRinWlTh4inG235QBtP/TT9LbFZ7Jr6w0+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFepUazxeeVE5bXylZ9+jZZw9RB1bLGJLYAuWDY9MfIPfI0mfBO3d5ZOqIxTLSLoJ
	 WCXko9b3vSaVZtIa2lZIUjNitDaWN6TioCg7BBNybxEHNRVz55Kjsuv6BT1cuTpNL+
	 0NvZRG8QJprTbXwu3e7KJmG+vWAriCeWHPuhiwus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubham Panwar <shubiisp8@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.19 317/350] ACPI: button: Add DMI quirk for Samsung Galaxy Book2 to fix initial lid detection issue
Date: Wed,  6 Nov 2024 13:04:05 +0100
Message-ID: <20241106120328.587696856@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -124,6 +124,17 @@ static const struct dmi_system_id lid_bl
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
 


