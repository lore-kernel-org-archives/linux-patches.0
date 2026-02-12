Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA50C19B5A7;
	Thu, 12 Feb 2026 01:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770858604; cv=none; b=G7Z6I41NONBAgZnpGnxm6H1QJIrXEta7pK40GRN8MdRN1b6zuddCFlMGN6RqZYXBDTMb3fXNWo7si+28WZqNTJYU88NAROlXTPE6een8QLkBMnLHgpq9aHit37yIu5CvBMHYiEDJdYfJJZ+dVlGUl064oRFlmdERaNXEvrl0PUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770858604; c=relaxed/simple;
	bh=MSdPoqU9C0vn5lMVrOrSdHYuJ/gSKrvg6bz9j0Oq3s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKsRAewA8WgdEKsn6P6xqRT9+yLPKuK+H43PR+RfWMJOTExHxQH1Vq+H6SguhFQymJB5GdsQt9fU3FsMBmhlzmjA8fDFcRoAUhVBfD9g3seKNFQvtJ1EZV5IXUWVsCkVkorb+mhUSShN8SkuaOKirMDSwjVedqOFf9IWScXJ83Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ql2Tcs5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ql2Tcs5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83328C2BC87;
	Thu, 12 Feb 2026 01:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770858604;
	bh=MSdPoqU9C0vn5lMVrOrSdHYuJ/gSKrvg6bz9j0Oq3s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ql2Tcs5TZEqt43OlGiMk9shYOgqLil34jEHzGRBG8aXc8JgyxQ11qIMT733a9kr9r
	 rJoevFgRa6aDt+OXvVWaeVwpH43+9HZYTamyKwfUWPhoUgCPUqoftZ0RM47clDCX9g
	 p+zmaH14gcCFbkT1Dc741P5A4eMDh5vwIyu/o8hHjVF7HBoXZR9/pgxdUjgK2HcI+M
	 HJaTyluuUITihPHrndMazB9iTLdET8uqC/22KYHY++duPmDxgJSRDUB6sKyBasZsHU
	 NyMbc6vdFqjQMqqVd7JJl8eGRHQzDK6SDkfJTNbAfnVUN6VdiGsUj++2wh3lu2MQmm
	 9bNAGUl3WISLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ihor Solodrai <ihor.solodrai@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	qmo@kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] bpftool: Fix dependencies for static build
Date: Wed, 11 Feb 2026 20:09:27 -0500
Message-ID: <20260212010955.3480391-4-sashal@kernel.org>
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

From: Ihor Solodrai <ihor.solodrai@linux.dev>

[ Upstream commit 08a7491843224f8b96518fbe70d9e48163046054 ]

When building selftests/bpf with EXTRA_LDFLAGS=-static the follwoing
error happens:

  LINK    /ws/linux/tools/testing/selftests/bpf/tools/build/bpftool/bootstrap/bpftool
