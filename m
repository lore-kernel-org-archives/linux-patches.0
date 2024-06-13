Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F1D1420C6;
	Thu, 13 Jun 2024 12:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282610; cv=none; b=GHzMNnHOCxhB4IMPxAF33CAjV7Nrjfj7O4Lg9xtdpZk1a9bvGBMtDU0B41hlsa1CdVsahbw19nXYTobOxdl5U/42u112Ybf3eB5dLEv14/Feaw9ZXjLm3TVBXtsdWMytOAfgPUbQ3djgd4hIG3VpwNb3rlOM4O4NOXmJoS/wcAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282610; c=relaxed/simple;
	bh=Xw7h0z+Qr7j60+U0uTJ7XkKm8wmrOExylemwVW8yV3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPJ2xZhDyYxnG45ZbFGmV1ZWHan12xyk3vn+DVLrSJR70zJaRhQzpe1qaBDY7PvIuoKNN4aojWLfpKHTqJOIuO7mqjuy7InFTcfeefWhB2CSzLQByvLhNPaihNVwi8QTzXIr1+7W5mdSmvZiIRLaAPT09Rnd8z3iBRVxDVilb5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgAaimYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgAaimYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5048DC2BBFC;
	Thu, 13 Jun 2024 12:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282610;
	bh=Xw7h0z+Qr7j60+U0uTJ7XkKm8wmrOExylemwVW8yV3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgAaimYEnpSd4RZJEK4xZAu3KjBx4EUS4yodmqTJMi9d9H4LD+0VmKOMouedjIvHq
	 yz18Or2B0xEWGLH1OEPQdnpVmXX5Kfgw4e2PS08IkucVg0q16vrBK8F6vCOKtheeVU
	 mHLDpaPo0v9Cvt9BP8+U6Ro09qVhzmw0olFoZ30E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 335/402] KVM: x86: Dont advertise guest.MAXPHYADDR as host.MAXPHYADDR in CPUID
Date: Thu, 13 Jun 2024 13:34:52 +0200
Message-ID: <20240613113315.203564801@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -934,9 +934,8 @@ static inline int __do_cpuid_func(struct
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
@@ -944,16 +943,16 @@ static inline int __do_cpuid_func(struct
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


