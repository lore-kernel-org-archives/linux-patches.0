Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA8A2F28EE;
	Fri, 10 Oct 2025 13:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102605; cv=none; b=u3sYKxfHGbQPDDThMP10tcwkgFNSdpJ6vTUxHUf7cqLQfRpqX4NMEb5lYd78wvVCYbXkXz0hpTYC3X8E/i+ybPOR0v01kPOggVU2l+MxHYrVbRuP353RaPkLdl0gqc19U40WJz9+bmeU0AE9qcZpBiyZ0CngtIRnm6ePxuxWsIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102605; c=relaxed/simple;
	bh=1sqFajZVB1zTCp8SIP11xeK4+MP62Fd9sVphvTipnGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgWn2vH5jYA8TnJyttolaHwZDyb0jGUgq5LMKyzuSaW1I+oyL/Ysr8e5RnD2bDvJFUcyZglkZJTZjzuTZCLsGbz9pVg8qQOvtmn39zzQnRM6g4zFM/84q2I6TKjaQUJT0aXiZYyLiBYaba4jwpHQUZGu0LrfQYYrbhL4+4yzlEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RiuDyNEJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RiuDyNEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3126C4CEF9;
	Fri, 10 Oct 2025 13:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102605;
	bh=1sqFajZVB1zTCp8SIP11xeK4+MP62Fd9sVphvTipnGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RiuDyNEJRcaxk3xQUF2b9sJ48XoqIZ74YKq9ndkkMuEw9OMIf+wZ9cC9Smmn95wcg
	 VX3MKw0LKz/2xtbFAUOwOFP0gXFXJEuhcJSLuJOCZgN7wjGvgf++5JjqcjW+EuMXcN
	 GM8sAVebCST7WoMYvJ8giUbbbtz7VURjjWbtrTZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Han Gao <rabenda.cn@gmail.com>
Subject: [PATCH 6.6 24/28] riscv: mm: Use hint address in mmap if available
Date: Fri, 10 Oct 2025 15:16:42 +0200
Message-ID: <20251010131331.245558091@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
References: <20251010131330.355311487@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlie Jenkins <charlie@rivosinc.com>

commit b5b4287accd702f562a49a60b10dbfaf7d40270f upstream.

On riscv it is guaranteed that the address returned by mmap is less than
the hint address. Allow mmap to return an address all the way up to
addr, if provided, rather than just up to the lower address space.

This provides a performance benefit as well, allowing mmap to exit after
checking that the address is in range rather than searching for a valid
address.

It is possible to provide an address that uses at most the same number
of bits, however it is significantly more computationally expensive to
provide that number rather than setting the max to be the hint address.
There is the instruction clz/clzw in Zbb that returns the highest set bit
which could be used to performantly implement this, but it would still
be slower than the current implementation. At worst case, half of the
address would not be able to be allocated when a hint address is
provided.

Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20240130-use_mmap_hint_address-v3-1-8a655cfa8bcb@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
[ Adjust TASK_SIZE64 -> TASK_SIZE in moved lines ]
Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Tested-by: Han Gao <rabenda.cn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/processor.h |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

--- a/arch/riscv/include/asm/processor.h
+++ b/arch/riscv/include/asm/processor.h
@@ -13,22 +13,16 @@
 
 #include <asm/ptrace.h>
 
-#ifdef CONFIG_64BIT
-#define DEFAULT_MAP_WINDOW	(UL(1) << (MMAP_VA_BITS - 1))
-#define STACK_TOP_MAX		TASK_SIZE
-
 #define arch_get_mmap_end(addr, len, flags)			\
 ({								\
 	unsigned long mmap_end;					\
 	typeof(addr) _addr = (addr);				\
-	if ((_addr) == 0 || (IS_ENABLED(CONFIG_COMPAT) && is_compat_task())) \
+	if ((_addr) == 0 ||					\
+	    (IS_ENABLED(CONFIG_COMPAT) && is_compat_task()) ||	\
+	    ((_addr + len) > BIT(VA_BITS - 1)))			\
 		mmap_end = STACK_TOP_MAX;			\
-	else if ((_addr) >= VA_USER_SV57)			\
-		mmap_end = STACK_TOP_MAX;			\
-	else if ((((_addr) >= VA_USER_SV48)) && (VA_BITS >= VA_BITS_SV48)) \
-		mmap_end = VA_USER_SV48;			\
 	else							\
-		mmap_end = VA_USER_SV39;			\
+		mmap_end = (_addr + len);			\
 	mmap_end;						\
 })
 
@@ -38,17 +32,18 @@
 	typeof(addr) _addr = (addr);				\
 	typeof(base) _base = (base);				\
 	unsigned long rnd_gap = DEFAULT_MAP_WINDOW - (_base);	\
-	if ((_addr) == 0 || (IS_ENABLED(CONFIG_COMPAT) && is_compat_task())) \
+	if ((_addr) == 0 ||					\
+	    (IS_ENABLED(CONFIG_COMPAT) && is_compat_task()) ||	\
+	    ((_addr + len) > BIT(VA_BITS - 1)))			\
 		mmap_base = (_base);				\
-	else if (((_addr) >= VA_USER_SV57) && (VA_BITS >= VA_BITS_SV57)) \
-		mmap_base = VA_USER_SV57 - rnd_gap;		\
-	else if ((((_addr) >= VA_USER_SV48)) && (VA_BITS >= VA_BITS_SV48)) \
-		mmap_base = VA_USER_SV48 - rnd_gap;		\
 	else							\
-		mmap_base = VA_USER_SV39 - rnd_gap;		\
+		mmap_base = (_addr + len) - rnd_gap;		\
 	mmap_base;						\
 })
 
+#ifdef CONFIG_64BIT
+#define DEFAULT_MAP_WINDOW	(UL(1) << (MMAP_VA_BITS - 1))
+#define STACK_TOP_MAX		TASK_SIZE
 #else
 #define DEFAULT_MAP_WINDOW	TASK_SIZE
 #define STACK_TOP_MAX		TASK_SIZE


