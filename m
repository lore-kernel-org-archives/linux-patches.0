Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3A217730
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F67C433EF;
	Mon, 15 May 2023 18:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173890;
	bh=C9CsyIc9/EAFnFPICyiM/TZOffJtXHqPj5sGRr04apw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hz43iQkvFkGVnZ6oo7zpRgE0WEb0kFt/WDStkuiMO7f/CKi5wKMOd6wtfhgwUgvJf
	 Uq54NdRXXGTyw1+Tp+r0RFqY59+fvRab3Yw5l6Lx33FAhIkW4Aq+BEltBUg9NXLTIB
	 lWDSsbIz08FLh0G6lvibFZvN+O3jyMGJ6yKIwwp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 208/282] perf intel-pt: Fix CYC timestamps after standalone CBR
Date: Mon, 15 May 2023 18:29:46 +0200
Message-Id: <20230515161728.480710199@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
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
@@ -1592,6 +1592,8 @@ static void intel_pt_calc_cbr(struct int
 
 	decoder->cbr = cbr;
 	decoder->cbr_cyc_to_tsc = decoder->max_non_turbo_ratio_fp / cbr;
+	decoder->cyc_ref_timestamp = decoder->timestamp;
+	decoder->cycle_cnt = 0;
 
 	intel_pt_mtc_cyc_cnt_cbr(decoder);
 }


