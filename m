Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B761FE46D;
	Mon, 23 Jun 2025 21:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713399; cv=none; b=SMXK9Ez5uoc/XpJ2N+5JfQb5hwsCQk0SrDLr4dMWt8y+NhjywHy+8XrLcuaQrA3ZHIVheIIXdEeEfCVmHJoCUOkyRhY11T5Fdo0NQ3Tuq1pfgKHKKFaOKuBWISN9KGMS1FH8wJWiJD+QNHEBe+HKULD3vFAXtfKg3PARFTn0WEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713399; c=relaxed/simple;
	bh=aS0X4SJaG4DLGiC2IfCHk7GURUlU2tApPlsc0teruW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6UeX370xY2zCRuDlrhW/+L7+1kNydk6Qq/7IyRBWckvoIhH9LO8a0jUy3K8MCHc0rVb/afda+EcEzXgAYal5x+5qQ/Yk8G1qAXnDHkgnzRHsgzK3Zf8UQ6XbN/xGTnhhYH7Nc/oS3mtw1pT2LXvxSMQTQ7hAELjbGbb0WBpNUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAFXVtH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAFXVtH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D6DC4CEEA;
	Mon, 23 Jun 2025 21:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713399;
	bh=aS0X4SJaG4DLGiC2IfCHk7GURUlU2tApPlsc0teruW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAFXVtH16ZJDcFv2qzGzWMm+R9LIZvjEsGMRG0vpnTPyc5KJmGiTpUwVav9WMYzAc
	 eCRt4WgXro4LbsSj2FFQBmjYekMtBn2PLm1eLlecZVwbO6orNyXw6L64U/tKYTuBgR
	 MQgbkH2gk/A5N38LVg5vZJ1NUTbF8IT7Vr5rNdSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Gao <chao.gao@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 088/290] KVM: VMX: Flush shadow VMCS on emergency reboot
Date: Mon, 23 Jun 2025 15:05:49 +0200
Message-ID: <20250623130629.626637301@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -787,8 +787,11 @@ static void vmx_emergency_disable(void)
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


