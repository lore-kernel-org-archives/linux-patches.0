Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7A0357A4A;
	Tue, 17 Mar 2026 17:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767183; cv=none; b=J3npkw3X+Q7ChfUpXYwsg33waQ1S+xL9+4KRbr5mO6sW9qTt8NdRszJN72rLk7eRZrHjre+M5yXDHtDOzQuL+9GVBAYdTlKuWu7A3V9DLu4iLY5IsD0I4wcdNP3E8TxPtDgQZ2YCEEenhoWX+zwjgtNuf6Dtuesx+fw0nActhbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767183; c=relaxed/simple;
	bh=jNU4AxmTHLyOgRUaJuHB1pLdLC2muvuoiHOX9eMZwFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ww4PnG12uyKf4L5yt8fJxVr0qAsgG5JxnwoTQVhgfjPLXqjUdwhA6mqkJqjm0birhPxEwMo1blMCzJUi+1k2DYx6/tb2KvNy8QCLrIaxYTYHcLac4+eDMS58UyPKwO3NcG1R9k8r4dqzlVn96Htr6RXHwGyN6jNTlE6qgFUXwEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/us8B/H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/us8B/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93550C4CEF7;
	Tue, 17 Mar 2026 17:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767183;
	bh=jNU4AxmTHLyOgRUaJuHB1pLdLC2muvuoiHOX9eMZwFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/us8B/H3PfR8oV/+znX2phl663ANLvY1HzFw24GyktVPl6yq2GBlAjfISWLcWvLh
	 emqn9DF6/GNzMj0m5bTBvEpNRtCU2NNMoXrAcORjK22mV6/4Ep9iuVSHka6Arh0sfn
	 ypRq27g0mA381fX63Y57NUc2eDn4u0TJ6pHqabCQ=
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
Subject: [PATCH 6.18 031/333] perf disasm: Fix off-by-one bug in outside check
Date: Tue, 17 Mar 2026 17:31:00 +0100
Message-ID: <20260317163000.516467799@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
index 88706b98b9064..b1be847446fea 100644
--- a/tools/perf/util/disasm.c
+++ b/tools/perf/util/disasm.c
@@ -412,7 +412,7 @@ static int jump__parse(struct arch *arch, struct ins_operands *ops, struct map_s
 	start = map__unmap_ip(map, sym->start);
 	end = map__unmap_ip(map, sym->end);
 
-	ops->target.outside = target.addr < start || target.addr > end;
+	ops->target.outside = target.addr < start || target.addr >= end;
 
 	/*
 	 * FIXME: things like this in _cpp_lex_token (gcc's cc1 program):
-- 
2.51.0



