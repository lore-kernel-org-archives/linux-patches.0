Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7DE402BA3;
	Tue, 28 Apr 2026 10:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372952; cv=none; b=p9+a4sDbXso/8j4lmj/pQ0Gn+92hfRwKhEm/0uejO7AxisGBEVBl3r2DXTUbVv/JwhbzN0jhVOLd66Oo2amg3zDc9jYsusReZfkZI3j7tBy2axHwbqKXrbQ5axcJieaXrk8adRZ0LEzEDPI2MzxY1CtqxBSTAzi/k2NuNfqCJyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372952; c=relaxed/simple;
	bh=VbCd9suTkAq0QTyiaF+WctXyADNMKX2UwVQqlIBS9ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UkguVUU9gCMB56vaGxwhCEnaG7mtt47GA1OkIfgvEcKHBBlL4SiMGnV640d56+AGt6XjcHFbnj55dIBQY3c/erkB67kT2+hpXZC5MQYQwJsPNLKpZiHUDTa9cFEsJLlzLT9RCSDnAb1rDEy3LhwT46x0mOYVZJPWrWO0F0WT0lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QUqY/J5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QUqY/J5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4DCC2BCAF;
	Tue, 28 Apr 2026 10:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372951;
	bh=VbCd9suTkAq0QTyiaF+WctXyADNMKX2UwVQqlIBS9ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUqY/J5UE/I0cXMxImdEMMq81tVUpP8i6xo1j08H/KYvAkD1b+1gjRykoWssb72Gn
	 ut8M/8hsyC7OAgQr/gO40z6fn9R+Fy9byWQtJPgM1jVzg0TgcD/j1JtLjmGejamcB/
	 70bmzgwARXme9Moc/Sg3/6HMm4DfVXGqXBnMPA9eVtdtwRv/2c9bYKVnAt9NmKfJDN
	 x5kD9U7cRd2PVCnSF4sCpG2m+A/KWc9sF8LRDtMlpb1WEgghoKeCc768XW/8LJbCpK
	 CfXsUR70VpHVR4s9JOALCYO4zKjwjbXJNdUEy7/+WigVPfulNfB/v4nrVK1qbTxcP1
	 RZPiYNdhTYY6Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yuho Choi <dbgh9129@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ijae Kim <ae878000@gmail.com>,
	Taegyu Kim <tmk5904@psu.edu>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>,
	adaplas@gmail.com,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] fbdev: savage: fix probe-path EDID cleanup leaks
Date: Tue, 28 Apr 2026 06:40:52 -0400
Message-ID: <20260428104133.2858589-41-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 9b8a9a3a6f57edd02b7c8db14a316e6fab7fa772 ]

When CONFIG_FB_SAVAGE_I2C is enabled, savagefb_probe() can build both an
EDID-derived monspecs.modedb and a modelist from it before later failing.

The normal success path frees monspecs.modedb after the initial mode selection,
but the probe error path only deletes the I2C busses and misses the
EDID-derived allocations.

Free both the modelist and monspecs.modedb on the failed: unwind path.

Co-developed-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Co-developed-by: Taegyu Kim <tmk5904@psu.edu>
Signed-off-by: Taegyu Kim <tmk5904@psu.edu>
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: subsystem `fbdev: savage`; action verb `fix`; claimed
intent is to free EDID-derived probe-path allocations on
`savagefb_probe()` failure.

Step 1.2 Record: tags present: `Co-developed-by` Myeonghun Pak, Ijae
Kim, Taegyu Kim; `Signed-off-by` Myeonghun Pak, Ijae Kim, Taegyu Kim,
Yuho Choi, Helge Deller. No `Fixes:`, `Reported-by:`, `Tested-by:`,
`Reviewed-by:`, `Acked-by:`, `Link:`, or `Cc: stable@vger.kernel.org`
tag in the supplied message.

Step 1.3 Record: the body describes a real resource leak when
`CONFIG_FB_SAVAGE_I2C=y`, EDID parsing creates `info->monspecs.modedb`
and modelist entries, and later probe failure reaches `failed:` without
freeing those allocations. Symptom is leaked kernel memory on failed
probe. No explicit affected kernel versions or user report are provided.

Step 1.4 Record: not hidden; this is explicitly a probe error-path
cleanup leak fix.

## Phase 2: Diff Analysis
Step 2.1 Record: one file changed,
`drivers/video/fbdev/savage/savagefb_driver.c`; 2 lines added, 0
removed; function modified: `savagefb_probe()`; scope is a single-file
surgical error-path fix.

