Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFD53DE42E;
	Mon,  4 May 2026 14:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903804; cv=none; b=PP/d66pfqzRbBgug9FGBEuGTFO2VPT1xYehkXaRkEgshj9XMGaolcTQYoIwbp7MuIypKmwWF8nmB6maxvNwxY69wFv6gYS1XCff7CjvhkgjYHRYxWOhCg0BzJTnNv5MGOpkHUVA6nIPIwhu2xHXlrOf0v1lER8xe9H+J0YsZoRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903804; c=relaxed/simple;
	bh=rSELtAeXp5gw3bkDRnPKpbp0ewP5vUqfSUKEDlbEMQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uc5EzZC5PRniUwIIVUBe+mO2XbDRsBm4NspY+J4Z7ziwzqi5UOjBFAyrhGPws0F8W2vIwCAEIcI2g7/oKJH8WrnjuS4lPxo0sQ46KvizKhh+yH+AHY53+a3sdd5OB+DUk4plVQrYV610aFacsagCOBxNYcEW5H/cppkHgU8xbu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aopzo4nA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aopzo4nA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0581EC2BCB8;
	Mon,  4 May 2026 14:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903804;
	bh=rSELtAeXp5gw3bkDRnPKpbp0ewP5vUqfSUKEDlbEMQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aopzo4nAVBQu0p+jjcf44KgK3OkMguX7dqMNWkQDeY/02qJV0SjN4amhin5AoEXQE
	 NYk+qFPDLzedxvp/Gav4JaTNdWBSeEJgZriQjY2+GDOeHywznO2v9ZsZ5vnqXn9JV0
	 rbs99bU9T4QZ2SmG6A33Ef1yXwWWoBcBHYjvioXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiquan Li <zhiquan_li@163.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 069/275] KVM: selftests: Fix reserved value WRMSR testcase for multi-feature MSRs
Date: Mon,  4 May 2026 15:50:09 +0200
Message-ID: <20260504135145.495324690@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 tools/testing/selftests/kvm/x86/msrs_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/selftests/kvm/x86/msrs_test.c
index 4c97444fdefe..f7e39bf887ad 100644
--- a/tools/testing/selftests/kvm/x86/msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
@@ -175,7 +175,7 @@ void guest_test_reserved_val(const struct kvm_msr *msr)
 	 * If the CPU will truncate the written value (e.g. SYSENTER on AMD),
 	 * expect success and a truncated value, not #GP.
 	 */
-	if (!this_cpu_has(msr->feature) ||
+	if ((!this_cpu_has(msr->feature) && !this_cpu_has(msr->feature2)) ||
 	    msr->rsvd_val == fixup_rdmsr_val(msr->index, msr->rsvd_val)) {
 		u8 vec = wrmsr_safe(msr->index, msr->rsvd_val);
 
-- 
2.54.0



