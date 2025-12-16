Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F145433A00F;
	Tue, 16 Dec 2025 12:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887527; cv=none; b=NEHWpkx8vUove8Fg2c+Ksa0PcpEU+045md8FOPzsjZYLxLiaolLMRXZjkt703M6ScKbnYoDESdyEkJEOSO60cIrwqUDcwzpovjhLda66co5avNXhQuQOYbcXkN2EpH9rH9ZNY387vgjjyjtviHsjukGVmR8uFbAZutZXsn4c0eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887527; c=relaxed/simple;
	bh=EPVqwo5opi5AWqKaeQpstBDo4hTpJw021M3gPFDv2ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRjJwe3Q/II7STw4VZh9VSfkcMQ2hb2yxlog2O6+C05/fA0cb7sEugyIxkCsSOsBLCaVhvz4rxxtfA9oZrd31NWNe2jElLyVord2fQjrOkGmMcAERduT3W90u90Rn//atv9uZmNuQZ/wH4Doqm/HLxyDA2a6MyG8n9PLNW4Rmao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmdKzJTZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmdKzJTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EDCC4CEF1;
	Tue, 16 Dec 2025 12:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887526;
	bh=EPVqwo5opi5AWqKaeQpstBDo4hTpJw021M3gPFDv2ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmdKzJTZSklRZSELUHoX7jv5+nynJfTE2Xm7+HDAX5/tI9bDd/Io/Ey+RB+sYmjBg
	 k7Sh6r3f5SHnosEyd20VrQzezIVp2d56Wu9gXiOA5ZA+ye3PdrzEL6whKttlEKVAAG
	 rITCmnPwE7Uin+FzkgBZtEiB6Y0y5PpDf9hs1nOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Chen, Zide" <zide.chen@intel.com>
Subject: [PATCH 6.18 258/614] perf tools: Fix missing feature check for inherit + SAMPLE_READ
Date: Tue, 16 Dec 2025 12:10:25 +0100
Message-ID: <20251216111410.721124044@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

[ Upstream commit 367377f45c0b568882567f797b7b18b263505be7 ]

It should also have PERF_SAMPLE_TID to enable inherit and PERF_SAMPLE_READ
on recent kernels.  Not having _TID makes the feature check wrongly detect
the inherit and _READ support.

It was reported that the following command failed due to the error in
the missing feature check on Intel SPR machines.

  $ perf record -e '{cpu/mem-loads-aux/S,cpu/mem-loads,ldlat=3/PS}' -- ls
  Error:
  Failure to open event 'cpu/mem-loads,ldlat=3/PS' on PMU 'cpu' which will be removed.
  Invalid event (cpu/mem-loads,ldlat=3/PS) in per-thread mode, enable system wide with '-a'.

Reviewed-by: Ian Rogers <irogers@google.com>
Fixes: 3b193a57baf15c468 ("perf tools: Detect missing kernel features properly")
Reported-and-tested-by: Chen, Zide <zide.chen@intel.com>
Closes: https://lore.kernel.org/lkml/20251022220802.1335131-1-zide.chen@intel.com/
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 56ebefd075f2e..9df9818e37013 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2473,7 +2473,7 @@ static bool evsel__detect_missing_features(struct evsel *evsel, struct perf_cpu
 	/* Please add new feature detection here. */
 
 	attr.inherit = true;
-	attr.sample_type = PERF_SAMPLE_READ;
+	attr.sample_type = PERF_SAMPLE_READ | PERF_SAMPLE_TID;
 	if (has_attr_feature(&attr, /*flags=*/0))
 		goto found;
 	perf_missing_features.inherit_sample_read = true;
-- 
2.51.0



