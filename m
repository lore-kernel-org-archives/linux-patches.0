Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46BC6FC5;
	Thu, 12 Feb 2026 01:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770858627; cv=none; b=hSIcZCAj/IRYeBgtehF5pSb42sJVxN6dMcpv0RtgnXPtcGAmHVzGSLYOBH5lttBBIW14qwjsVjVjh8oVC/p1G5/BElP+Ku53jdHegpMAFal0nI3KTr3/fafhtlzSMVg/HhNU/S1L8A7+sVfwEWBNiyPI2FrZ4KREukoWXJtY2p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770858627; c=relaxed/simple;
	bh=GWfxoPjAlhmbYzmaHzlAUTsYdSb7eG4rjSIH+V6odZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGDcexzTodVOJBtKylp3A1ovqISPJrQuZNFmu+e/29Gvw496dr9yGTYTv1NenRmXIk10muh63hdaxgGFbLyYdmsBx0qBhUdEz9SWz66YMhs0wL9QlLKLAicMuJcwNcKYvqubEFeWwFT/DnT8H/VNWzfn7spaZ3jTSJq68Bop6lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jXwK2MFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jXwK2MFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F03C4CEF7;
	Thu, 12 Feb 2026 01:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770858626;
	bh=GWfxoPjAlhmbYzmaHzlAUTsYdSb7eG4rjSIH+V6odZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXwK2MFvg8DB9sVzNGOuGUBlTdC+uEL/9w8GZB9DdFcPHhnaVcEP/fMHQbDnq07js
	 kO0NCoyhzTOjK/2cvidRcn0Ku+f5FWJkyLYYfWpaqgfVeNJzSbTbavITjfo7lLSF1w
	 jfyiQjRFOcFxXdspG+Fh035pccpluwhVhrVQKMLq+O3+rwUVJKO5xgpoANt9fNDUlt
	 2HJNdfBJ41+XsPwmmzj8IQR60l5kzmIG3yf55V10MJ0qZMQoeYS+7We5xgjPlsz5uA
	 +W24E2q/xi4w0kBmZV4Foxv89UTj5ll6Y76Cmf1HvL0Lj4iZmvy1HDQcuP0EJcW7KC
	 SsDfAgIFJHj8g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Viktor Malik <vmalik@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	vadim.fedorenko@linux.dev,
	daniel@iogearbox.net,
	andrii@kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] bpf: crypto: Use the correct destructor kfunc type
Date: Wed, 11 Feb 2026 20:09:41 -0500
Message-ID: <20260212010955.3480391-18-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260212010955.3480391-1-sashal@kernel.org>
References: <20260212010955.3480391-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit b40a5d724f29fc2eed23ff353808a9aae616b48a ]

