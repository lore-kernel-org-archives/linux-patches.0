Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486862EA172;
	Tue, 15 Jul 2025 13:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587955; cv=none; b=KIZu3lH+OpXT1pDclzhv9m3fm2wtS5YBKjP3h6OOw1p1JQlXFNwXcOZ9n6XvNcJXu31a8TY6iQGwIt3u6t4ZFacBNJhZhDt83/s6egXTTx4yvev3B1GWOXe+Re/GN1vGp5LpiPQ0NQQ0uldVb60lvi5MwT+NJjai32i4xvIQ/hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587955; c=relaxed/simple;
	bh=pmBD/pUO84+12foBTusqnJwZvrUeI98HoXkE5UTpxAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oujhtv0i2KBnlNg4YSsEjAGh6T7WX8ZiyFNUqM6TOGq30zZuYofJCNHdt9wciWVdrMfVnPWvY5JBwoqSSps3oSN0t94YeiW5dmOLI+s0B/UKG56ebhET3DvuiIL1x/lhtxCNUEZzqBIvWsIkOSwfVDMbeaDEnXiGlP5bLVTGwZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxdmXbFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxdmXbFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F5CC4CEE3;
	Tue, 15 Jul 2025 13:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587955;
	bh=pmBD/pUO84+12foBTusqnJwZvrUeI98HoXkE5UTpxAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxdmXbFBhOe/uydr4OK2AhHTh3G1b7ilZo6yTpxH13CkB6fOrmdzDzUGnVPCJkiaN
	 Jui/p36t+6KkATPH3/8Iq2dbG1+cSFTnIeBS816Fxg1Lf/ljhEyvDkv341wTFCBfF2
	 NRaofL5tIFRVGufh1tukqBFIkKA0ZkwxBLldgeX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.10 206/208] KVM: x86: add support for CPUID leaf 0x80000021
Date: Tue, 15 Jul 2025 15:15:15 +0200
Message-ID: <20250715130819.180401995@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@kernel.org>

From: Paolo Bonzini <pbonzini@redhat.com>

Commit 58b3d12c0a860cda34ed9d2378078ea5134e6812 upstream.

CPUID leaf 0x80000021 defines some features (or lack of bugs) of AMD
processors.  Expose the ones that make sense via KVM_GET_SUPPORTED_CPUID.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -810,7 +810,7 @@ static inline int __do_cpuid_func(struct
 		entry->edx = 0;
 		break;
 	case 0x80000000:
-		entry->eax = min(entry->eax, 0x8000001f);
+		entry->eax = min(entry->eax, 0x80000021);
 		break;
 	case 0x80000001:
 		entry->ebx &= ~GENMASK(27, 16);
@@ -875,6 +875,23 @@ static inline int __do_cpuid_func(struct
 		if (!boot_cpu_has(X86_FEATURE_SEV))
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 		break;
+	case 0x80000020:
+		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+		break;
+	case 0x80000021:
+		entry->ebx = entry->ecx = entry->edx = 0;
+		/*
+		 * Pass down these bits:
+		 *    EAX      0      NNDBP, Processor ignores nested data breakpoints
+		 *    EAX      2      LAS, LFENCE always serializing
+		 *    EAX      6      NSCB, Null selector clear base
+		 *
+		 * Other defined bits are for MSRs that KVM does not expose:
+		 *   EAX      3      SPCL, SMM page configuration lock
+		 *   EAX      13     PCMSR, Prefetch control MSR
+		 */
+		entry->eax &= BIT(0) | BIT(2) | BIT(6);
+		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
 		/*Just support up to 0xC0000004 now*/


