Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD7415B10D;
	Mon, 28 Oct 2024 06:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097156; cv=none; b=Amis6f25+muzLSLCbjebgPwktOKw7c8P901GgbdgfGiT/2RMTOYpFVyj8/fF87s2MhSu8/T3Fx1q/OLkswN/sS5cUm+1ovgX24GAcQc2bMa+W28KUXyprobtGUXbwT7myyxghad+/zFw15dMuJcbkMi4M6mrg4XBcmEriu+HLSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097156; c=relaxed/simple;
	bh=M2A3m6ia6pLsmBRJHqKd0PljowX1RR46bXkemKRlqQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9xqI9urLQzwb7s3+abQ+nTp6mC6abbgfYdsy1Uud2xiPGNtWupggh0MmM4Eo9cy+Ji4Nx9dKdwVQPFGTIjmNtJP2Q2kYEx1F9WbBAko/OpZ/mNEE6YIwkJLeSTweyVVH/zEjCFCbx74DJ++DPpaLFKwSTP1eEYicPfw1nUBZlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxZUV30F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxZUV30F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF654C4CEC7;
	Mon, 28 Oct 2024 06:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097156;
	bh=M2A3m6ia6pLsmBRJHqKd0PljowX1RR46bXkemKRlqQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hxZUV30F3FAw/E3JieZqUSBOPXUNNvsD0zyMNMBrZs+VHK70zVo8hbm7/FMAclcj3
	 FBVR79TwBK0s43mkGwvCK56sod4mmLuanfF3tgOAY8aRUgv52g1aE0072DDPAoXtmh
	 cl919GON9lzn6kJgDlgbjlyWHeGAuh3zsR0mKmCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubham Panwar <shubiisp8@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 70/80] ACPI: button: Add DMI quirk for Samsung Galaxy Book2 to fix initial lid detection issue
Date: Mon, 28 Oct 2024 07:25:50 +0100
Message-ID: <20241028062254.555544397@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


