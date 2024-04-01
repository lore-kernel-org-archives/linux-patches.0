Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CB045BE4;
	Mon,  1 Apr 2024 16:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988678; cv=none; b=LYhh9KNo+UMDdC4i85vYMkMGDEwRZuih8dHrSH0fck2DZIhw4ljWEzydgBT1IxpXeLvF6s1gTkaB864isq2/80iCuyAe/9FPyhOZnGVcp9hKQBlbDyizePWuLdOd6jhQaatbxnldYoGzKm8zKx7Is4f4fDcsYuYA4sEcnC48TFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988678; c=relaxed/simple;
	bh=jOxOpd+zHzQFmDT+8/Gu+mVxZgHiW400OHsO48092lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sn2PZNKHqiwT8gZhwVMOo2TNNY6goy8TKuMpthHXQrGj7XoTJjWTqWGVY3reRB1WFRIZYiaLmZ6234NW7FznoKDFzzrvL906nJEsdJkdy/QGGbnlAZAvOUqK5/Xnvw8Gm0YofoQFqtnjbAfRudonsP6WWEProFGwmX9DCQIW83E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBh/LeO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBh/LeO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20884C433F1;
	Mon,  1 Apr 2024 16:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988678;
	bh=jOxOpd+zHzQFmDT+8/Gu+mVxZgHiW400OHsO48092lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBh/LeO+NS2PVBwPBA8moI0cP1fhy5bvKM0BG7dYaZ7AtiaDw0rNmdwTeJmZP8T+a
	 Z6SY7AhJctrJGfBNPcXRIKdU27BbEihFBT5GbSq2GUHdU2Ait3oxY/tTaHdJpOp5tn
	 C+UthOCOXDuSOmYVPBEc6yPIY9Y7QjJvW3TZQlEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.7 255/432] SEV: disable SEV-ES DebugSwap by default
Date: Mon,  1 Apr 2024 17:44:02 +0200
Message-ID: <20240401152600.748031424@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 5abf6dceb066f2b02b225fd561440c98a8062681 upstream.

The DebugSwap feature of SEV-ES provides a way for confidential guests to use
data breakpoints.  However, because the status of the DebugSwap feature is
recorded in the VMSA, enabling it by default invalidates the attestation
signatures.  In 6.10 we will introduce a new API to create SEV VMs that
will allow enabling DebugSwap based on what the user tells KVM to do.
Contextually, we will change the legacy KVM_SEV_ES_INIT API to never
enable DebugSwap.

For compatibility with kernels that pre-date the introduction of DebugSwap,
as well as with those where KVM_SEV_ES_INIT will never enable it, do not enable
the feature by default.  If anybody wants to use it, for now they can enable
the sev_es_debug_swap_enabled module parameter, but this will result in a
warning.

Fixes: d1f85fbe836e ("KVM: SEV: Enable data breakpoints in SEV-ES")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -57,7 +57,7 @@ static bool sev_es_enabled = true;
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
 
 /* enable/disable SEV-ES DebugSwap support */
-static bool sev_es_debug_swap_enabled = true;
+static bool sev_es_debug_swap_enabled = false;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 #else
 #define sev_enabled false
@@ -612,8 +612,11 @@ static int sev_es_sync_vmsa(struct vcpu_
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
-	if (sev_es_debug_swap_enabled)
+	if (sev_es_debug_swap_enabled) {
 		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+		pr_warn_once("Enabling DebugSwap with KVM_SEV_ES_INIT. "
+			     "This will not work starting with Linux 6.10\n");
+	}
 
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);


