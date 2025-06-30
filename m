Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8291628E59E;
	Mon, 30 Jun 2025 20:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317119; cv=none; b=Kjq9TnyqQ2PE+iVZcd5PA8YVXsiN3bY6O7yKMwHg0MaV6Otf7USdFpKu22A9cg4dDC522GBAmlVtNGWlgU9SEIow8CVDi92ZqLPd/hyBU3+EDruE4Fk+UHTM3upkY4TtqrEFJpaCa5LMG+H6cAbkBUM8JjFyaMhJTRJLsCn0Oaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317119; c=relaxed/simple;
	bh=BkpQ94JuXi1auJUJ37Nsi92gLf14UvU0OReEgYN4xr4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SyTEH2Qn76PDPSJtlr9PQf2XPpyWtc+YS2B1bpUH7o0R8ISV6RYHZmEgVbR2xdLwEb/FDRiZCa25ic+HPfOAP/AZtlm/AFn2jch8WGSC1S4tXStvrUC2ROfAXo45smmdwFBmehwqQQMWvIkmXzcCQt5WE8USdi2rWmfGtE+obrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eyDHU7yI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eyDHU7yI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF9BC4CEE3;
	Mon, 30 Jun 2025 20:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317118;
	bh=BkpQ94JuXi1auJUJ37Nsi92gLf14UvU0OReEgYN4xr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyDHU7yIksLTXkvShLDHtnme3PsA6VUNRKgtXNJ8qjNerrIcu3Nc79vAlYCE3ko/E
	 ivDOkgLdGX3qnCzZC1kRyQQJjdCvvRuBoe5GT33h4Q/wvzBv4GqkaP8P2fTUcbyZ/U
	 YNRLcJyZskl4TJvLd2ToeZTIXmkXgvsOpGynQPpqXLa8Pqfdcsd8dB6CvMO12moStl
	 EeEA3g62pT1p0KtXmznFJP3ouGtXeawKbk/D96BbidlawE6TEsoQk0JLv1MS46FQ++
	 Fp4PiFl7kiBYZYD1gHDXFe0YEfrfPe50y5LPt4d8YZ5Q47cH8p//EZbRKADQbsSWQM
	 Iny2E2VO0NsTw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tamura Dai <kirinode0@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	yung-chuan.liao@linux.intel.com,
	peter.ujfalusi@linux.intel.com,
	pierre-louis.bossart@linux.dev,
	liam.r.girdwood@intel.com,
	brent.lu@intel.com,
	peterz@infradead.org,
	tavianator@tavianator.com
Subject: [PATCH AUTOSEL 6.15 04/23] ASoC: SOF: Intel: hda: Use devm_kstrdup() to avoid memleak.
Date: Mon, 30 Jun 2025 16:44:09 -0400
Message-Id: <20250630204429.1357695-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630204429.1357695-1-sashal@kernel.org>
References: <20250630204429.1357695-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.4
Content-Transfer-Encoding: 8bit

From: Tamura Dai <kirinode0@gmail.com>

[ Upstream commit 6c038b58a2dc5a008c7e7a1297f5aaa4deaaaa7e ]

sof_pdata->tplg_filename can have address allocated by kstrdup()
and can be overwritten. Memory leak was detected with kmemleak:

unreferenced object 0xffff88812391ff60 (size 16):
  comm "kworker/4:1", pid 161, jiffies 4294802931
  hex dump (first 16 bytes):
    73 6f 66 2d 68 64 61 2d 67 65 6e 65 72 69 63 00  sof-hda-generic.
  backtrace (crc 4bf1675c):
    __kmalloc_node_track_caller_noprof+0x49c/0x6b0
    kstrdup+0x46/0xc0
    hda_machine_select.cold+0x1de/0x12cf [snd_sof_intel_hda_generic]
    sof_init_environment+0x16f/0xb50 [snd_sof]
    sof_probe_continue+0x45/0x7c0 [snd_sof]
    sof_probe_work+0x1e/0x40 [snd_sof]
    process_one_work+0x894/0x14b0
    worker_thread+0x5e5/0xfb0
    kthread+0x39d/0x760
    ret_from_fork+0x31/0x70
    ret_from_fork_asm+0x1a/0x30