Step 2.2 Record: before, `failed:` under `CONFIG_FB_SAVAGE_I2C` only
deleted I2C busses. After, it also calls
`fb_destroy_modelist(&info->modelist)` and
`fb_destroy_modedb(info->monspecs.modedb)`. This affects probe unwind
paths after EDID/modelist setup.

Step 2.3 Record: bug category is resource leak. Verified allocation
sources: `fb_edid_to_monspecs()` stores `specs->modedb =
fb_create_modedb(...)`; `fb_create_modedb()` allocates with
`kzalloc_objs()`/`kmalloc_objs()`; `fb_videomode_to_modelist()` calls
`fb_add_videomode()`, which allocates `struct fb_modelist`. Verified
cleanup helpers free those objects.

Step 2.4 Record: fix quality is good: minimal, uses existing fbdev
cleanup APIs, no new feature/API. Regression risk is very low.
`fb_destroy_modedb(NULL)` is just `kfree(NULL)`, and
`fb_destroy_modelist()` safely iterates an initialized empty list.

## Phase 3: Git History Investigation
Step 3.1 Record: `git blame` shows the EDID/modelist setup and missing
`failed:` cleanup originate from very old code, much of it from the
initial imported history; the local EDID pointer handling was adjusted
by `0f8a1cae923670` in v5.18-rc1, but the leak pattern existed before
that with `par->edid`.

Step 3.2 Record: no `Fixes:` tag is present, so no target commit to
follow.

Step 3.3 Record: recent file history includes related probe fixes:
`e8d35898a78e3` fixed a savage probe leak in 2020, `04e5eac8f3ab`
handled zero pixclock, and `6ad959b6703e` fixed error handling for
`savagefb_check_var()`. No prerequisite was found for this cleanup,
because the failed label and cleanup helpers exist independently.

Step 3.4 Record: local history has no commits by Yuho Choi under
`drivers/video/fbdev`; Helge Deller signed off the supplied commit and
is verified in `MAINTAINERS` as framebuffer layer maintainer. The S3
Savage driver entry lists Antonino Daplas as maintainer.

Step 3.5 Record: dependency risk is low. The patch only uses
`fb_destroy_modelist()` and `fb_destroy_modedb()`, both verified present
in v5.15, v6.1, and v6.6 tags.

## Phase 4: Mailing List And External Research
Step 4.1 Record: no local commit hash was found with `git log --grep`,
so `b4 dig -c <hash>` could not be performed on a real commit object.
Attempts to use `b4 dig` with the subject failed: “Cannot find a commit
matching ...”. Lore `WebFetch` searches were blocked by Anubis; web
search found no exact subject match.

Step 4.2 Record: `b4 dig -w` could not identify recipients for the same
reason: no commit object found.

Step 4.3 Record: no `Link:` or `Reported-by:` tags were supplied; no
external bug report was verified.

Step 4.4 Record: no patch series context was verified. Local git history
suggests this is standalone.

Step 4.5 Record: stable-specific lore search could not be verified
because lore fetch was blocked; web search found no exact stable
discussion.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: modified function: `savagefb_probe()`.

Step 5.2 Record: `savagefb_probe()` is assigned as `.probe` in
`savagefb_driver`; `savagefb_init()` calls
`pci_register_driver(&savagefb_driver)`; `pci_register_driver` maps to
`__pci_register_driver()`, which registers the driver with the PCI core.
Impact is limited to S3 Savage PCI/AGP devices.

Step 5.3 Record: relevant callees are `savagefb_create_i2c_busses()`,
`savagefb_probe_i2c_connector()`, `fb_edid_to_monspecs()`,
`fb_videomode_to_modelist()`, `register_framebuffer()`, and the cleanup
helpers. Verified `savagefb_probe_i2c_connector()` can obtain EDID via
DDC or firmware copy.

Step 5.4 Record: reachable during PCI device probe at boot, module load,
hotplug, or driver bind. I did not verify an unprivileged direct
trigger; this appears hardware/config/probe-path reachable, not syscall-
hot-path reachable.

Step 5.5 Record: similar cleanup patterns exist in other fbdev drivers:
`udlfb`, `smscufx`, and `uvesafb` free both `monspecs.modedb` and
`modelist` on teardown/error paths.

## Phase 6: Stable Tree Analysis
Step 6.1 Record: buggy pattern verified in v4.14, v4.19, v5.10, v5.15,
v6.1, v6.6, v6.10, and v6.12 tags: EDID/modelist are created, normal
path destroys `monspecs.modedb`, but `failed:` only deletes I2C busses.

Step 6.2 Record: expected backport difficulty is clean or minor line-
offset adjustment. For older trees, EDID is stored as `par->edid`, but
the new cleanup lines only reference `info`, so no semantic dependency
on the v5.18 local-variable cleanup.

