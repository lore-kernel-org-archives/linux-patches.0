Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E76221543;
	Mon, 23 Jun 2025 22:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717548; cv=none; b=cJqgu73OdsW+oTlKvGFgIzC2Dho4Xkk78PrlMZZtZzMynfi0fhgtKItTyGNT7czu18UvYxEvVtPntvxFtGnJUCYYrySqHHUhhUuB2rw88LrTPk/IlMbnaUyWVJpm3yJWWmD7EyBb6B+TYZ/FGxhvugJk3J2kGxGlbCe1q10TC/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717548; c=relaxed/simple;
	bh=CnnuTi5oGar73iwmeqyNWOPlGKR5d8sgsvhQb1lJ01A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOpgn7o363VMAgQRf/9mgIHy8Do7HB3XlvKG1R5UepY2aGcFKhThiOjKSjC9kRTlaWdgYZbrYXXk6gQO4nka3YMeLcGYs0ycppLGyfqodjm7D6qFjIkVUxAi6Yc31g44Fl/nyVvKTBqvpPpHuL1MbLQqnCaskZfQhthx0wsCry8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXS74aTv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXS74aTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5BBC4CEEA;
	Mon, 23 Jun 2025 22:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717548;
	bh=CnnuTi5oGar73iwmeqyNWOPlGKR5d8sgsvhQb1lJ01A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXS74aTvS2wMidmhyCFzEtrsadD1h1wPIkCk4bnyLYR/LWU/Z2mrhv9FhUu0zeoNZ
	 pBIXAukXsOdtne/sB3RBId8VrVi53GJHC+23eSTN/004bmLUuXDbTtZL/pquZ3prnV
	 pxKO3UJQWWbPR/15BKfgUMtXM+Wegu9XEPCy81zs=
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
Subject: [PATCH 6.12 411/414] perf evsel: Missed close() when probing hybrid core PMUs
Date: Mon, 23 Jun 2025 15:09:08 +0200
Message-ID: <20250623130652.224732800@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 81e0135cddf01..a1c71d9793bd8 100644
--- a/tools/perf/util/print-events.c
+++ b/tools/perf/util/print-events.c
@@ -282,6 +282,7 @@ bool is_event_supported(u8 type, u64 config)
 			ret = evsel__open(evsel, NULL, tmap) >= 0;
 		}
 
+		evsel__close(evsel);
 		evsel__delete(evsel);
 	}
 
-- 
2.39.5



