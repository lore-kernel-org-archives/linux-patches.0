Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87018489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E67DC433EF;
	Fri, 10 Mar 2023 14:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457719;
	bh=HTi9XEIUTifRYvY7WFN0JL0Q4F9ejH1SNlPVIv0C1b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLBjSgxUBwojhfHjC6SiuCplDaCEd9XR+PTX62iGsXW/bvFEFbHrpsEvHsZyDN6uS
	 lxXSFfq6zPMEfWYtO0bEWHQFB/w9Fhvlc/Dlte8BQDVQZoxdmY/jC6pxvkUwpPpQRc
	 GogRcQixHZZ7UKPIh7Ywt06p8GdI2tWgBftFuJ7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 035/252] ACPICA: Drop port I/O validation for some regions
Date: Fri, 10 Mar 2023 14:36:45 +0100
Message-Id: <20230310133719.892957467@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit e1d9148582ab2c3dada5c5cf8ca7531ca269fee5 ]

Microsoft introduced support in Windows XP for blocking port I/O
to various regions.  For Windows compatibility ACPICA has adopted
the same protections and will disallow writes to those
(presumably) the same regions.

On some systems the AML included with the firmware will issue 4 byte
long writes to 0x80.  These writes aren't making it over because of this
blockage. The first 4 byte write attempt is rejected, and then
subsequently 1 byte at a time each offset is tried. The first at 0x80
works, but then the next 3 bytes are rejected.

This manifests in bizarre failures for devices that expected the AML to
write all 4 bytes.  Trying the same AML on Windows 10 or 11 doesn't hit
this failure and all 4 bytes are written.

Either some of these regions were wrong or some point after Windows XP
some of these regions blocks have been lifted.

In the last 15 years there doesn't seem to be any reports popping up of
this error in the Windows event viewer anymore.  There is no documentation
at Microsoft's developer site indicating that Windows ACPI interpreter
blocks these regions. Between the lack of documentation and the fact that
the writes actually do work in Windows 10 and 11, it's quite likely
Windows doesn't actually enforce this anymore.

So to help the issue, only enforce Windows XP specific entries if the
latest _OSI supported is Windows XP. Continue to enforce the
ALWAYS_ILLEGAL entries.

Link: https://github.com/acpica/acpica/pull/817
Fixes: 7f0719039085 ("ACPICA: New: I/O port protection")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/hwvalid.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpica/hwvalid.c b/drivers/acpi/acpica/hwvalid.c
index 24f9b61aa4049..b081177c421aa 100644
--- a/drivers/acpi/acpica/hwvalid.c
+++ b/drivers/acpi/acpica/hwvalid.c
@@ -23,8 +23,8 @@ acpi_hw_validate_io_request(acpi_io_address address, u32 bit_width);
  *
  * The table is used to implement the Microsoft port access rules that
  * first appeared in Windows XP. Some ports are always illegal, and some
- * ports are only illegal if the BIOS calls _OSI with a win_XP string or
- * later (meaning that the BIOS itelf is post-XP.)
+ * ports are only illegal if the BIOS calls _OSI with nothing newer than
+ * the specific _OSI strings.
  *
  * This provides ACPICA with the desired port protections and
  * Microsoft compatibility.
@@ -145,7 +145,8 @@ acpi_hw_validate_io_request(acpi_io_address address, u32 bit_width)
 
 			/* Port illegality may depend on the _OSI calls made by the BIOS */
 
-			if (acpi_gbl_osi_data >= port_info->osi_dependency) {
+			if (port_info->osi_dependency == ACPI_ALWAYS_ILLEGAL ||
+			    acpi_gbl_osi_data == port_info->osi_dependency) {
 				ACPI_DEBUG_PRINT((ACPI_DB_VALUES,
 						  "Denied AML access to port 0x%8.8X%8.8X/%X (%s 0x%.4X-0x%.4X)\n",
 						  ACPI_FORMAT_UINT64(address),
-- 
2.39.2