Step 6.3 Record: no related fix for this exact EDID/modelist failed-path
leak found in local history.

## Phase 7: Subsystem Context
Step 7.1 Record: subsystem is fbdev driver code, specifically S3 Savage
framebuffer. Criticality is peripheral/driver-specific, but kernel
memory leaks in probe error paths are still real bugs for affected
hardware/configurations.

Step 7.2 Record: `drivers/video/fbdev` is active, but
`drivers/video/fbdev/savage` has low churn. Recent changes are mostly
small fixes and cleanups.

## Phase 8: Impact And Risk
Step 8.1 Record: affected users are systems with `CONFIG_FB_SAVAGE` and
`CONFIG_FB_SAVAGE_I2C` using S3 Savage hardware or matching devices.

Step 8.2 Record: trigger requires successful EDID-derived allocation
followed by later `savagefb_probe()` failure, such as mode
validation/geometry failure or framebuffer registration failure.
Repeated privileged probe attempts could accumulate leaks; no
unprivileged trigger was verified.

Step 8.3 Record: failure mode is kernel memory/resource leak, severity
medium: not a crash or corruption, but real unreclaimed kernel memory on
failed probe.

Step 8.4 Record: benefit is moderate for affected systems because it
fixes a verified leak across many stable versions. Risk is very low: two
cleanup calls in an existing unwind path, using established helpers.

## Phase 9: Final Synthesis
Step 9.1 Record: evidence for backporting: verified real leak, tiny
scoped patch, existing helper APIs, same buggy pattern present in many
stable tags, no feature/API change, low regression risk. Evidence
against: driver-specific old hardware, only a probe failure path, no
verified user report/test/lore review. Unresolved: exact upstream commit
hash and mailing-list discussion could not be verified.

Step 9.2 Record: stable rules checklist: obviously correct by code
inspection: yes; fixes a real bug: yes, leaked `modedb` and modelist
allocations; important issue: medium, resource leak rather than crash;
small and contained: yes, 2 lines in one function; no new features/APIs:
yes; can apply to stable: likely yes, helpers and buggy code verified in
stable tags.

Step 9.3 Record: not a device-ID, quirk, DT, build, or documentation
exception. It is a standard resource-leak fix.

Step 9.4 Decision: backport. The issue is not high severity, but the fix
is minimal, correct, uses existing cleanup APIs, and addresses a
verified kernel memory leak present across stable trees.

Verification:
- [Phase 1] Parsed supplied subject/body/tags; confirmed no
  Fixes/Reported/Tested/Reviewed/Acked/Link/Cc stable tags in the
  supplied message.
- [Phase 2] Read `savagefb_probe()` and helper implementations;
  confirmed missing failed-path cleanup and verified allocation/free
  behavior.
- [Phase 3] Ran `git blame`, `git log`, `git show`, and ancestry checks
  without `--all`; found related savage probe/error-path history and no
  local candidate commit.
- [Phase 4] Ran `b4 dig` attempts, web search, and lore fetch attempts;
  no exact commit/thread verified, lore fetch blocked by Anubis.
- [Phase 5] Traced `savagefb_probe()` registration through the PCI
  driver structure and `pci_register_driver()`.
- [Phase 6] Used tag-scoped `git grep` on v4.14, v4.19, v5.10, v5.15,
  v6.1, v6.6, v6.10, and v6.12; confirmed the buggy pattern exists.
- [Phase 7] Checked `MAINTAINERS`; verified fbdev and S3 Savage
  maintainer entries.
- [Phase 8] Verified trigger and severity from code paths; unprivileged
  trigger remains unverified and did not drive the decision.

**YES**

 drivers/video/fbdev/savage/savagefb_driver.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/savage/savagefb_driver.c b/drivers/video/fbdev/savage/savagefb_driver.c
index ac41f8f37589f..c2f79357c8da0 100644
--- a/drivers/video/fbdev/savage/savagefb_driver.c
+++ b/drivers/video/fbdev/savage/savagefb_driver.c
@@ -2322,6 +2322,8 @@ static int savagefb_probe(struct pci_dev *dev, const struct pci_device_id *id)
  failed:
 #ifdef CONFIG_FB_SAVAGE_I2C
 	savagefb_delete_i2c_busses(info);
+	fb_destroy_modelist(&info->modelist);
+	fb_destroy_modedb(info->monspecs.modedb);
 #endif
 	fb_alloc_cmap(&info->cmap, 0, 0);
 	savage_unmap_video(info);
-- 
2.53.0

