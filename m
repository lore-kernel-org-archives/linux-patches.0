Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAD3330B04;
	Fri, 17 Oct 2025 15:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715278; cv=none; b=kiOgqXj0SCV/SSfqM+mdy5g0kGa8p1D0IxKCjpkokkBCwMLkoeAbpSbEyUHtaacr/7cCRWVeDAJMs89YXj6nhCLH3XcK2htvozOSzjY+NqUW5M80NO/3S0vvEC1Ky7PYfSNIyt0R2ULTlgqY/CeWNsQbTx4nVxlyoiRPSfU5asI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715278; c=relaxed/simple;
	bh=ARXmK2ldV2BwMGHZNaJxHRyhMdmdcvAHkaWO22VtKdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qjxe+W8mglZhbEzd8IVryvsjxQNzueFVDfmPBLovBxMxbcZXFxLgCiNHn4PsmRQmj5nKLeSJsOc668/uMhuavQDNGw7AcUJAjCrw7Kxu5bBV8kyFX247xv3i3p8Vr0Ff/qAEkHTDbB2l3GbtHKMxyb6RTKtO4OXng6K65L0R1fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0hn+4E7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0hn+4E7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E344C4CEE7;
	Fri, 17 Oct 2025 15:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715278;
	bh=ARXmK2ldV2BwMGHZNaJxHRyhMdmdcvAHkaWO22VtKdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g0hn+4E7tf56CeBVrm79Dp4ykhfW7HIiTSwMKU+vF8fP1VkfOFv8PZ+08gq0Agv8s
	 JqhzJppE9KH0v7Vk/u4XpvpBG4q7I8uglspjWWYjGQoXlFqu7WI6QYNeRZnMSU4lGX
	 DmEMR2zVZBc18g8dV0k6o73e37mfkXeuy8ZraACM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kai Huang <kai.huang@intel.com>,
	Tony Lindgren <tony.lindgren@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.17 159/371] KVM: TDX: Fix uninitialized error code for __tdx_bringup()
Date: Fri, 17 Oct 2025 16:52:14 +0200
Message-ID: <20251017145207.685746269@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Tony Lindgren <tony.lindgren@linux.intel.com>

commit 510c47f165f0c1f0b57329a30a9a797795519831 upstream.

Fix a Smatch static checker warning reported by Dan:

	arch/x86/kvm/vmx/tdx.c:3464 __tdx_bringup()
	warn: missing error code 'r'

Initialize r to -EINVAL before tdx_get_sysinfo() to simplify the code and
to prevent similar issues from sneaking in later on as suggested by Kai.

Cc: stable@vger.kernel.org
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 61bb28279623 ("KVM: TDX: Get system-wide info about TDX module on initialization")
Suggested-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Link: https://lore.kernel.org/r/20250918053226.802204-1-tony.lindgren@linux.intel.com
[sean: tag for stable]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/tdx.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3457,12 +3457,11 @@ static int __init __tdx_bringup(void)
 	if (r)
 		goto tdx_bringup_err;
 
+	r = -EINVAL;
 	/* Get TDX global information for later use */
 	tdx_sysinfo = tdx_get_sysinfo();
-	if (WARN_ON_ONCE(!tdx_sysinfo)) {
-		r = -EINVAL;
+	if (WARN_ON_ONCE(!tdx_sysinfo))
 		goto get_sysinfo_err;
-	}
 
 	/* Check TDX module and KVM capabilities */
 	if (!tdx_get_supported_attrs(&tdx_sysinfo->td_conf) ||
@@ -3505,14 +3504,11 @@ static int __init __tdx_bringup(void)
 	if (td_conf->max_vcpus_per_td < num_present_cpus()) {
 		pr_err("Disable TDX: MAX_VCPU_PER_TD (%u) smaller than number of logical CPUs (%u).\n",
 				td_conf->max_vcpus_per_td, num_present_cpus());
-		r = -EINVAL;
 		goto get_sysinfo_err;
 	}
 
-	if (misc_cg_set_capacity(MISC_CG_RES_TDX, tdx_get_nr_guest_keyids())) {
-		r = -EINVAL;
+	if (misc_cg_set_capacity(MISC_CG_RES_TDX, tdx_get_nr_guest_keyids()))
 		goto get_sysinfo_err;
-	}
 
 	/*
 	 * Leave hardware virtualization enabled after TDX is enabled


