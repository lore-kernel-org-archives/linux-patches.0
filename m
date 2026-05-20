Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7838F3EE1EC;
	Wed, 20 May 2026 11:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276035; cv=none; b=PkUQzZd90aLZKzmCi1L2KAhGT4f5P7j3VlFzbQusgSZ9q8A4vmI9iBEN6T0onsg8RrfSBjwN0JO1LXfxaLv45QJ2KuIrUQQLAKJjC7PreFTZYSbHfm5JPPRJ4Gw6bRviWn7BBpB/MMKZ8irUKI9TNacYyFJJjZzKsxce59A7BOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276035; c=relaxed/simple;
	bh=aHOj9Nlf2N+XoJD52ZtRFWgr+BO8IfzdwXTBS2M1Rn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jOenSkk2JxyTVJTSr3moDjsglYowvLXqFJ/hQZQPWNErEdKqlx3n7elekctBcN3MkkqcxPw63h1hW8wHO/IsQ5MUEROwZpAGC9WcMmcuzBgQ6njDNA7Yg5fgMoJuQC2UEJ4TmAc5A8r59HUHUQlrek2wK9xZJabQbyEDww67Gvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MyE9j4ju; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MyE9j4ju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670431F000E9;
	Wed, 20 May 2026 11:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276033;
	bh=SWbezCywpdNUVFp25XhJr2eKjtkK+ElxPwKt99tOrEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MyE9j4ju5eyZtifIMhw5WVNT1B4x2Z4jq0+5dyzpyKlUUWAU+9drGrZisvRKEnWYd
	 KOQ2/w2Z/2SVhvjv8CyqWAkLdQZcP1DgFJg4u/liZgqaJsN8S7Ofa6+JggR+xSnHW+
	 qVsWb0qq73sP4XW3E5KPlXG6pF4VHYSLaREahss5bbWUts7H0OQtHH90T3fQNfWqY3
	 VAKWrcMvrXxDaYI4I87JM2E7kyf0zJp/pHOv+cdwPBNwxE2cPt8dvmPLKvRvUwcyWh
	 sEWcNgWlwVk84dmR7y9OejVcKLeRNviNEzcLR6wl7FU7eGfKrqy1UHRubZjBVUc2ff
	 edFptGdznhgYg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Myeonghun Pak <mhun512@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] HID: google: hammer: stop hardware on devres action failure
Date: Wed, 20 May 2026 07:19:06 -0400
Message-ID: <20260520111944.3424570-34-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit b08665fe80fab0956e64741c07d9bbcec635c34d ]

hammer_probe() starts the HID hardware before registering the devres
action that stops it. If devm_add_action() fails, probe returns an
error with the hardware still started because the cleanup action was
never registered and the driver's remove callback is not called after a
failed probe.

Use devm_add_action_or_reset() so the stop action runs immediately on
registration failure while preserving the existing devres-managed cleanup
path for later probe failures and remove.

Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough

### Phase 1: Commit Message Forensics
- Step 1.1 Record: subsystem `HID: google: hammer`; action verb `stop`;
  intent is to stop HID hardware if devres action registration fails.
- Step 1.2 Record: tags in committed
  `b08665fe80fab0956e64741c07d9bbcec635c34d`: `Signed-off-by: Myeonghun
  Pak <mhun512@gmail.com>` and `Signed-off-by: Jiri Kosina
  <jkosina@suse.com>`. No `Fixes:`, `Reported-by:`, `Tested-by:`,
  `Reviewed-by:`, `Acked-by:`, `Link:`, or `Cc: stable`.
- Step 1.3 Record: bug is an error-path cleanup failure.
  `hammer_probe()` calls `hid_hw_start()` before registering
  `hammer_stop` with devres; if `devm_add_action()` returns `-ENOMEM`,
  probe fails and no registered cleanup action calls `hid_hw_stop()`.
- Step 1.4 Record: yes, this is a hidden bug fix: a one-line
  devres/error-path cleanup fix preventing started HID hardware from
  being left active after failed probe.

### Phase 2: Diff Analysis
- Step 2.1 Record: one file, `drivers/hid/hid-google-hammer.c`; 1
  insertion, 1 deletion; modified function `hammer_probe()`; single-file
  surgical fix.
