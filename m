Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BF0189B85;
	Tue, 30 Jul 2024 17:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359359; cv=none; b=hDvBrl+HP9ey1wOqLx5EVzRTE6i/9GZjsH3S07X1qMMvf9xjfvqCg9eNYqDgmXRUg71VtQWk543SGF9p4g4qs36B7zxczWb7qJkkos8eC0v9uPLFoiCxAibZlj1vkCRhVYcSjTfP4yY28YSi+MVMpNj1fa/gfUSwgSiUeCpl7Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359359; c=relaxed/simple;
	bh=J/4K/MeeDSIyYflvIXjZ/UEkuoUbZ6lL4F5om+h6gEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XNy2bIvemrpApWzC+tDZU6MlbG95g3VdIbqfaL6R6baCuQK69/4Q8bzkr1t7JCQ6rMUWp1eMtDu/hyg+ipdoO8/T5H9Xl7Ks3MzejqJLT6u4Jx1Eht0PSsaj6Nfio6zreW3GTjFBIGQ/yIJi4tU17Kaw8xgp8dtTU9JPfiHWXyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLFXfbWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLFXfbWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A08C32782;
	Tue, 30 Jul 2024 17:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359358;
	bh=J/4K/MeeDSIyYflvIXjZ/UEkuoUbZ6lL4F5om+h6gEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLFXfbWlv/UsVhwvQPkVozRfrJacz14+ldqUqK2+tZXKRBExMBbA3Co8QG9jixRn+
	 TxuX7LafdpdUkZk80eRDx85KIsddMrRmbUqvGuY/HKeV1cvZ155RQ50hmr4Qh8PjZn
	 rSbuOGIrvDp+CkfbyfYJ/k7N/pgzaG2adpUlJkp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bayduraev, Alexey V" <alexey.v.bayduraev@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.6 471/568] perf/x86/intel/ds: Fix non 0 retire latency on Raptorlake
Date: Tue, 30 Jul 2024 17:49:38 +0200
Message-ID: <20240730151658.434234169@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

commit e5f32ad56b22ebe384a6e7ddad6e9520c5495563 upstream.

A non-0 retire latency can be observed on a Raptorlake which doesn't
support the retire latency feature.
By design, the retire latency shares the PERF_SAMPLE_WEIGHT_STRUCT
sample type with other types of latency. That could avoid adding too
many different sample types to support all kinds of latency. For the
machine which doesn't support some kind of latency, 0 should be
returned.

Perf doesn’t clear/init all the fields of a sample data for the sake
of performance. It expects the later perf_{prepare,output}_sample() to
update the uninitialized field. However, the current implementation
doesn't touch the field of the retire latency if the feature is not
supported. The memory garbage is dumped into the perf data.

Clear the retire latency if the feature is not supported.

Fixes: c87a31093c70 ("perf/x86: Support Retire Latency")
Reported-by: "Bayduraev, Alexey V" <alexey.v.bayduraev@intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: "Bayduraev, Alexey V" <alexey.v.bayduraev@intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20240708193336.1192217-4-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/ds.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1830,8 +1830,12 @@ static void setup_pebs_adaptive_sample_d
 	set_linear_ip(regs, basic->ip);
 	regs->flags = PERF_EFLAGS_EXACT;
 
-	if ((sample_type & PERF_SAMPLE_WEIGHT_STRUCT) && (x86_pmu.flags & PMU_FL_RETIRE_LATENCY))
-		data->weight.var3_w = format_size >> PEBS_RETIRE_LATENCY_OFFSET & PEBS_LATENCY_MASK;
+	if (sample_type & PERF_SAMPLE_WEIGHT_STRUCT) {
+		if (x86_pmu.flags & PMU_FL_RETIRE_LATENCY)
+			data->weight.var3_w = format_size >> PEBS_RETIRE_LATENCY_OFFSET & PEBS_LATENCY_MASK;
+		else
+			data->weight.var3_w = 0;
+	}
 
 	/*
 	 * The record for MEMINFO is in front of GP


