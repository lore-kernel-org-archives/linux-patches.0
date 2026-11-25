Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622629;
	b=lVNzoHDDYk4W7RVUiTGCoksbGB8lv7ZgBeZqbaLCsEws1a0M2Z+DwL+hrJcBTPsvOA1C
	 fn/vm/27gRKq2GsRdF/5b+Ps+9IGRAyBxNF0lv/kpvtkE7W+qlOCvnGQbZDtP7YF/PRqt
	 mvLFf7qYnqDI/BNEoOilfOXIIm+tQUraC2LS9J9TVEYy8qAxqflNIJ4onASgXvVPkPlyO
	 YgPtmk9Y1UdTEcPSQlCg8RJFMiZD/NDcqISJDDHc9qytomuMBJI1xL6JuNxJSO92oTBAI
	 cdMzGdvtlYZgel+uuHZhO9ZHr8FfzqLdoNp4XpkdrJAHn09g0zjDJzFxek2CMIWlhcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bSHuRPvrVQkXAzrB9RXh/dzhdi2u3QYwis1NqxSWWEs=;
	b=dfKj7bAEmPVl2b6Om0jPsxGOixzwp+wxu2HwTe4sQgwLW2O4iHzWz/gG9L3P+jyiOmgr
	 S2U4ws8QDbAJSzc+IijySZ5a1XupR55wtQ8oNPbHCPmQNy/oBpqKXIZDJEmOo4tJp3jKt
	 9RL1lAoUfopFffu09BWIQGErp6XODlGQ0uZ6GkotNe3eQ97NnPwuUn6TUsK50++9YFO6/
	 OtfDV6F5LOr0pTrsKmpvHH67TsFgbmwMEtxYvbMqxHNUPUqtYpu4Fp0SZQ6T80x91sLL8
	 Dt/TgaJ5flUSPzMrfFKuegRBCCibNKO3JWjF2wNQQ0t/FO1mLbLoB+G3Nn4pu6sqyxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ghUBl7fM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DD1606A31E;
	Wed, 25 Nov 2026 16:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ghUBl7fM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD57F1F000C4;
	Wed, 25 Nov 2026 16:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622629;
	bh=bSHuRPvrVQkXAzrB9RXh/dzhdi2u3QYwis1NqxSWWEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghUBl7fMLg4p6OzAZzK/C+2BdD+Env+7VOOPJEuiLKhI39khSdSrJ1OV3zcPo7yvz
	 JR1tcxy0irYEp0rihByLT2B1MOMP2SFBhHYqrzPdWfdu9UKRpytOV59zq1Ab53SNpD
	 jxI+KTq084ywDUdqePFm3VXnlC0DfwNZRhxRo36E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 543/990] perf machine: Add session back pointer to fix out of bounds read
Date: Wed, 25 Nov 2026 15:31:50 +0100
Message-ID: <20261125143834.817499532@linuxfoundation.org>
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

[ Upstream commit d227b45fc162ce9134bb96f33f71e6952ec36ea5 ]

thread__e_machine_endian() decides whether a thread is live, and so
whether to read /proc/pid/exe rather than fall back to the perf.data
environment, by recovering the session from the machine:

	session = container_of(machine->machines, struct perf_session,
			       machines);
	is_live = !session->data;

That only holds when the struct machines is the one embedded in a struct
perf_session. It is not the only one. aslr_tool keeps its own in struct
aslr_tool, and hists_cumulate, hists_filter, hists_link, hists_output
and thread-maps-share each put one on the stack. For those the
container_of subtracts offsetof(struct perf_session, machines) from an
address that was never inside a session, and the following load of
session->data reads outside the object, which is what ASan reports.

Replace the derivation with an explicit link. machines__init() takes the
owning session, or NULL when the machines is standalone, and
thread__e_machine_endian() reads it back through machines__session().

A NULL session is treated as live. The tests use synthetic pids that
have no /proc entry, so the read fails there and the e_machine falls
back to EM_HOST as before, rather than being decided by whatever the
out of bounds read happened to return. perf inject registers its
session with the aslr tool once the session exists, before any event is
processed, so that tool keeps reporting file based threads as not live.

