Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3D51B87D5;
	Wed, 19 Mar 2025 14:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394929; cv=none; b=AkjlA+auiKDo4ijkIc7Xjh5QzRaLM5qjvdNmIlucwAvro9I9TIsBapDaS36/0C6r/DcIa4qeuA10/FWV/xSsCcuyewsFvs1ErLJ28DlDnmbU0BYn1UYkjXOe+BsFukkY59jsAJSSKj0OE6XSkaVlDbgYt1NtU9grIvo75Swumy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394929; c=relaxed/simple;
	bh=KsqaA79Guo+Pl72ToeMY79SPLQBlfitsB5Cjyilfd94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxqu29nN7BG8SNUQILZyff/6m2hXhrjR99ElZonTp3WZpWcoIw+pkXitr1RL+eEQ2W7gkn4bbUtCyd+wpvXxEL+V4aSqfwedQgjeqklCLzX/XioBjHhhnu3czbchPy9vuFaRwj0B5R7YXQUSGqm4Av6uPnL/DxoXUzRRwPlX6eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfAOexUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfAOexUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52BEC4CEE4;
	Wed, 19 Mar 2025 14:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394928;
	bh=KsqaA79Guo+Pl72ToeMY79SPLQBlfitsB5Cjyilfd94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfAOexUU5n7Lf4LGakPWtwsFmd3HRmOhbwPjjrlcKCUI5zTN2mOjE64LWbPmmWOoS
	 o9Leop3tRw8kmJXJG42FOLCkQ7pjk39e9yuvgSUaYr/EfH5ZTtAJemFmLJGEoEisRK
	 SA6bD0FmHCKUcMA5kPxK7HVBA72f1DVxzAO66PhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Maluka <dmaluka@chromium.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 142/241] x86/of: Dont use DTB for SMP setup if ACPI is enabled
Date: Wed, 19 Mar 2025 07:30:12 -0700
Message-ID: <20250319143031.234632035@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmytro Maluka <dmaluka@chromium.org>

[ Upstream commit 96f41f644c4885761b0d117fc36dc5dcf92e15ec ]

There are cases when it is useful to use both ACPI and DTB provided by
the bootloader, however in such cases we should make sure to prevent
conflicts between the two. Namely, don't try to use DTB for SMP setup
if ACPI is enabled.

Precisely, this prevents at least:

- incorrectly calling register_lapic_address(APIC_DEFAULT_PHYS_BASE)
  after the LAPIC was already successfully enumerated via ACPI, causing
  noisy kernel warnings and probably potential real issues as well

- failed IOAPIC setup in the case when IOAPIC is enumerated via mptable
  instead of ACPI (e.g. with acpi=noirq), due to
  mpparse_parse_smp_config() overridden by x86_dtb_parse_smp_config()

Signed-off-by: Dmytro Maluka <dmaluka@chromium.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20250105172741.3476758-2-dmaluka@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/devicetree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 59d23cdf4ed0f..dd8748c45529a 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -2,6 +2,7 @@
 /*
  * Architecture specific OF callbacks.
  */
+#include <linux/acpi.h>
 #include <linux/export.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
@@ -313,6 +314,6 @@ void __init x86_flattree_get_config(void)
 	if (initial_dtb)
 		early_memunmap(dt, map_len);
 #endif
-	if (of_have_populated_dt())
+	if (acpi_disabled && of_have_populated_dt())
 		x86_init.mpparse.parse_smp_cfg = x86_dtb_parse_smp_config;
 }
-- 
2.39.5



