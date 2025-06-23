Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFB01F7580;
	Mon, 23 Jun 2025 22:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717033; cv=none; b=n8a9srIXEw16Yt3BWvNBeYqGzy/9dNk3VUP0d8p3buVUGdaqqB5nEuMmrTtL4C2eipEXHvoZdLJ68ghT8yAr34OAW3N1veBUrlNVSbPT8CAEVVpCquGET2FvvhBEtWAE6ZRjkexForNW4o8Bo2WBJ5GlOnPPIBJQ9VqJDcOXcNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717033; c=relaxed/simple;
	bh=mA2JlrbQl7AhTgYiKSUMX9E18GuHyPp2Va7WjYH+Jlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppWbSLW1qlliJBjoTk1eqbyfi5EH0FqpS0sgCC4E3qSAWlHk1MaFj7hgNSHKv0LVHtAEiQ9bO9650bstnRYsZGTJ83S/e0bpvVpftk3/YXtcxjFj8yPtQ8c/z8fLlTv21rdUnLhtqjcKaOG8jklidonprtLO176dblMIXlvyj3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/WNtzvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/WNtzvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F0CC4CEEA;
	Mon, 23 Jun 2025 22:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717033;
	bh=mA2JlrbQl7AhTgYiKSUMX9E18GuHyPp2Va7WjYH+Jlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/WNtzvM69MKamLRDYZVBUO4Mkpzbkb2q39LHzkUFjQLLZ1NRqwuXGVugSsVV+taQ
	 k0H+zlAdJbNAeSD2bo1TU2TAZ4hjISCbW/jF3oVXrMI/H/PhUNynA6YEWM2pWKDCrG
	 pD+EcOajDkSuNuOTET31a3i+Sibp2JF6KSaE4O9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Michael Petlan <mpetlan@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Namhyung Kim <namhyung.kim@lge.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 579/592] perf evsel: Missed close() when probing hybrid core PMUs
Date: Mon, 23 Jun 2025 15:08:57 +0200
Message-ID: <20250623130714.209725389@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit ebec62bc7ec435b475722a5467d67c720a1ad79f ]

Add missing close() to avoid leaking perf events.

In past perfs this mattered little as the function was just used by 'perf
list'.

As the function is now used to detect hybrid PMUs leaking the perf event
is somewhat more painful.

Fixes: b41f1cec91c37eee ("perf list: Skip unsupported events")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Link: https://lore.kernel.org/r/20250614004108.1650988-2-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/print-events.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/print-events.c b/tools/perf/util/print-events.c
index a786cbfb0ff56..83aaf7cda6359 100644
--- a/tools/perf/util/print-events.c
+++ b/tools/perf/util/print-events.c
@@ -268,6 +268,7 @@ bool is_event_supported(u8 type, u64 config)
 			ret = evsel__open(evsel, NULL, tmap) >= 0;
 		}
 
+		evsel__close(evsel);
 		evsel__delete(evsel);
 	}
 
-- 
2.39.5



