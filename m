Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21591415F0A;
	Tue, 21 Jul 2026 18:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657254; cv=none; b=tT56KmZi8cciAIb48uzfEgcUT0b6j3TuxOGXk76ENp7Ghu8i0hkESPvZk6cltKveHBHh9LbfDB8C8yLZPoJmuq4QSGiuSjD4S178CQjT70tME/VCWERVkr26jt11IGiJfw0bSFexS9hwaeq4w6Hj6HbbTSwC9JhzQNRYgp+QK70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657254; c=relaxed/simple;
	bh=eNgxkywue2yaZFYqRnMfqJ2Tj18qIQVHUKg0ZbNiUf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TiGt/ts2n6vLRzVTtc9tCnFWzmDzS7136v54OgYD1EH+QSyYAZPJfC2FbYfL5g6yGlqp6yB9bhu3gUAObwRii3WtXhY6Mt8XyPTUIYNpd4BuNVaJpAExjbTRlHtdTyJxQxLbQkORMbwr7pa/js1/cRzSBzzTxBl+DkIN9h5RK/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BKlElGJT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKlElGJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B111F00A3A;
	Tue, 21 Jul 2026 18:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657253;
	bh=E1Z4vWtUv8zr6uwANC+fLSorDD2eLvLL1t8VZwdnTGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BKlElGJTN9Bc0nQC2lTbzrIjCSIN25ltjWvrjhAa1xLM7E5KN6bZGoocZ0tL8hLj6
	 I54NCsbNFyDDWo6XxgRkByqjP4XTVT1Bs4icuvSE9pG703fxo6m1819j/iMtQRKZuC
	 N1F5MSNyRXVx2Y9JCNsNcEuZXzFxASWTvVmdjNEQ=
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
Subject: [PATCH 6.18 0693/1611] perf sched: Fix idle-hist callchain display using wrong rb_first variant
Date: Tue, 21 Jul 2026 17:13:29 +0200
Message-ID: <20260721152530.968840510@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 074de58c8675b7..00d52816185f69 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3111,7 +3111,8 @@ static size_t timehist_print_idlehist_callchain(struct rb_root_cached *root)
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



