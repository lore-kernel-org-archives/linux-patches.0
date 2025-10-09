Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206DA35949;
	Thu,  9 Oct 2025 16:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025616; cv=none; b=E9CJm61+2xqhmTCFkGunj9N3lLxzsFC2ZQqTFtIBUBiHcZa0mXTAP1nh79KfFQjEc/Q2G/pNCdun6mRCvl3t0rZr8a4oo9HrBN17/oQU/5hOsUoK8GOy/2u4a1djfhRBy54S7jXt+4f6ZySzz5XO018TfivpGsup0W83RigOaWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025616; c=relaxed/simple;
	bh=v6Obz/APuabChahRaoUjFnlFmuZpIaMN+l88laEf0jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F+OZ85tjhnCAe01JKmzhriLG+dayoWnXfZZb5UpAPHX4Hny3JCiVS/tOXPt1eFCdPSg+Cc+iIBUuLPlKqlYy4P8UJJuk0ZTCdonJgsaPBZe1aAeUfY5Kq5+QPZwAuh4rAiKi7s2kpfYrUc8RDe6Y8p90yN9gYYjIHd6+Bk8OYPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ODfvDC/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ODfvDC/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767CDC116B1;
	Thu,  9 Oct 2025 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025615;
	bh=v6Obz/APuabChahRaoUjFnlFmuZpIaMN+l88laEf0jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODfvDC/al6rUFNEeSOcSpqsq/gxw6rxXEoM3VdCgwVPLSLaiY7SnKzurEqqkQxXs8
	 1TjTeYn5nPXhIzpRPDFkICzkKpOY5yrkfVcUmAvsirAH1yUu98ZMQqJXI0ID+qj0ch
	 CWzSlOqHeCgNRa7bLU5NDG505Xknb0loF6tGkifxg5Ll4N6YSfR+seKexYWY9U9oFI
	 FZTT/JZ7CiO55ZYih8/2zv0M24tMeh0j2h02vHSPu5XJJsPMd6c8fEHzChvEFWa9dV
	 5RzaVHItYDylLgdBED/CVnTkGCo73mXowtaCM7H/nbxrpuWTBjUTQxzRhvfkQwOwfO
	 oMEOlo8BQBq6g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	ckeepax@opensource.cirrus.com,
	nathan@kernel.org,
	linux-sound@vger.kernel.org,
	patches@opensource.cirrus.com,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17-5.4] mfd: madera: Work around false-positive -Wininitialized warning
Date: Thu,  9 Oct 2025 11:55:42 -0400
Message-ID: <20251009155752.773732-76-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 364752aa0c6ab0a06a2d5bfdb362c1ca407f1a30 ]

clang-21 warns about one uninitialized variable getting dereferenced
in madera_dev_init:

drivers/mfd/madera-core.c:739:10: error: variable 'mfd_devs' is uninitialized when used here [-Werror,-Wuninitialized]
  739 |                               mfd_devs, n_devs,
      |                               ^~~~~~~~
drivers/mfd/madera-core.c:459:33: note: initialize the variable 'mfd_devs' to silence this warning
  459 |         const struct mfd_cell *mfd_devs;
      |                                        ^
      |                                         = NULL

The code is actually correct here because n_devs is only nonzero
when mfd_devs is a valid pointer, but this is impossible for the
compiler to see reliably.

Change the logic to check for the pointer as well, to make this easier
for the compiler to follow.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20250807071932.4085458-1-arnd@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - Initializes `mfd_devs` to a known value to placate clang-21’s
    -Wuninitialized:
    - drivers/mfd/madera-core.c:459 initializes `const struct mfd_cell
      *mfd_devs = NULL;`
  - Hardens the validity check before use:
    - drivers/mfd/madera-core.c:673 expands the guard from `if
      (!n_devs)` to `if (!n_devs || !mfd_devs)`
  - The pointer is later passed to `mfd_add_devices()`:
    - drivers/mfd/madera-core.c:739 uses `mfd_devs, n_devs`

- Why it matters
  - Fixes a real build failure with newer toolchains: clang-21 flags the
    potential uninitialized use as an error (`-Werror,-Wuninitialized`)
    when passing `mfd_devs` to `mfd_add_devices()` (as described in the
    commit message and evidenced by the code at drivers/mfd/madera-
    core.c:739 and the declaration at drivers/mfd/madera-core.c:459).
  - The code’s intended invariant is that `n_devs` is set nonzero iff
    `mfd_devs` points to a valid array; this is enforced by setting them
    together in each supported device case, e.g.:
    - drivers/mfd/madera-core.c:603/604 (`cs47l15` case)
    - drivers/mfd/madera-core.c:616/617 (`cs47l35` case)
    - drivers/mfd/madera-core.c:630/631 (`cs47l85`/`WM1840` case)
    - drivers/mfd/madera-core.c:644/645 (`cs47l90`/`CS47L91` case)
    - drivers/mfd/madera-core.c:659/660 (`cs42l92`/`cs47l92`/`cs47l93`
      case)
  - Compilers cannot always see this invariant, leading to the false
    positive. Initializing the pointer and checking it explicitly makes
    the intent obvious and restores buildability with strict warning-as-
    error configurations.

- Stability and risk
  - Minimal, localized change confined to MFD madera core; no
    architectural changes.
  - No functional behavior change in the valid paths: when any supported
    device is matched, both `mfd_devs` and `n_devs` are set together
    (see examples above), so the new check behaves identically to the
    old one.
  - If an unexpected code path ever sets `n_devs` without a valid
    `mfd_devs`, the new guard fails fast with `-ENODEV` rather than
    risking undefined behavior at `mfd_add_devices()`—arguably safer.
  - Does not introduce new features; purely a correctness/build fix for
    newer compilers.

- Stable backport criteria
  - Fixes a user-affecting bug: builds with newer clang (and with
    `CONFIG_WERROR=y` or similar settings) break; this unblocks those
    builds.
  - The fix is small, contained, and low risk.
  - No cross-subsystem or architectural changes.
  - While there’s no explicit “Cc: stable” tag, stable trees routinely
    accept trivial, obviously-correct build fixes for widely used
    toolchains.

Given the above, this is a good candidate for stable backporting.

 drivers/mfd/madera-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/madera-core.c b/drivers/mfd/madera-core.c
index bdbd5bfc97145..2f74a8c644a32 100644
--- a/drivers/mfd/madera-core.c
+++ b/drivers/mfd/madera-core.c
@@ -456,7 +456,7 @@ int madera_dev_init(struct madera *madera)
 	struct device *dev = madera->dev;
 	unsigned int hwid;
 	int (*patch_fn)(struct madera *) = NULL;
-	const struct mfd_cell *mfd_devs;
+	const struct mfd_cell *mfd_devs = NULL;
 	int n_devs = 0;
 	int i, ret;
 
@@ -670,7 +670,7 @@ int madera_dev_init(struct madera *madera)
 		goto err_reset;
 	}
 
-	if (!n_devs) {
+	if (!n_devs || !mfd_devs) {
 		dev_err(madera->dev, "Device ID 0x%x not a %s\n", hwid,
 			madera->type_name);
 		ret = -ENODEV;
-- 
2.51.0

