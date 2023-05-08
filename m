Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF73168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE020C433EF;
	Mon,  8 May 2023 10:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543141;
	bh=UEz0h3yOFYBbqlGA/Sp6Ce54htzfm8kA5QfvhS62AKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UK11YESAjN7fhNZrTlGkROJPtPThGtNHqMsG/eznlLkRP+5Z8ZWngxYHOvJTZokD9
	 munmMZGtrLR70XL+YqcXTf/EFrMJWkIREV5X/qbH6H4taFd8cK41fOqNX+N9nLXBoI
	 oVk36p8agCfbMLm2HzGWpKIrqMMoTMe0FcvOhaMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.2 659/663] perf intel-pt: Fix CYC timestamps after standalone CBR
Date: Mon,  8 May 2023 11:48:05 +0200
Message-Id: <20230508094451.572793229@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1998,6 +1998,8 @@ static void intel_pt_calc_cbr(struct int
 
 	decoder->cbr = cbr;
 	decoder->cbr_cyc_to_tsc = decoder->max_non_turbo_ratio_fp / cbr;
+	decoder->cyc_ref_timestamp = decoder->timestamp;
+	decoder->cycle_cnt = 0;
 
 	intel_pt_mtc_cyc_cnt_cbr(decoder);
 }


