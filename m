Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047754;
	b=XsWnEgte9/FOvRlPxqDC/o6dDqilQgqeI+N0CnkB25A7AWBkzHO7RLjUxO5jLCdgXorP
	 M0ioknNZCvuwnU0J+e/mk5Eq4twW0bRXtmuTISxIc1OaPJC6B86/pUsDfhAGfPTMuyalK
	 O8kdZgTOZSm+AFnV3s60+HSQvujvm0J2tV9zNLH9tXHcHYI/iqQibi0zdUVVGEiKynx7b
	 MLyrbZtZiJNbnoxKjlFMoXStr9yjw9Y48LG2l4cIDlaL1YacQDQosA+sB2qisNZC0843U
	 AA6bnRmEG7EIcwx6AwFAbN9OkjPkqF6Tp/ysrRb8+l1jsXl5LU2PgzLfiifPSDktAbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BsdkmitIE433tQwvd0ZjbMcA1tQUebDcbaVT1TIrEr0=;
	b=a6k1HaHQPCyXfC2Loztg/4TOTn3h4sJX7mdAlTOD+EQrF6V+iZtUKGgOCJ08lNRZbom+
	 J5RI1+FdGthjbbY9aUDpn8G7eEl/wngFKQyMXId+afm6a35Fw6Fa502MHstUN+0JKDZ7v
	 +Fp/LRcD1bJiut+ShCnjY3VSRPLeDEgqG/zH17r3VYN6ZOPc+IsKiMQBIaG9cxEdXQ+f3
	 wOcYgD8x3OeBRP0lzKg+RIUBM2jMwMzllsLdaJG8++IK3bpII1BYPZmOh9JvN8S+gV2Q0
	 0UmWWLAMJw3WBb3KAxrNuc1rhVsYB7hNxuVg2x1oxMAylakyyag5TXY0Lv8zhTAdnmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPJOfwfi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97F2606A320;
	Thu, 19 Nov 2026 00:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPJOfwfi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C871F000C4;
	Thu, 19 Nov 2026 00:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047754;
	bh=BsdkmitIE433tQwvd0ZjbMcA1tQUebDcbaVT1TIrEr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPJOfwfi2ijAOJesKJXujIRaTENTrwhW+DqbCwRYhIPakTuanm1kvaqGWy9khLZ5K
	 vS6hIkB7VEODnl1lsDeY9KplYUqU01V7AlP4BsLCOhBc2MwhpbnmLE5l0uzLAmv/RE
	 L/4ZZQHuB40rn7h7reBlvbfSKnFKI1Qng2UEwmkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Brian Robbins <brianrob@linux.microsoft.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Yuan Can <yuancan@huawei.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1752/2857] perf jit: Fix a few memory leaks
Date: Wed, 18 Nov 2026 15:46:26 +0100
Message-ID: <20261118150304.381252826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit dc67c7837a832952459c4f7829e89b9d8d15f420 ]

As reported by leak sanitizer.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Brian Robbins <brianrob@linux.microsoft.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20230403203545.1872196-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 4eddf7d9e341 ("perf jitdump: Use dirname() return value in jit_open()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/genelf_debug.c | 45 +++++++++++++++++++++-------------
 tools/perf/util/jitdump.c      |  7 +++++-
 2 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/genelf_debug.c b/tools/perf/util/genelf_debug.c
index dd40683bd4c00..8786c366566e6 100644
--- a/tools/perf/util/genelf_debug.c
+++ b/tools/perf/util/genelf_debug.c
@@ -87,6 +87,12 @@ buffer_ext_init(struct buffer_ext *be)
 	be->max_sz = 0;
 }
 
