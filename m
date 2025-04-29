Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B953243364;
	Tue, 29 Apr 2025 16:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945421; cv=none; b=i2aufxrCjjocvPpXN7DHZ0TpFD8ajohdDsaHkm+bbpIBlcoyUYB7iqPGiv7dHzoI26rAhzaqd8tpHiSRRGCPQSxrIWL1b8WOwM+a2Sn7Wfc1pc04KppvcoZ4k0zC1O23wiUD0WcpcMGpv+ZSFq5gjTM9tHHN5yUolt9BQQeJ0LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945421; c=relaxed/simple;
	bh=LTyAquxuTc+esBhZIeWrXJ8kxTbdaO9o65NstLb/ml8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfOdV3EiC+3lRzJ3Jdlq+3LjHjpEKi7F0zdyaYc6kbDM5WG6KRFvCEwomJ/sCLdnnlcvTIBZGtbzwLriA8B2eVT1ZJbZWHBeKRuwOfE34rgXmk2hIAvmppCLSLuCwnPQdeC2I0tKOX21wGv7antPrx/8A/yc4TW4kvLXk7UDhBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWsJxQV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWsJxQV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3867C4CEE3;
	Tue, 29 Apr 2025 16:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945421;
	bh=LTyAquxuTc+esBhZIeWrXJ8kxTbdaO9o65NstLb/ml8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWsJxQV8mEDhFpLCeh1pBWXgQI3dmL+7XaWExYg+6tJNVd9fNH5bPknqelhlE6hVA
	 gjF5pmvAItxQ2U029+T37hl2XV0ezwns41/3hBKv7+Pstv2ITpdiHFXh5R04f8i+lU
	 h6lVERbPrjZjwwtM1fNwYanZtRtPycBqssbNFoiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5.4 106/179] perf/x86/intel/uncore: Fix the scale of IIO free running counters on SNR
Date: Tue, 29 Apr 2025 18:40:47 +0200
Message-ID: <20250429161053.692756839@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kan Liang <kan.liang@linux.intel.com>

commit 96a720db59ab330c8562b2437153faa45dac705f upstream.

There was a mistake in the SNR uncore spec. The counter increments for
every 32 bytes of data sent from the IO agent to the SOC, not 4 bytes
which was documented in the spec.

The event list has been updated:

  "EventName": "UNC_IIO_BANDWIDTH_IN.PART0_FREERUN",
  "BriefDescription": "Free running counter that increments for every 32
		       bytes of data sent from the IO agent to the SOC",

Update the scale of the IIO bandwidth in free running counters as well.

Fixes: 210cc5f9db7a ("perf/x86/intel/uncore: Add uncore support for Snow Ridge server")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250416142426.3933977-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore_snbep.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -4220,28 +4220,28 @@ static struct uncore_event_desc snr_unco
 	INTEL_UNCORE_EVENT_DESC(ioclk,			"event=0xff,umask=0x10"),
 	/* Free-Running IIO BANDWIDTH IN Counters */
 	INTEL_UNCORE_EVENT_DESC(bw_in_port0,		"event=0xff,umask=0x20"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port0.scale,	"3.814697266e-6"),
+	INTEL_UNCORE_EVENT_DESC(bw_in_port0.scale,	"3.0517578125e-5"),
 	INTEL_UNCORE_EVENT_DESC(bw_in_port0.unit,	"MiB"),
 	INTEL_UNCORE_EVENT_DESC(bw_in_port1,		"event=0xff,umask=0x21"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port1.scale,	"3.814697266e-6"),
+	INTEL_UNCORE_EVENT_DESC(bw_in_port1.scale,	"3.0517578125e-5"),
 	INTEL_UNCORE_EVENT_DESC(bw_in_port1.unit,	"MiB"),
 	INTEL_UNCORE_EVENT_DESC(bw_in_port2,		"event=0xff,umask=0x22"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port2.scale,	"3.814697266e-6"),
+	INTEL_UNCORE_EVENT_DESC(bw_in_port2.scale,	"3.0517578125e-5"),
 	INTEL_UNCORE_EVENT_DESC(bw_in_port2.unit,	"MiB"),
 	INTEL_UNCORE_EVENT_DESC(bw_in_port3,		"event=0xff,umask=0x23"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port3.scale,	"3.814697266e-6"),
+	INTEL_UNCORE_EVENT_DESC(bw_in_port3.scale,	"3.0517578125e-5"),
 	INTEL_UNCORE_EVENT_DESC(bw_in_port3.unit,	"MiB"),
 	INTEL_UNCORE_EVENT_DESC(bw_in_port4,		"event=0xff,umask=0x24"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port4.scale,	"3.814697266e-6"),
+	INTEL_UNCORE_EVENT_DESC(bw_in_port4.scale,	"3.0517578125e-5"),
 	INTEL_UNCORE_EVENT_DESC(bw_in_port4.unit,	"MiB"),
 	INTEL_UNCORE_EVENT_DESC(bw_in_port5,		"event=0xff,umask=0x25"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port5.scale,	"3.814697266e-6"),
+	INTEL_UNCORE_EVENT_DESC(bw_in_port5.scale,	"3.0517578125e-5"),
 	INTEL_UNCORE_EVENT_DESC(bw_in_port5.unit,	"MiB"),
 	INTEL_UNCORE_EVENT_DESC(bw_in_port6,		"event=0xff,umask=0x26"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port6.scale,	"3.814697266e-6"),
+	INTEL_UNCORE_EVENT_DESC(bw_in_port6.scale,	"3.0517578125e-5"),
 	INTEL_UNCORE_EVENT_DESC(bw_in_port6.unit,	"MiB"),
 	INTEL_UNCORE_EVENT_DESC(bw_in_port7,		"event=0xff,umask=0x27"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port7.scale,	"3.814697266e-6"),
+	INTEL_UNCORE_EVENT_DESC(bw_in_port7.scale,	"3.0517578125e-5"),
 	INTEL_UNCORE_EVENT_DESC(bw_in_port7.unit,	"MiB"),
 	{ /* end: all zeroes */ },
 };


