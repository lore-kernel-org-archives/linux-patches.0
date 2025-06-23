Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E004253B68;
	Mon, 23 Jun 2025 13:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684666; cv=none; b=Kt6ITHAvkT/a1Bh235C1EqYgVtJyyr5R0fPzQcjpR2/DHfyhz4+g5d3AkpeYeZUOelZLRFAnMieJiq1+AE6xavXT0J4n3GJCBtQkS1qpTmbunbU3Gw4PbQSLy7PoB3b22AHEiG3XckJ7EmWYwNUWv1enCYn46Jt/W7eScIyRAg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684666; c=relaxed/simple;
	bh=IKchYsAOxz/TRVz2OgbfMXdbp0r/ZrUqwMiia3ewGqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFVUzCASRYd8dnbHVRmkCMXcyv5Yzj5hrHSYmnAAeGmxXfUbPwCBQWOSzCtLn3VAuj+77c9XrGBmX9FSZPSQd3Ee5TUSAz5gRF6opcfct3NdAYwEnY3fYgVtGV/Oyu1Cw82BjuecFxUWtKtbHrD6wzA5jXa6xs20k/BbrapBses=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9MyLPZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9MyLPZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C21C4CEF0;
	Mon, 23 Jun 2025 13:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684666;
	bh=IKchYsAOxz/TRVz2OgbfMXdbp0r/ZrUqwMiia3ewGqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9MyLPZDS9dAPbca3aUtxw1J1c1vdv7J8W+u5cAsAX8k9+NhU6sTh8juzisCMTxhM
	 YISwowDm3YJwXesibGpAeC3VQ0Kkwe+IGg+Tym0/4FIBSWG5Dyt/pTqT/u6Qc0SHRj
	 HVWeUZpij5eyym2XZPLMy+FixLprdjFDiq69glR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Gao <chao.gao@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.15 150/592] KVM: VMX: Flush shadow VMCS on emergency reboot
Date: Mon, 23 Jun 2025 15:01:48 +0200
Message-ID: <20250623130703.850174780@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Gao <chao.gao@intel.com>

commit a0ee1d5faff135e28810f29e0f06328c66f89852 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -769,8 +769,11 @@ void vmx_emergency_disable_virtualizatio
 		return;
 
 	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
-			    loaded_vmcss_on_cpu_link)
+			    loaded_vmcss_on_cpu_link) {
 		vmcs_clear(v->vmcs);
+		if (v->shadow_vmcs)
+			vmcs_clear(v->shadow_vmcs);
+	}
 
 	kvm_cpu_vmxoff();
 }


