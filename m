Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587371C331A;
	Mon, 14 Oct 2024 15:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919773; cv=none; b=SXu69d8b0B8Joh9jRXsuz32MszugJLwsU9xMqFC6m5f6jkrmtCqUltq6F6A/9bpHYek6Yfct5XonKlFAKcpkL0hXLhlL0uuCPBYhuELNaxrh3/3a5nzEF4uzC3uNDjmNRCxePxBcFTNpdH0t4X2jKafvRm6wIqEabS1VwTNsit4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919773; c=relaxed/simple;
	bh=HliaOWIpuVeAXXP13yhqEmagwyLUvC0iDnxujig54Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIGDvBYliE/H4fxwWCxFsy7URDzh8pnpucdeQdvUYQQahA9xwL+wsB63ArTR1Wu+/QKDlKI0fY4/9Evwq31AMDEnCFQRvEUxlFfFPDoeVrI0HGhRN15AlHNViyxCgAcGy/kQDGtRcpFXu8nHEUkk1fCT1sUot8Yufv1kwNnen/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sd5jvjzW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sd5jvjzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5AAC4CEC3;
	Mon, 14 Oct 2024 15:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919773;
	bh=HliaOWIpuVeAXXP13yhqEmagwyLUvC0iDnxujig54Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sd5jvjzWEWYQDn6BwfytyJ/8P/wb8AnDesENi+qJwk+pBYOb4HdICp12eiF3NKz26
	 FEgCnzt3pN6SdZCqIzj1zK/Tv9PlkGSu1dsnma/dIUMH4wIBlGbGheklFA4Fc00SQ/
	 uqTTpjg073lg2U6j/vyeVQFLCebAFeBco7jczVxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ross Zwisler <zwisler@chromium.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sean Christopherson <seanjc@google.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Leo Yan <leo.yan@linaro.org>,
	Andi Kleen <ak@linux.intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Ingo Molnar <mingo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 672/798] perf lock: Dynamically allocate lockhash_table
Date: Mon, 14 Oct 2024 16:20:26 +0200
Message-ID: <20241014141244.466609490@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit eef4fee5e52071d563d9a851df1c09869215ee15 ]

lockhash_table is 32,768 bytes in .bss, make it a memory allocation so
that the space is freed for non-lock perf commands.

Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20230526183401.2326121-10-irogers@google.com
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ross Zwisler <zwisler@chromium.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Yang Jihong <yangjihong1@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-perf-users@vger.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 1a5efc9e13f3 ("libsubcmd: Don't free the usage string")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-lock.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 470106643ed52..28fa76ecc0822 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -45,7 +45,7 @@ static struct target target;
 #define LOCKHASH_BITS		12
 #define LOCKHASH_SIZE		(1UL << LOCKHASH_BITS)
 
-static struct hlist_head lockhash_table[LOCKHASH_SIZE];
+static struct hlist_head *lockhash_table;
 
 #define __lockhashfn(key)	hash_long((unsigned long)key, LOCKHASH_BITS)
 #define lockhashentry(key)	(lockhash_table + __lockhashfn((key)))
@@ -1645,16 +1645,22 @@ static int __cmd_contention(int argc, const char **argv)
 	};
 	struct lock_contention con = {
 		.target = &target,
-		.result = &lockhash_table[0],
 		.map_nr_entries = bpf_map_entries,
 		.max_stack = max_stack_depth,
 		.stack_skip = stack_skip,
 	};
 
+	lockhash_table = calloc(LOCKHASH_SIZE, sizeof(*lockhash_table));
+	if (!lockhash_table)
+		return -ENOMEM;
+
+	con.result = &lockhash_table[0];
+
 	session = perf_session__new(use_bpf ? NULL : &data, &eops);
 	if (IS_ERR(session)) {
 		pr_err("Initializing perf session failed\n");
-		return PTR_ERR(session);
+		err = PTR_ERR(session);
+		goto out_delete;
 	}
 
 	con.machine = &session->machines.host;
@@ -1755,6 +1761,7 @@ static int __cmd_contention(int argc, const char **argv)
 	evlist__delete(con.evlist);
 	lock_contention_finish();
 	perf_session__delete(session);
+	zfree(&lockhash_table);
 	return err;
 }
 
@@ -1946,6 +1953,10 @@ int cmd_lock(int argc, const char **argv)
 	unsigned int i;
 	int rc = 0;
 
+	lockhash_table = calloc(LOCKHASH_SIZE, sizeof(*lockhash_table));
+	if (!lockhash_table)
+		return -ENOMEM;
+
 	for (i = 0; i < LOCKHASH_SIZE; i++)
 		INIT_HLIST_HEAD(lockhash_table + i);
 
@@ -1967,7 +1978,7 @@ int cmd_lock(int argc, const char **argv)
 		rc = __cmd_report(false);
 	} else if (!strcmp(argv[0], "script")) {
 		/* Aliased to 'perf script' */
-		return cmd_script(argc, argv);
+		rc = cmd_script(argc, argv);
 	} else if (!strcmp(argv[0], "info")) {
 		if (argc) {
 			argc = parse_options(argc, argv,
@@ -1996,5 +2007,6 @@ int cmd_lock(int argc, const char **argv)
 		usage_with_options(lock_usage, lock_options);
 	}
 
+	zfree(&lockhash_table);
 	return rc;
 }
-- 
2.43.0



