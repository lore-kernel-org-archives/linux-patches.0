Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B713615E8B;
	Mon, 30 Dec 2024 15:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574289; cv=none; b=Ts+3PKt+D4LVU3Yk1wzJhoaGz1KGy/so9giKkxfSrgICzBW6q95A+T0oqR2Vg4rPeJrcBg2F6m+GRJZuWWWBVQjLDpGQUt90SEGazQx9R0+BzF15xC0eP1zC8dC+dW7A7ExgZK7G7q6ZHyFVpsMwDOi6zm5qRGInriXsnzMWRGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574289; c=relaxed/simple;
	bh=HPZysbXXj1O8HffU9W5XYGSwfuOBOQhw0xb/mC4Qo80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJgSiqnopPpOtJFnUeNV50sbW2sKlEkgpVLKi6XjD0Q2VXAANl42VKRzz0UdRkHy2X4y0Dg8T1oxETx6P+gIXddvI7xL/v87UbZdszrPI+3wNnbP5885bgpsGD3j+5LNx1AMPApN50kSaQ3kWYujDQjcV129rsQpUbM8Cdc0ZBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXv95dGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXv95dGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24308C4CED0;
	Mon, 30 Dec 2024 15:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574289;
	bh=HPZysbXXj1O8HffU9W5XYGSwfuOBOQhw0xb/mC4Qo80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXv95dGDWBtwfEag5S5t3zkAVk5LX3o4m00k96HpYT6dZZM6dI80mQ9Q4YllpyZqd
	 VZPcKMust31VP9c+lEuJbKSpD+TqwBFXNjQxOZPeuVAuq62uQyEUmF49fjs1Z0JOeW
	 R0FQuvKqfZQ2Fl9a/wvwdUYW141jsVxgSPFksoik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Kleen <ak@linux.intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.12 093/114] perf/x86/intel: Fix bitmask of OCR and FRONTEND events for LNC
Date: Mon, 30 Dec 2024 16:43:30 +0100
Message-ID: <20241230154221.675776598@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

commit aa5d2ca7c179c40669edb5e96d931bf9828dea3d upstream.

The released OCR and FRONTEND events utilized more bits on Lunar Lake
p-core. The corresponding mask in the extra_regs has to be extended to
unblock the extra bits.

Add a dedicated intel_lnc_extra_regs.

Fixes: a932aa0e868f ("perf/x86: Add Lunar Lake and Arrow Lake support")
Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20241216160252.430858-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -429,6 +429,16 @@ static struct event_constraint intel_lnc
 	EVENT_CONSTRAINT_END
 };
 
+static struct extra_reg intel_lnc_extra_regs[] __read_mostly = {
+	INTEL_UEVENT_EXTRA_REG(0x012a, MSR_OFFCORE_RSP_0, 0xfffffffffffull, RSP_0),
+	INTEL_UEVENT_EXTRA_REG(0x012b, MSR_OFFCORE_RSP_1, 0xfffffffffffull, RSP_1),
+	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
+	INTEL_UEVENT_EXTRA_REG(0x02c6, MSR_PEBS_FRONTEND, 0x9, FE),
+	INTEL_UEVENT_EXTRA_REG(0x03c6, MSR_PEBS_FRONTEND, 0x7fff1f, FE),
+	INTEL_UEVENT_EXTRA_REG(0x40ad, MSR_PEBS_FRONTEND, 0xf, FE),
+	INTEL_UEVENT_EXTRA_REG(0x04c2, MSR_PEBS_FRONTEND, 0x8, FE),
+	EVENT_EXTRA_END
+};
 
 EVENT_ATTR_STR(mem-loads,	mem_ld_nhm,	"event=0x0b,umask=0x10,ldlat=3");
 EVENT_ATTR_STR(mem-loads,	mem_ld_snb,	"event=0xcd,umask=0x1,ldlat=3");
@@ -6344,7 +6354,7 @@ static __always_inline void intel_pmu_in
 	intel_pmu_init_glc(pmu);
 	hybrid(pmu, event_constraints) = intel_lnc_event_constraints;
 	hybrid(pmu, pebs_constraints) = intel_lnc_pebs_event_constraints;
-	hybrid(pmu, extra_regs) = intel_rwc_extra_regs;
+	hybrid(pmu, extra_regs) = intel_lnc_extra_regs;
 }
 
 static __always_inline void intel_pmu_init_skt(struct pmu *pmu)