With CONFIG_CFI enabled, the kernel strictly enforces that indirect
function calls use a function pointer type that matches the target
function. I ran into the following type mismatch when running BPF
self-tests:

  CFI failure at bpf_obj_free_fields+0x190/0x238 (target:
    bpf_crypto_ctx_release+0x0/0x94; expected type: 0xa488ebfc)
  Internal error: Oops - CFI: 00000000f2008228 [#1]  SMP
  ...

As bpf_crypto_ctx_release() is also used in BPF programs and using
a void pointer as the argument would make the verifier unhappy, add
a simple stub function with the correct type and register it as the
destructor kfunc instead.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Tested-by: Viktor Malik <vmalik@redhat.com>
Link: https://lore.kernel.org/r/20260110082548.113748-7-samitolvanen@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Here is my comprehensive analysis:

---

## Commit Analysis: "bpf: crypto: Use the correct destructor kfunc type"

### 1. COMMIT MESSAGE ANALYSIS

The commit message is explicit and detailed about the crash:
- **Trigger**: Running BPF self-tests with `CONFIG_CFI` enabled
- **Symptom**: `CFI failure at bpf_obj_free_fields+0x190/0x238 (target:
  bpf_crypto_ctx_release+0x0/0x94; expected type: 0xa488ebfc)` followed
  by `Internal error: Oops - CFI: 00000000f2008228 [#1] SMP`
- **Root cause**: Function type mismatch between what the destructor
  function pointer expects (`void (*)(void *)`) and what
  `bpf_crypto_ctx_release` actually is (`void (*)(struct bpf_crypto_ctx
  *)`)
- **Tags**: Acked-by Yonghong Song, Tested-by Viktor Malik

### 2. CODE CHANGE ANALYSIS

The bug mechanism is clear:

**The destructor type** (from `include/linux/bpf.h:228`):
```c
typedef void (*btf_dtor_kfunc_t)(void *);
```

**The call site** (`kernel/bpf/syscall.c:855`):
```c
field->kptr.dtor(xchgd_field);
```

This is an indirect call through a `btf_dtor_kfunc_t` function pointer,
which has type `void (*)(void *)`. With CONFIG_CFI, the kernel enforces
that the actual target function's type hash matches the function
pointer's type hash. But `bpf_crypto_ctx_release` has signature `void
(*)(struct bpf_crypto_ctx *)` - the types don't match, causing a CFI
failure and kernel Oops.

**The fix** adds a thin wrapper with the correct type signature:
```c
__bpf_kfunc void bpf_crypto_ctx_release_dtor(void *ctx)
{
    bpf_crypto_ctx_release(ctx);
}
CFI_NOSEAL(bpf_crypto_ctx_release_dtor);
```
And registers this wrapper as the destructor instead:
```c
-BTF_ID(func, bpf_crypto_ctx_release)
+BTF_ID(func, bpf_crypto_ctx_release_dtor)
```

### 3. ESTABLISHED PATTERN

This is NOT a novel fix. It follows an **exact established pattern**
from commit `e4c00339891c` ("bpf: Fix dtor CFI", v6.7-rc3) by Peter
Zijlstra, which applied the same fix to:
- `kernel/bpf/cpumask.c` - `bpf_cpumask_release_dtor`
- `kernel/bpf/helpers.c` - `bpf_task_release_dtor`,
  `bpf_cgroup_release_dtor`
- `net/bpf/test_run.c` - `bpf_kfunc_call_test_release_dtor`,
  `bpf_kfunc_call_memb_release_dtor`

The crypto code was introduced later (v6.10) and simply missed applying
this pattern, leaving a latent CFI crash.

### 4. SCOPE AND RISK

- **Lines changed**: ~10 lines added, 1 line modified
- **Files changed**: 1 (`kernel/bpf/crypto.c`)
- **Risk**: Extremely low - trivial wrapper function that exactly
  matches the pattern already in use by 5 other BPF destructors
- **Self-contained**: Yes, no dependency on other patches in the series

### 5. AFFECTED STABLE TREES

- **Bug present in**: v6.10 through v6.19 (all versions with
  `kernel/bpf/crypto.c`)
- **v6.12.y LTS**: Confirmed buggy (checked v6.12.69) - has the crypto
  code with the mismatched dtor type
- **v6.6.y and older**: Not affected (`kernel/bpf/crypto.c` doesn't
  exist)
- **CFI_NOSEAL availability**: Present since v6.7-rc3 - available in all
  affected trees
- **Patch applies cleanly**: Verified the surrounding code in v6.12 is
  essentially identical to HEAD

### 6. USER IMPACT

- **Who is affected**: Any user with CONFIG_CFI enabled (Android
  devices, security-hardened enterprise kernels, arm64 systems with
  kCFI)
- **What triggers it**: BPF programs using crypto kptr objects being
  freed (map cleanup, program unload)
- **Severity**: **Kernel Oops/crash** - the CFI check failure causes an
  immediate Oops with `[#1] SMP`, which is a kernel crash
- **Frequency**: Deterministic once the destructor path is hit with CFI
  enabled

### 7. CLASSIFICATION

This is unambiguously a **bug fix**:
- Fixes a kernel crash (Oops)
- No new features, APIs, or behavioral changes
- Small, surgical, well-tested fix
- Follows an established, proven pattern
- No risk of regression

### 8. DEPENDENCY CHECK

- The only dependency is the `CFI_NOSEAL` macro from `e9d13b9d2f99c`
  (v6.7-rc3) and the `__bpf_kfunc` annotation infrastructure - both
  present in all affected stable trees
- The fix is entirely self-contained within `kernel/bpf/crypto.c`

### Summary

This commit fixes a deterministic kernel crash (Oops) on CFI-enabled
kernels when BPF crypto context destructors are invoked. The fix is a
minimal ~10-line change adding a type-correct wrapper function,
following an exact pattern already applied to 5 other BPF destructors
since v6.7. The bug has been present since `kernel/bpf/crypto.c` was
introduced in v6.10 and affects the v6.12.y LTS tree. The fix is
obviously correct, small, self-contained, well-tested, and carries
virtually zero regression risk.

**YES**

 kernel/bpf/crypto.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/crypto.c b/kernel/bpf/crypto.c
index 83c4d9943084b..1d024fe7248ac 100644
--- a/kernel/bpf/crypto.c
+++ b/kernel/bpf/crypto.c
@@ -261,6 +261,12 @@ __bpf_kfunc void bpf_crypto_ctx_release(struct bpf_crypto_ctx *ctx)
 		call_rcu(&ctx->rcu, crypto_free_cb);
 }
 
+__bpf_kfunc void bpf_crypto_ctx_release_dtor(void *ctx)
+{
+	bpf_crypto_ctx_release(ctx);
+}
+CFI_NOSEAL(bpf_crypto_ctx_release_dtor);
+
 static int bpf_crypto_crypt(const struct bpf_crypto_ctx *ctx,
 			    const struct bpf_dynptr_kern *src,
 			    const struct bpf_dynptr_kern *dst,
@@ -368,7 +374,7 @@ static const struct btf_kfunc_id_set crypt_kfunc_set = {
 
 BTF_ID_LIST(bpf_crypto_dtor_ids)
 BTF_ID(struct, bpf_crypto_ctx)
-BTF_ID(func, bpf_crypto_ctx_release)
+BTF_ID(func, bpf_crypto_ctx_release_dtor)
 
 static int __init crypto_kfunc_init(void)
 {
-- 
2.51.0

