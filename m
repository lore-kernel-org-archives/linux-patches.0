Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9979112EBEA;
	Tue, 25 Jun 2024 09:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308659; cv=none; b=a9QjrBPFtTKaDtonQx46VwpTF8hxgwQJ+6lzsOMrT16bpG0nUmqlzaZ14cyzkQmjmznRCCtPXB+Xw3TI9g4a58boTP122wvfZUHt2E/+CwLjK37hpYYsa40CVaKN+dLxWQaImbt7L1XeooBUdIS7aMDoAm4A7uZHouxtBpnGzZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308659; c=relaxed/simple;
	bh=7S6qiaTP+bV+6VW+EHhxcHs7QFHpbGL2j0VFk607yWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAL4F+GinulUu5p67v05Ms/troUEebAPwIJ5mMyBbFc8LcOOm8zQGnO/UoqPoDet3lfSmZ5cQeRp737zA6+8CMniyRAn3a7RbIlz6z5eO2mkX6LjmISwU6UvkEGbyxFrXLRgJD9+Kl3m15RbgeWkk+NQ9okN2cxtazkykQtZ0qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4VEnrfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4VEnrfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB2DC32786;
	Tue, 25 Jun 2024 09:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308659;
	bh=7S6qiaTP+bV+6VW+EHhxcHs7QFHpbGL2j0VFk607yWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4VEnrfsDovKQq7y7MaKLCQ0OQ7QjmlknphuLOazTR2Ac+P0Q5/5JiaQz4KXrn3RH
	 SJRrMPswf/hs7JbiGpK+WC5iyM3YI8fBfjNc+3MI/Vf/fRuHP/zpM+rYde5tOeQC1h
	 xNVOmWQhf5nxcdAO+N11LEdPkSNZ/iD5oRIOxQBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 166/250] ACPI: scan: Ignore camera graph port nodes on all Dell Tiger, Alder and Raptor Lake models
Date: Tue, 25 Jun 2024 11:32:04 +0200
Message-ID: <20240625085554.428150368@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c7be64355fccfe7d4727681e32fce07113e40af1 ]

Dell laptops with IPU6 camera (the Tiger Lake, Alder Lake and Raptor
Lake generations) have broken ACPI MIPI DISCO information (this results
from an OEM attempt to make Linux work by supplying it with custom data
in the ACPI tables which has never been supported in the mainline).

Instead of adding a lot of DMI quirks for this, check for Dell platforms
based on the processor generations in question and drop the ACPI graph
port nodes, likely to be created with the help of invalid data, on all
of them.

Fixes: bd721b934323 ("ACPI: scan: Extract CSI-2 connection graph from _CRS")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/internal.h       |  4 ++++
 drivers/acpi/mipi-disco-img.c | 28 +++++++++++++++++++---------
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index a0801e0876fc0..a96d1bc662a37 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -301,6 +301,10 @@ void acpi_mipi_check_crs_csi2(acpi_handle handle);
 void acpi_mipi_scan_crs_csi2(void);
 void acpi_mipi_init_crs_csi2_swnodes(void);
 void acpi_mipi_crs_csi2_cleanup(void);
+#ifdef CONFIG_X86
 bool acpi_graph_ignore_port(acpi_handle handle);
+#else
+static inline bool acpi_graph_ignore_port(acpi_handle handle) { return false; }
+#endif
 
 #endif /* _ACPI_INTERNAL_H_ */
diff --git a/drivers/acpi/mipi-disco-img.c b/drivers/acpi/mipi-disco-img.c
index d05413a0672a9..0ab13751f0dbc 100644
--- a/drivers/acpi/mipi-disco-img.c
+++ b/drivers/acpi/mipi-disco-img.c
@@ -725,14 +725,20 @@ void acpi_mipi_crs_csi2_cleanup(void)
 		acpi_mipi_del_crs_csi2(csi2);
 }
 
-static const struct dmi_system_id dmi_ignore_port_nodes[] = {
-	{
-		.matches = {
-			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS 9315"),
-		},
-	},
-	{ }
+#ifdef CONFIG_X86
+#include <asm/cpu_device_id.h>
+#include <asm/intel-family.h>
+
+/* CPU matches for Dell generations with broken ACPI MIPI DISCO info */
+static const struct x86_cpu_id dell_broken_mipi_disco_cpu_gens[] = {
+	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE_L, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S, NULL),
+	{}
 };
 
 static const char *strnext(const char *s1, const char *s2)
@@ -761,7 +767,10 @@ bool acpi_graph_ignore_port(acpi_handle handle)
 	static bool dmi_tested, ignore_port;
 
 	if (!dmi_tested) {
-		ignore_port = dmi_first_match(dmi_ignore_port_nodes);
+		if (dmi_name_in_vendors("Dell Inc.") &&
+		    x86_match_cpu(dell_broken_mipi_disco_cpu_gens))
+			ignore_port = true;
+
 		dmi_tested = true;
 	}
 
@@ -794,3 +803,4 @@ bool acpi_graph_ignore_port(acpi_handle handle)
 	kfree(orig_path);
 	return false;
 }
+#endif
-- 
2.43.0



