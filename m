Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2B7239E8B;
	Tue, 26 Aug 2025 13:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216786; cv=none; b=FTA5mRvZjwwnKRKxNWWLDKDJuLM2fO4S8V6lV/l1SgzyE0/l1vscjaDoFPOJBkjDSlz6OLKqHUl+k3cXNz6im/vqUPuR64OjhUUOqo71etx0iNfhSQsq+2A+lvhxYbv74QcljZo7XYnGWyT58gfOZR/lKM/uZOh0znTyJL1tJdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216786; c=relaxed/simple;
	bh=HqvJimAvuSH+w6jRTCC9nh5pJ07y32bohTnPtPdD0Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrIr7jNg3uTjScIShwWgn+Tyqx58vhKJwgM9zPxqPtUrfoE3MLMcrjlEJEtmkCaZJizU9mv+tOMEgbkJAavUESZntVil19wO33JUcFI7W4BASCMxJ4f6nWYV/+NGJukqMnFrcYwuGUZYRj9zGuKn4Dgj/G4LFRLyoApZ551CaF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2xtCyHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2xtCyHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6F4C113CF;
	Tue, 26 Aug 2025 13:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216786;
	bh=HqvJimAvuSH+w6jRTCC9nh5pJ07y32bohTnPtPdD0Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2xtCyHbCquSlszL/amO/NsiAw+PMiyekXDM5LKPhsySk+b2Dt5tsCFJhQxvTUG3M
	 duZlx9ZgL8dmtx8AU7i68R+19RyLRohulP4WdrCtL0N+TmJYW0eINetbEHScP1k1p6
	 XD/JYyRVsvC75GSJg/vGGpeh8sJTaq8GPlFFIypE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Gao <chao.gao@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 544/644] KVM: VMX: Flush shadow VMCS on emergency reboot
Date: Tue, 26 Aug 2025 13:10:35 +0200
Message-ID: <20250826110959.999488726@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Gao <chao.gao@intel.com>

[ Upstream commit a0ee1d5faff135e28810f29e0f06328c66f89852 ]

Ensure the shadow VMCS cache is evicted during an emergency reboot to
prevent potential memory corruption if the cache is evicted after reboot.

This issue was identified through code inspection, as __loaded_vmcs_clear()
flushes both the normal VMCS and the shadow VMCS.

Avoid checking the "launched" state during an emergency reboot, unlike the
behavior in __loaded_vmcs_clear(). This is important because reboot NMIs
can interfere with operations like copy_shadow_to_vmcs12(), where shadow
VMCSes are loaded directly using VMPTRLD. In such cases, if NMIs occur
right after the VMCS load, the shadow VMCSes will be active but the
"launched" state may not be set.

Fixes: 16f5b9034b69 ("KVM: nVMX: Copy processor-specific shadow-vmcs to VMCS12")
Cc: stable@vger.kernel.org
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Link: https://lore.kernel.org/r/20250324140849.2099723-1-chao.gao@intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ adjusted context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -681,8 +681,11 @@ static void crash_vmclear_local_loaded_v
 	struct loaded_vmcs *v;
 
 	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
-			    loaded_vmcss_on_cpu_link)
+			    loaded_vmcss_on_cpu_link) {
 		vmcs_clear(v->vmcs);
+		if (v->shadow_vmcs)
+			vmcs_clear(v->shadow_vmcs);
+	}
 }
 #endif /* CONFIG_KEXEC_CORE */
 


