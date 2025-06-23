Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00381E51FA;
	Mon, 23 Jun 2025 21:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713894; cv=none; b=XO80HVwYM2T/AeDS6r6iyEXC1Q+uBEWoAMbp3KtyuuvVCkWkKYkk8XpzANhgEoKHniKu8Uhe5/Ssc2lKD0kAAAjRIWuCuJTHtgHQySnfWSrG4nU0TqNrcHHCq75I2f7P3wYQTrhcFnzC6d8GIp/n6GJqPeD7smBo2uxbYiaYU3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713894; c=relaxed/simple;
	bh=SdhCiqURNWeEz+jTcWQsln3/vf5HwTzSYkVz3B5C0Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z52Ey2MKoKzfzudbNpdtIr8i07THsNYzO9k8Qw7Mspic/aA809gfQ777njYP7mZ6N1lWWBtIh9nR5lYVcbbwuJHH4kvAijXOzP014nnPJB3FhUx73eWsBHsSAruQgmDcbG3zEkdKj6cysIw0HAJLRhoCtnD8Pq2KycZZ+4rRoQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8VLjUmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8VLjUmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D6EC4CEEA;
	Mon, 23 Jun 2025 21:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713893;
	bh=SdhCiqURNWeEz+jTcWQsln3/vf5HwTzSYkVz3B5C0Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8VLjUmhl2H8u50x/blr2ObTH9hqdlZkz9XayTrYH7UZWJPVqpiHMEhUbwQB8Z9xz
	 wKFcNIRMmv8evK6qfpSHsr0v83Aep3wGUhkbacbDZ8fOsMVN/k50+pEesNispUvMqs
	 uUPz1zD/L6QxlxYSliSepfQ3h8afO8bAnV/yENUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/508] perf ui browser hists: Set actions->thread before calling do_zoom_thread()
Date: Mon, 23 Jun 2025 15:02:58 +0200
Message-ID: <20250623130648.561969445@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 1741189d843a1d5ef38538bc52a3760e2e46cb2e ]

In 7cecb7fe8388d5c3 ("perf hists: Move sort__has_comm into struct
perf_hpp_list") it assumes that act->thread is set prior to calling
do_zoom_thread().

This doesn't happen when we use ESC or the Left arrow key to Zoom out of
a specific thread, making this operation not to work and we get stuck
into the thread zoom.

In 6422184b087ff435 ("perf hists browser: Simplify zooming code using
pstack_peek()") it says no need to set actions->thread, and at that
point that was true, but in 7cecb7fe8388d5c3 a actions->thread == NULL
check was added before the zoom out of thread could kick in.

We can zoom out using the alternative 't' thread zoom toggle hotkey to
finally set actions->thread before calling do_zoom_thread() and zoom
out, but lets also fix the ESC/Zoom out of thread case.

Fixes: 7cecb7fe8388d5c3 ("perf hists: Move sort__has_comm into struct perf_hpp_list")
Reported-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/Z_TYux5fUg2pW-pF@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index fd3e67d2c6bdd..a68d3ee1769d6 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -3238,10 +3238,10 @@ static int evsel__hists_browse(struct evsel *evsel, int nr_events, const char *h
 				/*
 				 * No need to set actions->dso here since
 				 * it's just to remove the current filter.
-				 * Ditto for thread below.
 				 */
 				do_zoom_dso(browser, actions);
 			} else if (top == &browser->hists->thread_filter) {
+				actions->thread = thread;
 				do_zoom_thread(browser, actions);
 			} else if (top == &browser->hists->socket_filter) {
 				do_zoom_socket(browser, actions);
-- 
2.39.5



