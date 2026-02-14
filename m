Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AAA21ADB7;
	Sat, 14 Feb 2026 01:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031145; cv=none; b=rG47SbdjoNrzXAyNHwkLQpGWCc/b9oViJYGNAbf+N2dwRMwuPUh9k4fh5yL4PWH2hhbJQeDNJZwQVLa59ak9uoCr5sQ3Ok8HPr5S+klZ+QwmWwwFGwAFkgw6CA0mjap674UCmaeUaqhsqz+SkWMwtdfuxl/WdyhPWsHA0TtTiJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031145; c=relaxed/simple;
	bh=Mn2BvRC/v2EumkTXNegBNbOaWJXMHSR3yTdmbtsVVVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aHV6KRD6Yq85QmrEZkHnuCr+woaYfVY5WToQHSKfqA1AcGrZcb9WU9enNznCXKsZBfbKdfjhRfdJcjGreni8OgKGcTcZq8cOkVyvUs4eSFNfej1usChrCXLEanRAntmyi0phSCgBj0eqxBDxHpWPfAbkdXOMWMbiIfrHVmQIey8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eu2AK6N4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eu2AK6N4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30811C116C6;
	Sat, 14 Feb 2026 01:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031145;
	bh=Mn2BvRC/v2EumkTXNegBNbOaWJXMHSR3yTdmbtsVVVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eu2AK6N4wprzWLSEJhfiNJar0dXZ45qW5mPxtjhHvGIjpZQl35QQDOPnSHjJjs+tw
	 DGgq2xLsApewINY9a0cW3UhGjuLUd184g66dwQHxRJuzKX2/6tW9YEVh9uXC1BDFoA
	 AXW5iRNHCg51eF6kdhBETUbXd90nJf9TbgOp0tQz1BU0u5pdXRDA+lLWKXunGSGwLF
	 q/MPy7IgZLHSm0qNi+jEFezBSFs0o1ZEAOVzTOnjEl1z4+KHwTqDTTUBzCNcmQlYcR
	 DHeDULiKFg6pKnZDEA2FNC1wB7opoAjCjresxzUWF8enjBUcpPHmMn1ZulJv4/JIsF
	 4a552FgU8QQkg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nicolas Schier <nsc@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	hansg@kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.19-5.10] virt: vbox: uapi: Mark inner unions in packed structs as packed
Date: Fri, 13 Feb 2026 19:59:22 -0500
Message-ID: <20260214010245.3671907-82-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit c25d01e1c4f2d43f47af87c00e223f5ca7c71792 ]

The unpacked unions within a packed struct generates alignment warnings
on clang for 32-bit ARM:

./usr/include/linux/vbox_vmmdev_types.h:239:4: error: field u within 'struct vmmdev_hgcm_function_parameter32'
  is less aligned than 'union (unnamed union at ./usr/include/linux/vbox_vmmdev_types.h:223:2)'
  and is usually due to 'struct vmmdev_hgcm_function_parameter32' being packed,
  which can lead to unaligned accesses [-Werror,-Wunaligned-access]
     239 |         } u;
         |           ^

./usr/include/linux/vbox_vmmdev_types.h:254:6: error: field u within
  'struct vmmdev_hgcm_function_parameter64::(anonymous union)::(unnamed at ./usr/include/linux/vbox_vmmdev_types.h:249:3)'
  is less aligned than 'union (unnamed union at ./usr/include/linux/vbox_vmmdev_types.h:251:4)' and is usually due to
  'struct vmmdev_hgcm_function_parameter64::(anonymous union)::(unnamed at ./usr/include/linux/vbox_vmmdev_types.h:249:3)'
  being packed, which can lead to unaligned accesses [-Werror,-Wunaligned-access]

With the recent changes to compile-test the UAPI headers in more cases,
these warning in combination with CONFIG_WERROR breaks the build.

Fix the warnings.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512140314.DzDxpIVn-lkp@intel.com/
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/linux-kbuild/20260110-uapi-test-disable-headers-arm-clang-unaligned-access-v1-1-b7b0fa541daa@kernel.org/
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/linux-kbuild/29b2e736-d462-45b7-a0a9-85f8d8a3de56@app.fastmail.com/
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Tested-by: Nicolas Schier <nsc@kernel.org>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260115-kbuild-alignment-vbox-v1-2-076aed1623ff@linutronix.de
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of Commit: Mark inner unions in packed structs as packed

### 1. COMMIT MESSAGE ANALYSIS

