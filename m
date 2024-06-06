Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90E019750D;
	Thu,  6 Jun 2024 14:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682954; cv=none; b=e2lztT84cdFVsXhw6KeU/KvtOek8ie5wzLcIGNYe+/il8U04dC26DL/l14O4uctZdfJrE7uF2OGtiMRjCuwt0C6/rsdMob+rDAAwMDA2EyvtLh5UuBKiQxpUrBS9fQw/fQiEbSDnFNJ1ptMIWFOz3GERMIdIFMtE0OBQaDvGWqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682954; c=relaxed/simple;
	bh=v3d0BWdK9zawT1JI87PFHxXUrPk2uoMlrKMqHF9g69I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vimx08YGZAxICOAUviTKIR4uXRW3sWBZgDG2OwcJ8BNrHiKdVR9W/yA7iPbfqEO7GoKx4j1D6aM5EtcpKrN/FRt0rhJ9Qydjicr90iecvb19IxDBSfxaTjwzLW5pJ59PZkoJSEcasfqhSJe3x5ZuaQg02xOCx3FnHp+zhkxW2WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eq9Gl5o3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eq9Gl5o3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E81C2BD10;
	Thu,  6 Jun 2024 14:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682954;
	bh=v3d0BWdK9zawT1JI87PFHxXUrPk2uoMlrKMqHF9g69I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eq9Gl5o3KU7E/vlr+W4FhzeEMEO6Aj1b0YFEPpwnr2i/gDNXvfJ+4BegZOB8fOaxo
	 BehKdNjjuMSAWG3p28iF4iSE7rUq82CzKBP2ASCNyU8/f5VNvk/hEImLsfyZ5TLBMY
	 f0BmB5DDfRlTYp96SlozOLxMUVP5wkbFvZoUnd94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 120/374] perf annotate: Fix segfault on sample histogram
Date: Thu,  6 Jun 2024 16:01:39 +0200
Message-ID: <20240606131655.942275683@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 9ef30265a483f0405e4f7b3f15cda251b9a2c7da ]

A symbol can have no samples, then accessing the annotated_source->samples
hashmap will result in a segfault.

Fixes: a3f7768bcf48281d ("perf annotate: Fix memory leak in annotated_source")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240510210452.2449944-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/annotate.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 617b98da377e5..79d082155c2f9 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -893,10 +893,11 @@ static __maybe_unused void annotated_source__delete(struct annotated_source *src
 	if (src == NULL)
 		return;
 
-	hashmap__for_each_entry(src->samples, cur, bkt)
-		zfree(&cur->pvalue);
-
-	hashmap__free(src->samples);
+	if (src->samples) {
+		hashmap__for_each_entry(src->samples, cur, bkt)
+			zfree(&cur->pvalue);
+		hashmap__free(src->samples);
+	}
 	zfree(&src->histograms);
 	free(src);
 }
-- 
2.43.0



