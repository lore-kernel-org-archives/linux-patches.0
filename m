Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B04E3BA254;
	Mon, 23 Mar 2026 16:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282421; cv=none; b=NesARjn7wYlz4fl35RWfTSz8TTxbmMGPMFCUX8Qq4AV5sNOnTHL/sxKb4wxo/MWAgddxLLHQW6NgmKf2aEVU8jVJN8BPiUYFh596iP70ATZwUrWzOlYBTc2K8DHnSmTqSctxxMmjnNMSubB0flICSOoVD7wvpVTcApuqMVd1mqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282421; c=relaxed/simple;
	bh=lOku3nFW6AFClrGWcW6QhvDSnKmvNyoleu10Yq+stNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdVGi1umYmbD5O7p06Hppz5EadP589HglR4HQ5esH/bDl+py6+8s3JQdk73tGX/xWK7gqyFZGYXv8MBIwNEDcTHyl4niax09F4C9BSPJbv5jQLSU9D+3oVCkYfocJLQPr63kyTCJ8HtUuFvIRBnqw1L0ISDX39gTSvdr5VU4wuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1WKK4sj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1WKK4sj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB132C4CEF7;
	Mon, 23 Mar 2026 16:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282421;
	bh=lOku3nFW6AFClrGWcW6QhvDSnKmvNyoleu10Yq+stNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1WKK4sjxqbMzIbdr/Mqwy/GQptLvXmILM127Wq30CKdgdqsqpYEZSY5zXbAYLSFA
	 LZJyyFs7eVXugN5AO6JlGpP0vqkhJ125YT3V5leKNJX6gPrMcMzDybY+1GMhiWCcXF
	 KINpGQW+FSVOPDl+VK1ixD1Wu3ZZHFQxcsJaMKng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sofia Schneider <sofia@schn.dev>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/481] ACPI: OSI: Add DMI quirk for Acer Aspire One D255
Date: Mon, 23 Mar 2026 14:42:13 +0100
Message-ID: <20260323134528.927102867@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



