Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470A33AE18E;
	Tue, 17 Mar 2026 11:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747174; cv=none; b=h62PDK6aI0iAnepQ3AcTrk6ULz8OodzEOPBV1PbV0j+v8EyHoP8G6U/J+6Bu+3dU0Pk4FVkXQNMcjMTymyAVSzfUqBaELC8xLRXk/VTVIcSlCmzlzoozCXa8851uwwVxMv15kGFI5OfRZVMFVK+/DQuP8XgwLUir8mi3V1Cc9I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747174; c=relaxed/simple;
	bh=5o96v/1i1Me6CnZbJzkrii5AQ8rclitXQ8OYqSTFhvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=REN1814MVeb6SipYaBd6fEZu/28wblVibBaur0zmWVbVoi0iGT/wS4kUOWvJcS2iP902FXRsUWV0/ybwaZnKa5HxQPA2RJQt+AcnBHubxF9rgsC4CwUGBqoYkSzPn/NuprJs/ml1zNyje2EsEzJiw9PClL0HJ0xLAwX/zXpymVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tkPByqbG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tkPByqbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F83C4CEF7;
	Tue, 17 Mar 2026 11:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773747173;
	bh=5o96v/1i1Me6CnZbJzkrii5AQ8rclitXQ8OYqSTFhvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkPByqbGWFMU7x3BJYjvld2kqQ/sib158AGBzZE8vs9bGBk7aNOcg/pIH8dktPdPm
	 4J6SHSTbdLtoTX137DLrh6NLqrtzxBdva1Hv5AI1YQ145MFJFsBhTJd7BqVHuj1HhG
	 4GK5e6UF/Yv9G8AF0Y1IcKChpscQAylvXHDGgt65YR11hKymlyZTGMOSD/dOxm1zPo
	 UICvnN6VtMDxkRGnfFAd0PM0Is3sqcWQSz/XC9mOJEZyHwfxs6rm0al1/9GP4b1lUh
	 OZRMKttuV+VQeSPNydYyIQ9s77MiqMGQOS0WzvXc+oMszY2blPd1R+Z11Q1G6Yc3VS
	 zTd8YTeLqBAOw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: HONG Yifan <elsk@google.com>,
	Carlos Llamas <cmllamas@google.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	peterz@infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19] objtool: Use HOSTCFLAGS for HAVE_XXHASH test
Date: Tue, 17 Mar 2026 07:32:34 -0400
Message-ID: <20260317113249.117771-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260317113249.117771-1-sashal@kernel.org>
References: <20260317113249.117771-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: HONG Yifan <elsk@google.com>

[ Upstream commit 32234049107d012703d50547e815f198f147968b ]

Previously, HAVE_XXHASH is tested by invoking HOSTCC without HOSTCFLAGS.

Consider the following scenario:

- The host machine has libxxhash installed
- We build the kernel with HOSTCFLAGS containing a --sysroot that does
  not have xxhash.h (for hermetic builds)

In this case, HAVE_XXHASH is set to y, but when it builds objtool with
HOSTCFLAGS, because the --sysroot does not contain xxhash.h, the
following error is raised:

<...>/common/tools/objtool/include/objtool/checksum_types.h:12:10: fatal error: 'xxhash.h' file not found
   12 | #include <xxhash.h>
      |          ^~~~~~~~~~

To resolve the error, we test HAVE_XXHASH by invoking HOSTCC with
HOSTCFLAGS.

Signed-off-by: HONG Yifan <elsk@google.com>
Reviewed-by: Carlos Llamas <cmllamas@google.com>
Link: https://patch.msgid.link/20260303010340.306164-1-elsk@google.com
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### Key Finding: Code Exists Only in v6.19+

The `HAVE_XXHASH` test was introduced in commit `0d83da43b1e1c`
("objtool/klp: Add --checksum option to generate per-function
checksums"), which first appeared in v6.19-rc1. This means:
- The buggy code does **not exist** in any older stable trees (6.12.y,
  6.6.y, 6.1.y, 5.15.y, etc.)
- This fix is only relevant for the **6.19.y** stable tree

### Assessment

**Pros:**
- Build fix — explicitly listed as appropriate stable material
- One-line change with zero runtime risk
- Obviously correct: the feature test should use the same flags as the
  actual build
- Reviewed by Carlos Llamas, accepted by Josh Poimboeuf (objtool
  maintainer)
- Fixes a real `fatal error` that completely blocks compilation

**Cons:**
- Only affects builds using custom `HOSTCFLAGS` with `--sysroot`
  (hermetic builds) — a niche scenario
- Only applicable to 6.19.y (the code doesn't exist in older stable
  trees)

### Verdict

This is a legitimate build fix: small, obviously correct, zero risk, and
it prevents a real compilation failure for users with custom sysroot
configurations. Build fixes are explicitly called out as appropriate for
stable trees. The only caveat is that it only applies to 6.19.y since
the affected code was introduced in v6.19-rc1.

### Verification

- `git tag --contains 0d83da43b1e1c` confirmed the HAVE_XXHASH code was
  introduced in v6.19-rc1, not present in earlier stable trees
- `git log -- tools/objtool/Makefile | grep -i xxhash` confirmed the
  history of xxhash-related changes
- The diff is a one-line addition of `$(HOSTCFLAGS)` — verified by
  reading the patch
- Reviewed-by: Carlos Llamas and signed-off by Josh Poimboeuf (objtool
  maintainer) confirmed in commit message
- The fix logic is self-evident: if the build uses `$(HOSTCC)
  $(HOSTCFLAGS)`, the test should too

**YES**

 tools/objtool/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index 76bcd4e85de34..b71d1886022e9 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -13,7 +13,7 @@ endif
 
 ifeq ($(ARCH_HAS_KLP),y)
 	HAVE_XXHASH = $(shell printf "$(pound)include <xxhash.h>\nXXH3_state_t *state;int main() {}" | \
-		      $(HOSTCC) -xc - -o /dev/null -lxxhash 2> /dev/null && echo y || echo n)
+		      $(HOSTCC) $(HOSTCFLAGS) -xc - -o /dev/null -lxxhash 2> /dev/null && echo y || echo n)
 	ifeq ($(HAVE_XXHASH),y)
 		BUILD_KLP	 := y
 		LIBXXHASH_CFLAGS := $(shell $(HOSTPKG_CONFIG) libxxhash --cflags 2>/dev/null) \
-- 
2.51.0

