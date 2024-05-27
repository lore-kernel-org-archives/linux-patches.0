Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107011607BC;
	Mon, 27 May 2024 19:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836585; cv=none; b=csQl8nSdbbLmL0yfWMkyWccI2lHQC0ZCxswDROvPd9xLhOHL5Zbkj7GI/O8d9dnTwYuFK+a8qgQtdyYsopY3ivJjGnbMFnCyu6u4ercuXgogzz6YGY86X6FFAQjyr0nhfU1z5GLd+DN2EbL8n+OGo6DpOSnr8gSEuC4YDXjzIFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836585; c=relaxed/simple;
	bh=slJCr3qUgsCUsj6IbDau8oZkJarBxLLV6a0gqsv6Fu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCn+IXFieiwhe+V2PLJRGiTFopj9Cr4r1wvDGLzmFVBcAhq/7Hjy11jLbqxpPdm5av26d0nT8y7rFQ7Gv+IEIth7ZUfgYJKiibwWDqEL9OgYhVeLwjsSsovr5BzECQLarrWdj82gwZ2mrm+WQa7m8HHHVJBxUKu/CDo+2zNYG+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gprZM8kh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gprZM8kh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403C7C2BBFC;
	Mon, 27 May 2024 19:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836584;
	bh=slJCr3qUgsCUsj6IbDau8oZkJarBxLLV6a0gqsv6Fu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gprZM8khOYEF4EQFw8xf+rS9nRIAYQ9G1VuOCu2jETt5/R+MkA6lqYn6PpI4ezime
	 taB+dn0DVQpqGDXJHPyNdQW5Qa42CLdCf5IDiuEOJTzpgCZ2K7BVtdbrYmun8EDnZK
	 +yf/sTHlD2OEVHsy1A82nMR4PVB2mnsQUR/rNlSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 111/427] ACPI: bus: Indicate support for more than 16 p-states thru _OSC
Date: Mon, 27 May 2024 20:52:38 +0200
Message-ID: <20240527185612.150935061@linuxfoundation.org>
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

[ Upstream commit 6e8345f23ca37d6d41bb76be5d6a705ddf542817 ]

The code responsible for parsing the available p-states should
have no problems handling more than 16 p-states.

Indicate this by setting bit 10 ("Greater Than 16 p-state support")
when evaluating _OSC.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: a8a967a243d7 ("ACPI: bus: Indicate support for the Generic Event Device thru _OSC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/bus.c   | 1 +
 include/linux/acpi.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 9c13a4e43fa82..d5b0e80dc48e4 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -321,6 +321,7 @@ static void acpi_bus_osc_negotiate_platform_control(void)
 
 	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_HOTPLUG_OST_SUPPORT;
 	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_PCLPI_SUPPORT;
+	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_OVER_16_PSTATES_SUPPORT;
 	if (IS_ENABLED(CONFIG_ACPI_PRMT))
 		capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_PRM_SUPPORT;
 	if (IS_ENABLED(CONFIG_ACPI_FFH))
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 51bdd9e08f6da..0e0b027e27e21 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -574,6 +574,7 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 #define OSC_SB_PCLPI_SUPPORT			0x00000080
 #define OSC_SB_OSLPI_SUPPORT			0x00000100
 #define OSC_SB_FAST_THERMAL_SAMPLING_SUPPORT	0x00000200
+#define OSC_SB_OVER_16_PSTATES_SUPPORT		0x00000400
 #define OSC_SB_CPC_DIVERSE_HIGH_SUPPORT		0x00001000
 #define OSC_SB_GENERIC_INITIATOR_SUPPORT	0x00002000
 #define OSC_SB_CPC_FLEXIBLE_ADR_SPACE		0x00004000
-- 
2.43.0



