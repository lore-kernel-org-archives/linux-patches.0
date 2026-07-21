Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8EB3B8BB9;
	Tue, 21 Jul 2026 19:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660496; cv=none; b=qXjSJT31Z+lYVxrTqhmoFDC3aAavP1hGdqZ2mfYK2K3x8j4tn/FF+X4h1rXyZM1q5HERtL/nz5Rj0jAro+O1pimQcky1Wxq7baLztuN/A/jLmkgpTZYwxhPC1oHaGcVBmln0I9ejycFuvAN/YZgQ6V4rD7hA+/ddYboXkq3u9Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660496; c=relaxed/simple;
	bh=Tu7FdCsllJZKTw1Kj+zityW/j4Stz1ZVSY+ZyG55gLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DBZiwrCytRNVMoup6AFZhYR9O3YlDXpL47dlLfGKK75pKMyudvh+UW02dXugLgrc+9jFF33I493lNBvJW6voqc/CmHQJ4ylRTaSURwbVW7uzvfa3hxNFlvY9Ndk/RbqB+qjHHgE59LHHKKzsAqaeS+GAdb/wpXjHddr/v4otPdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOnBXgFO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOnBXgFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915A91F00A3F;
	Tue, 21 Jul 2026 19:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660457;
	bh=ZPbNil/VMwrJLIbkm9+0E0NtyyJCv/CuKptl7/tfWxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NOnBXgFOMeculBD+blMoMlh1DsGwCCsNMqhdYJQOLAPtpOwHM7NumXHrDcdygT9X3
	 aId0ZWtpiQyxwS5N2F5i0mJGt16MyoNUmmdPJ8el0COxb7tpyWsdr61ihC5S7k+OSW
	 DFBRKd3y4lTpgR+6Ay0MOhHQBY7PHYwatT6zrzwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0987/2077] perf sched: Fix idle-hist callchain display using wrong rb_first variant
Date: Tue, 21 Jul 2026 17:11:00 +0200
Message-ID: <20260721152616.097792526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit d9b99dc8148e0c1f5da3942131b47e0d21187a32 ]

timehist_print_idlehist_callchain() calls rb_first_cached() on
sorted_root, but the sort function (callchain_param.sort) populates it
via rb_insert_color() on the plain rb_root member — not the cached
variant.  This means rb_leftmost is never set, so rb_first_cached()
always returns NULL and the entire callchain summary is silently
dropped from --idle-hist output.

The original code in ba957ebb54893aca ("perf sched timehist: Show
callchains for idle stat") was correct — it used struct rb_root and
rb_first().  The bug was introduced when sorted_root was converted to
rb_root_cached without converting the sort insertion path to use
rb_insert_color_cached().

Use rb_first(&root->rb_root) to match how the tree was populated.

Fixes: cb4c13a5137766c3 ("perf sched: Use cached rbtrees")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 6cf034f60c6667..2ccda1e382930a 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3133,7 +3133,8 @@ static size_t timehist_print_idlehist_callchain(struct rb_root_cached *root)
 	size_t ret = 0;
 	FILE *fp = stdout;
 	struct callchain_node *chain;
-	struct rb_node *rb_node = rb_first_cached(root);
+	/* sort() uses rb_insert_color() on rb_root, not rb_root_cached */
+	struct rb_node *rb_node = rb_first(&root->rb_root);
 
 	printf("  %16s  %8s  %s\n", "Idle time (msec)", "Count", "Callchains");
 	printf("  %.16s  %.8s  %.50s\n", graph_dotted_line, graph_dotted_line,
-- 
2.53.0



