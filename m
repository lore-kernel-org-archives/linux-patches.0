Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71798612D7;
	Tue, 20 Feb 2024 21:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463909; cv=none; b=CAGA9BHp3A/imyFfL5Yyudrh1BjDIqevFPJ0M1vP2Tb1oyqv9MdIQZnvHg6fgkDt1l6JPHVtAySITceBrVmumN2cVUo5xb3yvMI7+tuUxVtwrf9tLDkuLq9tEHOlOiQ7HLUW2kVbn8/Y2DgOYZe+/NxIByq76kim8dg5E/3fZiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463909; c=relaxed/simple;
	bh=lgQGPyIk7PNW/1yEFXh2Np3VAU3dxH5j1FmdAjY+WzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bE2WnstLZ9QrWYqZXxucrPVfBaYvxT6/5G2t+QgJqJFKQhdiL82lIUdqKYAjG7PIzV7vj8xbIjZaBYyqu/Rg+JIENo0Qqew60LOyPmAaODhrb7PsKzrm7nVeaBRJN/LpY4zwwpXxamsVe5qHvudPOvk8a6bN4fUFEI5g6rwHasA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nizPdx92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nizPdx92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6601C433F1;
	Tue, 20 Feb 2024 21:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463909;
	bh=lgQGPyIk7PNW/1yEFXh2Np3VAU3dxH5j1FmdAjY+WzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nizPdx927MiPb6gycP3m8zeN51FYyeWWrMp/+5g/AEf9vDuu0tTA/kg8PPuYJagLo
	 lj4YObWYx2YHb3kJoggebzLqrMpkUPw8sJaGhiEbShTUG/UORB3Xq2PzhF2j05K7sb
	 nd9jMDc28zrcF+sy747T42VFlZz+bkSOu2TkQF2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zhang <mizhang@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 192/331] KVM: x86/pmu: Fix type length error when reading pmu->fixed_ctr_ctrl
Date: Tue, 20 Feb 2024 21:55:08 +0100
Message-ID: <20240220205643.614654072@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingwei Zhang <mizhang@google.com>

commit 05519c86d6997cfb9bb6c82ce1595d1015b718dc upstream.

Use a u64 instead of a u8 when taking a snapshot of pmu->fixed_ctr_ctrl
when reprogramming fixed counters, as truncating the value results in KVM
thinking fixed counter 2 is already disabled (the bug also affects fixed
counters 3+, but KVM doesn't yet support those).  As a result, if the
guest disables fixed counter 2, KVM will get a false negative and fail to
reprogram/disable emulation of the counter, which can leads to incorrect
counts and spurious PMIs in the guest.

Fixes: 76d287b2342e ("KVM: x86/pmu: Drop "u8 ctrl, int idx" for reprogram_fixed_counter()")
Cc: stable@vger.kernel.org
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Link: https://lore.kernel.org/r/20240123221220.3911317-1-mizhang@google.com
[sean: rewrite changelog to call out the effects of the bug]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/pmu_intel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -71,7 +71,7 @@ static int fixed_pmc_events[] = {
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 {
 	struct kvm_pmc *pmc;
-	u8 old_fixed_ctr_ctrl = pmu->fixed_ctr_ctrl;
+	u64 old_fixed_ctr_ctrl = pmu->fixed_ctr_ctrl;
 	int i;
 
 	pmu->fixed_ctr_ctrl = data;


