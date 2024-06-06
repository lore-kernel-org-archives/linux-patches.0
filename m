Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBCE196D9B;
	Thu,  6 Jun 2024 14:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683005; cv=none; b=Iokq5X/+tCD6lTI4X/IBrbIKmK7Lc8ZI7RZzdRoVbkrDdSbzDgcfSWQ/C25UGXNqECiBVruM8b9ggsYnqyY9DfaivrDRKJ+R/nSIop8nQsPdpVcFhwAlYCHHMyJ6dzJuPQktHUUqmJAgt9JBNXpOxaC+3/fz5f/AwAmCDFswgGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683005; c=relaxed/simple;
	bh=G5723X7617AI+tONuSEEeEtr8Qye1PaFpbQdnLKD7+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxidrYSdCiFO+PvdKWPVRH47VNansL7HQ93MptRPQfxqy9NLOHLmv8OLapU5Dg2UEoaVkshMjjRoE3uI7GZcU0679fffNXR4wjX0UdlbLATR1AWsSliuYSix6D16zl7JL8/wCFSmCxnOGZshGwwM096gmpN/9yjkpD7T4kWd9XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sq+J+MLL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sq+J+MLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8063C2BD10;
	Thu,  6 Jun 2024 14:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683005;
	bh=G5723X7617AI+tONuSEEeEtr8Qye1PaFpbQdnLKD7+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sq+J+MLLRSltBC5BWLTJEDYE/4/SYIJNoTWW1+w34WTK2Tz3AdJpRrGfOyOhFjv2E
	 WIvvNTeZjoZxWWw7LiRX9lIaMl4gSk+yu9aRRHIijyV4b73aF/xAUM9SfsxuOg4m8u
	 qxDbuj2WQK/cOXTpA1Eq+KmJApm0H6abdeUQkzPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 212/374] KVM: PPC: Book3S HV nestedv2: Cancel pending DEC exception
Date: Thu,  6 Jun 2024 16:03:11 +0200
Message-ID: <20240606131658.913706104@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vaibhav Jain <vaibhav@linux.ibm.com>

[ Upstream commit 7be6ce7043b4cf293c8826a48fd9f56931cef2cf ]

This reverts commit 180c6b072bf3 ("KVM: PPC: Book3S HV nestedv2: Do not
cancel pending decrementer exception") [1] which prevented canceling a
pending HDEC exception for nestedv2 KVM guests. It was done to avoid
overhead of a H_GUEST_GET_STATE hcall to read the 'DEC expiry TB' register
which was higher compared to handling extra decrementer exceptions.

However recent benchmarks indicate that overhead of not handling 'DECR'
expiry for Nested KVM Guest(L2) is higher and results in much larger exits
to Pseries Host(L1) as indicated by the Unixbench-arithoh bench[2]

Metric	    	      | Current upstream    | Revert [1]  | Difference %
========================================================================
arithoh-count (10)    |	3244831634	    | 3403089673  | +04.88%
kvm_hv:kvm_guest_exit |	513558		    | 152441	  | -70.32%
probe:kvmppc_gsb_recv |	28060		    | 28110	  | +00.18%

N=1

As indicated by the data above that reverting [1] results in substantial
reduction in number of L2->L1 exits with only slight increase in number of
H_GUEST_GET_STATE hcalls to read the value of 'DEC expiry TB'. This results
in an overall ~4% improvement of arithoh[2] throughput.

[1] commit 180c6b072bf3 ("KVM: PPC: Book3S HV nestedv2: Do not cancel pending decrementer exception")
[2] https://github.com/kdlucas/byte-unixbench/

Fixes: 180c6b072bf3 ("KVM: PPC: Book3S HV nestedv2: Do not cancel pending decrementer exception")
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240415035731.103097-1-vaibhav@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 8e86eb577eb8e..692a7c6f5fd91 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4857,7 +4857,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	 * entering a nested guest in which case the decrementer is now owned
 	 * by L2 and the L1 decrementer is provided in hdec_expires
 	 */
-	if (!kvmhv_is_nestedv2() && kvmppc_core_pending_dec(vcpu) &&
+	if (kvmppc_core_pending_dec(vcpu) &&
 			((tb < kvmppc_dec_expires_host_tb(vcpu)) ||
 			 (trap == BOOK3S_INTERRUPT_SYSCALL &&
 			  kvmppc_get_gpr(vcpu, 3) == H_ENTER_NESTED)))
-- 
2.43.0



