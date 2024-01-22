Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999F312F5A7;
	Tue, 23 Jan 2024 00:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969040; cv=none; b=keI9MH2gGt8cIq179tJta4vJmuAKiX3f0E+pwKyPJsc+BcEAm8QntTVl2FlUPkN4t8geJXLRltbtpWtPyWPhy2Nlw2IqSBBnzlF+rngzCmVpDJK0CY4XnjGBTRecsV4KJ8fpjyVIWCewXtJIjcQn85GVk5oC822HiP1S8KEYbWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969040; c=relaxed/simple;
	bh=jp9j6qBgtIkMcTuxE0QwCtTvwdQJNcdHnTS4ujV9ln0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgyRIUCAOTrUhmKfOv4TcioYSXSOs98omco54x0JEWuH2cHWDqkZV7kTdK8MW74UFpXZtr+drHI+Nc0KPxSwn3WVYJBy6BYNwMfmJHF4FCH0HhT11z6mUUy/vlYmemZn1CzydlfOeD27lv3eCLr1MO8lJVeDa6l/EvwuHElOWB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0oDdSR4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0oDdSR4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5C4C433F1;
	Tue, 23 Jan 2024 00:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969040;
	bh=jp9j6qBgtIkMcTuxE0QwCtTvwdQJNcdHnTS4ujV9ln0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0oDdSR4E97QBVEH+kFMIb8b1veKnTFPltbYYePMZzq3KPkI/X2FNWiIt4GUhIw1dg
	 R5dLwnX3PZC3KgTEKEob7J1mruLk90vP1+iU4J3XI676e6qvXUncesi22pcnxCFzJH
	 B23+cHZYA04XvXYHYDt1XDpRpN+vUldauu2EL4Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Song Liu <songliubraving@fb.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 175/194] perf top: Move sb_evlist to struct perf_top
Date: Mon, 22 Jan 2024 15:58:25 -0800
Message-ID: <20240122235726.722918189@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit ca6c9c8b107f9788662117587cd24bbb19cea94d ]

Where state related to a 'perf top' session is grouped.

Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Link: http://lore.kernel.org/lkml/20200429131106.27974-3-acme@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 9c51f8788b5d ("perf env: Avoid recursively taking env->bpf_progs.lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-top.c | 7 +++----
 tools/perf/util/top.h    | 2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b83a861fab2e..d83954f75557 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1542,7 +1542,6 @@ int cmd_top(int argc, const char **argv)
 	OPTS_EVSWITCH(&top.evswitch),
 	OPT_END()
 	};
-	struct evlist *sb_evlist = NULL;
 	const char * const top_usage[] = {
 		"perf top [<options>]",
 		NULL
@@ -1684,9 +1683,9 @@ int cmd_top(int argc, const char **argv)
 	}
 
 	if (!top.record_opts.no_bpf_event)
-		bpf_event__add_sb_event(&sb_evlist, &perf_env);
+		bpf_event__add_sb_event(&top.sb_evlist, &perf_env);
 
-	if (perf_evlist__start_sb_thread(sb_evlist, target)) {
+	if (perf_evlist__start_sb_thread(top.sb_evlist, target)) {
 		pr_debug("Couldn't start the BPF side band thread:\nBPF programs starting from now on won't be annotatable\n");
 		opts->no_bpf_event = true;
 	}
@@ -1694,7 +1693,7 @@ int cmd_top(int argc, const char **argv)
 	status = __cmd_top(&top);
 
 	if (!opts->no_bpf_event)
-		perf_evlist__stop_sb_thread(sb_evlist);
+		perf_evlist__stop_sb_thread(top.sb_evlist);
 
 out_delete_evlist:
 	evlist__delete(top.evlist);
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index f117d4f4821e..7bea36a61645 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -18,7 +18,7 @@ struct perf_session;
 
 struct perf_top {
 	struct perf_tool   tool;
-	struct evlist *evlist;
+	struct evlist *evlist, *sb_evlist;
 	struct record_opts record_opts;
 	struct annotation_options annotation_opts;
 	struct evswitch	   evswitch;
-- 
2.43.0



