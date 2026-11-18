Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021508;
	b=S0+TSyPpZxst26e3TzrPJ5ZDruOZqtmW0iJ/MaKsGXThFgwTmo5lZMvzs4awrRlep8Yk
	 Uq440UYTSAf1WMAdTfJ3+Q4jJm08658GAc7z9eIasi6lz3+D/XcsEwRRA8rvTJcjPAA6y
	 rQZlCQZ7NeXh9RN/HJuOCN4L0+oYCSIIp2Tu+yr0i3ETWCzf7YVIE7nKVGHo0BkHtM46k
	 5EMfCRMf9ws0F642Cf6dTl3WINeLU5c6kJmEkUkDrSy6vaW1NgSdjWQkCOjFC3xlDJNhb
	 YKnQmFtZyUl3cIlv+H93LL5wMviwP781YilGvaoq7L8ZcUCyw7Xy6Qy9uAUcjMWi2Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eTNA0glYmsWBJh/KoTqH4Npz+q7Esqv8JQwJXLH/S/o=;
	b=Ag7H+6PSHZDPJGGYQ88MGe+NxYzuKC7jRZYyjCvNdXHmESIdUwpptuVtwibHHfl8WB3z
	 I80MDNqkA3a0tYdI4a+E/lu9HvG5zSXCLvmK8v4Z+eyLkiWTo+3Lwdgu+C3/Uo/Alq2A6
	 VOEh3fvtYG6JWALmnDTLzcw4I9k5PJKfXaOxlTocbNEzOrka5Q3lthD5wTpXgrke+iUNv
	 hjkG5U0VLwy0bPBfBLHweEZPbmUZQ9R+daT3BE3wOJlIi9OobaPNyuY6DiQExYuOxXTgP
	 zrGLNAwhul5iV86t+tO1VrcrLOqP0AjYs/t8qai67NaTBhipYVRKCGHaP5ac2iCiS6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xOuA4d0O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A87606A31C;
	Wed, 18 Nov 2026 17:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xOuA4d0O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37C31F000C4;
	Wed, 18 Nov 2026 17:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021508;
	bh=eTNA0glYmsWBJh/KoTqH4Npz+q7Esqv8JQwJXLH/S/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xOuA4d0OAka8keiqIdymR/lzTD0b8r+7XK9w0PNcxJsPtQyAKQ9BpX+Fac9G4h2a0
	 H/UHCK8g1ryWwByD3ec9DsmX+cvmysHWhVnZlO0/263tNLJReTqOpYiAi0GEiWmY74
	 L9CNem+jz71S2v3K9t1P8RnX+RCd1pt2cjxWiBZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2333/2651] perf lock contention: Filter events before creating lock_stat
Date: Wed, 18 Nov 2026 15:59:33 +0100
Message-ID: <20261118150409.112623108@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-lock.c | 61 +++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 28 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index d5c0d55cb82d9..778923c92f420 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -975,6 +975,7 @@ static int report_lock_contention_begin_event(struct perf_sample *sample)
 	struct machine *machine = &session->machines.host;
 	struct map *kmap;
 	struct symbol *sym;
+	u64 *callstack = NULL;
 
 	ret = get_key_by_aggr_mode(&key, addr, sample);
 	if (ret < 0)
@@ -1010,33 +1011,6 @@ static int report_lock_contention_begin_event(struct perf_sample *sample)
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
-			if (lock_contention_caller(sample, buf, sizeof(buf)) < 0)
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
 
@@ -1066,7 +1040,7 @@ static int report_lock_contention_begin_event(struct perf_sample *sample)
 	}
 
 	if (needs_callstack()) {
-		u64 *callstack = get_callstack(sample, max_stack_depth);
+		callstack = get_callstack(sample, max_stack_depth);
 		if (callstack == NULL)
 			return 0;
 
@@ -1074,7 +1048,38 @@ static int report_lock_contention_begin_event(struct perf_sample *sample)
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
+			if (lock_contention_caller(sample, buf, sizeof(buf)) < 0)
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



