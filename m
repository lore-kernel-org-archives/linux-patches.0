Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE464151CDD;
	Tue, 20 Feb 2024 21:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463082; cv=none; b=F2duqrerOT9IX57kgn17Z9sEk9qeMcT1hG+gHsrToLyXuRIRh7MyzfNsrdPT67OuVIB/00n46WUyHZfB3yfQPBeguakgrjttzOD2MXSX54617Twfuh0Hvu8HCxUD1a5vI5lF16TiPEyYRPToWspjEn3Kao7pdBlK9qZzZS418z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463082; c=relaxed/simple;
	bh=clyBH0icWTkTKJc5jUCFnyN0OBl6CdPGVEjdswt6fxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6yi/hOxPsPv3zMWsWalbmwwfFg0/Mjbq1XX7zai84kSyzjZ7VLAdjJkwASg791/9cR55qeNW9VqnEmD+9YzDLPfyfdeccQaxEY5rjP+DXWPGit1W6AGmROAflTIb3oDCIAvB2J/RoHVyMx6ks6n12S2Jleum59yQD4HhaEhXpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+h7nt+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+h7nt+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFF8C433F1;
	Tue, 20 Feb 2024 21:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463081;
	bh=clyBH0icWTkTKJc5jUCFnyN0OBl6CdPGVEjdswt6fxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+h7nt+o3C9vDhm142tqn5vH036R6kzZAiMH77GfD0gPelgnr6L8b7VCqytXt2lJK
	 6S3i/lgtU0xSjfJcPhgtGwPBK+/lUJHcht8g6qWnUO0QiW2vKlzilG7UKOmLXFHPRk
	 FvGxnwIAUVdAdMonV7RvLp21qUXYyc4nSvorJQJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zhang <mizhang@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 129/197] KVM: x86/pmu: Fix type length error when reading pmu->fixed_ctr_ctrl
Date: Tue, 20 Feb 2024 21:51:28 +0100
Message-ID: <20240220204844.933540146@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -38,7 +38,7 @@ static int fixed_pmc_events[] = {1, 0, 7
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 {
 	struct kvm_pmc *pmc;
-	u8 old_fixed_ctr_ctrl = pmu->fixed_ctr_ctrl;
+	u64 old_fixed_ctr_ctrl = pmu->fixed_ctr_ctrl;
 	int i;
 
 	pmu->fixed_ctr_ctrl = data;


