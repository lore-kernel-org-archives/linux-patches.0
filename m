Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625488;
	b=kd7a++stZkg9x7JjUSkff+icodIkXjJ/7jwJuoy7vNnSE+3F+JKNSSHMr8cNUBkzsVaQ
	 mwxACO9DaCJyXjkWy+Wyk4v3AB6GmAAAyBalX1QhTvrsesVd8I3Ak8+3qu6Raz4fHmHN4
	 R6hx89aCzVn5dimzc07oJZofWoe9/JWItCv/XSn4D9zzsFLrpQusGVOrseVog7/798yu4
	 AqV9L/h1zz27tfVF4JWINF/ov25dO61JlpE/34bXFsyG1Cmor5MhKP0JVh+EFiPFmVpoP
	 1OaMF75TEzjaDsYAcroX3Y2H3RFj1P6HqJGjUr9BgNRdafA5LexDTgvKGXCnsXSAE9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mk19yznoLP8+S9Bfaj8NigwSM11mLNS5Lnq9TJvX+fs=;
	b=WzFiwJQXACHLBHUuyDaj0jTn6ZiIoq6jYLIhB2lvE+7V6Y3V7cyNsiC1ngLgN9frASHl
	 tMWUeb6sdjE59ldE3vc3NA9xyGtbNED/Mj0sA3QQQ33Pp7QvXtHhqOKhDW6pE2zV0O8QY
	 PvLxTnSLijK7UjbuCBcPHIiJakNrbmDWJ91c3EzlmNCrk/+bqIaLqTOuFXE1m9G5tVXYi
	 By57moZRGzBjgcEPkan6wOAo1ZdZS1z1LWinWlkDAa/H4u6eDDfvUmnv+5wuwBenMkI00
	 86rnTvKOZd2hRkZxPF+QFTl0eiXKgDLFsXj8YJ1a0IRLORGN3nSLXGfvCaoVwqaNZgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksMFeDXY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92952606A31E;
	Wed, 25 Nov 2026 16:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksMFeDXY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BDE1F000C6;
	Wed, 25 Nov 2026 16:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625488;
	bh=mk19yznoLP8+S9Bfaj8NigwSM11mLNS5Lnq9TJvX+fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksMFeDXYglvFM2jl76Vhor49jsgs42/KB0GVjI2XGwEoUXJFG6rNycES5z4PyhQ4f
	 4ug4qnkX8ArfPzxjeW5U+xOKL48yRt39P2UjNyWQiIaPes1Eh8Wg/BylAxNu8brupA
	 bfjBcIkL5PGgBYXKvCaIIfft+oCRYRMdl+O5p/nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 533/816] perf lock contention: Filter events before creating lock_stat
Date: Wed, 25 Nov 2026 15:34:41 +0100
Message-ID: <20261125143901.528528304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted the lock_contention_caller() call to pass the extra evsel argument, and kept the existing -ENOMEM return on get_callstack() failure instead of 0. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-lock.c | 61 +++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 28 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 3d490ea46551b..1de2ee1464fee 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -1070,6 +1070,7 @@ static int report_lock_contention_begin_event(struct evsel *evsel,
 	struct machine *machine = &session->machines.host;
 	struct map *kmap;
 	struct symbol *sym;
+	u64 *callstack = NULL;
 
 	ret = get_key_by_aggr_mode(&key, addr, evsel, sample);
 	if (ret < 0)
@@ -1105,33 +1106,6 @@ static int report_lock_contention_begin_event(struct evsel *evsel,
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
 
@@ -1161,7 +1135,7 @@ static int report_lock_contention_begin_event(struct evsel *evsel,
 	}
 
 	if (needs_callstack()) {
-		u64 *callstack = get_callstack(sample, max_stack_depth);
+		callstack = get_callstack(sample, max_stack_depth);
 		if (callstack == NULL)
 			return -ENOMEM;
 
@@ -1169,7 +1143,38 @@ static int report_lock_contention_begin_event(struct evsel *evsel,
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



