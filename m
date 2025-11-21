Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6034654763;
	Fri, 21 Nov 2025 13:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731384; cv=none; b=PDgN+UPI641tV/syY6ctjIMKLlSwEmvEmYmwXX1Q6hwJEEtuPy3PvIvUCZZSUodN+dz1ZVVuKzO2HGECuylinTGvixzb+VZM9M0mRKOumfmiiRLAswZNlJfmq2StWRelIeRgBESnakdvTm7jVjZ5JRNikGN3W1n2rZvD35Xb5vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731384; c=relaxed/simple;
	bh=O6UzYm9jfwVXkiZ+N+i+AK23NRzH1de7mIH3V6cQHU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtfGIU3EOiibjhS0qvpuC1b8QwVtYP5ObF59shDFq38lVZWV2c8ZdiE0j0NbsUpK1kj80P1wXpTnRZ5QAm9mJRceFm4v/YWVFZED/OaBAgSTvXY7JhP9ce+le46nAyc3uAL7D1qqGLb2D8SxLUjJEgnh2N3fxaZl26Gg7V88krA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JakxscX7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JakxscX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E111EC4CEF1;
	Fri, 21 Nov 2025 13:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731384;
	bh=O6UzYm9jfwVXkiZ+N+i+AK23NRzH1de7mIH3V6cQHU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JakxscX7eA/VCrZIzOUEC/WM00wRT2FTvwdFyoRLh1gjtx/Mvzm1S5ck1kBlgDlUV
	 RuzBIi7F0qv2+X7Lh1Q1ipxTM3F5d6E7hD/FplpwIa25d3MdsNEBnWqnuMTbNed9iR
	 Q9x5K5xwIcMqkIh+BT3vpCAb2Xpd3nLkv0uHbc5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sukrit Bhatnagar <Sukrit.Bhatnagar@sony.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.17 157/247] KVM: VMX: Fix check for valid GVA on an EPT violation
Date: Fri, 21 Nov 2025 14:11:44 +0100
Message-ID: <20251121130200.356953940@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sukrit Bhatnagar <Sukrit.Bhatnagar@sony.com>

commit d0164c161923ac303bd843e04ebe95cfd03c6e19 upstream.

On an EPT violation, bit 7 of the exit qualification is set if the
guest linear-address is valid. The derived page fault error code
should not be checked for this bit.

Fixes: f3009482512e ("KVM: VMX: Set PFERR_GUEST_{FINAL,PAGE}_MASK if and only if the GVA is valid")
Cc: stable@vger.kernel.org
Signed-off-by: Sukrit Bhatnagar <Sukrit.Bhatnagar@sony.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://patch.msgid.link/20251106052853.3071088-1-Sukrit.Bhatnagar@sony.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -98,7 +98,7 @@ static inline int __vmx_handle_ept_viola
 	error_code |= (exit_qualification & EPT_VIOLATION_PROT_MASK)
 		      ? PFERR_PRESENT_MASK : 0;
 
-	if (error_code & EPT_VIOLATION_GVA_IS_VALID)
+	if (exit_qualification & EPT_VIOLATION_GVA_IS_VALID)
 		error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) ?
 			      PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 


