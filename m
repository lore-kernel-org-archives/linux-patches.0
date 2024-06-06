Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05FF19D09F;
	Thu,  6 Jun 2024 14:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683482; cv=none; b=Ebe8e3n3dLQhjuSzyHTVe4ZhiVPWhDw6dqkpA3D2uCWpJA41QT9t1pLG7YuUWHJKIm+H9y8YWfHgX/NyqBfHVkbw/yPLnUYDo8WqD+k3ul9bwl3aBSUxhpYqY8JThSrTidV/EgzGYRTkXDPoxx7XdjkR0YrrVa4xdRi3JuLNvjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683482; c=relaxed/simple;
	bh=CmFODyk6xXiUPZitWNmnChP1mvuGGtAzcHR+X8NTsfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUkHa/4+UtrldMD7OWDlPDEFsJygoW/9mmXH9xXZG8u6pE2SsOBQY9uuYVbxyvT6vC8vCNByohjRIMhbJpg4Avg/0x5pbhjWq7NMtdeGdF179k6MIZuw83uopNHP23RkxPdX2C/tGoXfQT6coJRC0vdWkSXMfxz6heNJzsHjwIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrUwnE9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrUwnE9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1EBC2BD10;
	Thu,  6 Jun 2024 14:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683481;
	bh=CmFODyk6xXiUPZitWNmnChP1mvuGGtAzcHR+X8NTsfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrUwnE9HeLo4NVg6MT8OkvqbXsPO19p0pj1h0pfT9AhPLu7PmeylAIgXSxnNFwakd
	 1jytlNGZsNkXIBL5Bpc9Ej/F2AD86epweuczfyVx8UxcYQFz5v84Nv4qxPGIhCubUq
	 x4q8Txku1cEcJq0oQcQZe+NehNq0QrZg4HLi04oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Spoorthy S <spoorts2@in.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 424/744] perf tests: Make "test data symbol" more robust on Neoverse N1
Date: Thu,  6 Jun 2024 16:01:36 +0200
Message-ID: <20240606131746.071326081@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@arm.com>

[ Upstream commit 256ef072b3842273ce703db18b603b051aca95fe ]

To prevent anyone from seeing a test failure appear as a regression and
thinking that it was caused by their code change, insert some noise into
the loop which makes it immune to sampling bias issues (errata 1694299).

The "test data symbol" test can fail with any unrelated change that
shifts the loop into an unfortunate position in the Perf binary which is
almost impossible to debug as the root cause of the test failure.
Ultimately it's caused by the referenced errata.

Fixes: 60abedb8aa902b06 ("perf test: Introduce script for data symbol testing")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: James Clark <james.clark@arm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Spoorthy S <spoorts2@in.ibm.com>
Link: https://lore.kernel.org/r/20240410103458.813656-2-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/workloads/datasym.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/perf/tests/workloads/datasym.c b/tools/perf/tests/workloads/datasym.c
index ddd40bc63448a..8e08fc75a973e 100644
--- a/tools/perf/tests/workloads/datasym.c
+++ b/tools/perf/tests/workloads/datasym.c
@@ -16,6 +16,22 @@ static int datasym(int argc __maybe_unused, const char **argv __maybe_unused)
 {
 	for (;;) {
 		buf1.data1++;
+		if (buf1.data1 == 123) {
+			/*
+			 * Add some 'noise' in the loop to work around errata
+			 * 1694299 on Arm N1.
+			 *
+			 * Bias exists in SPE sampling which can cause the load
+			 * and store instructions to be skipped entirely. This
+			 * comes and goes randomly depending on the offset the
+			 * linker places the datasym loop at in the Perf binary.
+			 * With an extra branch in the middle of the loop that
+			 * isn't always taken, the instruction stream is no
+			 * longer a continuous repeating pattern that interacts
+			 * badly with the bias.
+			 */
+			buf1.data1++;
+		}
 		buf1.data2 += buf1.data1;
 	}
 	return 0;
-- 
2.43.0



