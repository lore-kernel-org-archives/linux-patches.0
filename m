Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A4B335541;
	Fri, 21 Nov 2025 13:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732042; cv=none; b=Q2/KJm7M5v8UIprfnQamUnLl9e2aj7muqHC+1gqZ6s/f3/IN25Vjm/Av1FEA2nxQ1CkLlq34hMd5nJxBJesYMs+SCDZs+U0PI93iVm9ZP+AY5ANw7yxP2tVBG2BipCi7oyXBkzNS4pyUo04RlqXh+bm2pFILcsZPNvxBTkaAuUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732042; c=relaxed/simple;
	bh=//AE5JizHkORpV/3gvu5MrikDwo+wsJkAQoQQHP6ShU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ep/ROFPOTTXvOeuklXg4enGiTHrlmyL/0fpZLRL+24no2leTCndNPKzGB1mpy0+wsHsY0UtUKDDYOfkFh9ETseAmaywejf80yKqzsTsJV7yca4WEWNlRw1fYPFR0T8YptHxZqUY27WzzJ2Gw5c1UMSXZ/nSGXOPf8acaOd4lz0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Ai8jA6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Ai8jA6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526EFC4CEF1;
	Fri, 21 Nov 2025 13:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732042;
	bh=//AE5JizHkORpV/3gvu5MrikDwo+wsJkAQoQQHP6ShU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Ai8jA6ROPJ2cgukNO5jQdfQ2wNF+C+jMkb9sD3VhCusODKIEybmZXeaUV0WO+2mD
	 OCC4QNHr5x8Dn0EONMFf+8dJL6mrODAjExLFG5EDf5h95u2Gt3MsBKuvKlOV4gEJ1r
	 v2KZvHl+pfhCeNOQhGmbypMVzNoNZ5FoLOyGXAJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sukrit Bhatnagar <Sukrit.Bhatnagar@sony.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 170/185] KVM: VMX: Fix check for valid GVA on an EPT violation
Date: Fri, 21 Nov 2025 14:13:17 +0100
Message-ID: <20251121130150.019304053@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Sukrit Bhatnagar <Sukrit.Bhatnagar@sony.com>

[ Upstream commit d0164c161923ac303bd843e04ebe95cfd03c6e19 ]

On an EPT violation, bit 7 of the exit qualification is set if the
guest linear-address is valid. The derived page fault error code
should not be checked for this bit.

Fixes: f3009482512e ("KVM: VMX: Set PFERR_GUEST_{FINAL,PAGE}_MASK if and only if the GVA is valid")
Cc: stable@vger.kernel.org
Signed-off-by: Sukrit Bhatnagar <Sukrit.Bhatnagar@sony.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://patch.msgid.link/20251106052853.3071088-1-Sukrit.Bhatnagar@sony.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -24,7 +24,7 @@ static inline int __vmx_handle_ept_viola
 	error_code |= (exit_qualification & EPT_VIOLATION_RWX_MASK)
 		      ? PFERR_PRESENT_MASK : 0;
 
-	if (error_code & EPT_VIOLATION_GVA_IS_VALID)
+	if (exit_qualification & EPT_VIOLATION_GVA_IS_VALID)
 		error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) ?
 			      PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 


