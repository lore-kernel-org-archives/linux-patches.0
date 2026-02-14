Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E3B27510B;
	Sat, 14 Feb 2026 21:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104452; cv=none; b=eMj949aeKnl4Md2s5TglTk/LumDElRP3hk8LgYGaRLUo+atGQ203nBQHPzHdAmZCk7XcyvoXufsLvdQ2clOqBWR/RHPBdAgvo9s0jxJpTC1LjKp22XF3ZAq8afaL8hfEV+Ups/A6s8Z8whvV3HNDCNOk1esK89UXyIxAMXvO0uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104452; c=relaxed/simple;
	bh=ACxywjYmrjn8CZAVfqow64A/BOwi0uBOOFpXlYvOvLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RBmr6Ha2sBJ/a5cneiKNm3Qo+9PyU9/4hmYNpSJ7wYX/6b0UsFJp9jyrqQ3Uez8E0zWwzasFapzbxL846ZAULLsv7+4Q5IAFM/uNc4+yZYCzKWOD7Emz3v0P+nzaboUyXzC0mY/UEt8T/5envrAcC7wod3dHiWfxf0rWSysRko8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fGCeI9yf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fGCeI9yf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AD8C19423;
	Sat, 14 Feb 2026 21:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104451;
	bh=ACxywjYmrjn8CZAVfqow64A/BOwi0uBOOFpXlYvOvLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGCeI9yfxixC7PccSGMtaFX1IZvc/jHqXr/hrpPe3PxqkmCfhI6AhGfSEvsGMRVUV
	 wC064PygT2H+VIAgAfm6RToxbhdTMf5E92VVZsqx2jnG+9wK12uu266GtV+KJ9XCWv
	 NLtYGlA3ZmKvtUgEoZPdDP2dxYR4VVNawXvcPD4Ct2LqS9ewVpgu9hCLk9ZCt2hZ5k
	 9AZsCoe6bK5Gn7/VcFoL0XzH6PzZLagfL83qMAllHxNBRB9ZQQZ47YKvulo9svip4X
	 rHrFtaOVi0pW+CnGEpV0xg/l3zmD5ogLpZnc3MjwctdJSzAiGAHcOPiJRQMFQfoxvb
	 UQ52euAqVvy6g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wander Lairson Costa <wander@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	rostedt@goodmis.org,
	neil.armstrong@linaro.org,
	crwood@redhat.com,
	ipravdin.official@gmail.com,
	yelangyan@huaqin.corp-partner.google.com
Subject: [PATCH AUTOSEL 6.19-6.18] rtla: Fix NULL pointer dereference in actions_parse
Date: Sat, 14 Feb 2026 16:23:57 -0500
Message-ID: <20260214212452.782265-92-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wander Lairson Costa <wander@redhat.com>

[ Upstream commit a0890f9dbd24b302d327fe7dad9b9c5be0e278aa ]

The actions_parse() function uses strtok() to tokenize the trigger
string, but does not check if the returned token is NULL before
passing it to strcmp(). If the trigger parameter is an empty string
or contains only delimiter characters, strtok() returns NULL, causing
strcmp() to dereference a NULL pointer and crash the program.

This issue can be triggered by malformed user input or edge cases in
trigger string parsing. Add a NULL check immediately after the strtok()
call to validate that a token was successfully extracted before using
it. If no token is found, the function now returns -1 to indicate a
parsing error.

Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Link: https://lore.kernel.org/r/20260106133655.249887-13-wander@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of rtla NULL Pointer Dereference Fix

### Commit Message Analysis

The commit message is clear and explicit: it fixes a **NULL pointer
dereference** in `actions_parse()`. The bug mechanism is well-explained:
- `strtok()` can return NULL when given an empty string or a string
  containing only delimiters
- The returned value is passed directly to `strcmp()` without a NULL
  check
- This causes a crash (NULL pointer dereference)

The commit is from a Red Hat engineer, reviewed and applied by another
Red Hat engineer, and posted to the kernel mailing list with a proper
Link tag.

### Code Change Analysis

The fix is extremely small and surgical: **2 lines added**.

```c
token = strtok(trigger_c, ",");
+       if (!token)
+               return -1;

if (strcmp(token, "trace") == 0)
```

This is a textbook NULL check before dereference. The function already
returns `-1` for invalid trigger types, so this is consistent with
existing error handling patterns. The change:

1. Adds a NULL check after `strtok()` returns
2. Returns `-1` (error) if no token was found
3. Prevents the subsequent `strcmp(token, ...)` calls from crashing

### Bug Classification

- **Type**: NULL pointer dereference (crash/segfault)
- **Trigger**: Malformed user input (empty string or delimiter-only
  string passed as trigger)
- **Severity**: Program crash - rtla is a userspace tool, so this is a
  userspace crash, not a kernel crash
- **Scope**: Affects the `rtla` tracing tool (a userspace utility in
  `tools/tracing/rtla/`)

### Important Context: This is a Userspace Tool

The file is in `tools/tracing/rtla/` — this is **rtla** (Real-Time Linux
Analysis), a userspace tool shipped with the kernel source tree. It's
not kernel code per se, but a userspace utility that ships alongside the
kernel.

### Stable Kernel Criteria Assessment

1. **Obviously correct and tested**: Yes — a simple NULL check before
   dereference. The fix is trivially correct.
2. **Fixes a real bug**: Yes — NULL pointer dereference causing a crash
   on malformed input.
3. **Important issue**: Moderate — it's a crash in a userspace tool, not
   a kernel crash. However, it can be triggered by user input, which
   makes it a robustness issue.
4. **Small and contained**: Yes — 2 lines, 1 file, purely additive
   safety check.
5. **No new features**: Correct — this is purely a bug fix.
6. **Applies cleanly**: Should apply cleanly as it's a minimal change.

### Risk Assessment

- **Risk**: Essentially zero. Adding a NULL check and returning an error
  code cannot introduce a regression. The function already handles the
  `-1` return for other invalid inputs.
- **Benefit**: Prevents a crash when rtla receives malformed trigger
  input.

### Considerations

- This is a **userspace tool** fix, not a kernel fix. The stable kernel
  rules primarily target kernel code, but tools shipped with the kernel
  tree do get backported regularly.
- The fix is so small and obviously correct that there's virtually no
  risk.
- The `rtla` tool is used by real-time Linux users who rely on it for
  system analysis — a crash on malformed input is a real usability
  issue.

### Verdict

This is a straightforward NULL pointer dereference fix in a userspace
tool. It's small (2 lines), obviously correct, fixes a real crash
triggered by user input, and has zero regression risk. While it's a
userspace tool rather than kernel code, such fixes are commonly
backported to stable trees. The fix meets all stable kernel criteria.

**YES**

 tools/tracing/rtla/src/actions.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/tracing/rtla/src/actions.c b/tools/tracing/rtla/src/actions.c
index 8945aee58d511..15986505b4376 100644
--- a/tools/tracing/rtla/src/actions.c
+++ b/tools/tracing/rtla/src/actions.c
@@ -141,6 +141,8 @@ actions_parse(struct actions *self, const char *trigger, const char *tracefn)
 
 	strcpy(trigger_c, trigger);
 	token = strtok(trigger_c, ",");
+	if (!token)
+		return -1;
 
 	if (strcmp(token, "trace") == 0)
 		type = ACTION_TRACE_OUTPUT;
-- 
2.51.0