Fixes: 70351029b556 ("perf thread: Add support for reading the e_machine type for a thread")
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[ sashal: adapted to machines__init() returning void and dropped the ASLR hunks since that code is absent, so the test callers pass NULL as a plain statement. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/hists_cumulate.c    |  2 +-
 tools/perf/tests/hists_filter.c      |  2 +-
 tools/perf/tests/hists_link.c        |  2 +-
 tools/perf/tests/hists_output.c      |  2 +-
 tools/perf/tests/thread-maps-share.c |  2 +-
 tools/perf/util/machine.c            |  3 ++-
 tools/perf/util/machine.h            | 10 +++++++++-
 tools/perf/util/session.c            |  2 +-
 tools/perf/util/thread.c             |  8 +++-----
 9 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/tools/perf/tests/hists_cumulate.c b/tools/perf/tests/hists_cumulate.c
index 3eb9ef8d7ec63..bdf4ce82612dd 100644
--- a/tools/perf/tests/hists_cumulate.c
+++ b/tools/perf/tests/hists_cumulate.c
@@ -724,7 +724,7 @@ static int test__hists_cumulate(struct test_suite *test __maybe_unused, int subt
 		goto out;
 	err = TEST_FAIL;
 
-	machines__init(&machines);
+	machines__init(&machines, /*session=*/NULL);
 
 	/* setup threads/dso/map/symbols also */
 	machine = setup_fake_machine(&machines);
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
index 1cebd20cc91c0..4a1d45ecc03ff 100644
--- a/tools/perf/tests/hists_filter.c
+++ b/tools/perf/tests/hists_filter.c
@@ -131,7 +131,7 @@ static int test__hists_filter(struct test_suite *test __maybe_unused, int subtes
 		goto out;
 	err = TEST_FAIL;
 
-	machines__init(&machines);
+	machines__init(&machines, /*session=*/NULL);
 
 	/* setup threads/dso/map/symbols also */
 	machine = setup_fake_machine(&machines);
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 996f5f0b3bd17..0af2ba1ad1aa5 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -303,7 +303,7 @@ static int test__hists_link(struct test_suite *test __maybe_unused, int subtest
 		goto out;
 
 	err = TEST_FAIL;
-	machines__init(&machines);
+	machines__init(&machines, /*session=*/NULL);
 
 	/* setup threads/dso/map/symbols also */
 	machine = setup_fake_machine(&machines);
diff --git a/tools/perf/tests/hists_output.c b/tools/perf/tests/hists_output.c
index ee5ec8bda60e5..a80263ab1d346 100644
--- a/tools/perf/tests/hists_output.c
+++ b/tools/perf/tests/hists_output.c
@@ -611,7 +611,7 @@ static int test__hists_output(struct test_suite *test __maybe_unused, int subtes
 		goto out;
 	err = TEST_FAIL;
 
-	machines__init(&machines);
+	machines__init(&machines, /*session=*/NULL);
 
 	/* setup threads/dso/map/symbols also */
 	machine = setup_fake_machine(&machines);
diff --git a/tools/perf/tests/thread-maps-share.c b/tools/perf/tests/thread-maps-share.c
index e9ecd30a5c058..cea1f92b5302c 100644
--- a/tools/perf/tests/thread-maps-share.c
+++ b/tools/perf/tests/thread-maps-share.c
@@ -27,7 +27,7 @@ static int test__thread_maps_share(struct test_suite *test __maybe_unused, int s
 	 * other  group (pid: 4, tids: 4, 5)
 	*/
 
-	machines__init(&machines);
+	machines__init(&machines, /*session=*/NULL);
 	machine = &machines.host;
 
 	/* create process with 4 threads */
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 091022e9c867f..0fcbd56746f24 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -229,9 +229,10 @@ void machine__delete(struct machine *machine)
 	}
 }
 
-void machines__init(struct machines *machines)
+void machines__init(struct machines *machines, struct perf_session *session)
 {
 	machine__init(&machines->host, "", HOST_KERNEL_ID);
+	machines->session = session;
 	machines->host.machines = machines;
 	machines->guests = RB_ROOT_CACHED;
 }
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 22a42c5825fab..049bbbdfa20d2 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -15,6 +15,7 @@ struct dso;
 struct dso_id;
 struct evsel;
 struct perf_sample;
+struct perf_session;
 struct symbol;
 struct target;
 struct thread;
@@ -148,13 +149,20 @@ int machine__process_event(struct machine *machine, union perf_event *event,
 typedef void (*machine__process_t)(struct machine *machine, void *data);
 
 struct machines {
+	/** @session: back link to owning session if there is one. */
+	struct perf_session *session;
 	struct machine host;
 	struct rb_root_cached guests;
 };
 
-void machines__init(struct machines *machines);
+void machines__init(struct machines *machines, struct perf_session *session);
 void machines__exit(struct machines *machines);
 
+static inline struct perf_session *machines__session(struct machines *machines)
+{
+	return machines->session;
+}
+
 void machines__process_guests(struct machines *machines,
 			      machine__process_t process, void *data);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0eee9d2f59d9a..f737ddb377553 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -152,7 +152,7 @@ struct perf_session *__perf_session__new(struct perf_data *data,
 	session->decomp_data.zstd_decomp = &session->zstd_data;
 	session->active_decomp = &session->decomp_data;
 	INIT_LIST_HEAD(&session->auxtrace_index);
-	machines__init(&session->machines);
+	machines__init(&session->machines, session);
 	ordered_events__init(&session->ordered_events,
 			     ordered_events__deliver_event, NULL);
 
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index bda001ccf571d..6e22f83ae1e1b 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -513,12 +513,10 @@ uint16_t thread__e_machine(struct thread *thread, struct machine *machine)
 		bool is_live = machine->machines == NULL;
 
 		if (!is_live) {
-			/* Check if the session has a data file. */
-			struct perf_session *session = container_of(machine->machines,
-								    struct perf_session,
-								    machines);
+			/* Check if the session has a data file (assume no session is a test). */
+			struct perf_session *session = machines__session(machine->machines);
 
-			is_live = !session->data;
+			is_live = !session || !session->data;
 		}
 		/* Read from /proc/pid/exe if live. */
 		if (is_live)
-- 
2.53.0



