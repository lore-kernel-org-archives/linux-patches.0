Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7305F51DAEA;
	Wed, 30 Sep 2026 17:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789435; cv=none; b=TF36FT+aV3EBLsT8KO7JGynSV0TZKOB4kvr4XD39tvkvvXZrLOOhIpn3qH++sl6hKHWl7fLEikFgWM3wy4DbYzdAISVEZXirIlfc09NISSaakzaaScLKKZQ6FgZ3Ll5ibfu3KYj8nPkYodayfh/pKEBHLURBacR8fKopdKRXKas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789435; c=relaxed/simple;
	bh=F/JsWvUBlyeBs9WkjGuiItNjvQoyqOMxcJbHj5IewH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UadcYlI8OwiR2Z4w7MwldzHMqW9QT/RM13wNatwFR6G14z47zpcdfnSWg46iKA+wWA/9p995Sujzopjzj3Wh/jUEv1Qz10kewoNaXw9VfoI+DWEXgHnjwMmT5IeeHIWyGbQxsvZQHOi5cnEfa9eW0/FT/sxieNYf5eiV39d7Aas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YN9qEJen; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YN9qEJen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815091F000FF;
	Wed, 30 Sep 2026 17:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789434;
	bh=sc4WMQmrJBjvOlPquDiaPfhpdj366L6+3apQDz93E7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YN9qEJennzRUI2CqsR9s49Yp0wAQmVP6uB/idrHgV83mmKWHF+Pu5Il/WYdEnAB0g
	 NkUIpyBoXvIJ6obeGyDzHKXJP55ssP0P3Z4Jj/VMkWrc4i3jOo/YaYHNWR6nmrJh8c
	 wVraELL0XFBQflNuBy4b0DQPwgIO4aQcAF21IS/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 449/877] perf/x86/intel: Ensure KVM guest PEBS path doesnt set unwanted PERF_GLOBAL_CTRL bits
Date: Wed, 30 Sep 2026 17:22:40 +0200
Message-ID: <20260930152424.369443666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit cec38d5c098a350dcf084d345025136ade7e6d1e ]

When reinstating PEBS counters into PERF_GLOBAL_CTRL for a KVM guest, mask
the value with perf's desired/original PERF_GLOBAL_CTRL value to ensure
KVM doesn't unintentionally set reserved bits in PERF_GLOBAL_CTRL.  E.g.
if the guest's PEBS_ENABLE value had bit 63, "Enable Precise Store", set,
then using the raw guest PEBS value would propagate bit 63 to the guest's
PERF_GLOBAL_CTRL value (which thankfully would be a failed VM-Entry, not
a VMX Abort).

The only reason this bug isn't reachable is because KVM doesn't support
"Enable Precise Store" (which is probably a KVM bug?), i.e. bit 63 can't
be set in kvm_pmu->pebs_enable and thus not in arr[pebs_enable].guest.  In
other words, this _should_ be a glorified NOP in the current code base.

Fixes: c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20260921191418.950933-2-seanjc@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 27001daade100..b4c1875ef1373 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4355,7 +4355,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		arr[pebs_enable].guest &= ~kvm_pmu->host_cross_mapped_mask;
 		arr[global_ctrl].guest &= ~kvm_pmu->host_cross_mapped_mask;
 		/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
-		arr[global_ctrl].guest |= arr[pebs_enable].guest;
+		arr[global_ctrl].guest |= intel_ctrl & arr[pebs_enable].guest;
 	}
 
 	return arr;
-- 
2.53.0



