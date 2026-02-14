Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC2B1E1E12;
	Sat, 14 Feb 2026 01:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031174; cv=none; b=QzN0S3nvXMPEMAfUi4S8rHwax2f/UT4jcdYtGP7yt0zFlodzMCOxPchtnDVcSefjlWbWaTEs7brsDr8icXhsxQQiCnbFJzKBDB6iJxWDLFHru9QTl2MU8rF2FSomkvj+F1zXn44GpMHctjMt70zUjmsAjW2KuSnEy269+1ExsdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031174; c=relaxed/simple;
	bh=P757cIvbybrbEigvjiYTK9LdfSBIH58ZVy2Orfdfk4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cW050KpAJBXO+PuWbEobyeSQEksQw4P5MJEDkS1nj1y2cCOeG6gn/IfLq4QxHAgtSRDWWTLkIqwF7hrk80yRUIQwO/w6YX1w6G9Wxx+Di35JctHgZDVDIKa9sJtOSMpxlbqIhbBNSRAZkTfW9gCLGpz6AYY77eEh4HCno5M5GDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o7qNBqk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o7qNBqk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA81C19423;
	Sat, 14 Feb 2026 01:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031174;
	bh=P757cIvbybrbEigvjiYTK9LdfSBIH58ZVy2Orfdfk4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7qNBqk4gFz0xDlse3fuddnJlgjgpi18nsyFVScDgyVn2F6M2tQiSH5Jyy+vI1zLQ
	 W2nG6SL2Zk+j/vMy90AuJGpzNidU7sFtVp56druL/DaGxrHyShc2wXgYdWfoF/H1hI
	 ARuvrQcL8Dgb5exXn9QMQBfg38RaeLaBtFe/dJjmHEf6r1PaKjIg7+0+C38hf22eMm
	 eELpC515TEAaW/SsD6XcCNOv1brienfK/irrtfTR+qAPwjr0eHPVJ3SA/oUuaJkVxd
	 ZK+V8Uj3NDJJabyg9jFbwBU0GY/AC6zDknYYrybXifla5reqniUtCi2uv/MbDobUnq
	 YCZoiqWD3R1gA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	nsc@kernel.org,
	masahiroy@kernel.org,
	peterz@infradead.org,
	petr.pavlu@suse.com,
	neil.armstrong@linaro.org,
	u.kleine-koenig@baylibre.com,
	yelangyan@huaqin.corp-partner.google.com,
	jeff.johnson@oss.qualcomm.com,
	linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] modpost: Amend ppc64 save/restfpr symnames for -Os build
Date: Fri, 13 Feb 2026 19:59:29 -0500
Message-ID: <20260214010245.3671907-89-sashal@kernel.org>
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

From: René Rebe <rene@exactco.de>

[ Upstream commit 3cd9763ce4ad999d015cf0734e6b968cead95077 ]

Building a size optimized ppc64 kernel (-Os), gcc emits more FP
save/restore symbols, that the linker generates on demand into the
.sfpr section. Explicitly allow-list those in scripts/mod/modpost.c,
too. They are needed for the amdgpu in-kernel floating point support.

MODPOST Module.symvers
ERROR: modpost: "_restfpr_20" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost: "_restfpr_26" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost: "_restfpr_22" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost: "_savegpr1_27" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost: "_savegpr1_25" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost: "_restfpr_28" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost: "_savegpr1_29" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost: "_savefpr_20" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost: "_savefpr_22" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
ERROR: modpost: "_restfpr_15" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
WARNING: modpost: suppressed 56 unresolved symbol warnings because there were too many)

Signed-off-by: René Rebe <rene@exactco.de>
Link: https://patch.msgid.link/20251123.131330.407910684435629198.rene@exactco.de
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The base code is present and the patch should apply cleanly to any
stable tree that has the PPC64 symbol allowlist in
`ignore_undef_symbol()`, which has been there for many years.

### Summary

- **What it fixes**: Build failure on ppc64 with `-Os` optimization
- **Severity**: Build breakage (prevents kernel compilation in a valid
  configuration)
- **Risk**: Minimal — adds 4 trivial string checks following existing
  patterns
- **Scope**: Tiny, contained to one function
- **Dependencies**: None — standalone fix
- **Stable criteria**: Meets all criteria — obviously correct, fixes a
  real build issue, small and contained, no new features

This is a textbook build fix suitable for stable backporting. It's
small, obviously correct, follows existing patterns, has no risk of
regression, and fixes a real build failure.

**YES**

 scripts/mod/modpost.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 755b842f1f9b7..88ad227f87cd1 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -602,6 +602,10 @@ static int ignore_undef_symbol(struct elf_info *info, const char *symname)
 		/* Special register function linked on all modules during final link of .ko */
 		if (strstarts(symname, "_restgpr0_") ||
 		    strstarts(symname, "_savegpr0_") ||
+		    strstarts(symname, "_restgpr1_") ||
+		    strstarts(symname, "_savegpr1_") ||
+		    strstarts(symname, "_restfpr_") ||
+		    strstarts(symname, "_savefpr_") ||
 		    strstarts(symname, "_restvr_") ||
 		    strstarts(symname, "_savevr_") ||
 		    strcmp(symname, ".TOC.") == 0)
-- 
2.51.0

