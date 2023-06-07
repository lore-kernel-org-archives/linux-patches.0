Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804B712B79;
	Wed,  7 Jun 2023 21:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B6EC433D2;
	Wed,  7 Jun 2023 21:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686172878;
	bh=jSlEKrCnMK95pETVHXEKH30RppvMmXwHnRIAJknEjUM=;
	h=From:Date:Subject:To:Cc:From;
	b=gJdnOvtTm3qZwrlGnx/agmFkFlojWgz2nJIaWWcgj1exOo3F19P5F3ej0gTkJfLtK
	 PH09tXlsjrcX23Fkor3z+4Oz9hYwzEwJ11TKAFLwh/hviAt4xrQiyg3tvOOUaA2odh
	 ZY84y3mh4FY5sn+V1Hef3B1o7cd5ZwXvboL/EAdZq3xr+HX9fcD62fAE1hhKLpb6Tu
	 HPZRLhfaOCCoqjIh+/vnApqwAvy/Jje4UxFHlyX/i/7ocueef60FvfYYkCNZJGU3b4
	 bewoMXcm6M28KgXLwZzHYH4teKZyQ3kcyiokp8rXpF2vFy1kUO4Tg+zo7OHgWqYdA6
	 8SILOHmkAMqdA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 07 Jun 2023 14:20:59 -0700
Subject: [PATCH] percpu: Fix self-assignment of __old in
 raw_cpu_generic_try_cmpxchg()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230607-fix-shadowing-in-raw_cpu_generic_try_cmpxchg-v1-1-8f0a3d930d43@kernel.org>
X-B4-Tracking: v=1; b=H4sIALr0gGQC/5XOQQ6CMBCF4auQrp1YqErwKsQ07TC0E2NpWhUM4
 e4Wb+DyX7wvbxWZElMW12oVid6ceQol6kMl0JvgCHgoLRrZKHmRLYy8QPZmmGYODjhAMrPG+NK
 OQqFQP9NH4yMu6B2c287Wsh6VVJ0opDWZwCYT0O+oPR3/4qzB+87ERGX3e93ftu0LMaPdpcUAA
 AA=
To: peterz@infradead.org
Cc: mark.rutland@arm.com, arnd@arndb.de, ndesaulniers@google.com, 
 trix@redhat.com, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2305; i=nathan@kernel.org;
 h=from:subject:message-id; bh=jSlEKrCnMK95pETVHXEKH30RppvMmXwHnRIAJknEjUM=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCkNX85eNOfhDjcKuLy2JurVr61OW50+rKrcYHno8Ilzn
 AILwmrVO0pZGMQ4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEarQY/hdoJqv95NH523yh
 MTbcNuy6y4dr93aXT/n52WqjdPPVk62MDCfvfrb5LPFxxnGzrafiry/wYdZbxXv/CZv6lzfPN5j
 /28wOAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After commit c5c0ba953b8c ("percpu: Add {raw,this}_cpu_try_cmpxchg()"),
clang built ARCH=arm and ARCH=arm64 kernels with CONFIG_INIT_STACK_NONE
started panicking on boot in alloc_vmap_area():

  [    0.000000] kernel BUG at mm/vmalloc.c:1638!
  [    0.000000] Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
  [    0.000000] Modules linked in:
  [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.4.0-rc2-ARCH+ #1
  [    0.000000] Hardware name: linux,dummy-virt (DT)
  [    0.000000] pstate: 200000c9 (nzCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  [    0.000000] pc : alloc_vmap_area+0x7ec/0x7f8
  [    0.000000] lr : alloc_vmap_area+0x7e8/0x7f8

Compiling mm/vmalloc.c with W=2 reveals an instance of -Wshadow, which
helps uncover that through macro expansion, '__old = *(ovalp)' in
raw_cpu_generic_try_cmpxchg() can become '__old = *(&__old)' through
raw_cpu_generic_cmpxchg(), which results in garbage being assigned to
the inner __old and the cmpxchg not working properly.

Add an extra underscore to __old in raw_cpu_generic_try_cmpxchg() so
that there is no more self-assignment, which resolves the panics.

Closes: https://github.com/ClangBuiltLinux/linux/issues/1868
Debugged-by: Nick Desaulniers <ndesaulniers@google.com>
Fixes: c5c0ba953b8c ("percpu: Add {raw,this}_cpu_try_cmpxchg()")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 include/asm-generic/percpu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index 68c410e85cd7..94cbd50cc870 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -101,9 +101,9 @@ do {									\
 #define raw_cpu_generic_try_cmpxchg(pcp, ovalp, nval)			\
 ({									\
 	typeof(pcp) *__p = raw_cpu_ptr(&(pcp));				\
-	typeof(pcp) __val = *__p, __old = *(ovalp);			\
+	typeof(pcp) __val = *__p, ___old = *(ovalp);			\
 	bool __ret;							\
-	if (__val == __old) {						\
+	if (__val == ___old) {						\
 		*__p = nval;						\
 		__ret = true;						\
 	} else {							\

---
base-commit: ef558b4b7bbbf7e115c87e4da21ce86444d6ec3b
change-id: 20230607-fix-shadowing-in-raw_cpu_generic_try_cmpxchg-579b101f3039

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

