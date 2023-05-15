Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93634FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77B1C433D2;
	Mon, 15 May 2023 16:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169955;
	bh=/3+bICBJRDiT+GRmkOQXF+bB+THNaZhIcXP1O47jEYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sbr/vAbPg1qpFdWyXeaPBfbd62tHR3TXYP7dzFOgHDBq1xOvDYV2QV3lmtou7p9GA
	 7Almes2tVRoC+lmDY3pDYw68rMVylR1FIOf3XNucOkRCtKVehFSKrhhjyqCP7Ofdcl
	 xJyED1IozQcmYpc17eaX+VT3pXbuGzUnfpzfGiAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.3 225/246] perf/x86: Fix missing sample size update on AMD BRS
Date: Mon, 15 May 2023 18:27:17 +0200
Message-Id: <20230515161729.340042361@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namhyung Kim <namhyung@kernel.org>

commit 90befef5a9e820ccccc33181ec14c015980300cc upstream.

It missed to convert a PERF_SAMPLE_BRANCH_STACK user to call the new
perf_sample_save_brstack() helper in order to update the dyn_size.
This affects AMD Zen3 machines with the branch-brs event.

Fixes: eb55b455ef9c ("perf/core: Add perf_sample_save_brstack() helper")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20230427030527.580841-1-namhyung@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index d096b04bf80e..9d248703cbdd 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -1703,10 +1703,8 @@ int x86_pmu_handle_irq(struct pt_regs *regs)
 
 		perf_sample_data_init(&data, 0, event->hw.last_period);
 
-		if (has_branch_stack(event)) {
-			data.br_stack = &cpuc->lbr_stack;
-			data.sample_flags |= PERF_SAMPLE_BRANCH_STACK;
-		}
+		if (has_branch_stack(event))
+			perf_sample_save_brstack(&data, event, &cpuc->lbr_stack);
 
 		if (perf_event_overflow(event, &data, regs))
 			x86_pmu_stop(event, 0);
-- 
2.40.1



