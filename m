Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D743A14F9C8;
	Tue, 20 Feb 2024 21:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465091; cv=none; b=pZaezl+DIYoeY4uebVmrUNJnCZJfX7j4TMuI6EW6uTsxiZB2CdVZgDRJDzeB4FUGy1jYCMoISQXuXtjCC5pTHC0m/ClC6ZDmzx+X8qBEOVp4pDzTAMem6ij83HYGJAH1tvxsdgGwhKHvu8C8eVhF/3o1TcDMXKy1tzIGHW/IWYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465091; c=relaxed/simple;
	bh=A2vbwPZwgrWOPNdDRqUPJlfpEf+gDpsIXmjgxYL+x50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3uYiqfjG73h/q4sEzbGoLkOsBKJMyCWJj3wDNQZ8ri44Rgkkk8uICdCSc1V2HaQiIUICYgc7XRLRF8xdHn6P0HqP5GXnCxiDSwbzXmjeLujjiTxCuYJXmPwnvjjzSGaWnAJC8sBzSBc2Xn5AtyovZn8oxwdmGRYFnJR5uB8LOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G295MRig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G295MRig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EFDC433C7;
	Tue, 20 Feb 2024 21:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465091;
	bh=A2vbwPZwgrWOPNdDRqUPJlfpEf+gDpsIXmjgxYL+x50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G295MRigwRywYbdCfIU61jUrQCKqxVWr8qbfW7tZQzE9tNHH4/4WLTBrOWJtqTMYc
	 3lB9L6LRvS6uF5fE3qZ+aGnxD9Wfo/uLi5Dg7hO8eZdDP9i8tn+iLASfa0nqaewF7s
	 rAcaMTIaktcGdnDQmftetqGtHH/Kzo400WuIr91E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zhang <mizhang@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.7 234/309] KVM: x86/pmu: Fix type length error when reading pmu->fixed_ctr_ctrl
Date: Tue, 20 Feb 2024 21:56:33 +0100
Message-ID: <20240220205640.476232033@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


