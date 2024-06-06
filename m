Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EB01B3739;
	Thu,  6 Jun 2024 14:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683422; cv=none; b=XWtc2DSZJXceE/0Cc/0h04rD6BhFrvBWXm1QoDP7Ng7Xc3Vd1THB9QEimo1TYPhN7NoUzE+4flIfJ2jdnLoM266+vHyg3EqcXp2dRITKOAr9xoCenI9VsobtSx7J8OuRUGfYc6qgEXO9frPYiprK/o8WdiLjSfcRBO7GLwDJAdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683422; c=relaxed/simple;
	bh=JdLV5T89apanJB114zcbkfBvw57lMzFYFZj3F35VvFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQK56pyM8+q6imbF/PFeAnX7wbrsRUiCcO/PnRNB3+W/ZWOcvB2r+8cvSDHLLye6DCNEaUXnBG0kEMQ91T4EWzslHC6Nc0d/KcysrypxLwysJIZjVc/mGUg0iHCGBIv/kxvRLA27BkpG3pXC3b67CjfIe5xrJLTQipdyyFcyMgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ief5pS10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ief5pS10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D0AC32781;
	Thu,  6 Jun 2024 14:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683422;
	bh=JdLV5T89apanJB114zcbkfBvw57lMzFYFZj3F35VvFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ief5pS10S2gtIPD3XXRchEdCu2DGBa24ximc6yYvlGZYKksbiY37NMYX6hldDf5GM
	 lyhK8Vf3EZhI9RXIUvJd3IgFUbZZI4QO84huRL8PkkpQXs+WPZ3RfCD6aL2UQvnUCl
	 vIj5iUkDjXyDZKMnKP5TOvGMKYk7UuqnZEhptCTM=
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
Subject: [PATCH 6.1 304/473] perf tests: Make "test data symbol" more robust on Neoverse N1
Date: Thu,  6 Jun 2024 16:03:53 +0200
Message-ID: <20240606131709.980054641@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



