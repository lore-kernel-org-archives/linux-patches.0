Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7447A145329;
	Fri,  8 Aug 2025 15:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754667064; cv=none; b=Iib6JFZHgDjf8gFVtOk7fj/KT+RwXXry9M3SN0l6hRwBIB7EBV0i2JtRhmiHDbT+l9AF2X9zfVDNZjI3ePSre2oTi0AsBYiiuR2kG613go3ejK1qBwLDIgIgtLeSpHAThRMCsulMVkqJc5N/s5ijomxgSypNd3byAYtG61NeKm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754667064; c=relaxed/simple;
	bh=ST4oh74nXSw2f0tanvoma6I/+x9/jUIiZOYhL7iEFTM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cXqiDBsCDAdb7nuO3jdYVnbeYJP8aqd8Zr6R83gmg0NcODWw771hPnpPOH513I3Pk/2SsU5H/yqsMgLqxSqWeTgbaPx2NJyPaq6f74O7Wf3SuBlU7naqBc/h0CiBL6U6yvVxGlzYF7++68c/BGsXwayHvp0Rl1KLzU+QTqubpik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jc2ubues; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jc2ubues"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC35C4CEED;
	Fri,  8 Aug 2025 15:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754667064;
	bh=ST4oh74nXSw2f0tanvoma6I/+x9/jUIiZOYhL7iEFTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jc2ubuesfByhEv5TceChFPJpOeMvEh5a/vvP1Hks4g/4i7FkXXcI+x/szCf0/D21R
	 z5M1pB5uofUj1vo4ELMwPYt3rEf9nnOtEOSEUnaBedtDx6DnApp3D3faSN5Ih2iYVv
	 apClDgmAlBgNo2Pva8Aoz5zOrrvhDKoeOCvp7RyueP78DpM0oqsLGvzq+tRXGKk33H
	 n2ZBaT+I66mobVpxWh2yO69hjyNtkKvEUPYD2g78efgYVCvAsQt29+jD9BhKGBTYSE
	 UgLeb41gVIDq1Rsk1kw2pBIWrZLK8UoHBG1kIYiNrPJYlLzNyXX3nn3N6v3pGb0Yei
	 p4ZSKAWaN3+Uw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.16-5.10] dm-mpath: don't print the "loaded" message if registering fails
Date: Fri,  8 Aug 2025 11:30:44 -0400
Message-Id: <20250808153054.1250675-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250808153054.1250675-1-sashal@kernel.org>
References: <20250808153054.1250675-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 6e11952a6abc4641dc8ae63f01b318b31b44e8db ]

If dm_register_path_selector, don't print the "version X loaded" message.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit is a clear candidate for backporting to stable kernel trees.
Here's my extensive analysis:

## Bug Analysis

The commit fixes a logic error in the error handling of four device-
mapper path selector modules. Looking at the code changes:

1. **Original buggy behavior**: When `dm_register_path_selector()` fails
   (returns r < 0), the code would:
   - Print "register failed" error message
   - **Continue to print "version X loaded" message**
   - Return the error code

2. **Fixed behavior**: When registration fails:
   - Print "register failed" error message
   - **Return immediately with the error code**
   - Skip the misleading "loaded" message

## Why This Should Be Backported

1. **Clear Bug Fix**: This is a straightforward bug fix that corrects
   misleading log messages. When module registration fails, it
   incorrectly reports success with "version X loaded".

2. **Small and Contained**: The fix is minimal - just adding an early
   return statement in four similar init functions:
   - `dm_hst_init()` in dm-ps-historical-service-time.c
   - `dm_ql_init()` in dm-ps-queue-length.c
   - `dm_rr_init()` in dm-ps-round-robin.c
   - `dm_st_init()` in dm-ps-service-time.c

3. **No Side Effects**: The change only affects error path behavior and
   logging. It doesn't introduce new functionality or change any
   successful operation paths.

4. **User-Visible Issue**: This fixes a user-visible problem where
   system logs would incorrectly indicate a module loaded successfully
   when it actually failed.

5. **Consistent Pattern**: All four files have the identical bug and
   identical fix, showing this is a systematic issue that should be
   addressed.

6. **Low Risk**: The change is trivial - adding an early return on
   error. There's virtually no risk of regression since:
   - It only changes behavior when registration already failed
   - The function already returns the error code at the end
   - This just makes it return earlier without printing the misleading
     message

7. **Affects Core Subsystem**: Device-mapper is a critical storage
   subsystem, and accurate error reporting is important for system
   administrators debugging storage issues.

The commit perfectly fits stable kernel criteria: it's a small, obvious
fix for a real bug that affects users (through misleading log messages),
with minimal risk of introducing new problems.

 drivers/md/dm-ps-historical-service-time.c | 4 +++-
 drivers/md/dm-ps-queue-length.c            | 4 +++-
 drivers/md/dm-ps-round-robin.c             | 4 +++-
 drivers/md/dm-ps-service-time.c            | 4 +++-
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-ps-historical-service-time.c b/drivers/md/dm-ps-historical-service-time.c
index b49e10d76d03..2c8626a83de4 100644
--- a/drivers/md/dm-ps-historical-service-time.c
+++ b/drivers/md/dm-ps-historical-service-time.c
@@ -541,8 +541,10 @@ static int __init dm_hst_init(void)
 {
 	int r = dm_register_path_selector(&hst_ps);
 
-	if (r < 0)
+	if (r < 0) {
 		DMERR("register failed %d", r);
+		return r;
+	}
 
 	DMINFO("version " HST_VERSION " loaded");
 
diff --git a/drivers/md/dm-ps-queue-length.c b/drivers/md/dm-ps-queue-length.c
index e305f05ad1e5..eb543e6431e0 100644
--- a/drivers/md/dm-ps-queue-length.c
+++ b/drivers/md/dm-ps-queue-length.c
@@ -260,8 +260,10 @@ static int __init dm_ql_init(void)
 {
 	int r = dm_register_path_selector(&ql_ps);
 
-	if (r < 0)
+	if (r < 0) {
 		DMERR("register failed %d", r);
+		return r;
+	}
 
 	DMINFO("version " QL_VERSION " loaded");
 
diff --git a/drivers/md/dm-ps-round-robin.c b/drivers/md/dm-ps-round-robin.c
index d1745b123dc1..66a15ac0c22c 100644
--- a/drivers/md/dm-ps-round-robin.c
+++ b/drivers/md/dm-ps-round-robin.c
@@ -220,8 +220,10 @@ static int __init dm_rr_init(void)
 {
 	int r = dm_register_path_selector(&rr_ps);
 
-	if (r < 0)
+	if (r < 0) {
 		DMERR("register failed %d", r);
+		return r;
+	}
 
 	DMINFO("version " RR_VERSION " loaded");
 
diff --git a/drivers/md/dm-ps-service-time.c b/drivers/md/dm-ps-service-time.c
index 969d31c40272..f8c43aecdb27 100644
--- a/drivers/md/dm-ps-service-time.c
+++ b/drivers/md/dm-ps-service-time.c
@@ -341,8 +341,10 @@ static int __init dm_st_init(void)
 {
 	int r = dm_register_path_selector(&st_ps);
 
-	if (r < 0)
+	if (r < 0) {
 		DMERR("register failed %d", r);
+		return r;
+	}
 
 	DMINFO("version " ST_VERSION " loaded");
 
-- 
2.39.5

