Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1073370FB;
	Fri, 17 Oct 2025 15:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714862; cv=none; b=Tj6vHWjinUrIrFEQy0AUpDi0qEbd4AK7W/I5i2w2stbMfwtzW/biQA3bJpX8VTJNf2YryqP45DH0YE3otUdSFMdpq+fm9Wne47t98BcrJyKfl4nZHgMs44ytk10w2sNG133UTXz01gLskVbGK+dYemkHgS6gwjm4u2MfUmYNHWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714862; c=relaxed/simple;
	bh=5D8lXGuzfMewsS5eF219nE1FSQaA1mK7u/5oE/hZxP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZGmqma4fc1943JfMPqkJOIZfUG8Ed2jHTWtFoB6ZIRVV3gWhb2jJ82NqoBMdS/zl1wxVEp8UBzYWFyLoZkxVHdNq8DzP0NcQTjV/mTGOSwtjnYRCyjT0VUaWnxB5gPibXeldBiheDLWXrEBu0wgKLd6ziO5G87UtKgXceK+uFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyVMRZ5V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyVMRZ5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D046BC4CEE7;
	Fri, 17 Oct 2025 15:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714862;
	bh=5D8lXGuzfMewsS5eF219nE1FSQaA1mK7u/5oE/hZxP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyVMRZ5VnEArXeE64KzHxjVSFBeiyeOXIApHuwrW3ee+RIONFLELWHw1UcBzw5XPv
	 oGx/gfZTY5cpnm8iK9H+iU6c/GMWmjYj7Wex7nFj5pb0Dg1fhgrnhhukJ7K1pLwibc
	 L5XTWjGdJxcnob+sqM//1DkirPgesUX0w72CyeZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.17 015/371] KVM: x86: Add helper to retrieve current value of user return MSR
Date: Fri, 17 Oct 2025 16:49:50 +0200
Message-ID: <20251017145202.349700585@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

commit 9bc366350734246301b090802fc71f9924daad39 upstream.

In the user return MSR support, the cached value is always the hardware
value of the specific MSR. Therefore, add a helper to retrieve the
cached value, which can replace the need for RDMSR, for example, to
allow SEV-ES guests to restore the correct host hardware value without
using RDMSR.

Cc: stable@vger.kernel.org
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
[sean: drop "cache" from the name, make it a one-liner, tag for stable]
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://lore.kernel.org/r/20250923153738.1875174-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2356,6 +2356,7 @@ int kvm_add_user_return_msr(u32 msr);
 int kvm_find_user_return_msr(u32 msr);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
 void kvm_user_return_msr_update_cache(unsigned int index, u64 val);
+u64 kvm_get_user_return_msr(unsigned int slot);
 
 static inline bool kvm_is_supported_user_return_msr(u32 msr)
 {
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -677,6 +677,12 @@ void kvm_user_return_msr_update_cache(un
 }
 EXPORT_SYMBOL_GPL(kvm_user_return_msr_update_cache);
 
+u64 kvm_get_user_return_msr(unsigned int slot)
+{
+	return this_cpu_ptr(user_return_msrs)->values[slot].curr;
+}
+EXPORT_SYMBOL_GPL(kvm_get_user_return_msr);
+
 static void drop_user_return_notifiers(void)
 {
 	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);


