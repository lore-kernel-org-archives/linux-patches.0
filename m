Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A331C26B2DA;
	Mon, 23 Mar 2026 15:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278103; cv=none; b=jX5nLXWZcRdrad0VjTgA3EBDgEIQtiJlvpKncbatePsy8jiI4jPwtu4xCDEU1bFMNhPRi9VQlZBl6r9CIyaqI8cvyCb341nPUP5i2H5Oeuiz2ewR/2jfskVOEj1RQ3CNsUIQaou392L9KsZ3Y4MdXa6L39F5zUeTxO6jraxLkC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278103; c=relaxed/simple;
	bh=/qJO6Qdd32GiTOJUou3Fwc2NF9U++wbooMfVejPgGxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgy84z99kyM+I3ddNTDVk3w7NMYIu4zy0O11uR9DHV8+cn6pzs7+OKeNHN/+gDmFD51t/f6Xp9PrFZOsmPnRnI64rZxAI8LOHsbqJ5eYNiYdu4cJrHNuQ0JSTPTGRpIRKlYvmBCiqHegXyIOS0Cp8QzP3JxhARm8Yqs38/Uh3sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJqMjuxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJqMjuxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C0CC4CEF7;
	Mon, 23 Mar 2026 15:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278103;
	bh=/qJO6Qdd32GiTOJUou3Fwc2NF9U++wbooMfVejPgGxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJqMjuxPEjCHmxObtte4IWVmvDcBa3rM8XMahW2E/plI6BTxs+UgE8t3PZsR37bG0
	 Pt8frSD0j+SXIJ5mvkvjlYwePvgRvlEHn+J+o4tQ6WIvkOCB43qKMDZrHDtbfFhKe6
	 FCYc+uhBK65bnWaZyeqQpyGO6gXz79wOmxZmwSF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sofia Schneider <sofia@schn.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 203/567] ACPI: OSI: Add DMI quirk for Acer Aspire One D255
Date: Mon, 23 Mar 2026 14:42:03 +0100
Message-ID: <20260323134538.867576322@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sofia Schneider <sofia@schn.dev>

[ Upstream commit 5ede90206273ff156a778254f0f972a55e973c89 ]

The screen backlight turns off during boot (specifically during udev device
initialization) when returning true for _OSI("Windows 2009").

Analyzing the device's DSDT reveals that the firmware takes a different
code path when Windows 7 is reported, which leads to the backlight shutoff.
Add a DMI quirk to invoke dmi_disable_osi_win7 for this model.

Signed-off-by: Sofia Schneider <sofia@schn.dev>
Link: https://patch.msgid.link/20260223025240.518509-1-sofia@schn.dev
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/osi.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/acpi/osi.c b/drivers/acpi/osi.c
index ae9620757865b..600af8814038a 100644
--- a/drivers/acpi/osi.c
+++ b/drivers/acpi/osi.c
@@ -389,6 +389,19 @@ static const struct dmi_system_id acpi_osi_dmi_table[] __initconst = {
 		},
 	},
 
+	/*
+	 * The screen backlight turns off during udev device creation
+	 * when returning true for _OSI("Windows 2009")
+	 */
+	{
+	.callback = dmi_disable_osi_win7,
+	.ident = "Acer Aspire One D255",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "AOD255"),
+		},
+	},
+
 	/*
 	 * The wireless hotkey does not work on those machines when
 	 * returning true for _OSI("Windows 2012")
-- 
2.51.0



