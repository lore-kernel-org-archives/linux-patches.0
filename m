Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725B8176242;
	Wed, 23 Apr 2025 15:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422425; cv=none; b=LdZHWwKBVyLDdvwZ8+rUT9WJMngYw3OjAofARkifldxSG/WGyvHQ6IkXN/AoOrmT7rRAhd23iA6gDJVLRg4b7s4MLx6L26NoFKlZAvj1F6XcuYfB8/WbdACJLVBX3FhRVHW3qpZNV8CTE4s8203okN0631CHfR1gpTnvC73aJbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422425; c=relaxed/simple;
	bh=KCKEX7u/4gornimO5vXQsV6l6YTrxGqMA68dc8+WcHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8EYbsIgdvjZ+Qym0rdKlbX39FPFBfP05pGedLUwTbzBpvyz7sWR0ld0Qno8tSo32HkEwAVwa4CdawUU+Ad6H5eiC+0cXJSotpjbliCws1WDCoSqaO3Zih8WO2rXblMa8Fnr7rORuecJKX6FkS+VJ0nu2gemfsC11R/pkK3U/LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cWsuBswD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cWsuBswD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09C8C4CEE2;
	Wed, 23 Apr 2025 15:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422425;
	bh=KCKEX7u/4gornimO5vXQsV6l6YTrxGqMA68dc8+WcHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cWsuBswDQb+MGxo193jUoZuDrAWrY01Iewbz9VYSFiyKSCTiViXcvhHGJ8WunCKIC
	 ySn8aArTIFvcRhSW3F0LWbSLZ84ImNTKEDBfsRZBmbrYlkvWZE/dhryrZ0g71SJNAM
	 FAi3Mt/DANSwH+mpCX7XeURx4CKp2W5prZOmhpFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tang Jun <dukang.tj@alibaba-inc.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 6.6 345/393] perf/x86/intel/uncore: Fix the scale of IIO free running counters on SPR
Date: Wed, 23 Apr 2025 16:44:01 +0200
Message-ID: <20250423142657.590782227@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

commit 506f981ab40f0b03a11a640cfd77f48b09aff330 upstream.

The scale of IIO bandwidth in free running counters is inherited from
the ICX. The counter increments for every 32 bytes rather than 4 bytes.

The IIO bandwidth out free running counters don't increment with a
consistent size. The increment depends on the requested size. It's
impossible to find a fixed increment. Remove it from the event_descs.

Fixes: 0378c93a92e2 ("perf/x86/intel/uncore: Support IIO free-running counters on Sapphire Rapids server")
Reported-by: Tang Jun <dukang.tj@alibaba-inc.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250416142426.3933977-3-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore_snbep.c |   58 -----------------------------------
 1 file changed, 1 insertion(+), 57 deletions(-)

--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -6210,69 +6210,13 @@ static struct freerunning_counters spr_i
 	[SPR_IIO_MSR_BW_OUT]	= { 0x3808, 0x1, 0x10, 8, 48 },
 };
 
-static struct uncore_event_desc spr_uncore_iio_freerunning_events[] = {
-	/* Free-Running IIO CLOCKS Counter */
-	INTEL_UNCORE_EVENT_DESC(ioclk,			"event=0xff,umask=0x10"),
-	/* Free-Running IIO BANDWIDTH IN Counters */
-	INTEL_UNCORE_EVENT_DESC(bw_in_port0,		"event=0xff,umask=0x20"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port0.scale,	"3.814697266e-6"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port0.unit,	"MiB"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port1,		"event=0xff,umask=0x21"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port1.scale,	"3.814697266e-6"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port1.unit,	"MiB"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port2,		"event=0xff,umask=0x22"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port2.scale,	"3.814697266e-6"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port2.unit,	"MiB"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port3,		"event=0xff,umask=0x23"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port3.scale,	"3.814697266e-6"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port3.unit,	"MiB"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port4,		"event=0xff,umask=0x24"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port4.scale,	"3.814697266e-6"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port4.unit,	"MiB"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port5,		"event=0xff,umask=0x25"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port5.scale,	"3.814697266e-6"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port5.unit,	"MiB"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port6,		"event=0xff,umask=0x26"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port6.scale,	"3.814697266e-6"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port6.unit,	"MiB"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port7,		"event=0xff,umask=0x27"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port7.scale,	"3.814697266e-6"),
-	INTEL_UNCORE_EVENT_DESC(bw_in_port7.unit,	"MiB"),
-	/* Free-Running IIO BANDWIDTH OUT Counters */
-	INTEL_UNCORE_EVENT_DESC(bw_out_port0,		"event=0xff,umask=0x30"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port0.scale,	"3.814697266e-6"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port0.unit,	"MiB"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port1,		"event=0xff,umask=0x31"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port1.scale,	"3.814697266e-6"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port1.unit,	"MiB"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port2,		"event=0xff,umask=0x32"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port2.scale,	"3.814697266e-6"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port2.unit,	"MiB"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port3,		"event=0xff,umask=0x33"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port3.scale,	"3.814697266e-6"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port3.unit,	"MiB"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port4,		"event=0xff,umask=0x34"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port4.scale,	"3.814697266e-6"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port4.unit,	"MiB"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port5,		"event=0xff,umask=0x35"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port5.scale,	"3.814697266e-6"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port5.unit,	"MiB"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port6,		"event=0xff,umask=0x36"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port6.scale,	"3.814697266e-6"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port6.unit,	"MiB"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port7,		"event=0xff,umask=0x37"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port7.scale,	"3.814697266e-6"),
-	INTEL_UNCORE_EVENT_DESC(bw_out_port7.unit,	"MiB"),
-	{ /* end: all zeroes */ },
-};
-
 static struct intel_uncore_type spr_uncore_iio_free_running = {
 	.name			= "iio_free_running",
 	.num_counters		= 17,
 	.num_freerunning_types	= SPR_IIO_FREERUNNING_TYPE_MAX,
 	.freerunning		= spr_iio_freerunning,
 	.ops			= &skx_uncore_iio_freerunning_ops,
-	.event_descs		= spr_uncore_iio_freerunning_events,
+	.event_descs		= snr_uncore_iio_freerunning_events,
 	.format_group		= &skx_uncore_iio_freerunning_format_group,
 };
 


