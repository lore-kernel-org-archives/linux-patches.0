Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1722749CF;
	Tue,  5 Aug 2025 13:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399488; cv=none; b=CU8lvK/BHjcveskmY+Wy08xeKoWRbJPW89bCGSsFuf/zN3G8QKyvifzv2+1uVzQCYtTT2HoM6XP1SGSz5UmEc4uu6TWPFEy2Va2+qAcfNE6+R90Ltrbvu1li8tsCtagjojRFapHsSVs/iHVobJwjUQaQUfstvyWvGIxz5pK/Cug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399488; c=relaxed/simple;
	bh=EfBkt+MghfOjvtpqGjuyCDnn+Jg2bBYSq+HLaw+7kzs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NziaOTdAmnya1z6AcjhFPd0D2OYK+5DICPit6pR3qeIcWv6f6KSts3NyfWwTSEM1dM/GPnfp/XMhtkuQ6ovPa3JcOM7+JRlqU1IhiAaG5JkZ3fAbSsvqYA8FmPMLpL72f+g26kWc5gB6xaIwqz0l4hvrB3ievpTGpcgfqWVhPTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8sP84fB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8sP84fB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7195C4CEF0;
	Tue,  5 Aug 2025 13:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399488;
	bh=EfBkt+MghfOjvtpqGjuyCDnn+Jg2bBYSq+HLaw+7kzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8sP84fB320gJuf1c6VArzeTvcP0G4lQXnvv/DeHp4ZZGN/ryJ5bLUWJzwFNA7aJv
	 wTWhVVv8SFNDbZFRp2hVtKJOMW9wG+XbMR8AKd/Daps8tcAneIDhLq48V7z0sJ7EBq
	 v5/DeLbkulo0bYRwyGkbWmFGh4X7sLcSKc2OIFK69shUuu9a8BhDeCYojsXrQag77N
	 kUhKv2jR3Cm1RbTDJS/g9q27EV3AdnJcfhq2qN1/M+GbahiOdwrJ/zU3OtEX+TRNy/
	 Wtk5FHFxUDKdI582eIKnDSgg1oGhR/ueApMwQS8ud+yWlidprNM28tCjpJtfuD9THg
	 SbshLwu/EqQgw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Akira Yokosawa <akiyks@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>,
	kees@kernel.org
Subject: [PATCH AUTOSEL 6.16-6.15] sphinx: kernel_abi: fix performance regression with O=<dir>
Date: Tue,  5 Aug 2025 09:09:21 -0400
Message-Id: <20250805130945.471732-46-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
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

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 2b16b71a05a7f056221751b906c13f8809656b1f ]

The logic there which adds a dependency note to Sphinx cache
is not taking into account that the build dir may not be
the source dir. This causes a performance regression:

$ time make O=/tmp/foo SPHINXDIRS=admin-guide htmldocs

	[OUTDATED]
	Added: set()
	Changed: {'abi-obsolete', 'abi-removed', 'abi-stable-files', 'abi-obsolete-files', 'abi-stable', 'abi', 'abi-removed-files', 'abi-testing-files', 'abi-testing', 'gpio/index', 'gpio/obsolete'}
	Removed: set()
	All docs count: 385
	Found docs count: 385

	real    0m11,324s
	user    0m15,783s
	sys     0m1,164s

To get the root cause of the problem (ABI files reported as changed),
I used this changeset:

	diff --git a/Documentation/conf.py b/Documentation/conf.py
	index e8766e689c1b..ab486623bd8b 100644
	--- a/Documentation/conf.py
	+++ b/Documentation/conf.py
	@@ -571,3 +571,16 @@ def setup(app):
	     """Patterns need to be updated at init time on older Sphinx versions"""

	     app.connect('config-inited', update_patterns)
	+    app.connect('env-get-outdated', on_outdated)
	+
	+def on_outdated(app, env, added, changed, removed):
	+    """Track cache outdated due to added/changed/removed files"""
	+    print("\n[OUTDATED]")
	+    print(f"Added: {added}")
	+    print(f"Changed: {changed}")
	+    print(f"Removed: {removed}")
	+    print(f"All docs count: {len(env.all_docs)}")
	+    print(f"Found docs count: {len(env.found_docs)}")
	+
	+    # Just return what we have
	+    return added | changed | removed

