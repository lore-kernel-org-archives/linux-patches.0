Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D3C3F23BE;
	Sat, 12 Sep 2026 10:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209857; cv=none; b=SofYPTXgsOiX/hJJD8ewniGbP2TXUxtL4k8LZEFLMdaMBwSLZ6dGlAICwXHlWYft+Mt1rRRq/FeiHE/uVMltN6kAiXAWTvdldXvQtfqVyx1zTa/zJ6fFczUsqjgzh/wo6kMmA2uIwERMnkHdrIaABtQXjEbDElxDTE89zpp8us4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209857; c=relaxed/simple;
	bh=xc0tvc65ajeVNX6I9ye6eFcjXjI2RQDZ8EqbFnQ/irk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfVG7znQr43oJGMG+Rt0U2yC0n/fxyiAdJtr8F1vYdyijf8y0sPlbiMgeIUi7ITq6WlzoprbJ+l/zag8KovhGI017CZWH5uRlTiXDQ88afLMVg9/Ci3PGSn3vafJyV1V+o+okItcx5inivxzIg1QcMS9ljlHVTrQWQRbviZyibY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPEX7C2u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPEX7C2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958241F000FF;
	Sat, 12 Sep 2026 10:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209855;
	bh=mtmRdVF6JXOUJOSf1jkTtiXfeX/njYz9Ifmp0Stg1nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPEX7C2u/EdF7PqKPM4I5Fp3gMDOQjUeUr9fON78+sLY50dTEERIxm1K6/9Qx/myj
	 ah7HUm/5bbpmkieQnRwd/daPVvcG18yBoDKrZB1/0Gf21Cov72GPv0dqQ3Zwki5qBu
	 2DLLTfO6wF4gh4HQpki6bbD7e5YAVvJFrZVqpM80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0906/1518] perf report: Fix histogram entry collapsing for -F option
Date: Sat, 12 Sep 2026 08:51:15 +0200
Message-ID: <20260912065643.949424816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 5d35d829bb0b19ee51be9732e3b5f81abc7ef3bb ]

Users can use -F/--fields option to set output fields and sort keys
together.

But it missed to set perf_hpp_list->need_collapse for sort entries that
have se_collapse callbacks.

So it ends up with having duplicated entries separately.

For example, let's run this command first.

  $ perf mem record -t load -U -- perf test -w datasym

This will record samples for memory access (load) to struct 'buf' and a
loop condition ('sig_atomic_t') types.

So the following two commands should have identical output.

  $ perf report -s type --stdio --percent-limit=1 -q
      87.80%  perf                  buf
      12.17%  perf                  sig_atomic_t

But using -F option didn't collapse the entries based on types so the
result looked like below:

  $ perf report -F overhead,type --stdio --percent-limit=1 -q
      23.31%  perf                  buf
      22.84%  perf                  buf
      21.26%  perf                  buf
      20.39%  perf                  buf
      12.17%  perf                  sig_atomic_t

Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: f53f5c2437c1 ("perf c2c: Fix error masking, OOM, and unchecked caller errors in hpp_list__parse()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/sort.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index f3a565b0e2307..3d4b68fd6e445 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -3585,6 +3585,9 @@ static int __sort_dimension__add_output(struct perf_hpp_list *list,
 	if (__sort_dimension__add_hpp_output(sd, list, level) < 0)
 		return -1;
 
+	if (sd->entry->se_collapse)
+		list->need_collapse = 1;
+
 	sd->taken = 1;
 	return 0;
 }
-- 
2.53.0