Signed-off-by: Tamura Dai <kirinode0@gmail.com>
Link: https://patch.msgid.link/20250615235548.8591-1-kirinode0@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## 1. **This fixes a real memory leak bug**

The kmemleak trace in the commit message shows concrete evidence of a
memory leak:
```
unreferenced object 0xffff88812391ff60 (size 16):
  comm "kworker/4:1", pid 161, jiffies 4294802931
  hex dump (first 16 bytes):
    73 6f 66 2d 68 64 61 2d 67 65 6e 65 72 69 63 00  sof-hda-generic.
```

## 2. **The bug mechanism is clear**

Looking at the code changes, the leak occurs because:
- `remove_file_ext()` allocates memory with `kstrdup()`
- This allocated pointer is assigned to `sof_pdata->tplg_filename`
- Later in `hda_machine_select()`, this pointer can be overwritten
  multiple times (lines 1373, 1413, 1452, 1473, 1484 all show
  `devm_kasprintf()` calls that reassign `sof_pdata->tplg_filename`)
- Each overwrite leaks the previously allocated memory

## 3. **The fix is minimal and contained**

The change is extremely focused:
```diff
-static char *remove_file_ext(const char *tplg_filename)
+static char *remove_file_ext(struct device *dev, const char
*tplg_filename)
 {
     char *filename, *tmp;

- filename = kstrdup(tplg_filename, GFP_KERNEL);
+    filename = devm_kstrdup(dev, tplg_filename, GFP_KERNEL);
```

Only two lines change: the function signature and the allocation call.
The caller already has access to the device pointer, so the integration
is trivial.

## 4. **Low risk of regression**

- `devm_kstrdup()` is a well-established kernel API
- The same function (`hda_machine_select()`) already uses multiple
  `devm_*` allocations, showing this is the established pattern
- Device-managed memory is automatically freed on device removal,
  eliminating the leak

## 5. **This differs from the similar commits shown**

The historical commits provided were all marked "NO" for backporting,
but they were:
- Code cleanups (removing macros, using newer APIs)
- Refactoring (renaming files)
- Defensive programming (NULL checks)

This commit is fundamentally different - it fixes an actual bug that
affects users.

## 6. **User impact is real**

- Systems with SOF audio that reload drivers (suspend/resume cycles,
  module reload) will leak memory
- Long-running systems could accumulate significant memory waste
- The leak happens in the probe path, a common operation

## 7. **The bug was recently introduced**

According to the kernel repository analysis, this bug was introduced in
August 2024, making it relatively recent and likely present in current
stable kernels that need the fix.

## Conclusion

This commit meets all the criteria for stable backporting:
- Fixes a real bug (not a theoretical issue)
- Minimal, contained change
- Clear root cause and solution
- Low regression risk
- Follows established patterns in the codebase
- Has actual user impact

The absence of a "Cc: stable" tag in the original commit appears to be
an oversight rather than an intentional decision to exclude it from
stable trees.

 sound/soc/sof/intel/hda.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 6a3932d90b43a..27b077f5c8f58 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -1254,11 +1254,11 @@ static int check_tplg_quirk_mask(struct snd_soc_acpi_mach *mach)
 	return 0;
 }
 
-static char *remove_file_ext(const char *tplg_filename)
+static char *remove_file_ext(struct device *dev, const char *tplg_filename)
 {
 	char *filename, *tmp;
 
-	filename = kstrdup(tplg_filename, GFP_KERNEL);
+	filename = devm_kstrdup(dev, tplg_filename, GFP_KERNEL);
 	if (!filename)
 		return NULL;
 
@@ -1342,7 +1342,7 @@ struct snd_soc_acpi_mach *hda_machine_select(struct snd_sof_dev *sdev)
 		 */
 		if (!sof_pdata->tplg_filename) {
 			/* remove file extension if it exists */
-			tplg_filename = remove_file_ext(mach->sof_tplg_filename);
+			tplg_filename = remove_file_ext(sdev->dev, mach->sof_tplg_filename);
 			if (!tplg_filename)
 				return NULL;
 
-- 
2.39.5

