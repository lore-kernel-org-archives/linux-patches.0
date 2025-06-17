Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B94818E025;
	Tue, 17 Jun 2025 16:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177068; cv=none; b=KYzKrA5Ka2UMdzfyRpAYAdGDT7AyWunChXKDY4uWuBby8mypy2HMhwUc1b7xmUVDxaj3zhZ3QCL5rPJEzdqY8HI1H4vbMV+OomCiSQ36oB6yekEbGH3xeuTliy8euhO0KN/FAnxD9+7YckQ++DfZSJTSlMKtJYMjYbrx0AZuGWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177068; c=relaxed/simple;
	bh=8IF+hUpvLRCuHMX1K5+ykWNDma5RfV8wNonD61iup9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3J5ioKjpWx6ya6S4tcwE4Il8fUDP0PCdMVEGVF2EChuTOOvlvGb/c2tW5G6d/+JW0HxKZHwjDLMUY2RLHGPDsWPYshAbJnSUB/ytFoxpD2zHCepiYv1RBr9jpYCaS6prdvF0ktspa5BTcXlQ8gURLt9dWnx+e59S/rSjUBDv44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyn3LeQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyn3LeQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAB0C4CEE3;
	Tue, 17 Jun 2025 16:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177068;
	bh=8IF+hUpvLRCuHMX1K5+ykWNDma5RfV8wNonD61iup9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyn3LeQldLX+YCvaYDBAyReE21WPVYbIIX4XXekfHz7HJbMtlx2r5pqPriUBfD8WQ
	 Q/dtNXfZT7ZCyYVXxDtpf/UYLZM8H97VH5zyyC9wQFun1tlMCckTTr2zZiis5dMwek
	 Dawi1qN2b+jixhIb3NkXf9izY64tVknHbTpkoq7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Marcus Seyfarth <m.seyfarth@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.6 344/356] kbuild: Disable -Wdefault-const-init-unsafe
Date: Tue, 17 Jun 2025 17:27:39 +0200
Message-ID: <20250617152351.981186649@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit d0afcfeb9e3810ec89d1ffde1a0e36621bb75dca upstream.

A new on by default warning in clang [1] aims to flags instances where
const variables without static or thread local storage or const members
in aggregate types are not initialized because it can lead to an
indeterminate value. This is quite noisy for the kernel due to
instances originating from header files such as:

  drivers/gpu/drm/i915/gt/intel_ring.h:62:2: error: default initialization of an object of type 'typeof (ring->size)' (aka 'const unsigned int') leaves the object uninitialized [-Werror,-Wdefault-const-init-var-unsafe]
     62 |         typecheck(typeof(ring->size), next);
        |         ^
  include/linux/typecheck.h:10:9: note: expanded from macro 'typecheck'
     10 | ({      type __dummy; \
        |              ^

  include/net/ip.h:478:14: error: default initialization of an object of type 'typeof (rt->dst.expires)' (aka 'const unsigned long') leaves the object uninitialized [-Werror,-Wdefault-const-init-var-unsafe]
    478 |                 if (mtu && time_before(jiffies, rt->dst.expires))
        |                            ^
  include/linux/jiffies.h:138:26: note: expanded from macro 'time_before'
    138 | #define time_before(a,b)        time_after(b,a)
        |                                 ^
  include/linux/jiffies.h:128:3: note: expanded from macro 'time_after'
    128 |         (typecheck(unsigned long, a) && \
        |          ^
  include/linux/typecheck.h:11:12: note: expanded from macro 'typecheck'
     11 |         typeof(x) __dummy2; \
        |                   ^

  include/linux/list.h:409:27: warning: default initialization of an object of type 'union (unnamed union at include/linux/list.h:409:27)' with const member leaves the object uninitialized [-Wdefault-const-init-field-unsafe]
    409 |         struct list_head *next = smp_load_acquire(&head->next);
        |                                  ^
  include/asm-generic/barrier.h:176:29: note: expanded from macro 'smp_load_acquire'
    176 | #define smp_load_acquire(p) __smp_load_acquire(p)
        |                             ^
  arch/arm64/include/asm/barrier.h:164:59: note: expanded from macro '__smp_load_acquire'
    164 |         union { __unqual_scalar_typeof(*p) __val; char __c[1]; } __u;   \
        |                                                                  ^
  include/linux/list.h:409:27: note: member '__val' declared 'const' here

  crypto/scatterwalk.c:66:22: error: default initialization of an object of type 'struct scatter_walk' with const member leaves the object uninitialized [-Werror,-Wdefault-const-init-field-unsafe]
     66 |         struct scatter_walk walk;
        |                             ^
  include/crypto/algapi.h:112:15: note: member 'addr' declared 'const' here
    112 |                 void *const addr;
        |                             ^

  fs/hugetlbfs/inode.c:733:24: error: default initialization of an object of type 'struct vm_area_struct' with const member leaves the object uninitialized [-Werror,-Wdefault-const-init-field-unsafe]
    733 |         struct vm_area_struct pseudo_vma;
        |                               ^
  include/linux/mm_types.h:803:20: note: member 'vm_flags' declared 'const' here
    803 |                 const vm_flags_t vm_flags;
        |                                  ^

Silencing the instances from typecheck.h is difficult because '= {}' is
not available in older but supported compilers and '= {0}' would cause
warnings about a literal 0 being treated as NULL. While it might be
possible to come up with a local hack to silence the warning for
clang-21+, it may not be worth it since -Wuninitialized will still
trigger if an uninitialized const variable is actually used.

In all audited cases of the "field" variant of the warning, the members
are either not used in the particular call path, modified through other
means such as memset() / memcpy() because the containing object is not
const, or are within a union with other non-const members.

Since this warning does not appear to have a high signal to noise ratio,
just disable it.

Cc: stable@vger.kernel.org
Link: https://github.com/llvm/llvm-project/commit/576161cb6069e2c7656a8ef530727a0f4aefff30 [1]
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/CA+G9fYuNjKcxFKS_MKPRuga32XbndkLGcY-PVuoSwzv6VWbY=w@mail.gmail.com/
Reported-by: Marcus Seyfarth <m.seyfarth@gmail.com>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2088
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.extrawarn |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -29,6 +29,18 @@ KBUILD_CFLAGS-$(CONFIG_CC_NO_ARRAY_BOUND
 ifdef CONFIG_CC_IS_CLANG
 # The kernel builds with '-std=gnu11' so use of GNU extensions is acceptable.
 KBUILD_CFLAGS += -Wno-gnu
+
+# Clang may emit a warning when a const variable, such as the dummy variables
+# in typecheck(), or const member of an aggregate type are not initialized,
+# which can result in unexpected behavior. However, in many audited cases of
+# the "field" variant of the warning, this is intentional because the field is
+# never used within a particular call path, the field is within a union with
+# other non-const members, or the containing object is not const so the field
+# can be modified via memcpy() / memset(). While the variable warning also gets
+# disabled with this same switch, there should not be too much coverage lost
+# because -Wuninitialized will still flag when an uninitialized const variable
+# is used.
+KBUILD_CFLAGS += $(call cc-disable-warning, default-const-init-unsafe)
 else
 
 # gcc inanely warns about local variables called 'main'