/usr/bin/x86_64-linux-gnu-ld.bfd: /usr/lib/gcc/x86_64-linux-gnu/15/../../../x86_64-linux-gnu/libcrypto.a(libcrypto-lib-dso_dlfcn.o): in function `dlfcn_globallookup':
   [...]
/usr/bin/x86_64-linux-gnu-ld.bfd: /usr/lib/gcc/x86_64-linux-gnu/15/../../../x86_64-linux-gnu/libcrypto.a(libcrypto-lib-c_zlib.o): in function `zlib_oneshot_expand_block':
(.text+0xc64): undefined reference to `uncompress'
/usr/bin/x86_64-linux-gnu-ld.bfd: /usr/lib/gcc/x86_64-linux-gnu/15/../../../x86_64-linux-gnu/libcrypto.a(libcrypto-lib-c_zlib.o): in function `zlib_oneshot_compress_block':
(.text+0xce4): undefined reference to `compress'
collect2: error: ld returned 1 exit status
make[1]: *** [Makefile:252: /ws/linux/tools/testing/selftests/bpf/tools/build/bpftool/bootstrap/bpftool] Error 1
make: *** [Makefile:327: /ws/linux/tools/testing/selftests/bpf/tools/sbin/bpftool] Error 2
make: *** Waiting for unfinished jobs....

This is caused by wrong order of dependencies in the Makefile. Fix it.

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260128211255.376933-1-ihor.solodrai@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis.

## Analysis

### 1. Commit Message Analysis

The commit subject "bpftool: Fix dependencies for static build" clearly
identifies this as a **build fix**. The message includes the full linker
error output showing undefined references to `compress` and `uncompress`
when building with `EXTRA_LDFLAGS=-static`. This is a concrete,
reproducible build failure.

### 2. Code Change Analysis

The change is extremely minimal -- two lines are modified in
`tools/bpf/bpftool/Makefile`:

```133:134:tools/bpf/bpftool/Makefile
LIBS = $(LIBBPF) -lelf -lz -lcrypto
LIBS_BOOTSTRAP = $(LIBBPF_BOOTSTRAP) -lelf -lz -lcrypto
```

Changed to:
```
LIBS = $(LIBBPF) -lelf -lcrypto -lz
LIBS_BOOTSTRAP = $(LIBBPF_BOOTSTRAP) -lelf -lcrypto -lz
```

The fix is swapping the order of `-lcrypto` and `-lz`. This is the
classic GNU static linker dependency ordering issue: when statically
linking, `ld` resolves symbols left-to-right. Since `libcrypto` depends
on `libz` (it calls `compress`/`uncompress`), `-lcrypto` must appear
**before** `-lz` on the command line. The original order (`-lz
-lcrypto`) leaves `libcrypto`'s references to `compress`/`uncompress`
unresolved because `libz` has already been processed.

### 3. Origin of the Bug

The `-lcrypto` dependency was introduced by commit `40863f4d6ef2c`
("bpftool: Add support for signing BPF programs") which first appeared
in **v6.18**. That commit added `-lcrypto` at the end of the LIBS line,
putting it after `-lz`, which is the wrong order for static linking.

### 4. Affected Stable Trees

- **v6.17 and earlier**: NOT affected -- they do not have `-lcrypto` at
  all (confirmed: `git show v6.17:tools/bpf/bpftool/Makefile` has only
  `-lelf -lz`)
- **v6.18.y**: AFFECTED -- confirmed the buggy ordering `LIBS =
  $(LIBBPF) -lelf -lz -lcrypto` is present in `stable/linux-6.18.y`
- **v6.19.y**: AFFECTED -- same buggy ordering confirmed in
  `stable/linux-6.19.y` and `v6.19`

### 5. Stable Criteria Evaluation

| Criterion | Assessment |
|-----------|-----------|
| Obviously correct and tested | **YES** -- standard linker ordering
fix, the error output confirms the root cause |
| Fixes a real bug | **YES** -- static builds fail completely with
linker errors |
| Important issue | **YES** -- build fix category (prevents
compilation/linking) |
| Small and contained | **YES** -- 2 lines changed, only reordering
flags |
| No new features | **YES** -- pure fix, no new behavior |
| Applies cleanly | **YES** -- the affected lines are identical in
6.18.y and 6.19.y |

### 6. Risk Assessment

**Risk: Near zero.** This change only affects static linking behavior.
Dynamic linking is unaffected by library ordering because the dynamic
linker resolves all symbols at runtime. The fix is trivially correct --
it's a well-known requirement that in static linking, if library A
depends on library B, then `-lA` must precede `-lB`.

### 7. User Impact

Users building bpftool statically (common in container/embedded
environments where static binaries are preferred) are completely blocked
from building on 6.18+ without this fix. The selftests/bpf build is also
broken when `EXTRA_LDFLAGS=-static` is passed.

### 8. Dependency Check

The fix is completely self-contained. It has no dependencies on any
other commit and can be applied independently. It only requires that the
`-lcrypto` dependency exists in the target tree (which it does in 6.18.y
and 6.19.y).

### Summary

This is a textbook stable backport candidate: a small, obvious, zero-
risk build fix that prevents a complete static linking failure in
bpftool on kernels 6.18+. Build fixes are explicitly listed as
appropriate for stable trees in the stable kernel rules. The fix applies
cleanly to the affected stable trees (6.18.y and 6.19.y) since the buggy
lines are identical.

**YES**

 tools/bpf/bpftool/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 5442073a2e428..519ea5cb8ab1c 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -130,8 +130,8 @@ include $(FEATURES_DUMP)
 endif
 endif
 
-LIBS = $(LIBBPF) -lelf -lz -lcrypto
-LIBS_BOOTSTRAP = $(LIBBPF_BOOTSTRAP) -lelf -lz -lcrypto
+LIBS = $(LIBBPF) -lelf -lcrypto -lz
+LIBS_BOOTSTRAP = $(LIBBPF_BOOTSTRAP) -lelf -lcrypto -lz
 
 ifeq ($(feature-libelf-zstd),1)
 LIBS += -lzstd
-- 
2.51.0

