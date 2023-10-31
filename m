Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84769208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gjMxE1C/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A10C433C7;
	Tue, 31 Oct 2023 17:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774624;
	bh=hgUHb6fCVYKjKvJIT/vAEOT5DqDh0lLNdl4UJ8F7hao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gjMxE1C/+sVfALIed/Ra9+cYn1AurcHVMordK49SzPPwS+BuSjBsaHSj7+f8AQDM+
	 QPLuqSR7wbbAkCQmVwWSff55+HuLwHwvvpM3ny6ZmHTkPELwanUu01/MjLuKY0pmzd
	 QaiGhy7IgZTvbKTtdJYUx+DUlg1WDBaqdN5tauKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	David Lazar <dlazar@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 110/112] platform/x86: Add s2idle quirk for more Lenovo laptops
Date: Tue, 31 Oct 2023 18:01:51 +0100
Message-ID: <20231031165904.732444000@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lazar <dlazar@gmail.com>

[ Upstream commit 3bde7ec13c971445faade32172cb0b4370b841d9 ]

When suspending to idle and resuming on some Lenovo laptops using the
Mendocino APU, multiple NVME IOMMU page faults occur, showing up in
dmesg as repeated errors:

nvme 0000:01:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x000b
address=0xb6674000 flags=0x0000]

The system is unstable afterwards.

Applying the s2idle quirk introduced by commit 455cd867b85b ("platform/x86:
thinkpad_acpi: Add a s2idle resume quirk for a number of laptops")
allows these systems to work with the IOMMU enabled and s2idle
resume to work.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218024
Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Suggested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Signed-off-by: David Lazar <dlazar@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/ZTlsyOaFucF2pWrL@localhost
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc-quirks.c |   73 ++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

--- a/drivers/platform/x86/amd/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc-quirks.c
@@ -111,6 +111,79 @@ static const struct dmi_system_id fwbug_
 			DMI_MATCH(DMI_PRODUCT_NAME, "21A1"),
 		}
 	},
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=218024 */
+	{
+		.ident = "V14 G4 AMN",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82YT"),
+		}
+	},
+	{
+		.ident = "V14 G4 AMN",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83GE"),
+		}
+	},
+	{
+		.ident = "V15 G4 AMN",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82YU"),
+		}
+	},
+	{
+		.ident = "V15 G4 AMN",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83CQ"),
+		}
+	},
+	{
+		.ident = "IdeaPad 1 14AMN7",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82VF"),
+		}
+	},
+	{
+		.ident = "IdeaPad 1 15AMN7",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82VG"),
+		}
+	},
+	{
+		.ident = "IdeaPad 1 15AMN7",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82X5"),
+		}
+	},
+	{
+		.ident = "IdeaPad Slim 3 14AMN8",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82XN"),
+		}
+	},
+	{
+		.ident = "IdeaPad Slim 3 15AMN8",
+		.driver_data = &quirk_s2idle_bug,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82XQ"),
+		}
+	},
 	/* https://gitlab.freedesktop.org/drm/amd/-/issues/2684 */
 	{
 		.ident = "HP Laptop 15s-eq2xxx",


