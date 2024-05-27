Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5721754B;
	Mon, 27 May 2024 19:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836592; cv=none; b=jMiJfLeA6dgO4Irl4gYU/rnBHGnRmmwjjikmDUrUDdfp8zl+q2uYEv9Bgn7VbGQ5nKK2ocfBMS/7XKWdiA75y6gSSPZnLwgiy1olZlmvgIDSezms9bUiEbIrGUKngnHBR+t8aD2+ItzCSN91pGLjLiKZeXJwyumfHwTRxzcCz2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836592; c=relaxed/simple;
	bh=1vosxzuqwiljRV/YSEv6SXb0Qi0TVjlsSuPhf3OyRQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nh59dJwl6eZDSayiY/bGi+ltNJbSkvV3GbCQ3rNf4XxPj/fHoQTJzYgQj9/QOe3+V1WeyeBdR92p/+JctKqLKj8HLxgBfuAe0OYkVLBMOcpirmPhLCCrUnK+xs8+0rbth61+rB16412Xz5+rh2c0wMMvMWfhYAzlyw6MRUeeyQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4viDN3Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4viDN3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B79C2BBFC;
	Mon, 27 May 2024 19:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836592;
	bh=1vosxzuqwiljRV/YSEv6SXb0Qi0TVjlsSuPhf3OyRQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4viDN3YI9tDksrptPHihMFeVUTtwVA7mNKArHsFTjJS8/YB/FGiQpie4ja7crxv5
	 Zss45TbQTIQYwAPoyUzpv9RRKSIWpFBzhgi6tpbGv4l3nsCFB/dYhEcJX7tFoa0Fb2
	 aFalMOZTlWrdC4t98OulaRDBokJn4RudfqKHKB08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 114/427] ACPI: bus: Indicate support for IRQ ResourceSource thru _OSC
Date: Mon, 27 May 2024 20:52:41 +0200
Message-ID: <20240527185612.410807835@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 403ad17c06509794fdf6e4d4b3070bd5b56e2a8e ]

The ACPI IRQ mapping code supports parsing of ResourceSource,
but this is not reported thru _OSC.

Fix this by setting bit 13 ("Interrupt ResourceSource support")
when evaluating _OSC.

Fixes: d44fa3d46079 ("ACPI: Add support for ResourceSource/IRQ domain mapping")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c   | 1 +
 include/linux/acpi.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 0c48b603098a8..a87b10eef77df 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -323,6 +323,7 @@ static void acpi_bus_osc_negotiate_platform_control(void)
 	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_PCLPI_SUPPORT;
 	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_OVER_16_PSTATES_SUPPORT;
 	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_GED_SUPPORT;
+	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_IRQ_RESOURCE_SOURCE_SUPPORT;
 	if (IS_ENABLED(CONFIG_ACPI_PRMT))
 		capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_PRM_SUPPORT;
 	if (IS_ENABLED(CONFIG_ACPI_FFH))
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index e77783e101c36..168201e4c7827 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -577,6 +577,7 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 #define OSC_SB_OVER_16_PSTATES_SUPPORT		0x00000400
 #define OSC_SB_GED_SUPPORT			0x00000800
 #define OSC_SB_CPC_DIVERSE_HIGH_SUPPORT		0x00001000
+#define OSC_SB_IRQ_RESOURCE_SOURCE_SUPPORT	0x00002000
 #define OSC_SB_CPC_FLEXIBLE_ADR_SPACE		0x00004000
 #define OSC_SB_GENERIC_INITIATOR_SUPPORT	0x00020000
 #define OSC_SB_NATIVE_USB4_SUPPORT		0x00040000
-- 
2.43.0



