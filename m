Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A23C144D0B;
	Thu, 13 Jun 2024 12:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282256; cv=none; b=H/WroBlkdXR9d5Keekuqu9Db27FHzfjS/xVn02EnwYimXniF5IACt6XusWIidR/FAjQc2vOQB0vOiaGO8PwyykTL/DkF8+dTHSzzIjjM2cAXhVxfEr5zimrEbaJvBagcmVwHxkHn9WAZTaVgWDmBCb7YdaWa8wMSej8/dBCkpnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282256; c=relaxed/simple;
	bh=2YGhwGGMmnkD/ru9J4BKN6ORPeC7sWZi6yQteSjboak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwlU1DN1lI5c5x8I87HeDwUDuDRA2fljPAXhx2+XO7HMurnLProIidykdo8vX+o2kuqFrOOUqKULsOxljeHxCv8Lf59UHWtG7HR2pSvsW7g9GLB+IVqy25B/PGtk/0Ku+YAQ7u5wQYL6pBFyPrtXvfxy2n6t5qY43BDiF6OQRyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7gn1iYC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7gn1iYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719FAC4AF51;
	Thu, 13 Jun 2024 12:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282255;
	bh=2YGhwGGMmnkD/ru9J4BKN6ORPeC7sWZi6yQteSjboak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U7gn1iYCgX+QeV2qCe6uEk7rd5ZZZjMUFBCZBDr166j2Llduh+8/8rsV4PTw4l0b4
	 iaTv+JKIFw8jTB1lF1RArnjeLMu+iJfcwaIX+jVCHrqA0xtTylNzTLiJsLjl1QelnH
	 voTuWkmqqHqt5A7VVS0yZxFRMOCeXbNsGmj0VZIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 214/402] perf intel-pt: Fix unassigned instruction op (discovered by MemorySanitizer)
Date: Thu, 13 Jun 2024 13:32:51 +0200
Message-ID: <20240613113310.497334696@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit e101a05f79fd4ee3e89d2f3fb716493c33a33708 ]

MemorySanitizer discovered instances where the instruction op value was
not assigned.:

  WARNING: MemorySanitizer: use-of-uninitialized-value
    #0 0x5581c00a76b3 in intel_pt_sample_flags tools/perf/util/intel-pt.c:1527:17
  Uninitialized value was stored to memory at
    #0 0x5581c005ddf8 in intel_pt_walk_insn tools/perf/util/intel-pt-decoder/intel-pt-decoder.c:1256:25

The op value is used to set branch flags for branch instructions
encountered when walking the code, so fix by setting op to
INTEL_PT_OP_OTHER in other cases.

Fixes: 4c761d805bb2d2ea ("perf intel-pt: Fix intel_pt_fup_event() assumptions about setting state type")
Reported-by: Ian Rogers <irogers@google.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Closes: https://lore.kernel.org/linux-perf-users/20240320162619.1272015-1-irogers@google.com/
Link: https://lore.kernel.org/r/20240326083223.10883-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c | 2 ++
 tools/perf/util/intel-pt.c                          | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
index b9f94f198a3eb..3530551b82819 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1215,6 +1215,8 @@ static bool intel_pt_fup_event(struct intel_pt_decoder *decoder)
 	bool ret = false;
 
 	decoder->state.type &= ~INTEL_PT_BRANCH;
+	decoder->state.insn_op = INTEL_PT_OP_OTHER;
+	decoder->state.insn_len = 0;
 
 	if (decoder->set_fup_tx_flags) {
 		decoder->set_fup_tx_flags = false;
diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 805bad9364e94..b00776c65c186 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -721,6 +721,7 @@ static int intel_pt_walk_next_insn(struct intel_pt_insn *intel_pt_insn,
 	bool nr;
 
 	intel_pt_insn->length = 0;
+	intel_pt_insn->op = INTEL_PT_OP_OTHER;
 
 	if (to_ip && *ip == to_ip)
 		goto out_no_cache;
@@ -816,6 +817,7 @@ static int intel_pt_walk_next_insn(struct intel_pt_insn *intel_pt_insn,
 
 			if (to_ip && *ip == to_ip) {
 				intel_pt_insn->length = 0;
+				intel_pt_insn->op = INTEL_PT_OP_OTHER;
 				goto out_no_cache;
 			}
 
-- 
2.43.0



