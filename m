Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A541D5147;
	Mon, 25 Aug 2025 12:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756124122; cv=none; b=rVVcYYtKggG76/9EyiOfUHsZfy8oTwx+ZocJz3f1zvgdbLgSL0NPLMwADu3r6g7EbmIbflCjV8z7Gx1fdmcW6hBJKvEiGu8WuelxMYZljs0wnvkiIk69OTRARAhi7jPzZ6f4VPlqNDII69FKAZwPlZOPic6UolTjD6n53/cSmno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756124122; c=relaxed/simple;
	bh=oZ/HWGHWtR3AoWCQHYHY/dVpb+dhCodbBBNpfhT2rGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvShQiahXX6csxCYdqwMFg6m7LRebh9cS9xBeI5c+/yikVuR5CINMzL5T+ezlRHz/6rw6t4qOavGCt55NvDmc3rkipzShlRtyVqm4zBzgz0DMNpmHKUaxdsbODbPCvOiSrCIg8Aej9L5EpanRohhgr7h4D44yIxw39nHMx6n+4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rFSpwygL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rFSpwygL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58654C116C6;
	Mon, 25 Aug 2025 12:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756124121;
	bh=oZ/HWGHWtR3AoWCQHYHY/dVpb+dhCodbBBNpfhT2rGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFSpwygLSHOXEfX+DuV1w7Xc84AgXzhUOsTlCYN8OPEg+U7Fv3ndKZDxw1DEpbnhS
	 c61j9PV7cbuYnN/cm3DpcozZ0h3EK/qHT79GRrVv7QvDyiKyBN1xY5Y8PfPsUwrJt7
	 eGXK0Hsw0hQrHoVssGkiwQzQA6CjuMSOM7ANoPR8UeVWEXKklF3EHW1Hh7SvH+akHW
	 ATiimshxv5Tc/CMBIPkP+DY+JpRYBuNds9rjZ6u1pIvjJkk+EvWD4pzh5iFP8GM/gC
	 Y0+TFhpmiSFmGQlQ3E9MYIfJtxM2My1rGnT5dv6OxF9EO/I/oMc/0UHTrMO8+s2jpH
	 Nx1KAL/BZuRqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shinji Nomoto <fj5851bi@fujitsu.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.16-6.6] cpupower: Fix a bug where the -t option of the set subcommand was not working.
Date: Mon, 25 Aug 2025 08:14:59 -0400
Message-ID: <20250825121505.2983941-10-sashal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250825121505.2983941-1-sashal@kernel.org>
References: <20250825121505.2983941-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16.3
Content-Transfer-Encoding: 8bit

From: Shinji Nomoto <fj5851bi@fujitsu.com>

[ Upstream commit b3eaf14f4c63fd6abc7b68c6d7a07c5680a6d8e5 ]

The set subcommand's -t option is documented as being available for boost
configuration, but it was not actually functioning due to a bug
in the option handling.

Link: https://lore.kernel.org/r/20250522061122.2149188-2-fj5851bi@fujitsu.com
Signed-off-by: Shinji Nomoto <fj5851bi@fujitsu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit is a clear bug fix that should be backported to stable
kernel trees. Here's my detailed analysis:

## Bug Analysis

The commit fixes a critical bug where the `-t` option for the `cpupower
set` subcommand was documented and accepted as a valid option (defined
in `set_opts[]` structure), but was completely non-functional due to a
missing character in the `getopt_long()` call.

### Specific Code Changes

The bug is in line 58-59 of the original code:
```c
while ((ret = getopt_long(argc, argv, "b:e:m:",
                          set_opts, NULL)) != -1) {
```

The fix adds the missing `t:` to the argument string:
```c
while ((ret = getopt_long(argc, argv, "b:e:m:t:",
                          set_opts, NULL)) != -1) {
```

### Root Cause

When the turbo-boost feature was added in commit `eb426fc6bdd6` (merged
in v6.6-rc1), the developer:
1. Added the option to the `set_opts[]` array correctly
2. Added the case handler for 't' in the switch statement
3. **BUT forgot to add "t:" to the getopt_long argument string**

This means that while the option was defined and had handling code,
`getopt_long()` would never recognize `-t` as a valid option, making the
feature completely unusable.

## Why This Should Be Backported

1. **Clear Bug Fix**: This is an obvious bug where documented
   functionality doesn't work at all. Users trying to use `cpupower set
   -t` or `--turbo-boost` would get errors.

2. **Small and Contained**: The fix is a single-line change adding 2
   characters ("t:") to a string. This is as minimal as fixes get.

3. **No Side Effects**: The change only enables already-implemented
   functionality. It doesn't introduce new code paths or change existing
   behavior.

4. **User Impact**: The turbo-boost control feature is important for
   power management, and users on stable kernels with v6.6+ would expect
   this documented feature to work.

5. **Affects Stable Versions**: The bug was introduced in v6.6-rc1 and
   affects all kernels from v6.6 onwards that include the turbo-boost
   feature.

6. **Low Risk**: There's virtually no regression risk - the worst case
   is the option continues not working, which is the current state.

This is exactly the type of fix that stable kernel rules recommend: a
clear bug fix that restores documented functionality with minimal code
change and no architectural modifications.

 tools/power/cpupower/utils/cpupower-set.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/power/cpupower/utils/cpupower-set.c b/tools/power/cpupower/utils/cpupower-set.c
index 0677b58374ab..59ace394cf3e 100644
--- a/tools/power/cpupower/utils/cpupower-set.c
+++ b/tools/power/cpupower/utils/cpupower-set.c
@@ -62,8 +62,8 @@ int cmd_set(int argc, char **argv)
 
 	params.params = 0;
 	/* parameter parsing */
-	while ((ret = getopt_long(argc, argv, "b:e:m:",
-						set_opts, NULL)) != -1) {
+	while ((ret = getopt_long(argc, argv, "b:e:m:t:",
+				  set_opts, NULL)) != -1) {
 		switch (ret) {
 		case 'b':
 			if (params.perf_bias)
-- 
2.50.1

