Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A13229B18;
	Thu,  9 Oct 2025 15:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025561; cv=none; b=CzveZnwxemlPgHSXJPcubAp7VD2l7GKMQIjs0o8MKLoqK2TnwuHjXvV6JFEeZmvH8zu1yyWoWBZ6ylkRjG/uNiVdzCEISgt7q6uo1QWhpTsHpbybkDB2PzWRWbGPnRTLPVvpL6Dh5bC7gLooAt4xbdVpkJgoCOxF3m+WvTVFWKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025561; c=relaxed/simple;
	bh=PQIxaLpgLpFo0Awl76vdL8xdsvsx4lBd3yvYlHPbNHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OYGBRrQo1oXsoWnfbz4/Yl4njs/8B2GswDtT+tXZvMju6xZsAsLiZD5MXvtIkX4KxoJhzl6jCzkEte+C39ZDik9ZFnHyBBUyJEI5qz0iluqRZe0hjbYjDLfW1osajMwNTMCyfKfxzR/h7WrcspAyp/4gy6zL+RFLutPhUypPbbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p8agNBzN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p8agNBzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43AEC4CEE7;
	Thu,  9 Oct 2025 15:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025561;
	bh=PQIxaLpgLpFo0Awl76vdL8xdsvsx4lBd3yvYlHPbNHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8agNBzNpxyCtKPwrBtA1miDO/Sr8RpyYSDA05qRwFk90QhrhJ/ulqKJi+M7VYoU+
	 IMCH2mubtArOIBpRyM+OSupaThmLyjNpvO0/YqVBI9j0am1s8/GqY+XxlgQrwCyrUX
	 X2GRJg3ftDv2WIqTrURqloqj0sdOH2bCXgTyGOrI7x7i9ctifhiUKasgb/QGys/rVW
	 f03ZOOkBkzkPBuN04LCT0oWpVhzu/C4CICsPEP9BAex0aomfx0s9kVYtxIqXaRk7fT
	 46pTLOUY1cm8fNzNpC5hYxCf1bFIuLlik6t9YDeinQ80O5kz7N9S46wjPe/nsBH9mN
	 0j9OVzoy/ieBw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	jwyatt@redhat.com
Subject: [PATCH AUTOSEL 6.17-5.15] tools/cpupower: fix error return value in cpupower_write_sysfs()
Date: Thu,  9 Oct 2025 11:55:13 -0400
Message-ID: <20251009155752.773732-47-sashal@kernel.org>
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

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 57b100d4cf14276e0340eecb561005c07c129eb8 ]

The cpupower_write_sysfs() function currently returns -1 on
write failure, but the function signature indicates it should
return an unsigned int. Returning -1 from an unsigned function
results in a large positive value rather than indicating
an error condition.

Fix this by returning 0 on failure, which is more appropriate
for an unsigned return type and maintains consistency with typical
success/failure semantics where 0 indicates failure and non-zero
indicates success (bytes written).

Link: https://lore.kernel.org/r/20250828063000.803229-1-kaushlendra.kumar@intel.com
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

**What It Fixes**
- Corrects an unsigned return error path in `cpupower_write_sysfs()`:
  changes `return -1;` to `return 0;` inside the failure branch `if
  (numwritten < 1)` in `tools/power/cpupower/lib/cpupower.c:56-60`. This
  prevents `-1` from wrapping to a large unsigned value that looks like
  success.
- Aligns write semantics with read: `cpupower_read_sysfs()` already
  returns `0` on failure (`tools/power/cpupower/lib/cpupower.c:30-38`),
  and `cpupower_write_sysfs()` already returns `0` when `open()` fails
  (`tools/power/cpupower/lib/cpupower.c:51-53`).

**User-Visible Impact**
- Current callers interpret `<= 0` as failure. With the buggy `-1`
  (wrapped to large unsigned), failures are silently treated as success.
  Examples:
  - `tools/power/cpupower/utils/helpers/misc.c:83`
  - `tools/power/cpupower/utils/helpers/misc.c:102`
  - `tools/power/cpupower/utils/helpers/misc.c:120`
  - `tools/power/cpupower/utils/helpers/misc.c:289`
- After this fix, these checks correctly detect write failures
  (permission denied, invalid sysfs paths, etc.), improving reliability
  of cpupower operations like setting EPP, turbo boost, or perf bias.

**Scope and Risk**
- One-line change; no API/signature change; no architectural changes.
- Confined to `tools/` (cpupower userspace library). No kernel subsystem
  touched.
- Behavior change is limited to failure paths, converting a silent
  false-success into proper failure detection. Low regression risk and
  consistent with existing read/write patterns.

**Stable Criteria**
- Fixes a real bug affecting users of the cpupower tool (error paths not
  detected).
- Small, contained patch with minimal risk and no new features.
- Consistent semantics across the cpupower lib.
- Although the commit message does not include an explicit Cc: stable,
  the change clearly fits stable backport rules.

In summary, updating `return -1;` to `return 0;` in
`tools/power/cpupower/lib/cpupower.c:59` ensures callers’ `<= 0` checks
work as intended and aligns with existing cpupower I/O conventions. This
is a good candidate for backporting.

 tools/power/cpupower/lib/cpupower.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/cpupower/lib/cpupower.c b/tools/power/cpupower/lib/cpupower.c
index ce8dfb8e46abd..d7f7ec6f151c2 100644
--- a/tools/power/cpupower/lib/cpupower.c
+++ b/tools/power/cpupower/lib/cpupower.c
@@ -56,7 +56,7 @@ unsigned int cpupower_write_sysfs(const char *path, char *buf, size_t buflen)
 	if (numwritten < 1) {
 		perror(path);
 		close(fd);
-		return -1;
+		return 0;
 	}
 
 	close(fd);
-- 
2.51.0

