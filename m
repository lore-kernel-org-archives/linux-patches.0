Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D031838AC92;
	Sat, 12 Sep 2026 08:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202793; cv=none; b=SHqeMbacpqbjz7sPYczW/MowWy8ZmZFWf89ouYccy9JlICLdpMFeH7FqKB7QAwQ3V5JwypjqAJzv1MXGAARFQTKr/rRT45ed14UogMDUvoGGvnhHimzOvGsmg21/FoOtkgz/E+6iJUDbIjh9+5sIgUjGuLXZWAFIfF2O/BBYZbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202793; c=relaxed/simple;
	bh=kxImsfQIEpWNrG3M4wD8uAcleIMEc4o7pcIPVrjfm0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFX1mj2LTg0CpAsHgPVJll38gV/k9OOtYx6aRfL3FcHNH80lU3GGshH4AyqJit6Fb8TtmTcc63vDbjIGs3uSVNkAY0GJblagsHThFlhz0T1fH5+IravhsS34AHsxFR12eDpE0cuzLjrnlD2ncK1RZMqcUqiOBwVojmvKHeM+4j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KnP7o9cM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KnP7o9cM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B88B1F000FF;
	Sat, 12 Sep 2026 08:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202791;
	bh=fmuieqObRkU5KUccqZPkD+//AmUUlZvWyteERLvil3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KnP7o9cMi2qA1M+dDtQj2tHn4D3y6EbLQg2E8rGXG8MspocgsSQg+olDQ4CAsTtf7
	 h/y+CLaxUJivw04J9soeXuBJwrzDLPnPmoZgis1C8z2HzKNy4tPJyDd1k8l8J6i6sp
	 W5e0badNhccJkhLekkET0SwX6u+S8LDg43Q1LBwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1274/1815] perf tools: Fix sb_evlist leaks in top and record
Date: Sat, 12 Sep 2026 08:50:24 +0200
Message-ID: <20260912065718.925371747@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 08e96e3c737bf63d917c6c4e0bb67450ad53f1d8 ]

Fix a memory leak in cmd_top() where top.sb_evlist was not freed if
evlist__add_bpf_sb_event() fails. Note that evlist__start_sb_thread() and
evlist__stop_sb_thread() take ownership of the evlist and free it, so
we must only free it if we fail before starting the thread. Also set
top.sb_evlist to NULL to prevent use-after-free bugs.

Apply the same fix to builtin-record.c to avoid leaking rec->sb_evlist
and calling pthread_join on uninitialized threads in the error path.

Assisted-by: Antigravity:gemini-3.1-pro
Fixes: b38d85ef49cf ("perf bpf: Decouple creating the evlist from adding the SB event")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-record.c | 2 ++
 tools/perf/builtin-top.c    | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f58d7e3c7879e..a57987851cf03 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -2258,6 +2258,8 @@ static int record__setup_sb_evlist(struct record *rec)
 
 		if (evlist__add_bpf_sb_event(rec->sb_evlist, perf_session__env(rec->session))) {
 			pr_err("Couldn't ask for PERF_RECORD_BPF_EVENT side band events.\n.");
+			evlist__put(rec->sb_evlist);
+			rec->sb_evlist = NULL;
 			return -1;
 		}
 	}
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 5933c46ee137e..570410599f1b3 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1881,6 +1881,8 @@ int cmd_top(int argc, const char **argv)
 		if (evlist__add_bpf_sb_event(top.sb_evlist, &host_env)) {
 			pr_err("Couldn't ask for PERF_RECORD_BPF_EVENT side band events.\n.");
 			status = -EINVAL;
+			evlist__put(top.sb_evlist);
+			top.sb_evlist = NULL;
 			goto out_put_evlist;
 		}
 	}
-- 
2.53.0