- Step 2.2 Record: before, failure of `devm_add_action()` returned
  directly after `hid_hw_start()` succeeded. After,
  `devm_add_action_or_reset()` runs `hammer_stop(hdev)` immediately if
  action registration fails.
- Step 2.3 Record: bug category is error-path resource cleanup. The
  broken state is missing `hid_hw_stop()` after successful
  `hid_hw_start()` when devres action allocation fails.
- Step 2.4 Record: fix quality is high: it uses the kernel helper whose
  inline definition calls the action on registration failure. No
  unrelated changes, no public API change, and no normal-path behavior
  change when registration succeeds.

### Phase 3: Git History Investigation
- Step 3.1 Record: blame shows `devm_add_action(&hdev->dev, hammer_stop,
  hdev)` came from `d950db3f80a801` (`HID: google: switch to devm when
  registering keyboard backlight LED`), first contained by `v5.18-rc1`.
- Step 3.2 Record: no `Fixes:` tag. I followed the blamed introducing
  commit instead; `d950db3f80a801` added `hammer_stop()` and moved stop
  cleanup into devres.
- Step 3.3 Record: recent file history shows related Google HID
  cleanup/device-ID/vivaldi work, but no intermediate fix for this exact
  missed cleanup.
- Step 3.4 Record: candidate author has only this HID commit in
  `origin/master` in the checked history. Jiri Kosina is listed in
  `MAINTAINERS` for HID core and applied/signed the commit.
- Step 3.5 Record: no dependency found. The replacement helper exists in
  affected stable branches checked.

### Phase 4: Mailing List And External Research
- Step 4.1 Record: `b4 dig -c b08665fe80fab` found the original patch at
  `https://patch.msgid.link/20260424125043.52639-1-
  pakmyeonghun@bagmyeonghun-ui-MacBookPro.local`. `b4 dig -a` found only
  v1.
- Step 4.2 Record: `b4 dig -w` showed the original recipients were
  Myeonghun Pak, Jiri Kosina, Benjamin Tissoires, `linux-
  input@vger.kernel.org`, and `linux-kernel@vger.kernel.org`.
- Step 4.3 Record: no separate bug report or `Reported-by` tag was
  present.
- Step 4.4 Record: thread had 3 messages; Jiri replied, “Makes sense,
  thanks for catching it. Applied.” No NAKs or objections found in the
  fetched mbox.
- Step 4.5 Record: direct lore stable web search was blocked by Anubis;
  local stable branch log search did not find this commit already
  present.

### Phase 5: Code Semantic Analysis
- Step 5.1 Record: modified function is `hammer_probe()`.
- Step 5.2 Record: `hammer_probe()` is registered as `.probe` in
  `hammer_driver`; HID core reaches it via `hid_device_probe()` ->
  `__hid_device_probe()` -> `hdrv->probe(hdev, id)`.
- Step 5.3 Record: key callees are `hid_parse()`, `hid_hw_start()`,
  `devm_add_action_or_reset()`, `hid_hw_open()`, and
  `hammer_register_leds()`. `hid_hw_start()` documentation says
  `hid_hw_stop()` must be called after success.
- Step 5.4 Record: path is reachable during HID device probe for Google
  Hammer-family USB IDs in the driver table. Trigger for the bug is
  allocation failure inside `devm_add_action()` after hardware start.
- Step 5.5 Record: no other `hammer_stop` pattern found. Nearby HID
  drivers commonly call `hid_hw_stop()` on probe-error paths, supporting
  that this cleanup is expected.

### Phase 6: Stable Tree Analysis
- Step 6.1 Record: buggy code exists in `stable/linux-6.1.y`, `6.6.y`,
  `6.12.y`, `6.15.y`, `6.16.y`, `6.17.y`, `6.18.y`, and `6.19.y`; not in
  `stable/linux-5.15.y`.
- Step 6.2 Record: patch applied cleanly with `git apply --check` on
  temporary worktrees for `6.1.y`, `6.6.y`, `6.12.y`, and `6.19.y`.