The commit fixes **build warnings that become build errors** when
`CONFIG_WERROR` is enabled, specifically on 32-bit ARM with clang. The
key phrase is:

> "With the recent changes to compile-test the UAPI headers in more
cases, these warning in combination with CONFIG_WERROR breaks the
build."

This is explicitly a **build fix**. The commit has strong credibility
signals:
- **Two Reported-by tags**: kernel test robot and Nathan Chancellor (a
  prominent kernel build/clang maintainer)
- **Tested-by and Reviewed-by**: Nicolas Schier
- **Acked-by**: Greg Kroah-Hartman (stable tree maintainer himself)
- **Suggested-by**: Arnd Bergmann (architecture/cross-compilation
  expert)

### 2. CODE CHANGE ANALYSIS

The change is minimal and purely mechanical:

1. In `struct vmmdev_hgcm_function_parameter32`: The inner `union`
   member `u` is marked `__packed` (line: `} __packed u;` replacing `}
   u;`)
2. In `struct vmmdev_hgcm_function_parameter64`: An inner `union` member
   `u` within the `pointer` struct is marked `__packed` (line: `}
   __packed u;` replacing `} u;`)

These are UAPI header changes, meaning they affect the kernel-userspace
ABI definition. However, since the outer structs are already `__packed`,
adding `__packed` to the inner unions doesn't change the actual memory
layout — it just makes the packing attribute explicit to silence the
compiler warning. The `VMMDEV_ASSERT_SIZE` macros at the end of each
struct definition confirm that the sizes remain unchanged (4 + 8 for
32-bit, 4 + 12 for 64-bit).

### 3. CLASSIFICATION

This is a **build fix** — one of the explicitly allowed exception
categories for stable backports. Build fixes that prevent compilation
are critical for users who need to build the kernel.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 3 lines (two additions of `__packed`, one
  replacement)
- **Files touched**: 1 file (`include/uapi/linux/vbox_vmmdev_types.h`)
- **Risk**: Extremely low. The `__packed` attribute on inner unions
  within already-packed structs is redundant in terms of layout but
  silences legitimate compiler warnings. The `ASSERT_SIZE` macros
  guarantee no ABI change.
- **Complexity**: Trivial

### 5. USER IMPACT

Without this fix, users building the kernel for 32-bit ARM with clang
and `CONFIG_WERROR=y` will get a build failure. This is a real
configuration used by:
- Android builds (commonly use clang)
- Embedded ARM systems
- CI/build testing infrastructure (kernel test robot hit this)

### 6. STABILITY INDICATORS

- Tested-by, Reviewed-by, Acked-by from well-known kernel developers
- The fix is obviously correct — it just propagates the `__packed`
  attribute consistently
- No functional behavior change whatsoever

### 7. DEPENDENCY CHECK

The commit message mentions "recent changes to compile-test the UAPI
headers in more cases" which triggered this. However, this fix is
standalone — the `__packed` attribute is correct regardless of whether
those compile-test changes are present. Even without the compile-test
changes, this fix is harmless and correct, and the warning could be
triggered by other build configurations.

### Conclusion

This is a textbook stable backport candidate:
- It's a **build fix** (explicitly allowed category)
- It's **obviously correct** (adding `__packed` to unions inside packed
  structs)
- It's **tiny** (3 lines, 1 file)
- It has **zero risk** of runtime regression (no behavior change, sizes
  verified by assert macros)
- It has **strong review** (Acked-by Greg KH, Reviewed/Tested by others)
- It fixes a **real build failure** reported by multiple people
- It affects a **UAPI header** used across architectures

**YES**

 include/uapi/linux/vbox_vmmdev_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/vbox_vmmdev_types.h b/include/uapi/linux/vbox_vmmdev_types.h
index 6073858d52a2e..11f3627c3729b 100644
--- a/include/uapi/linux/vbox_vmmdev_types.h
+++ b/include/uapi/linux/vbox_vmmdev_types.h
@@ -236,7 +236,7 @@ struct vmmdev_hgcm_function_parameter32 {
 			/** Relative to the request header. */
 			__u32 offset;
 		} page_list;
-	} u;
+	} __packed u;
 } __packed;
 VMMDEV_ASSERT_SIZE(vmmdev_hgcm_function_parameter32, 4 + 8);
 
@@ -251,7 +251,7 @@ struct vmmdev_hgcm_function_parameter64 {
 			union {
 				__u64 phys_addr;
 				__u64 linear_addr;
-			} u;
+			} __packed u;
 		} __packed pointer;
 		struct {
 			/** Size of the buffer described by the page list. */
-- 
2.51.0

