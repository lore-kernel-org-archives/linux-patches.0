Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1CE15EAD
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VltYzLUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD649C433C8;
	Mon, 23 Oct 2023 11:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061764;
	bh=XRwFHqpQoaGUXYbkkr0JkIcnvRTt5CEJFjPVw7RFEb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VltYzLUruad2f4l/KRmUHxAJXa6h1W0J4MhWBPoUqFQbO9sDCeic00qWdjO/ktsPr
	 LAtwFXzRBU0dXU7i/sJvXOIQ32xtA/k4ES9lCoGkENWeMdEJYX2Kh6L2mqDJIEaCD+
	 K7+vlFFQNw1dRyoxoqgy+fSjMN//MNR7SDHtKsNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/202] ACPI: resource: Skip IRQ override on ASUS ExpertBook B1502CBA
Date: Mon, 23 Oct 2023 12:57:17 +0200
Message-ID: <20231023104830.333434449@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Menzel <pmenzel@molgen.mpg.de>

[ Upstream commit 05cda427126f30ce3fc8ffd82fd6f5196398d502 ]

Like the ASUS ExpertBook B2502CBA and various ASUS Vivobook laptops, the
ASUS ExpertBook B1502CBA has an ACPI DSDT table that describes IRQ 1 as
ActiveLow while the kernel overrides it to Edge_High.

    $ sudo dmesg | grep DMI
    DMI: ASUSTeK COMPUTER INC. ASUS EXPERTBOOK B1502CBA_B1502CBA/B1502CBA, BIOS B1502CBA.300 01/18/2023
    $ grep -A 40 PS2K dsdt.dsl | grep IRQ -A 1
                    IRQ (Level, ActiveLow, Exclusive, )
                        {1}

This prevents the keyboard from working. To fix this issue, add this laptop
to the skip_override_table so that the kernel does not override IRQ 1.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217323
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: c1ed72171ed5 ("ACPI: resource: Skip IRQ override on ASUS ExpertBook B1402CBA")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 57e8ba44df741..a49acf8ddacae 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -421,6 +421,13 @@ static const struct dmi_system_id asus_laptop[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "S5602ZA"),
 		},
 	},
+	{
+		.ident = "Asus ExpertBook B1502CBA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "B1502CBA"),
+		},
+	},
 	{
 		.ident = "Asus ExpertBook B2402CBA",
 		.matches = {
-- 
2.40.1



