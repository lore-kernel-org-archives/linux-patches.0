Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EAB1BE251;
	Tue,  2 Jul 2024 17:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941320; cv=none; b=duE8q7xKRUPZUBBbVtuV3EjyohPq5lR+Wuj0DI3RnnsDQN5WA8H/d3Tz0kN2DE/FBAfL9LhmRmd1yefRN8eSWj0/jwLwHu1K9kMGUGc5fBkOQlfjlRWfiID3dYFWox7yUHQz+RSHUhc3TQ8zZ9H+1trJtPo/1c6yptuCWYd5DoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941320; c=relaxed/simple;
	bh=Kgc72/wY4vsILA2RetK6AEhgNGjIAtj8DJFmpDbuWSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPLcYBED2cn24KCzajlOEHBiswd57LMtp/x2sozNgDYkna2XHpYU5tFMLJYigB6iAuv4vPQgR3kEW6RPaow57NAU29A3IFwZah/PFd4f9hws1w0jjXW+txUQlVB86WPfEFBpj5jXtCsZAd8ojI/VURVTGcdQSCIbNzSWDKyOzow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rp+ojxK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rp+ojxK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436A4C116B1;
	Tue,  2 Jul 2024 17:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941320;
	bh=Kgc72/wY4vsILA2RetK6AEhgNGjIAtj8DJFmpDbuWSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rp+ojxK3gtNAyC8Kjb/gYmLoYIWe3LLOMoXEWB67Phmz+Q6pvig5x0x3hc8iZpmls
	 B4my8PUTvsiKfBqYNU11Ega0H/QDiDXmlUcG7RRJZRt3WtAzJVYG3hSDl5W5DqcC0J
	 6BfTi2TUIXyXPFw1H4vVdwCNlOKuXGfSGjkwAe5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/128] ACPI: x86: Force StorageD3Enable on more products
Date: Tue,  2 Jul 2024 19:03:26 +0200
Message-ID: <20240702170226.438872782@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit e79a10652bbd320649da705ca1ea0c04351af403 ]

A Rembrandt-based HP thin client is reported to have problems where
the NVME disk isn't present after resume from s2idle.

This is because the NVME disk wasn't put into D3 at suspend, and
that happened because the StorageD3Enable _DSD was missing in the BIOS.

As AMD's architecture requires that the NVME is in D3 for s2idle, adjust
the criteria for force_storage_d3 to match *all* Zen SoCs when the FADT
advertises low power idle support.

This will ensure that any future products with this BIOS deficiency don't
need to be added to the allow list of overrides.

Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index ef431393381a0..d0257758cf989 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -188,16 +188,16 @@ bool acpi_device_override_status(struct acpi_device *adev, unsigned long long *s
 }
 
 /*
- * AMD systems from Renoir and Lucienne *require* that the NVME controller
+ * AMD systems from Renoir onwards *require* that the NVME controller
  * is put into D3 over a Modern Standby / suspend-to-idle cycle.
  *
  * This is "typically" accomplished using the `StorageD3Enable`
  * property in the _DSD that is checked via the `acpi_storage_d3` function
- * but this property was introduced after many of these systems launched
- * and most OEM systems don't have it in their BIOS.
+ * but some OEM systems still don't have it in their BIOS.
  *
  * The Microsoft documentation for StorageD3Enable mentioned that Windows has
- * a hardcoded allowlist for D3 support, which was used for these platforms.
+ * a hardcoded allowlist for D3 support as well as a registry key to override
+ * the BIOS, which has been used for these cases.
  *
  * This allows quirking on Linux in a similar fashion.
  *
@@ -210,19 +210,15 @@ bool acpi_device_override_status(struct acpi_device *adev, unsigned long long *s
  *    https://bugzilla.kernel.org/show_bug.cgi?id=216773
  *    https://bugzilla.kernel.org/show_bug.cgi?id=217003
  * 2) On at least one HP system StorageD3Enable is missing on the second NVME
-      disk in the system.
+ *    disk in the system.
+ * 3) On at least one HP Rembrandt system StorageD3Enable is missing on the only
+ *    NVME device.
  */
-static const struct x86_cpu_id storage_d3_cpu_ids[] = {
-	X86_MATCH_VENDOR_FAM_MODEL(AMD, 23, 24, NULL),  /* Picasso */
-	X86_MATCH_VENDOR_FAM_MODEL(AMD, 23, 96, NULL),	/* Renoir */
-	X86_MATCH_VENDOR_FAM_MODEL(AMD, 23, 104, NULL),	/* Lucienne */
-	X86_MATCH_VENDOR_FAM_MODEL(AMD, 25, 80, NULL),	/* Cezanne */
-	{}
-};
-
 bool force_storage_d3(void)
 {
-	return x86_match_cpu(storage_d3_cpu_ids);
+	if (!cpu_feature_enabled(X86_FEATURE_ZEN))
+		return false;
+	return acpi_gbl_FADT.flags & ACPI_FADT_LOW_POWER_S0;
 }
 
 /*
-- 
2.43.0



