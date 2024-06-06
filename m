Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F171974EC;
	Thu,  6 Jun 2024 14:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683089; cv=none; b=WM+/MevZBuBN/kp041YsQv01Lzx60gyPyFUtDDmXelNXDOS2clBcEH5qFuVnQ2QK+MDL2MYnj/YriK3peFV/JLc4Ka7XzKIbXDIiqArBc+eAEA9XVnaTSRYZdqCZZcaP9gitQlTwkqHLllk2d6wG8fW8dMggB1cETwsMF4D4YEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683089; c=relaxed/simple;
	bh=pqS6+iaaZ2L7JrE8LpqcznPPBUD+MASJzj2RQKYAe3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8ktEZQy8uETHVfffDgh1jRXLBthBq6mphQ0TWIkLVxadPj4hVRTbJKSzpbo6XuDgxtSmh2YrrKRjIYxikq/4E/nkfmexISjpPJvE/841OWnBkwL4ILpdMAbWyq11WqH9xdZ/+BMG9Ub9GH8UV6LM+JpIzMPoDGOMY7pA/ESQm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5BuT+JE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5BuT+JE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1902C2BD10;
	Thu,  6 Jun 2024 14:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683088;
	bh=pqS6+iaaZ2L7JrE8LpqcznPPBUD+MASJzj2RQKYAe3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5BuT+JETBXFIyQuhuRFY32fuX1/GUhtTc4I7zYtSk2lymkTJjbUrgrhpDGcF4ShD
	 YSyNJILCaYLgR8iZ5cyaqLyZaEWq+4f3gDXpq/2EmsODwmGh2BHDPIQOVD8Gnymuws
	 rsDbFORGya/UqCoeFx1UcGG3MJJTsE1eVhMWzSj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.9 370/374] KVM: x86: Dont advertise guest.MAXPHYADDR as host.MAXPHYADDR in CPUID
Date: Thu,  6 Jun 2024 16:05:49 +0200
Message-ID: <20240606131704.278545689@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

From: Gerd Hoffmann <kraxel@redhat.com>

commit 6f5c9600621b4efb5c61b482d767432eb1ad3a9c upstream.

Drop KVM's propagation of GuestPhysBits (CPUID leaf 80000008, EAX[23:16])
to HostPhysBits (same leaf, EAX[7:0]) when advertising the address widths
to userspace via KVM_GET_SUPPORTED_CPUID.

Per AMD, GuestPhysBits is intended for software use, and physical CPUs do
not set that field.  I.e. GuestPhysBits will be non-zero if and only if
KVM is running as a nested hypervisor, and in that case, GuestPhysBits is
NOT guaranteed to capture the CPU's effective MAXPHYADDR when running with
TDP enabled.

E.g. KVM will soon use GuestPhysBits to communicate the CPU's maximum
*addressable* guest physical address, which would result in KVM under-
reporting PhysBits when running as an L1 on a CPU with MAXPHYADDR=52,
but without 5-level paging.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://lore.kernel.org/r/20240313125844.912415-2-kraxel@redhat.com
[sean: rewrite changelog with --verbose, Cc stable@]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1232,9 +1232,8 @@ static inline int __do_cpuid_func(struct
 		entry->eax = entry->ebx = entry->ecx = 0;
 		break;
 	case 0x80000008: {
-		unsigned g_phys_as = (entry->eax >> 16) & 0xff;
-		unsigned virt_as = max((entry->eax >> 8) & 0xff, 48U);
-		unsigned phys_as = entry->eax & 0xff;
+		unsigned int virt_as = max((entry->eax >> 8) & 0xff, 48U);
+		unsigned int phys_as;
 
 		/*
 		 * If TDP (NPT) is disabled use the adjusted host MAXPHYADDR as
@@ -1242,16 +1241,16 @@ static inline int __do_cpuid_func(struct
 		 * reductions in MAXPHYADDR for memory encryption affect shadow
 		 * paging, too.
 		 *
-		 * If TDP is enabled but an explicit guest MAXPHYADDR is not
-		 * provided, use the raw bare metal MAXPHYADDR as reductions to
-		 * the HPAs do not affect GPAs.
+		 * If TDP is enabled, use the raw bare metal MAXPHYADDR as
+		 * reductions to the HPAs do not affect GPAs.
 		 */
-		if (!tdp_enabled)
-			g_phys_as = boot_cpu_data.x86_phys_bits;
-		else if (!g_phys_as)
-			g_phys_as = phys_as;
+		if (!tdp_enabled) {
+			phys_as = boot_cpu_data.x86_phys_bits;
+		} else {
+			phys_as = entry->eax & 0xff;
+		}
 
-		entry->eax = g_phys_as | (virt_as << 8);
+		entry->eax = phys_as | (virt_as << 8);
 		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
 		entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0008_EBX);


