Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305F6151988;
	Wed,  5 Feb 2025 14:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766165; cv=none; b=XQFS5TsA6THyvc7Oh8hluv08u6oWQKW+TKrRO5GHmiRvtO6HWKGpaBX/t5VPzddn0vRkJ96u3z5kxVFdzwReRK61vy+dD5mCWYn43NTLvaAeyjFyDW96FXmaVsKkKwEq6BF7YiblUk5y0OXpvwQ+40PmZGPY7WbycSoTJPBSDeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766165; c=relaxed/simple;
	bh=BNiTe+n9/CWMdAL2TIkOF9Lurn37ZwtRvxgefw/T/iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rc/WCRpIQLxnl2IDg6Br9vIcr9dmKye0pw8Rr4ZgXf9NETfHa0hdIqiMHXDOO+jhLj6D1MV1ori6XxXft46ZfUZTCsgAbPRNHP8+yelxytXcRuzG7jYJoE9CNhHnx+yk/3tFiyqEtyF6aAjv/2GsJZ7nquaYsqeHVgQMGjWxwwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUuDY7/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUuDY7/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9601C4CED1;
	Wed,  5 Feb 2025 14:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766165;
	bh=BNiTe+n9/CWMdAL2TIkOF9Lurn37ZwtRvxgefw/T/iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUuDY7/nUag1i3lTVWhRZ4F82na6prHOCGYM4GoX192Ul9UotIQP09tWy/dbrLW6a
	 n+CXXR3Jm0pHH20Kkr4Qai5TGlt2ZE4wo7xz0pOVBrUqUxRe1IhgEYgn0o516ae+cI
	 paE52vAZVHSD4zFvM4kX8BRwEWkK27cdixswAWyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Chun-Tse Shao <ctshao@google.com>,
	nick.forrington@arm.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 293/590] perf lock: Fix parse_lock_type which only retrieve one lock flag
Date: Wed,  5 Feb 2025 14:40:48 +0100
Message-ID: <20250205134506.486629344@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chun-Tse Shao <ctshao@google.com>

[ Upstream commit 1be9264158ef4818393e5d8144887a1a5d3cc480 ]

`parse_lock_type` can only add the first lock flag in `lock_type_table`
given input `str`. For example, for `Y rwlock`, it only adds `rwlock:R`
into this perf session. Another example is for `-Y mutex`, it only adds
the mutex without `LCB_F_SPIN` flag. The patch fixes this issue, makes
sure both `rwlock:R` and `rwlock:W` will be added with `-Y rwlock`, and
so on.

Testing:
  $ ./perf lock con -ab -Y mutex,rwlock -- perf bench sched pipe
  # Running 'sched/pipe' benchmark:
  # Executed 1000000 pipe operations between two processes

       Total time: 9.313 [sec]

         9.313976 usecs/op
           107365 ops/sec
   contended   total wait     max wait     avg wait         type   caller

         176      1.65 ms     19.43 us      9.38 us        mutex   pipe_read+0x57
          34    180.14 us     10.93 us      5.30 us        mutex   pipe_write+0x50
           7     77.48 us     16.09 us     11.07 us        mutex   do_epoll_wait+0x24d
           7     74.70 us     13.50 us     10.67 us        mutex   do_epoll_wait+0x24d
           3     35.97 us     14.44 us     11.99 us     rwlock:W   ep_done_scan+0x2d
           3     35.00 us     12.23 us     11.66 us     rwlock:W   do_epoll_wait+0x255
           2     15.88 us     11.96 us      7.94 us     rwlock:W   do_epoll_wait+0x47c
           1     15.23 us     15.23 us     15.23 us     rwlock:W   do_epoll_wait+0x4d0
           1     14.26 us     14.26 us     14.26 us     rwlock:W   ep_done_scan+0x2d
           2     14.00 us      7.99 us      7.00 us        mutex   pipe_read+0x282
           1     12.29 us     12.29 us     12.29 us     rwlock:R   ep_poll_callback+0x35
           1     12.02 us     12.02 us     12.02 us     rwlock:W   do_epoll_ctl+0xb65
           1     10.25 us     10.25 us     10.25 us     rwlock:R   ep_poll_callback+0x35
           1      7.86 us      7.86 us      7.86 us        mutex   do_epoll_ctl+0x6c1
           1      5.04 us      5.04 us      5.04 us        mutex   do_epoll_ctl+0x3d4

