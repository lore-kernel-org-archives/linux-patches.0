Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D97255F3C;
	Mon, 23 Jun 2025 13:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685433; cv=none; b=ZZYiP2DJ4u22YBatEElwY3FXGGAYBHOJQz6sC0Tf7fRow6R83H4KG7N2iDFwRzbvBqIja1fX/rcknXKIoTxRgvzraZWqLmgNdt1jiX2AJFBrYrZCrc2cV1UQESNKYjy+ptiAv5Vaa3ShZU5vxsBs0wbSyndgwbRiHCbjAfVxIss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685433; c=relaxed/simple;
	bh=bxB91XLfiQMSDzPLgKBpd7rm8J2ALb842OmvLPr5F8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bS2Ne+6Fb0SosfKx1OguUcehDbVSp2nQcmlFEdfmHlvVgLLdGW5jmqSBNrWqW+9WUA2YPd4ZY7XcMRTmbt/qsNUIikW+8Un2/c4bv5cRf4o3CHC4lDJ6Mwqj1uBO4mqaDzDZ5Gp8MAjAzVR0lvEfbrg5Lqhp3Cxo/m5Wvp0ZVF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0ZUTofj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0ZUTofj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BBCC4CEEA;
	Mon, 23 Jun 2025 13:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685433;
	bh=bxB91XLfiQMSDzPLgKBpd7rm8J2ALb842OmvLPr5F8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0ZUTofjtPlSWfXeHfV9KZTp/+ZfvIa1whaco5+QT0b6fUsK6cPUnNOMiFlgnKEWE
	 2/MG6lzI1swk8Cg4AZwizmTo3axWt8GV0YNfUt3Xj3OvpL+O2b/UILYRNBnL8LgLng
	 +ZaOu6PAx/GaRwGFOVCPTi940LI9rGVB0E+CatbA=
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
Subject: [PATCH 5.10 075/355] perf ui browser hists: Set actions->thread before calling do_zoom_thread()
Date: Mon, 23 Jun 2025 15:04:36 +0200
Message-ID: <20250623130629.078376300@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f2586e46d53e8..19e79e159996a 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -3241,10 +3241,10 @@ static int perf_evsel__hists_browse(struct evsel *evsel, int nr_events,
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



