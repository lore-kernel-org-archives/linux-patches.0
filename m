Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60BA4409;
	Mon, 23 Jun 2025 21:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714691; cv=none; b=K5Ivha1/JIeBo1qx2g0Xo97YoqaE75msbJaSRIKYIQWJ9o3zWZ3gaIyCpPJFsRQRCstavVaLBKMSNUrIFuR7zeYJ2yjvcXsJf+UWZh8s1UB3xvwpqWsSt8zoBQrO0ZC9aS0DcCdu0dLGJv2IOC9cASvwM9czhkSf9KXgpFbH7VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714691; c=relaxed/simple;
	bh=hKn+ZZ2NKpoBlWjBVjTULORrWNq/gBV8IZF5A8C1P3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKlw/qkXQakCoghI94Lv48iz9Uk3nqwB49RhGGbecqQ+T4UqBs89E2c65sLe2okB9msEBQuO+R7SLp0BIyhh3xdHJk4w1iZIaYpMsBOt3EhQ7K4ZysCW3mtlYy8kClR3NCUWGC3P3KzykfYOWJ+kK/9r/5lRVvamdV5qcO/IXC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EOd7dLOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EOd7dLOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC8CC4CEED;
	Mon, 23 Jun 2025 21:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714691;
	bh=hKn+ZZ2NKpoBlWjBVjTULORrWNq/gBV8IZF5A8C1P3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOd7dLOgQ5Dsu9fJ8Ta7naPQu8pcC1KtESPV0JIgQ97h/acqu1QARUtdyRnjQ+yEC
	 pO4wSUzdj9iJzobV2B84fcynqNG3ih4iRAQ4ek0+TWLWqE4rkAFgCdKurdoMFRerRY
	 qyrbpyW1rSbu/uQgB0emQZoT2g3k2kVMbqEsXR24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Gao <chao.gao@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 124/414] KVM: VMX: Flush shadow VMCS on emergency reboot
Date: Mon, 23 Jun 2025 15:04:21 +0200
Message-ID: <20250623130645.166397817@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -770,8 +770,11 @@ void vmx_emergency_disable_virtualizatio
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


