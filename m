Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA9116CD1D;
	Wed,  5 Feb 2025 14:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767092; cv=none; b=lF9M+USO8akJgvf63iWTUPFOeWPs6u61zJrx7LPzOzmK9eKUd1qsolHlznvzD3RrYyj44oFusY4A7vTsk56VwiErliCqEk9rlFTIXhT9FP0n0IhJVOEEBWLq04QFwgpf+rASscU0imOHtSlHFmG2VFuqz1cwSJvS74wJJsi1Z88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767092; c=relaxed/simple;
	bh=mN6sKHWfyzD6nb6d15BfJhWva6Wx81YU3yhvkx/O8sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SArXqn+9Ur+NdYy4p9gbGF0VE5wJ4jhpFoWgEi85ZMzBA5DPn3vh0cs/yQ1HAIdIP17P6JsH3N3GvjX6w1qh2x+AtclgCkliB/Zx9L2tK14gEjvUijg0WKm0qbVU5Iui/6N+ZGyOM6siVc9YwyosDWcqsawXsJwm005HdeoqsJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kcysjIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kcysjIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DC1C4CED1;
	Wed,  5 Feb 2025 14:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767092;
	bh=mN6sKHWfyzD6nb6d15BfJhWva6Wx81YU3yhvkx/O8sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1kcysjIF6O9O/R08NQ4xKP3PyMyYUubzwY2PCF4GWvSEZULyQhbe8Fx2UAQjbHfcS
	 tnZnZA9l/oLvRyD38BIEcpHzRWzaHIwSd01aLffhu9C/A0g0GcmW3lYoGNIRpfqMdE
	 ZJJtDRBmCTFHpEvYJiNfGN8YxoXOW4/YFF+ZK4c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Maluka <dmaluka@chromium.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 405/590] of/fdt: Restore possibility to use both ACPI and FDT from bootloader
Date: Wed,  5 Feb 2025 14:42:40 +0100
Message-ID: <20250205134510.756596214@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmytro Maluka <dmaluka@chromium.org>

[ Upstream commit 14bce187d1600710623d81888da3501bbc470ba2 ]

There are cases when the bootloader provides information to the kernel
in both ACPI and DTB, not interchangeably. One such use case is virtual
machines in Android. When running on x86, the Android Virtualization
Framework (AVF) boots VMs with ACPI like it is usually done on x86 (i.e.
the virtual LAPIC, IOAPIC, HPET, PCI MMCONFIG etc are described in ACPI)
but also passes various AVF-specific boot parameters in DTB. This allows
reusing the same implementations of various AVF components on both
arm64 and x86.

Commit 7b937cc243e5 ("of: Create of_root if no dtb provided by firmware")
removed the possibility to do that, since among other things
it introduced forcing emptying the bootloader-provided DTB if ACPI is
enabled (probably assuming that if ACPI is available, a DTB can only be
useful for applying overlays to it afterwards, for testing purposes).

So restore this possibility. Instead of completely preventing using ACPI
and DT together, rely on arch-specific setup code to prevent using both
to set up the same things (see various acpi_disabled checks under arch/).

Fixes: 7b937cc243e5 ("of: Create of_root if no dtb provided by firmware")
Signed-off-by: Dmytro Maluka <dmaluka@chromium.org>
Link: https://lore.kernel.org/r/20250105172741.3476758-3-dmaluka@chromium.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index d3ecf2bdd2023..8c80f4dc8b3fa 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -8,7 +8,6 @@
 
 #define pr_fmt(fmt)	"OF: fdt: " fmt
 
-#include <linux/acpi.h>
 #include <linux/crash_dump.h>
 #include <linux/crc32.h>
 #include <linux/kernel.h>
@@ -1215,14 +1214,7 @@ void __init unflatten_device_tree(void)
 	/* Save the statically-placed regions in the reserved_mem array */
 	fdt_scan_reserved_mem_reg_nodes();
 
-	/* Don't use the bootloader provided DTB if ACPI is enabled */
-	if (!acpi_disabled)
-		fdt = NULL;
-
-	/*
-	 * Populate an empty root node when ACPI is enabled or bootloader
-	 * doesn't provide one.
-	 */
+	/* Populate an empty root node when bootloader doesn't provide one */
 	if (!fdt) {
 		fdt = (void *) __dtb_empty_root_begin;
 		/* fdt_totalsize() will be used for copy size */
-- 
2.39.5



