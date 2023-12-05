Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D246FB1;
	Tue,  5 Dec 2023 03:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3hc7Ukw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E878C433C7;
	Tue,  5 Dec 2023 03:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701748059;
	bh=r/Q0iZq9g7g5DYzUmsKOIlRRljDhrMYAvl+wESEU1js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t3hc7UkwDIDli7z0ZOmBl3gTdclbOvrpzldutp6/VT8PJ2DpNtu/DF1cZN9RFLmom
	 4W+kQVMzDY2aHoOkvkPpGGNmcrmXI4hCCruAV9+P6dETeacdEzZaK90lMhN68YTBQR
	 yIbJC5whUuDdSrEp+WRWTgpc3WBj4NrEXxh5yBtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@redhat.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 73/94] perf intel-pt: Adjust sample flags for VM-Exit
Date: Tue,  5 Dec 2023 12:17:41 +0900
Message-ID: <20231205031526.907097948@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031522.815119918@linuxfoundation.org>
References: <20231205031522.815119918@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 695fc4510615f8db40ebaf7a2c011f0a594b5f77 ]

Use the change of NR to detect whether an asynchronous branch is a VM-Exit.

Note VM-Entry is determined from the vmlaunch or vmresume instruction,
in which case, sample flags will show "VMentry" even if the VM-Entry fails.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: https://lore.kernel.org/r/20210218095801.19576-10-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: f2d87895cbc4 ("perf intel-pt: Fix async branch flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/intel-pt.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index b40832419a279..bead66d65dc0b 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -997,13 +997,16 @@ static void intel_pt_sample_flags(struct intel_pt_queue *ptq)
 	if (ptq->state->flags & INTEL_PT_ABORT_TX) {
 		ptq->flags = PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_TX_ABORT;
 	} else if (ptq->state->flags & INTEL_PT_ASYNC) {
-		if (ptq->state->to_ip)
+		if (!ptq->state->to_ip)
+			ptq->flags = PERF_IP_FLAG_BRANCH |
+				     PERF_IP_FLAG_TRACE_END;
+		else if (ptq->state->from_nr && !ptq->state->to_nr)
+			ptq->flags = PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_CALL |
+				     PERF_IP_FLAG_VMEXIT;
+		else
 			ptq->flags = PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_CALL |
 				     PERF_IP_FLAG_ASYNC |
 				     PERF_IP_FLAG_INTERRUPT;
-		else
-			ptq->flags = PERF_IP_FLAG_BRANCH |
-				     PERF_IP_FLAG_TRACE_END;
 		ptq->insn_len = 0;
 	} else {
 		if (ptq->state->from_ip)
-- 
2.42.0