Reported-by: Akira Yokosawa <akiyks@gmail.com>
Closes: https://lore.kernel.org/linux-doc/c174f7c5-ec21-4eae-b1c3-f643cca90d9d@gmail.com/
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Tested-by: Akira Yokosawa <akiyks@gmail.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/e25673d87357457bc54ee863e97ff8f75956580d.1752752211.git.mchehab+huawei@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now, let me understand the actual bug better. The issue is that when
building with `O=<dir>`, the `f` variable contains a relative path from
the source tree, but when we use `os.path.abspath(f)`, it resolves
relative to the current working directory (which is the build
directory), not the source tree. This causes Sphinx to think files have
changed when they haven't.

**Backport Status: YES**

## Extensive Explanation:

This commit is a strong candidate for backporting to stable kernel trees
for the following reasons:

### 1. **Clear Bug Fix for Performance Regression**
The commit fixes a concrete performance regression in the documentation
build system when using out-of-tree builds (`O=<dir>`). The commit
message shows the issue causes unnecessary rebuilds with a ~11 second
penalty due to incorrectly tracking file dependencies.

### 2. **Small and Contained Change**
The code change is minimal and focused - only 4 lines are modified:
- Line 149-150 (old): `env.note_dependency(os.path.abspath(f))`
- Line 150-152 (new): Adds a proper path construction and file existence
  check

The fix correctly constructs the absolute path by joining `srctree` with
the relative path `f`, ensuring the dependency tracking works correctly
regardless of build directory location.

### 3. **Root Cause is Clear**
The bug occurs because `os.path.abspath(f)` resolves relative paths from
the current working directory (the build directory when using `O=`), not
from the source tree. This causes Sphinx to track non-existent or wrong
file paths as dependencies, leading to false positives in change
detection.

### 4. **No Architectural Changes**
This is a straightforward bugfix that:
- Doesn't introduce new features
- Doesn't change any APIs or interfaces
- Only fixes incorrect path resolution logic
- Adds a defensive file existence check

### 5. **Affects Common Use Case**
Out-of-tree builds with `O=<dir>` are a common workflow in kernel
development, especially for:
- CI/CD systems
- Clean builds
- Testing multiple configurations
- Keeping source trees pristine

### 6. **Low Risk of Regression**
The change:
- Only affects documentation builds
- Adds a safety check (`os.path.isfile()`) that prevents tracking non-
  existent files
- The logic is more correct than before (properly resolving paths
  relative to source tree)
- Has been tested by the reporter (Akira Yokosawa)

### 7. **Meets Stable Criteria**
According to stable kernel rules, this fix:
- Fixes a real bug that users hit (performance regression in
  documentation builds)
- Is obviously correct and tested
- Is small (under 100 lines)
- Fixes only one thing
- Has no dependencies on other changes

The commit directly addresses a performance issue that affects kernel
documentation builds, making it slower and less efficient when using
out-of-tree builds. This is the type of bug fix that stable kernels
should receive to maintain quality and performance for users who build
documentation.

 Documentation/sphinx/kernel_abi.py | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/sphinx/kernel_abi.py b/Documentation/sphinx/kernel_abi.py
index db6f0380de94..4c4375201b9e 100644
--- a/Documentation/sphinx/kernel_abi.py
+++ b/Documentation/sphinx/kernel_abi.py
@@ -146,8 +146,10 @@ class KernelCmd(Directive):
                 n += 1
 
             if f != old_f:
-                # Add the file to Sphinx build dependencies
-                env.note_dependency(os.path.abspath(f))
+                # Add the file to Sphinx build dependencies if the file exists
+                fname = os.path.join(srctree, f)
+                if os.path.isfile(fname):
+                    env.note_dependency(fname)
 
                 old_f = f
 
-- 
2.39.5

