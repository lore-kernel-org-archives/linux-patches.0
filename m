Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429AF433BB9;
	Tue, 21 Jul 2026 19:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662614; cv=none; b=fyAslYDB1X7/8+FFFaAW61Bg4Hnf3Tjid4X/7Leify9SM3KsgYyqtvkZvpCRUE5B4TEaC+5nUSPbZPVpqRM9lkSdfP9rYzmVHPk3upwGhSRkBvqQhHNSxaIVP+XABpSAcqvQCHmI0RT5LqSLkb4ihu6OsERjLFGyEiv7wrUjBWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662614; c=relaxed/simple;
	bh=AlfENHFskjGKI/kL3bTLVELgSmlVNBNp2eYPwFAbcUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGh8eNcZxKUbPZ3Id566OHO8JciK71czgxTD2DMBvNUQnXAT1o65IFrHQhjUt/vJu2xR2e6izZMgPTlL/oNfy+u6ottHzBWTPvIBU3VX5e7tk9+m0qY+TAaomDC7c7s1TR+GY1+jMUQcE0SiBi+15UGULZKImeeN8xmjOHDQYiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUNeNyVL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUNeNyVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F92F1F000E9;
	Tue, 21 Jul 2026 19:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662612;
	bh=nWB+/ZNFoR+pAtOQMCXPmOyHqycC26HKL1FZlA2t0co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NUNeNyVLICRVOF8kxDCeAe9aTYFiBIg/vx5MpE4+VPeFNRrZyfGpPW14IqDAz0kWT
	 I/5Q1pepV5gxe8SgWTMV4fbZJlz3sFDIoAlX/dCLRtwSAjXWXmkva3YggIVCGx+1bj
	 Ltt5UkvZ25e0+9j1Mhc1BMwtZkuTR0PgPK9NAXxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	David Ahern <dsahern@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0468/1276] perf sched: Clean up idle_threads entry on init failure
Date: Tue, 21 Jul 2026 17:15:11 +0200
Message-ID: <20260721152456.576400858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit cda5a94ad9181cd60cbf04be11d524201bf489a2 ]

get_idle_thread() allocates a thread via thread__new() and stores it in
idle_threads[cpu], then calls init_idle_thread() to set up the private
data.  If init_idle_thread() fails (e.g. OOM for the idle_thread_runtime
struct), the function returns NULL but leaves the partially initialized
thread in idle_threads[cpu].

On subsequent calls for the same CPU, get_idle_thread() finds a non-NULL
idle_threads[cpu], skips allocation, and returns thread__get() on a
thread that has no priv data.  Callers then get a thread whose
thread__priv() returns NULL, leading to unexpected behavior.

Release the thread and reset the slot to NULL on init failure so the
entry doesn't persist in a corrupted state.

Fixes: 49394a2a24c7 ("perf sched timehist: Introduce timehist command")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 4596037b5763c0..fd93ab11bd37ed 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2496,8 +2496,11 @@ static struct thread *get_idle_thread(int cpu)
 		idle_threads[cpu] = thread__new(0, 0);
 
 		if (idle_threads[cpu]) {
-			if (init_idle_thread(idle_threads[cpu]) < 0)
+			if (init_idle_thread(idle_threads[cpu]) < 0) {
+				/* clean up so next call doesn't find a half-initialized thread */
+				thread__zput(idle_threads[cpu]);
 				return NULL;
+			}
 		}
 	}
 
-- 
2.53.0