- Step 6.3 Record: no related stable fix with the same subject was found
  in checked stable branch logs.

### Phase 7: Subsystem Context
- Step 7.1 Record: subsystem is HID driver code, specifically Google
  Hammer HID devices; criticality is driver-specific/peripheral.
- Step 7.2 Record: HID is actively maintained; recent `drivers/hid`
  history includes multiple fixes and quirks, and the candidate was
  merged through the HID tree.

### Phase 8: Impact And Risk
- Step 8.1 Record: affected users are users of Google Hammer-family HID
  hardware on stable kernels containing `d950db3f80a801`.
- Step 8.2 Record: trigger is uncommon but real: memory/devres
  allocation failure during device probe after `hid_hw_start()`
  succeeds. I did not verify unprivileged syscall reachability.
- Step 8.3 Record: failure mode is leaked/active HID hardware state
  after failed probe, not a verified crash or data corruption. Severity
  is medium, with higher concern under memory pressure because cleanup
  is explicitly required by HID core semantics.
- Step 8.4 Record: benefit is moderate for affected hardware and error
  recovery correctness; risk is very low because the successful path is
  unchanged and the failure path calls the already intended cleanup
  function.

### Phase 9: Final Synthesis
- Step 9.1 Record: evidence for backporting: real cleanup bug, affected
  maintained stable trees, one-line obviously correct fix, uses existing
  helper, applies cleanly, maintainer accepted it. Evidence against: no
  reported user crash, rare trigger, driver-specific impact. Unresolved:
  no runtime test report or concrete field failure report found.
- Step 9.2 Record: stable rules: obviously correct yes; fixes real bug
  yes; important enough as resource/hardware-state leak on failed probe
  yes, though not crash-class; small and contained yes; no new
  feature/API yes; applies to stable yes for checked branches.
- Step 9.3 Record: no automatic exception category; this is not a device
  ID, quirk, DT, build, or documentation patch.
- Step 9.4 Record: risk-benefit favors backporting because the fix is a
  minimal correction to a verified cleanup bug in stable-present code.

## Verification
- Phase 1: inspected `git show --stat --no-ext-diff b08665fe80fab`;
  confirmed subject, body, tags, and 1-line diff.
- Phase 2: inspected full candidate diff; confirmed only
  `devm_add_action()` -> `devm_add_action_or_reset()` in
  `hammer_probe()`.
- Phase 3: ran blame on changed area; confirmed introducing commit
  `d950db3f80a801`, first contained by `v5.18-rc1`.
- Phase 3: inspected `d950db3f80a801`; confirmed it added devres-managed
  `hammer_stop()`.
- Phase 4: ran `b4 dig -c`, `-a`, and `-w`; confirmed original patch
  URL, v1 only, maintainers/lists included.
- Phase 4: fetched full thread with `b4 mbox`; confirmed Jiri Kosina
  replied that the patch made sense and was applied.
- Phase 5: read HID core and devres code; confirmed `hid_hw_start()`
  requires `hid_hw_stop()`, and `devm_add_action_or_reset()` invokes the
  action on failure.
- Phase 6: checked stable branches with `git grep`; confirmed buggy line
  in `6.1.y` through `6.19.y`, not `5.15.y`.
- Phase 6: ran `git apply --check` in temporary worktrees for `6.1.y`,
  `6.6.y`, `6.12.y`, and `6.19.y`; all passed.
- UNVERIFIED: no separate user bug report, crash report, or runtime test
  result was found.

**YES**

 drivers/hid/hid-google-hammer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-google-hammer.c b/drivers/hid/hid-google-hammer.c
index 1af477e58480b..c99c3c0d442e1 100644
--- a/drivers/hid/hid-google-hammer.c
+++ b/drivers/hid/hid-google-hammer.c
@@ -496,7 +496,7 @@ static int hammer_probe(struct hid_device *hdev,
 	if (error)
 		return error;
 
-	error = devm_add_action(&hdev->dev, hammer_stop, hdev);
+	error = devm_add_action_or_reset(&hdev->dev, hammer_stop, hdev);
 	if (error)
 		return error;
 
-- 
2.53.0

