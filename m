Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE46D168C4;
	Mon, 27 May 2024 19:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837884; cv=none; b=o37fM4g/jCiHlN9SD5xEA5fXhciY0tOeQijhjZPDABJ+4sqbVNUkBvF1QfcXRkHGZIdqxSG0GkuRwpeat+LSmRH/4AePK+nH+KKnOSocPG/j5qXrBo85He1JIm+lwKlSfdnNgblVbFxs8h8e30OlR1csFVlhc+2lHmc35wFVPFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837884; c=relaxed/simple;
	bh=1y2C+xV7BEdBJAHK0QsWTjc/hNp1gA/7a0+JmBw1wbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzlllReFQxpyEsHJxCuVEA0Jdk6RK40H8yMJYKFlJkJbmFwPgN28I96tNeg6BXY2jrpVqBRpHHiLOJDsM3oee+ogqFiix+7Z8kVB0qwcTOhLgAk8NliSD+5ZX1HoQAyTLYVtVygMlWrozgKq5zR+Kp2U0kK5F6yxEi/UXXl3h8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rj4Mjib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rj4Mjib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7411BC2BBFC;
	Mon, 27 May 2024 19:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837883;
	bh=1y2C+xV7BEdBJAHK0QsWTjc/hNp1gA/7a0+JmBw1wbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2rj4Mjib87WHCRzf0It1ZVFNSVkpNAdt0DYdNa20/ZtJNfHmj1fayjK7TGP/2Rn/8
	 6/lLG3NkMmCQnRd7cZH7wLrpFwZo6rdnjCR9wV0KpbEtqxKwPQyWIuJRs/68cLMzuZ
	 HtnrJoMMh/eM4KMHKKLFSO3Ud/b+BBci8MbIJJjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 183/493] ACPI: bus: Indicate support for IRQ ResourceSource thru _OSC
Date: Mon, 27 May 2024 20:53:05 +0200
Message-ID: <20240527185636.340606932@linuxfoundation.org>
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
index 9486c1be7258e..3f84d8ed9d299 100644
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
index 01ff2dd313680..de1263b1da3bc 100644
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