[namhyung: Add a comment and rename to 'mutex:spin' for consistency

Fixes: d783ea8f62c4 ("perf lock contention: Simplify parse_lock_type()")
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Chun-Tse Shao <ctshao@google.com>
Cc: nick.forrington@arm.com
Link: https://lore.kernel.org/r/20250116235838.2769691-1-ctshao@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-lock.c | 66 ++++++++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 25 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 062e2b56a2ab5..33a456980664a 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -1591,8 +1591,8 @@ static const struct {
 	{ LCB_F_PERCPU | LCB_F_WRITE,	"pcpu-sem:W",	"percpu-rwsem" },
 	{ LCB_F_MUTEX,			"mutex",	"mutex" },
 	{ LCB_F_MUTEX | LCB_F_SPIN,	"mutex",	"mutex" },
-	/* alias for get_type_flag() */
-	{ LCB_F_MUTEX | LCB_F_SPIN,	"mutex-spin",	"mutex" },
+	/* alias for optimistic spinning only */
+	{ LCB_F_MUTEX | LCB_F_SPIN,	"mutex:spin",	"mutex-spin" },
 };
 
 static const char *get_type_str(unsigned int flags)
@@ -1617,19 +1617,6 @@ static const char *get_type_name(unsigned int flags)
 	return "unknown";
 }
 
-static unsigned int get_type_flag(const char *str)
-{
-	for (unsigned int i = 0; i < ARRAY_SIZE(lock_type_table); i++) {
-		if (!strcmp(lock_type_table[i].name, str))
-			return lock_type_table[i].flags;
-	}
-	for (unsigned int i = 0; i < ARRAY_SIZE(lock_type_table); i++) {
-		if (!strcmp(lock_type_table[i].str, str))
-			return lock_type_table[i].flags;
-	}
-	return UINT_MAX;
-}
-
 static void lock_filter_finish(void)
 {
 	zfree(&filters.types);
@@ -2350,29 +2337,58 @@ static int parse_lock_type(const struct option *opt __maybe_unused, const char *
 			   int unset __maybe_unused)
 {
 	char *s, *tmp, *tok;
-	int ret = 0;
 
 	s = strdup(str);
 	if (s == NULL)
 		return -1;
 
 	for (tok = strtok_r(s, ", ", &tmp); tok; tok = strtok_r(NULL, ", ", &tmp)) {
-		unsigned int flags = get_type_flag(tok);
+		bool found = false;
 
-		if (flags == -1U) {
-			pr_err("Unknown lock flags: %s\n", tok);
-			ret = -1;
-			break;
+		/* `tok` is `str` in `lock_type_table` if it contains ':'. */
+		if (strchr(tok, ':')) {
+			for (unsigned int i = 0; i < ARRAY_SIZE(lock_type_table); i++) {
+				if (!strcmp(lock_type_table[i].str, tok) &&
+				    add_lock_type(lock_type_table[i].flags)) {
+					found = true;
+					break;
+				}
+			}
+
+			if (!found) {
+				pr_err("Unknown lock flags name: %s\n", tok);
+				free(s);
+				return -1;
+			}
+
+			continue;
 		}
 
-		if (!add_lock_type(flags)) {
-			ret = -1;
-			break;
+		/*
+		 * Otherwise `tok` is `name` in `lock_type_table`.
+		 * Single lock name could contain multiple flags.
+		 */
+		for (unsigned int i = 0; i < ARRAY_SIZE(lock_type_table); i++) {
+			if (!strcmp(lock_type_table[i].name, tok)) {
+				if (add_lock_type(lock_type_table[i].flags)) {
+					found = true;
+				} else {
+					free(s);
+					return -1;
+				}
+			}
 		}
+
+		if (!found) {
+			pr_err("Unknown lock name: %s\n", tok);
+			free(s);
+			return -1;
+		}
+
 	}
 
 	free(s);
-	return ret;
+	return 0;
 }
 
 static bool add_lock_addr(unsigned long addr)
-- 
2.39.5



