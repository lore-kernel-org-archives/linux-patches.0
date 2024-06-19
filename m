Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A9712FB31;
	Wed, 19 Jun 2024 13:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802400; cv=none; b=VLLoQT6Oirj82t/ZqY+dYLXXTwWHju5+9RI4pPemvKHgWbXu9XQehtqOTkvzzWfwdY7syqm6kovWyS9EKFuRupPkvThOTFXM5fqINeJpuUAxA4dUO9Vd65oZJiKnGtiE9o1+BfAEgumiVUOpHAUKwN3/podsTTYWS6DHHvOHdrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802400; c=relaxed/simple;
	bh=MVhMPVidpCIxYZoidtKC28VKKgxYp0+SxK+dkfzI8Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqOJWmVC3lOWJRqOuSGeSd+1t7PxuceyCCylGoaXRKXCpFSpvZlFfxvviq3HR9G/liLg9RbdqcdPb6k0l0CbdV01CDyAsHpVUWNzNXmKz8CM7xsPteV/WT7WDmkp85Skkzp2h1VPxgbbL3xSzL/c4likBMbbaJs3Gt/9N6PhG6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g68k/Vum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g68k/Vum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1F2C2BBFC;
	Wed, 19 Jun 2024 13:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802400;
	bh=MVhMPVidpCIxYZoidtKC28VKKgxYp0+SxK+dkfzI8Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g68k/Vum9ki4kKXgKobe1J5QROTSokiNWhtiAkP4xLYkS4xUvP3kjn46kbrw+EHct
	 5LwoDf4tcDsv6qjjUdLrgdIxbDcH6FVNOizRbHi/1KuZpDGESTx+4U/0X9uFIJuma3
	 BTMkuy8qCQN93dJmHDVhfS7Dzwqll4MoefHF8ksY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 182/267] ACPI: x86: Force StorageD3Enable on more products
Date: Wed, 19 Jun 2024 14:55:33 +0200
Message-ID: <20240619125613.329948465@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit e79a10652bbd320649da705ca1ea0c04351af403 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/x86/utils.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -198,16 +198,16 @@ bool acpi_device_override_status(struct
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
@@ -220,19 +220,15 @@ bool acpi_device_override_status(struct
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


