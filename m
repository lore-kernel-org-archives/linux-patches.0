Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309B96FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B1CC433D9;
	Sun, 17 Sep 2023 20:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980978;
	bh=sqnRGiiEFGhGG6ugw0LqK9GGqS8gdF2KOYCRPytx0Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0ZQFFAzVMMRLM4e86opf47hA9B0rj/rw4fv3whnOXRmPHey8G5RPVJXsLQE0bnH7
	 jQNNCNIBI3ci6DpRwLNGQanxa4llPDgX3z2RP9CoE14IjU2QwkQtVJ9GD8HNIo8fq+
	 RRnTRnSe0U9cNOhwKo6sl3YBJQ0D7LlE8JicBDTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/219] perf trace: Use zfree() to reduce chances of use after free
Date: Sun, 17 Sep 2023 21:13:11 +0200
Message-ID: <20230917191043.315076488@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 9997d5dd177c52017fa0541bf236a4232c8148e6 ]

Do defensive programming by using zfree() to initialize freed pointers
to NULL, so that eventual use after free result in a NULL pointer deref
instead of more subtle behaviour.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 7962ef13651a ("perf trace: Really free the evsel->priv area")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 97b17f8941dc0..6392fcf2610c4 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2293,7 +2293,7 @@ static void syscall__exit(struct syscall *sc)
 	if (!sc)
 		return;
 
-	free(sc->arg_fmt);
+	zfree(&sc->arg_fmt);
 }
 
 static int trace__sys_enter(struct trace *trace, struct evsel *evsel,
@@ -3129,7 +3129,7 @@ static void evlist__free_syscall_tp_fields(struct evlist *evlist)
 		if (!et || !evsel->tp_format || strcmp(evsel->tp_format->system, "syscalls"))
 			continue;
 
-		free(et->fmt);
+		zfree(&et->fmt);
 		free(et);
 	}
 }
@@ -4765,11 +4765,11 @@ static void trace__exit(struct trace *trace)
 	int i;
 
 	strlist__delete(trace->ev_qualifier);
-	free(trace->ev_qualifier_ids.entries);
+	zfree(&trace->ev_qualifier_ids.entries);
 	if (trace->syscalls.table) {
 		for (i = 0; i <= trace->sctbl->syscalls.max_id; i++)
 			syscall__exit(&trace->syscalls.table[i]);
-		free(trace->syscalls.table);
+		zfree(&trace->syscalls.table);
 	}
 	syscalltbl__delete(trace->sctbl);
 	zfree(&trace->perfconfig_events);
-- 
2.40.1



