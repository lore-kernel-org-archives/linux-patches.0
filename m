Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DCE33F8A1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300898; cv=none; b=dRvIS0i0Z5nxS9ZS2EIrfC41O3g+4a7aw05GiFal+jyQWEWu2WYX03RGpAI8bDZW29+yB7U8WT6g+iZE2ldzHTyS+N4Dyrabf5lhNoHBcnA95oDcJFkgyxYtAIfJGw+tjYCmYmmM178tcc/CIREieWGcQdQ+N/B4azGhkiyjqTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300898; c=relaxed/simple;
	bh=7uvaeHPoSH2tKbMUr/MemqSD7tr+E+a5e34IHw6SqrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWiqM2+w7H4CZIjpdF4ZgvaMX6Moi1vDZTzIM2Z0VTECNxlKVBaaOzxqoxYI1DJfLjSPh8r/RxN1HBa2zSc58adDkBsAGzXo/7Rgau1nCxMWbHgd6t+YXfyumINNpuHXDPrmy8L5FzL+BZxIieGBGVP9V+wuNJyIBPHNr5fPzh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t19EWmNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t19EWmNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E66EC2BC87;
	Sat, 28 Feb 2026 17:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300898;
	bh=7uvaeHPoSH2tKbMUr/MemqSD7tr+E+a5e34IHw6SqrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t19EWmNIj4RKX0y2AHBVwftAkdRPb8fQgukw3HPOb3IAQrD46ld7ux5f4pM+ZYcD3
	 WGeYN6RT45YgfHjUeqTID1IUSXl5tSJf0Z2plzOI2fHC15F3zN/qaMtOryGfK0LhsQ
	 bmpZR/Oa9EPpN8k3o5R50/rwcLtFiY41pf/8AbPGixaeuiV3Tubaz9NBHn9nxUFYjb
	 5sfmzCm2qIN9RhYNUHz3NObSWh5jyK3bZWXVRnpuB/yY7Q4y7jvSIkLH97CRUkDiRG
	 gNS+BqWMdnC0ikvltUo7NT2WGkbj1G4R763zRa9mU0VlJmIo2jQ8xfi1EraGyAKPBe
	 nJ8Z1OA3GT+Mg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Suchit Karunakaran <suchitkarunakaran@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/752] perf annotate: Fix memcpy size in arch__grow_instructions()
Date: Sat, 28 Feb 2026 12:35:25 -0500
Message-ID: <20260228174750.1542406-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Suchit Karunakaran <suchitkarunakaran@gmail.com>

[ Upstream commit f0d98c78f8bf73ce2a9b7793f66cda240fa9ab10 ]

The memcpy() in arch__grow_instructions() is copying the wrong number of
bytes when growing from a non-allocated table.

It should copy arch->nr_instructions * sizeof(struct ins) bytes, not
just arch->nr_instructions bytes.

This bug causes data corruption as only a partial copy of the
instruction table is made, leading to garbage data in most entries and
potential crashes

Fixes: 2a1ff812c40be982 ("perf annotate: Introduce alternative method of keeping instructions table")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Suchit Karunakaran <suchitkarunakaran@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/disasm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/disasm.c b/tools/perf/util/disasm.c
index 924429142631a..88706b98b9064 100644
--- a/tools/perf/util/disasm.c
+++ b/tools/perf/util/disasm.c
@@ -81,7 +81,7 @@ static int arch__grow_instructions(struct arch *arch)
 	if (new_instructions == NULL)
 		return -1;
 
-	memcpy(new_instructions, arch->instructions, arch->nr_instructions);
+	memcpy(new_instructions, arch->instructions, arch->nr_instructions * sizeof(struct ins));
 	goto out_update_instructions;
 }
 
-- 
2.51.0