+static void
+buffer_ext_exit(struct buffer_ext *be)
+{
+	free(be->data);
+}
+
 static inline size_t
 buffer_ext_size(struct buffer_ext *be)
 {
@@ -487,28 +493,28 @@ jit_add_debug_info(Elf *e, uint64_t code_addr, void *debug, int nr_debug_entries
 	Elf_Scn *scn;
 	Elf_Shdr *shdr;
 	struct buffer_ext dl, di, da;
-	int ret;
+	int ret = -1;
 
 	buffer_ext_init(&dl);
 	buffer_ext_init(&di);
 	buffer_ext_init(&da);
 
-	ret = jit_process_debug_info(code_addr, debug, nr_debug_entries, &dl, &da, &di);
-	if (ret)
-		return -1;
+	if (jit_process_debug_info(code_addr, debug, nr_debug_entries, &dl, &da, &di))
+		goto out;
+
 	/*
 	 * setup .debug_line section
 	 */
 	scn = elf_newscn(e);
 	if (!scn) {
 		warnx("cannot create section");
-		return -1;
+		goto out;
 	}
 
 	d = elf_newdata(scn);
 	if (!d) {
 		warnx("cannot get new data");
-		return -1;
+		goto out;
 	}
 
 	d->d_align = 1;
@@ -521,7 +527,7 @@ jit_add_debug_info(Elf *e, uint64_t code_addr, void *debug, int nr_debug_entries
 	shdr = elf_getshdr(scn);
 	if (!shdr) {
 		warnx("cannot get section header");
-		return -1;
+		goto out;
 	}
 
 	shdr->sh_name = 52; /* .debug_line */
@@ -536,13 +542,13 @@ jit_add_debug_info(Elf *e, uint64_t code_addr, void *debug, int nr_debug_entries
 	scn = elf_newscn(e);
 	if (!scn) {
 		warnx("cannot create section");
-		return -1;
+		goto out;
 	}
 
 	d = elf_newdata(scn);
 	if (!d) {
 		warnx("cannot get new data");
-		return -1;
+		goto out;
 	}
 
 	d->d_align = 1;
@@ -555,7 +561,7 @@ jit_add_debug_info(Elf *e, uint64_t code_addr, void *debug, int nr_debug_entries
 	shdr = elf_getshdr(scn);
 	if (!shdr) {
 		warnx("cannot get section header");
-		return -1;
+		goto out;
 	}
 
 	shdr->sh_name = 64; /* .debug_info */
@@ -570,13 +576,13 @@ jit_add_debug_info(Elf *e, uint64_t code_addr, void *debug, int nr_debug_entries
 	scn = elf_newscn(e);
 	if (!scn) {
 		warnx("cannot create section");
-		return -1;
+		goto out;
 	}
 
 	d = elf_newdata(scn);
 	if (!d) {
 		warnx("cannot get new data");
-		return -1;
+		goto out;
 	}
 
 	d->d_align = 1;
@@ -589,7 +595,7 @@ jit_add_debug_info(Elf *e, uint64_t code_addr, void *debug, int nr_debug_entries
 	shdr = elf_getshdr(scn);
 	if (!shdr) {
 		warnx("cannot get section header");
-		return -1;
+		goto out;
 	}
 
 	shdr->sh_name = 76; /* .debug_info */
@@ -601,9 +607,14 @@ jit_add_debug_info(Elf *e, uint64_t code_addr, void *debug, int nr_debug_entries
 	/*
 	 * now we update the ELF image with all the sections
 	 */
-	if (elf_update(e, ELF_C_WRITE) < 0) {
+	if (elf_update(e, ELF_C_WRITE) < 0)
 		warnx("elf_update debug failed");
-		return -1;
-	}
-	return 0;
+	else
+		ret = 0;
+
+out:
+	buffer_ext_exit(&dl);
+	buffer_ext_exit(&di);
+	buffer_ext_exit(&da);
+	return ret;
 }
diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 9d44a039464eb..6e8fff117364e 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -240,9 +240,11 @@ jit_open(struct jit_buf_desc *jd, const char *name)
 	 */
 	strcpy(jd->dir, name);
 	dirname(jd->dir);
+	free(buf);
 
 	return 0;
 error:
+	free(buf);
 	funlockfile(jd->in);
 error_noflock:
 	free(buf);
@@ -561,7 +563,7 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 
 	ret = perf_event__process_mmap2(tool, event, &sample, jd->machine);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = jit_inject_event(jd, event);
 	/*
@@ -570,6 +572,8 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 	if (!ret)
 		build_id__mark_dso_hit(tool, event, &sample, NULL, jd->machine);
 
+out:
+	free(event);
 	return ret;
 }
 
@@ -924,6 +928,7 @@ jit_process(struct perf_session *session,
 	}
 
 	nsinfo__put(jd.nsi);
+	free(jd.buf);
 
 	return ret;
 }
-- 
2.53.0



