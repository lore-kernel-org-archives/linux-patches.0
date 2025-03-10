Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B34122F175;
	Mon, 10 Mar 2025 17:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627870; cv=none; b=Lb+/pc+WYQAVyuOnxhaw8xRi1hkHUX9Di4RiFTgWifL4rdp/E+sCgdne9Qki5EZhcYVrUeSsNqh3fjjZkENk7F3ZcxJhpU9REg18NJxalq3VM+NeGSpNyj+8MlAl8+JsFv7UQh1gLVVUc1DHxciOnvw2hW0lE6Ke2HALbiJrWY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627870; c=relaxed/simple;
	bh=kUUKkFULwYkjPamnH2fiFlos+oIs7BVZ5i9zwFFRS2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fi1/I4DCUKt0OHR8wqQng2oL3RlE/ircSgbRnHWvkXoQGOKOG89h7ipL2PxohrsfHsvZWTDJfYhuL2dVviTQX1Edk9o23T24pCvzz9NusRXqj0rrweg4tof9PBT/TPWlSicojlMtIEiDHM2MB/f9gidfRV8/3ek13ITAXAcYpq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNahVy3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNahVy3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AE3C4CEE5;
	Mon, 10 Mar 2025 17:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627870;
	bh=kUUKkFULwYkjPamnH2fiFlos+oIs7BVZ5i9zwFFRS2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNahVy3IWv/H8+Q0SBhKA4HWbwtrZZZXQEkFHATSjwFhLuGYOiUu2eJfDq4UBsP8s
	 94+slqiKRlTmXdkncZBV2FvgNTgbZpFhMQoSRnTScmwHs9PN1y+Cd31Dl3/HG3o0rQ
	 L6RIBD5UUXuZoQtKITmnkOSN69ejksTs/LHhqfR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.6 001/145] x86/amd_nb: Use rdmsr_safe() in amd_get_mmconfig_range()
Date: Mon, 10 Mar 2025 18:04:55 +0100
Message-ID: <20250310170434.798445998@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Cooper <andrew.cooper3@citrix.com>

commit 14cb5d83068ecf15d2da6f7d0e9ea9edbcbc0457 upstream.

Xen doesn't offer MSR_FAM10H_MMIO_CONF_BASE to all guests.  This results
in the following warning:

  unchecked MSR access error: RDMSR from 0xc0010058 at rIP: 0xffffffff8101d19f (xen_do_read_msr+0x7f/0xa0)
  Call Trace:
   xen_read_msr+0x1e/0x30
   amd_get_mmconfig_range+0x2b/0x80
   quirk_amd_mmconfig_area+0x28/0x100
   pnp_fixup_device+0x39/0x50
   __pnp_add_device+0xf/0x150
   pnp_add_device+0x3d/0x100
   pnpacpi_add_device_handler+0x1f9/0x280
   acpi_ns_get_device_callback+0x104/0x1c0
   acpi_ns_walk_namespace+0x1d0/0x260
   acpi_get_devices+0x8a/0xb0
   pnpacpi_init+0x50/0x80
   do_one_initcall+0x46/0x2e0
   kernel_init_freeable+0x1da/0x2f0
   kernel_init+0x16/0x1b0
   ret_from_fork+0x30/0x50
   ret_from_fork_asm+0x1b/0x30

based on quirks for a "PNP0c01" device.  Treating MMCFG as disabled is the
right course of action, so no change is needed there.

This was most likely exposed by fixing the Xen MSR accessors to not be
silently-safe.

Fixes: 3fac3734c43a ("xen/pv: support selecting safe/unsafe msr accesses")
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20250307002846.3026685-1-andrew.cooper3@citrix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/amd_nb.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -360,7 +360,6 @@ bool __init early_is_amd_nb(u32 device)
 
 struct resource *amd_get_mmconfig_range(struct resource *res)
 {
-	u32 address;
 	u64 base, msr;
 	unsigned int segn_busn_bits;
 
@@ -368,13 +367,11 @@ struct resource *amd_get_mmconfig_range(
 	    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON)
 		return NULL;
 
-	/* assume all cpus from fam10h have mmconfig */
-	if (boot_cpu_data.x86 < 0x10)
+	/* Assume CPUs from Fam10h have mmconfig, although not all VMs do */
+	if (boot_cpu_data.x86 < 0x10 ||
+	    rdmsrl_safe(MSR_FAM10H_MMIO_CONF_BASE, &msr))
 		return NULL;
 
-	address = MSR_FAM10H_MMIO_CONF_BASE;
-	rdmsrl(address, msr);
-
 	/* mmconfig is not enabled */
 	if (!(msr & FAM10H_MMIO_CONF_ENABLE))
 		return NULL;


