Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C280A2E1C74;
	Tue,  8 Jul 2025 17:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994197; cv=none; b=M3xjygsUWmEysDco7/wo9dPSKqOS7WdKczXDA5oTKJF6T4JJ1pQEV8xIkUsVeIslagzXIMgQVlGpIebHhr9v+fbOlKL0yGzYy6hhgjRG/UW4rPpoJe6MiThcBQlNc9egO/pYzfm2GlNs2JQneuKJ3dWioovjJlNHxXN2Ujzwb9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994197; c=relaxed/simple;
	bh=+A+NWHpuAhIZpmyumxbzYUcUFFjGumTfrfscF7lvt/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upv4jLqx7GmZc1FaO2CBFaGxeXjq9MJAe2BKfCrl7uW0EWtKj096IGVDGbI4Qjmu3OxptFfZVBvQc9Yzgop6ZaAc8kd6ygphGtKsd+r2x/sTMBmWWqzy+JUrbnW2yYt2ApH6jvXonrD44846MruFDhiXcP8OEZplHuMT5ZcahXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFjY2kiA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFjY2kiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA14C4CEED;
	Tue,  8 Jul 2025 17:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994197;
	bh=+A+NWHpuAhIZpmyumxbzYUcUFFjGumTfrfscF7lvt/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFjY2kiASbwceOlql36NWQd2xWdYlaGlcQ2cjTxTHNoS+KQ1vI/dqJVAugjOHgrwr
	 P6Nu+caRzFz0OwlmJCMroFUrI13Tcd03TkebfSZ+t2l5mqDq+2jxmT6eQHuagadISw
	 prhCfm4i7cs32OSiw8Rn2rPq8QTflux9jR65ZQsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.15 158/160] KVM: x86: add support for CPUID leaf 0x80000021
Date: Tue,  8 Jul 2025 18:23:15 +0200
Message-ID: <20250708162235.671662565@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
@@ -915,7 +915,7 @@ static inline int __do_cpuid_func(struct
 		entry->edx = 0;
 		break;
 	case 0x80000000:
-		entry->eax = min(entry->eax, 0x8000001f);
+		entry->eax = min(entry->eax, 0x80000021);
 		break;
 	case 0x80000001:
 		entry->ebx &= ~GENMASK(27, 16);
@@ -995,6 +995,23 @@ static inline int __do_cpuid_func(struct
 			entry->ebx &= ~GENMASK(11, 6);
 		}
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


