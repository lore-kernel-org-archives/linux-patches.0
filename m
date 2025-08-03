Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF011F55FA;
	Sun,  3 Aug 2025 21:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754256086; cv=none; b=A+AL3oMspLluFn/rpx5Sj9lWiK8a5tm9wQ5bIa757npMQd/s+VxvncDvImEEZrk6Cfk4jl/WN5acB6h06dEVS8se4WvIWXTHhLrX32uHgPtkG/mwvRWNxLins8WPj4avJVfrnWd82imrwkwF9rnpNRzFPRaqr6oqof41wMH+VfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754256086; c=relaxed/simple;
	bh=X4eWb+l/9AGMdIOeSxGFNMFpIMN2bfYyPiB8HJXzFpg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DySkGr4YdBTMwguTCJBxu2SCKp4Zq4zXud0TBa9kICMc8tHWWULY4qZDe2oCxWNtIgmrvtpIpVK+dKn31WwAGWrZnkrOMTMIhiYLjh71Lcr59isoI2YhZDqK7AW/hBxyHJ2b9gSkg4LfB5HnusNAQa/VgMYsjqOyO3ESqPz3Ors=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GorLFdaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GorLFdaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46949C4CEF0;
	Sun,  3 Aug 2025 21:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754256085;
	bh=X4eWb+l/9AGMdIOeSxGFNMFpIMN2bfYyPiB8HJXzFpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GorLFdaDmgjacEYwGdg+G7zl7GrZSbklQSP+qYUOE9T5W6WolCRqIuR+DY6nuVtF5
	 oMU3bzzk2VtP3oQt0JN/sOa++sgxEQ8F25cunACV1wWoWknK+rd+LBUMhuU9U8go02
	 ow4J5sqORG/MeuLszl/owb+QdGry8n4DTaL7lmiCyKQIW8F3ScfFrSV3cSOHIB1/tQ
	 EpRhNHYQWT65d4BU++DmH0hqm8fZzHt/jAv+pV0aabPMfmSoqJNZwToLRzP3lpK3eF
	 xPQOV6t5mb9vPlM4wb8rUtaiKCshWmqJfUqpoi2gioMUZAD0esH2x2xGkYG8VIvHqD
	 N0VV79f5+z6qQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>,
	mhiramat@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 23/23] tracefs: Add d_delete to remove negative dentries
Date: Sun,  3 Aug 2025 17:20:30 -0400
Message-Id: <20250803212031.3547641-23-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803212031.3547641-1-sashal@kernel.org>
References: <20250803212031.3547641-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
Content-Transfer-Encoding: 8bit

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit d9b13cdad80dc11d74408cf201939a946e9303a6 ]

If a lookup in tracefs is done on a file that does not exist, it leaves a
dentry hanging around until memory pressure removes it. But eventfs
dentries should hang around as when their ref count goes to zero, it
requires more work to recreate it. For the rest of the tracefs dentries,
they hang around as their dentry is used as a descriptor for the tracing
system. But if a file lookup happens for a file in tracefs that does not
exist, it should be deleted.

Add a .d_delete callback that checks if dentry->fsdata is set or not. Only
eventfs dentries set fsdata so if it has content it should not be deleted
and should hang around in the cache.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of this commit, here is my assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Analysis of the commit:

1. **Bug Fix Nature**: This commit fixes a memory leak issue where
   negative dentries (dentries for non-existent files) in tracefs are
   not properly cleaned up, leading to unnecessary memory consumption
   until memory pressure forces their removal.

2. **Small and Contained Change**: The patch adds only 11 lines of code
   - a single `d_delete` callback function that returns whether a dentry
   should be immediately deleted based on whether it has `d_fsdata` set
   or not. This is a minimal, focused fix.

3. **Clear Problem and Solution**:
   - Problem: Negative dentries in tracefs hang around unnecessarily
     consuming memory
   - Solution: Add `d_delete` callback to immediately remove negative
     dentries that aren't eventfs dentries
   - The logic is simple: `return dentry->d_fsdata == NULL;`

4. **No Architectural Changes**: This commit doesn't change any
   fundamental behavior or architecture. It simply adds a cleanup
   mechanism for negative dentries that should have been there from the
   beginning.

5. **Low Risk of Regression**: The change is conservative:
   - It only affects negative dentries (files that don't exist)
   - It preserves the existing behavior for eventfs dentries (which need
     to be cached)
   - The callback is idempotent and constant as required by the VFS
     documentation

6. **Performance Impact**: This is a performance improvement that
   reduces memory usage by preventing the accumulation of useless
   negative dentries in tracefs.

7. **Subsystem Maturity**: The tracefs/eventfs subsystem has been
   undergoing fixes and improvements, and this appears to be part of
   cleaning up edge cases that were discovered through usage.

The commit follows the stable kernel rules perfectly - it's a clear bug
fix that improves system behavior without introducing new features or
making risky changes. The fact that it was reported by Al Viro (a VFS
maintainer) and signed off by him adds additional confidence that this
is a proper fix.

 fs/tracefs/inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 7d389dd5ed51..6b70965063d7 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -483,9 +483,20 @@ static int tracefs_d_revalidate(struct dentry *dentry, unsigned int flags)
 	return !(ei && ei->is_freed);
 }
 
+static int tracefs_d_delete(const struct dentry *dentry)
+{
+	/*
+	 * We want to keep eventfs dentries around but not tracefs
+	 * ones. eventfs dentries have content in d_fsdata.
+	 * Use d_fsdata to determine if it's a eventfs dentry or not.
+	 */
+	return dentry->d_fsdata == NULL;
+}
+
 static const struct dentry_operations tracefs_dentry_operations = {
 	.d_revalidate = tracefs_d_revalidate,
 	.d_release = tracefs_d_release,
+	.d_delete = tracefs_d_delete,
 };
 
 static int trace_fill_super(struct super_block *sb, void *data, int silent)
-- 
2.39.5

