Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDF117731
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5E9C433C7;
	Wed,  9 Aug 2023 11:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579185;
	bh=HiIS/Q/X2Hl6vybF8TqdA/UJq/Lm682ImU96KC0EaKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQDWG/rOIuAjP7MVTUJrMwxG/uHM9TCuqdvU5vy4nMM3VrLiHeiZdRxumF9LjDN6M
	 uZUr8oKU4QEE1ECfFjX2dLJl0C4RtZuGZh44LKDWMdJiVwiXAjUDUS+eg4qEfZst68
	 7WGJXj26HmTAhThwKs5yCBTCU0oC2XbPG4mv1xdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.14 104/204] perf intel-pt: Fix CYC timestamps after standalone CBR
Date: Wed,  9 Aug 2023 12:40:42 +0200
Message-ID: <20230809103646.101032444@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adrian Hunter <adrian.hunter@intel.com>

commit 430635a0ef1ce958b7b4311f172694ece2c692b8 upstream.

After a standalone CBR (not associated with TSC), update the cycles
reference timestamp and reset the cycle count, so that CYC timestamps
are calculated relative to that point with the new frequency.

Fixes: cc33618619cefc6d ("perf tools: Add Intel PT support for decoding CYC packets")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230403154831.8651-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1499,6 +1499,8 @@ static void intel_pt_calc_cbr(struct int
 
 	decoder->cbr = cbr;
 	decoder->cbr_cyc_to_tsc = decoder->max_non_turbo_ratio_fp / cbr;
+	decoder->cyc_ref_timestamp = decoder->timestamp;
+	decoder->cycle_cnt = 0;
 }
 
 static void intel_pt_calc_cyc_timestamp(struct intel_pt_decoder *decoder)


