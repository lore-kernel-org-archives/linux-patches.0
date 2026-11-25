Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622723;
	b=AiND38JdZt1qShcumqXA+yTpYgMb0LKPHGJBZQ70Z/P3V24qgYen6EI7Eq5L8g0dBNcz
	 5XRi6l1c+UJQAEIomMEDUNQQ+uZSSyVFhPXfr8mjK+Awumq6at3vjoaRDvBGV+0FjP5+0
	 jOoXyOUEtqUJ59BIqdlBjMP6Vj/WRdb/PRBbk9ktCJTVnVp78xKXwDz7s6OlCQ/BsnYUz
	 4us3WNOisWvqjysd2uPlx3nzWD59eYSy1Us8tcKEEEgKBrY4wnyfMCAc1gXLKyfAlNNlD
	 aIb4V+5s2anOYlm49H7l5R95JVWWsBACvj9smQsonZnH5dFiKQ+sZa5IAA6HvAWXurQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622723;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7e11V9x56sbFKOdFjTlGOpp75Um8M+o0fNPWnHOFJ50=;
	b=kVtgOx6XWkVNy1034L+eZQQ0WfAOlV6eP5XR4tyKGLPB2qaRl6YkpeYuEYEeFNBqnWUA
	 G4e2Yy9fGu76MzpQgnhv8DdtYM+U80/5iH0KCIN0kfYs/ETRTg1cfR7c+/WkC0GD5DxJY
	 kyRlPxPNgjneXETtGVbaHYgLoUttzBumIlwqxpXUxZ636LZ1u/d/b98eML9ZMd58rDBHb
	 2QST3Vggvd+TBqB/PxTKHYb5q9TnNcFPGPZSFXcb7/sEZh0fQVkTrp6dq5ieDxJtLmILN
	 q84YxxTpuEIQZDsG+3DMFRTSy8tsotbgB3Z3tZMG6bIrsaNixQ6EO07Ta5N52BijfUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uE0qGb/r";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75923606A323;
	Wed, 25 Nov 2026 16:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uE0qGb/r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB3C1F000C6;
	Wed, 25 Nov 2026 16:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622723;
	bh=7e11V9x56sbFKOdFjTlGOpp75Um8M+o0fNPWnHOFJ50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uE0qGb/rz/zPNwiwsT80+nd+ryBKEiuUVOe+Lif+jPY3N8Gv4TpZHxqbaE3rH8YMe
	 sGDe1qrZHQ4tMW2IdEY6JrCAw4LnbHLqjIqd35XFBTBw/J7OKQ71Jh6Ey6OnU13NtW
	 mVqGoJw4/HkpTGzByme07BPkPfcKhHWgtNOSKaj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 626/990] perf lock contention: Filter events before creating lock_stat
Date: Wed, 25 Nov 2026 15:33:13 +0100
Message-ID: <20261125143836.762294956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit c58d1598e79554cc8f587668ab2ebcaeb616b076 ]

In report_lock_contention_begin_event(), lock_stat_findnew() was
called before checking filters.nr_types (-Y), filters.nr_addrs (-L),
and match_callstack_filter() (-S).

When a filtered-out lock event (such as a mutex contention when
running with -Y spinlock) shared the same aggregation key as a
subsequent matching event (for example, contention on the mutex's
internal wait_lock spinlock from the same caller), the first event
created the lock_stat entry with the filtered-out lock's flags and the
second event reused that entry, causing non-spinlock entries to appear
in -Y spinlock output.

Check the type, address, and callstack filters before looking up or
creating the lock_stat entry.

Fixes: b4a7eff93c39f985 ("perf lock contention: Add -Y/--type-filter option")
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[ sashal: Used the tree's lock_contention_caller(evsel, sample, ...) signature, with the extra evsel argument, in the moved lock_stat lookup block instead of upstream's lock_contention_caller(sample, ...). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-lock.c | 61 +++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 28 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 5585aeb97684d..66bfd9e4fe17f 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -977,6 +977,7 @@ static int report_lock_contention_begin_event(struct evsel *evsel,
 	struct machine *machine = &session->machines.host;
 	struct map *kmap;
 	struct symbol *sym;
+	u64 *callstack = NULL;
 
 	ret = get_key_by_aggr_mode(&key, addr, evsel, sample);
 	if (ret < 0)
@@ -1012,33 +1013,6 @@ static int report_lock_contention_begin_event(struct evsel *evsel,
 		}
 	}
 
-	ls = lock_stat_find(key);
-	if (!ls) {
-		char buf[128];
-		const char *name = "";
-
-		switch (aggr_mode) {
-		case LOCK_AGGR_ADDR:
-			sym = machine__find_kernel_symbol(machine, key, &kmap);
-			if (sym)
-				name = sym->name;
-			break;
-		case LOCK_AGGR_CALLER:
-			name = buf;
-			if (lock_contention_caller(evsel, sample, buf, sizeof(buf)) < 0)
-				name = "Unknown";
-			break;
-		case LOCK_AGGR_CGROUP:
-		case LOCK_AGGR_TASK:
-		default:
-			break;
-		}
-
-		ls = lock_stat_findnew(key, name, flags);
-		if (!ls)
-			return -ENOMEM;
-	}
-
 	if (filters.nr_types) {
 		bool found = false;
 
@@ -1068,7 +1042,7 @@ static int report_lock_contention_begin_event(struct evsel *evsel,
 	}
 
 	if (needs_callstack()) {
-		u64 *callstack = get_callstack(sample, max_stack_depth);
+		callstack = get_callstack(sample, max_stack_depth);
 		if (callstack == NULL)
 			return -ENOMEM;
 
@@ -1076,7 +1050,38 @@ static int report_lock_contention_begin_event(struct evsel *evsel,
 			free(callstack);
 			return 0;
 		}
+	}
+
+	ls = lock_stat_find(key);
+	if (!ls) {
+		char buf[128];
+		const char *name = "";
+
+		switch (aggr_mode) {
+		case LOCK_AGGR_ADDR:
+			sym = machine__find_kernel_symbol(machine, key, &kmap);
+			if (sym)
+				name = sym->name;
+			break;
+		case LOCK_AGGR_CALLER:
+			name = buf;
+			if (lock_contention_caller(evsel, sample, buf, sizeof(buf)) < 0)
+				name = "Unknown";
+			break;
+		case LOCK_AGGR_CGROUP:
+		case LOCK_AGGR_TASK:
+		default:
+			break;
+		}
+
+		ls = lock_stat_findnew(key, name, flags);
+		if (!ls) {
+			free(callstack);
+			return -ENOMEM;
+		}
+	}
 
+	if (callstack) {
 		if (ls->callstack == NULL)
 			ls->callstack = callstack;
 		else
-- 
2.53.0



