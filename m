Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2523175D5D;
	Wed,  5 Feb 2025 14:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766605; cv=none; b=TpK6f8yDXyLrrZV6mPOQnK36Qc+r/QCeKvAiaCvFh+ChG43j6Qz75bEfzw82jCDL4BJRAt2hLx8oEO3g9lyUtAAwwSrzBdEphKh7lqxdBH9Qbe/s20EbSXJxSTrnXwNDXFfWmjvTbqROOrjQp8QnCkSyyq/ge/irhC1IFvTewBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766605; c=relaxed/simple;
	bh=w3eeQlXGFRlgzHZm0b1YPbu/d0jV5hCsfXTAVeZJUFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrFtH+XivGe+Xaa8h6i6snPJt767po53q8siZufWALg04QrfTps4/OjMCGSYbtBiZOZe9jClNZYHYJYXsoQDCsH6ihl/9E6AZViks72i3DZOUHEGk+isCw+f/7M4fhHTFL+DTxfg+ossN9cHGsIgpBfhv2BY0QCnVu7NfWBHXjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b98A40d3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b98A40d3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC6DC4CEDD;
	Wed,  5 Feb 2025 14:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766604;
	bh=w3eeQlXGFRlgzHZm0b1YPbu/d0jV5hCsfXTAVeZJUFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b98A40d3aDsIqAFMFEaGKMQDtdgruKoGh6rrh7GLhpWOwg409iHuxxRXc+enFt0Fq
	 ldg5cXy+I1+kVh3vLdNOQu9IDCQPgqWVB2Cd6SL/HON5L4kiBaOm9VghSh8WGcBWRR
	 AtmCF/4VbK22jONzwBf1UCGx2WilcUDev+tRszNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Nigro <fnigro@redhat.com>,
	Ilan Green <igreen@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Clark Williams <williams@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Stephane Eranian <eranian@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Yonatan Goldschmidt <yonatan.goldschmidt@granulate.io>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 291/623] perf namespaces: Introduce nsinfo__set_in_pidns()
Date: Wed,  5 Feb 2025 14:40:33 +0100
Message-ID: <20250205134507.364498837@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 9c6a585d257f6845731f4e36b45fe42b5c3162f5 ]

When we're processing a perf.data file we will, for every thread in that
file do a machine__findnew_thread(machine, pid, tid) that when that pid
is seen for the first time will create a 'struct thread' representing
it.

That in turn will call nsinfo__new() -> nsinfo__init() and there it will
assume we're running live, which is wrong and will need to be addressed
in a followup patch.

The nsinfo__new() assumes that if we can't access that thread it has
already finished and will ignore the -1 return from nsinfo__init(), just
taking notes to avoid trying to enter in that namespace, since it isn't
there anymore, a race.

When doing this from 'perf inject', tho, we can fill in parts of that
nsinfo from what we get from the PERF_RECORD_MMAP2 (pid, tid) and in the
jitdump file name, that has the form of jit-<PID>.dump.

So if the pid in the jitdump file name is not the one in the
PERF_RECORD_MMAP2, we can assume that its the pid of the process
_inside_ the namespace, and that perf was runing outside that namespace.

This will be done in the following patch.

Reported-by: Francesco Nigro <fnigro@redhat.com>
Reported-by: Ilan Green <igreen@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yonatan Goldschmidt <yonatan.goldschmidt@granulate.io>
Link: https://lore.kernel.org/r/20241206204828.507527-4-acme@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 64a7617efd5a ("perf namespaces: Fixup the nsinfo__in_pidns() return type, its bool")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/namespaces.c | 5 +++++
 tools/perf/util/namespaces.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/tools/perf/util/namespaces.c b/tools/perf/util/namespaces.c
index cb185c5659d6b..36047184d76e2 100644
--- a/tools/perf/util/namespaces.c
+++ b/tools/perf/util/namespaces.c
@@ -271,6 +271,11 @@ pid_t nsinfo__in_pidns(const struct nsinfo  *nsi)
 	return RC_CHK_ACCESS(nsi)->in_pidns;
 }
 
+void nsinfo__set_in_pidns(struct nsinfo *nsi)
+{
+	RC_CHK_ACCESS(nsi)->in_pidns = true;
+}
+
 void nsinfo__mountns_enter(struct nsinfo *nsi,
 				  struct nscookie *nc)
 {
diff --git a/tools/perf/util/namespaces.h b/tools/perf/util/namespaces.h
index 8c0731c6cbb7e..e014becb9cd8e 100644
--- a/tools/perf/util/namespaces.h
+++ b/tools/perf/util/namespaces.h
@@ -59,6 +59,7 @@ pid_t nsinfo__tgid(const struct nsinfo  *nsi);
 pid_t nsinfo__nstgid(const struct nsinfo  *nsi);
 pid_t nsinfo__pid(const struct nsinfo  *nsi);
 pid_t nsinfo__in_pidns(const struct nsinfo  *nsi);
+void nsinfo__set_in_pidns(struct nsinfo *nsi);
 
 void nsinfo__mountns_enter(struct nsinfo *nsi, struct nscookie *nc);
 void nsinfo__mountns_exit(struct nscookie *nc);
-- 
2.39.5



