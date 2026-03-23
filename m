Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BC41A6818;
	Mon, 23 Mar 2026 14:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275255; cv=none; b=G82m1g5QGZiNCKr3PT/Qf2pVwMlfPdzgRwoQTZTNMIlM+s+hfz10OG8U3cctWSyFLjjxbzSL8jCrSqLgR2WEMRVA2YF1EqDCs2W+rFla7R0gWGGPrEMOseh19D1wZJQpCJXS16SyXsuV/MxwxUTxdokl6p+Ay+1y9u0sb35nhds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275255; c=relaxed/simple;
	bh=e3t+4b3SADgb9Bf5Mew6nhi4DY0M3CIe+p5ubcBJhF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8HUYvNakjbi1s/5nfIlA/CVg8cYCVt57IFK+mDd+fjQglkcEvijrrYVywtP5JOgX6nGBdRS19LF2YuXNJVdKcA71zMgEZhUDLnNHkYdIAycSzrJLHSkMGFcRbYePi4QbfZm9c1mb7ki56SHSXf+oFN2VZWMCxZx1POAw0I7gvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vMCmZWCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vMCmZWCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC53C4CEF7;
	Mon, 23 Mar 2026 14:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275255;
	bh=e3t+4b3SADgb9Bf5Mew6nhi4DY0M3CIe+p5ubcBJhF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vMCmZWCMXW/zdRGSinrnATvM0xScOxWVKYE1TSdTetJ9Dz1wgGIufIm0UrKBXSHfm
	 lIGkNCcVOq3tbNiUlouE9CN5Tf7Ug7zgtEklbd17Bp8t7HHc1952DWlg4g+n1mOR2u
	 528PZgf68IiqthAiCO9hTkXK/7sRIHamBCfgNf9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Peter Collingbourne <pcc@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Bill Wendling <morbo@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Justin Stitt <justinstitt@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/460] perf disasm: Fix off-by-one bug in outside check
Date: Mon, 23 Mar 2026 14:40:26 +0100
Message-ID: <20260323134527.436583113@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Peter Collingbourne <pcc@google.com>

[ Upstream commit b3ce769203a99d6f3c6d6269ec09232a8c5da422 ]

If a branch target points to one past the end of a function, the branch
should be treated as a branch to another function.

This can happen e.g. with a tail call to a function that is laid out
immediately after the caller.

Fixes: 751b1783da784299 ("perf annotate: Mark jumps to outher functions with the call arrow")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Peter Collingbourne <pcc@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://linux-review.googlesource.com/id/Ide471112e82d68177e0faf08ca411d9fcf0a7bdf
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/disasm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/disasm.c b/tools/perf/util/disasm.c
index 2dc93199ac258..8a6f450c6f8e7 100644
--- a/tools/perf/util/disasm.c
+++ b/tools/perf/util/disasm.c
@@ -408,7 +408,7 @@ static int jump__parse(struct arch *arch, struct ins_operands *ops, struct map_s
 	start = map__unmap_ip(map, sym->start);
 	end = map__unmap_ip(map, sym->end);
 
-	ops->target.outside = target.addr < start || target.addr > end;
+	ops->target.outside = target.addr < start || target.addr >= end;
 
 	/*
 	 * FIXME: things like this in _cpp_lex_token (gcc's cc1 program):
-- 
2.51.0



