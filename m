Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9168529BD9A;
	Mon,  4 May 2026 13:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903025; cv=none; b=gFBYNMffRi3H7ApH/FqeYHUfXvlX2CdBeRt6p1O8HbWGQpej3ktg4MYeCMn2uQ0TBL8jNzzlMEUummNCFhRei98C+w691SMhtLXZPEY8cF2+G6KwBb+twaImoECCW1AV4trxqdY3n6Qsaf6k1XYEgBZ0fy2FWdZvnCumPASEJX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903025; c=relaxed/simple;
	bh=7p8txR31dcYiQpWWlneWsrbLb7v2ju9cSfum0Gcfq0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6CRnKPTmW6xaafAEWoeQ4diYSWHEjoxxQJ/ngvUgTP6qjKE3Uz880HcsFaLrkV/FnD10oPXn3y1VBfmigIJqlWiH131eVvYdS7miWdJnzzFfyEBCfU6hXqyurzn+eqb/DcFIExlLrdiv3wUy4R6ALzKEiPH/Er/H5Nt1BrzzQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CcNKEkWU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CcNKEkWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286E2C2BCB8;
	Mon,  4 May 2026 13:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903025;
	bh=7p8txR31dcYiQpWWlneWsrbLb7v2ju9cSfum0Gcfq0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CcNKEkWU6aTRpOSfbYdwIKChqha+s1Qf/zBKTv+ef1vM8rdmHvaQN0j+JqvpKNcsT
	 LFBqqY6my3rSocxbn9rRrzun9b3r9ZceoA19C50KadtVXRDV+xjkqkdv06kY7n93FG
	 FgFYEq//NU/MqJsEz58yaI8akow6f8uQOd1o02/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiquan Li <zhiquan_li@163.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.0 075/307] KVM: selftests: Fix reserved value WRMSR testcase for multi-feature MSRs
Date: Mon,  4 May 2026 15:49:20 +0200
Message-ID: <20260504135145.637540155@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 9396cc1e282a280bcba2e932e03994e0aada4cd8 upstream.

When determining whether or not a WRMSR with reserved bits will #GP or
succeed due to the WRMSR not existing per the guest virtual CPU model,
expect failure if and only if _all_ features associated with the MSR are
unsupported.  Checking only the primary feature results in false failures
when running on AMD and Hygon CPUs with only one of RDPID or RDTSCP, as
AMD/Hygon CPUs ignore MSR_TSC_AUX[63:32], i.e. don't treat the bits as
reserved, and so #GP only if the MSR is unsupported.

Fixes: 9c38ddb3df94 ("KVM: selftests: Add an MSR test to exercise guest/host and read/write")
Reported-by: Zhiquan Li <zhiquan_li@163.com>
Closes: https://lore.kernel.org/all/20260209041305.64906-6-zhiquan_li@163.com
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260212103841.171459-5-zhiquan_li@163.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kvm/x86/msrs_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/kvm/x86/msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
@@ -175,7 +175,7 @@ void guest_test_reserved_val(const struc
 	 * If the CPU will truncate the written value (e.g. SYSENTER on AMD),
 	 * expect success and a truncated value, not #GP.
 	 */
-	if (!this_cpu_has(msr->feature) ||
+	if ((!this_cpu_has(msr->feature) && !this_cpu_has(msr->feature2)) ||
 	    msr->rsvd_val == fixup_rdmsr_val(msr->index, msr->rsvd_val)) {
 		u8 vec = wrmsr_safe(msr->index, msr->rsvd_val);
 


