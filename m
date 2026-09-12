Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABC347C0FB;
	Sat, 12 Sep 2026 12:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217779; cv=none; b=IB9CpqmOuRWle/aFtvGBCcBc3EXM5zh58LAbIc0Q/UudkrZ4HW/7Zpz35wFHHCOsWW1SA2u/0A+CeEixAC0/Nr2RoZTLtpAez5q07tAeJ22V0CixYBXCukeHTHxqHRgjElXSnfenqUNAeK0xndOC4VC25e3HszOGT+ufTQOoFhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217779; c=relaxed/simple;
	bh=4ujy4prjrUVm9hqgDYiCV0dAVo+ifKiftju76HJH4TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCdW8uhoZr2HuIBoBpChj8jA0NUfc+Dfs5dh/FMzHRSMUsMKdPQ6d2YZM+ZNEQ5T0xTQuaEc4k/LRma5CaZhB49pJeJr+WTaAruDnW50qSDefu0H6h2Dy3Gas/N362GkMTm0aiRmoDF4pLX7mf2zVm1o/do/SNDzhQJ2FHJGNV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vS8ob0VO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vS8ob0VO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCB81F000FF;
	Sat, 12 Sep 2026 12:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217778;
	bh=fcUTr4LxmJoUrzV/3M60EmqXVKiQNYnDe6n5UxDCi3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vS8ob0VOYlMUs6e/IIVLN/G7sberXST2KIjn5tAqpns0hNhfAZykxOOW928m/ZrFt
	 PuPeTjMWrf5l/gNte0izWel+egbvI+29BsN/mjvSfki+5JNdvlDAn0t/CN7TGlx9W5
	 S8EygAyt+GpZmEqnpxUxRG4bGzf0rp5glWqbZV/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Clark Williams <williams@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1008/1376] perf test: Introduce workloads__for_each()
Date: Sat, 12 Sep 2026 08:57:14 +0200
Message-ID: <20260912065630.030066443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

[ Upstream commit 18b63d63cd0148fef02c6c3f33a596ad7ee97a9a ]

And use it in run_workload().

Testing it:

  root@x1:~# perf trace -e *landlock* perf test -w landlock
       0.000 ( 0.015 ms): :1274331/1274331 landlock_add_rule(ruleset_fd: 11, rule_type: LANDLOCK_RULE_PATH_BENEATH, rule_attr: 0x7ffd3fea55e0, flags: 45) = -1 EINVAL (Invalid argument)
       0.018 ( 0.003 ms): :1274331/1274331 landlock_add_rule(ruleset_fd: 11, rule_type: LANDLOCK_RULE_NET_PORT, rule_attr: 0x7ffd3fea55f0, flags: 45) = -1 EINVAL (Invalid argument)
  root@x1:~# perf test -w bla
  No workload found: bla
  root@x1:~#

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Clark Williams <williams@redhat.com>
Link: https://lore.kernel.org/r/20241020021842.1752770-2-acme@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 44e82c4d2ff3 ("perf test: Fix skiplist leak in cmd_test")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/builtin-test.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 3aa4ab160947d..4f2f941bd1feb 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -156,6 +156,9 @@ static struct test_workload *workloads[] = {
 	&workload__traploop,
 };
 
+#define workloads__for_each(workload) \
+	for (unsigned i = 0; i < ARRAY_SIZE(workloads) && ({ workload = workloads[i]; 1; }); i++)
+
 static int num_subtests(const struct test_suite *t)
 {
 	int num;
@@ -505,11 +508,9 @@ static int perf_test__list(int argc, const char **argv)
 
 static int run_workload(const char *work, int argc, const char **argv)
 {
-	unsigned int i = 0;
 	struct test_workload *twl;
 
-	for (i = 0; i < ARRAY_SIZE(workloads); i++) {
-		twl = workloads[i];
+	workloads__for_each(twl) {
 		if (!strcmp(twl->name, work))
 			return twl->func(argc, argv);
 	}
-- 
2.53.0



