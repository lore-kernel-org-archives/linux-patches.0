Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D051F60A;
	Mon,  4 Mar 2024 21:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587930; cv=none; b=hNjJEbZKa6ZSfTsgl3Wim61n7ldqtcetVN0WaL8XRyNjvutHq2cgQU4r4i9ngu6GFop9q5UJz6HbjCI/Y63qDwgQeKa1IaHcLpwZWv3eOSRBMVNFLU0JfyHULw2A+E8WiyNefSLQh88F6Z3ztxLDVGBm8SvgtX1kliUIA3rnz6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587930; c=relaxed/simple;
	bh=diqakf/+tvfWKyaKWbda71oNxRjusugvnoL4uFgQuoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nyZK0fxHyB79oFyI/1+am1I7uZ3G7PqKvWBkaG7L63htgJUFvDeJQZdiCV1D2swHBubOkixY5V5tmbR/6TnSwkAMXwma7nbVwkNdUco/ajx+KvDwWHSJRN6yhF1QpkrZznxbu+LxngD87UkgU1WnoV1vcau1/hFk+kvdjzZD7D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wV+E6Yf2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wV+E6Yf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1463DC433F1;
	Mon,  4 Mar 2024 21:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587930;
	bh=diqakf/+tvfWKyaKWbda71oNxRjusugvnoL4uFgQuoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wV+E6Yf2BZg76NRbsPWO4FwJYqPTeVTQ9lJvZnyn+LLGMv1GQy60bS1QRxavNmVdF
	 k1KANRA7enV4jiJnPYBFaOPLWbi/nvRGvCEsJI80dgUdmB/YvJGk/y51qlGS4TQwdB
	 4ODT8FUysWUQPQuznlB4LIxTczRAmmVSXZ2jH+9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.7 120/162] x86/cpu: Allow reducing x86_phys_bits during early_identify_cpu()
Date: Mon,  4 Mar 2024 21:23:05 +0000
Message-ID: <20240304211555.589854941@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 9a458198eba98b7207669a166e64d04b04cb651b upstream.

In commit fbf6449f84bf ("x86/sev-es: Set x86_virt_bits to the correct
value straight away, instead of a two-phase approach"), the initialization
of c->x86_phys_bits was moved after this_cpu->c_early_init(c).  This is
incorrect because early_init_amd() expected to be able to reduce the
value according to the contents of CPUID leaf 0x8000001f.

Fortunately, the bug was negated by init_amd()'s call to early_init_amd(),
which does reduce x86_phys_bits in the end.  However, this is very
late in the boot process and, most notably, the wrong value is used for
x86_phys_bits when setting up MTRRs.

To fix this, call get_cpu_address_sizes() as soon as X86_FEATURE_CPUID is
set/cleared, and c->extended_cpuid_level is retrieved.

Fixes: fbf6449f84bf ("x86/sev-es: Set x86_virt_bits to the correct value straight away, instead of a two-phase approach")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240131230902.1867092-2-pbonzini%40redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1596,6 +1596,7 @@ static void __init early_identify_cpu(st
 		get_cpu_vendor(c);
 		get_cpu_cap(c);
 		setup_force_cpu_cap(X86_FEATURE_CPUID);
+		get_cpu_address_sizes(c);
 		cpu_parse_early_param();
 
 		if (this_cpu->c_early_init)
@@ -1608,10 +1609,9 @@ static void __init early_identify_cpu(st
 			this_cpu->c_bsp_init(c);
 	} else {
 		setup_clear_cpu_cap(X86_FEATURE_CPUID);
+		get_cpu_address_sizes(c);
 	}
 
-	get_cpu_address_sizes(c);
-
 	setup_force_cpu_cap(X86_FEATURE_ALWAYS);
 
 	cpu_set_bug_bits(c);


