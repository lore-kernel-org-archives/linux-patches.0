Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D091170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F555C433C8;
	Mon, 11 Sep 2023 14:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442388;
	bh=BML5QJbF1wpznZpZWR/4jQSZRGTU5a8LjED5AQTOPsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YdWcHCY8k7AnxrMymOb7GGCMzhpOQehykFTKjQNRUD4+hNWMzQVZy5uG+FEGzDrPf
	 1KBlD08E2qcj5nG/Bz8/8r5tE1OO/1vFC64ZK62WTy71k47o4P/QkLMH8Mhi99xeMN
	 kHkOPPTIDF/BIK/HMn40ShWm/w3ie8R4C9yCIfeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephane Eranian <eranian@google.com>,
	Yunying Sun <yunying.sun@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.5 727/739] perf/x86/uncore: Correct the number of CHAs on EMR
Date: Mon, 11 Sep 2023 15:48:46 +0200
Message-ID: <20230911134711.376785081@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

commit 6f7f984fa85b305799076a1bcec941b9377587de upstream.

Starting from SPR, the basic uncore PMON information is retrieved from
the discovery table (resides in an MMIO space populated by BIOS). It is
called the discovery method. The existing value of the type->num_boxes
is from the discovery table.

On some SPR variants, there is a firmware bug that makes the value from the
discovery table incorrect. We use the value from the
SPR_MSR_UNC_CBO_CONFIG MSR to replace the one from the discovery table:

   38776cc45eb7 ("perf/x86/uncore: Correct the number of CHAs on SPR")

Unfortunately, the SPR_MSR_UNC_CBO_CONFIG isn't available for the EMR
XCC (Always returns 0), but the above firmware bug doesn't impact the
EMR XCC.

Don't let the value from the MSR replace the existing value from the
discovery table.

Fixes: 38776cc45eb7 ("perf/x86/uncore: Correct the number of CHAs on SPR")
Reported-by: Stephane Eranian <eranian@google.com>
Reported-by: Yunying Sun <yunying.sun@intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Yunying Sun <yunying.sun@intel.com>
Link: https://lore.kernel.org/r/20230905134248.496114-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore_snbep.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -6474,8 +6474,18 @@ void spr_uncore_cpu_init(void)
 
 	type = uncore_find_type_by_id(uncore_msr_uncores, UNCORE_SPR_CHA);
 	if (type) {
+		/*
+		 * The value from the discovery table (stored in the type->num_boxes
+		 * of UNCORE_SPR_CHA) is incorrect on some SPR variants because of a
+		 * firmware bug. Using the value from SPR_MSR_UNC_CBO_CONFIG to replace it.
+		 */
 		rdmsrl(SPR_MSR_UNC_CBO_CONFIG, num_cbo);
-		type->num_boxes = num_cbo;
+		/*
+		 * The MSR doesn't work on the EMR XCC, but the firmware bug doesn't impact
+		 * the EMR XCC. Don't let the value from the MSR replace the existing value.
+		 */
+		if (num_cbo)
+			type->num_boxes = num_cbo;
 	}
 	spr_uncore_iio_free_running.num_boxes = uncore_type_max_boxes(uncore_msr_uncores, UNCORE_SPR_IIO);
 }


