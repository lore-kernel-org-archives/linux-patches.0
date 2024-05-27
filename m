Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D990C168C4;
	Mon, 27 May 2024 19:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837985; cv=none; b=WGDA6jg3Hpm9F5CLjRpD+LJ1e//YlKwg4BQw8Cz58ixVegqeJlfag66wsP/Y1wcH1q8UC4qdeUiybV1mpWP/zTOA2fr7zwLuKfengQhoygARJzLQ+FItc9Xa7uOz2jXWY1nQ0OSwSuMwm2/wkal29FOpDvKkBYRXIlxkhp82NCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837985; c=relaxed/simple;
	bh=EaDqHmZNEPOe90+EBE31B+mkLK5FgyYbsDeNPkZ6MjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDtBdrbpLdgcVmQ0U/7gCJS8oOZ809maj8tW5ODawdDVNtQFhc/XESCOjN2jSY809fyiz3ZshKJn0xAfcVLa/+MJ1o2UAtwcKXfPa3+ioZ6of8slJP8uiU295XVFDoiVEq/EiDJK5Z1isETbwjO4vdg/jEwsIGK1HO7TFqPSx0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lq6GDdW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lq6GDdW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED91C2BBFC;
	Mon, 27 May 2024 19:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837985;
	bh=EaDqHmZNEPOe90+EBE31B+mkLK5FgyYbsDeNPkZ6MjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lq6GDdW38opfF7ZSURMUl8Ke6geXNAHmJ2kjF/OgAZqAO+oo5wcvRZw36CKol33qN
	 K2hpHk4jRFGWl9Omv8b7tyZiWUJ0XANp9zl15VpGkxb8a0hrPUyUe0N3DDoaFnw27F
	 J2CSxu2mOcBjeh5c07Pcj4zaG6/H8KQVoNsRDN1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 179/493] ACPI: bus: Indicate support for _TFP thru _OSC
Date: Mon, 27 May 2024 20:53:01 +0200
Message-ID: <20240527185636.206339752@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 95d43290f1e476b3be782dd17642e452d0436266 ]

The ACPI thermal driver already uses the _TPF ACPI method to retrieve
precise sampling time values, but this is not reported thru _OSC.

Fix this by setting bit 9 ("Fast Thermal Sampling support") when
evaluating _OSC.

Fixes: a2ee7581afd5 ("ACPI: thermal: Add Thermal fast Sampling Period (_TFP) support")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c   | 2 ++
 include/linux/acpi.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 569bd15f211be..9c5fc12fc13cb 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -316,6 +316,8 @@ static void acpi_bus_osc_negotiate_platform_control(void)
 		capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_PAD_SUPPORT;
 	if (IS_ENABLED(CONFIG_ACPI_PROCESSOR))
 		capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_PPC_OST_SUPPORT;
+	if (IS_ENABLED(CONFIG_ACPI_THERMAL))
+		capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_FAST_THERMAL_SAMPLING_SUPPORT;
 
 	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_HOTPLUG_OST_SUPPORT;
 	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_PCLPI_SUPPORT;
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index b7165e52b3c68..e4f4fb67ab55a 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -573,6 +573,7 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 #define OSC_SB_CPCV2_SUPPORT			0x00000040
 #define OSC_SB_PCLPI_SUPPORT			0x00000080
 #define OSC_SB_OSLPI_SUPPORT			0x00000100
+#define OSC_SB_FAST_THERMAL_SAMPLING_SUPPORT	0x00000200
 #define OSC_SB_CPC_DIVERSE_HIGH_SUPPORT		0x00001000
 #define OSC_SB_GENERIC_INITIATOR_SUPPORT	0x00002000
 #define OSC_SB_CPC_FLEXIBLE_ADR_SPACE		0x00004000
-- 
2.43.0



