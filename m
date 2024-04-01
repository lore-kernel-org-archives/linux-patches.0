Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB53433DA;
	Mon,  1 Apr 2024 16:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990094; cv=none; b=EMSuqtf/zLmbxCJo0qD3c3u/NpFOfbIAOE/OE3HtVlggZ+vwTQ/o2zK8tPNaPoksP2mOpEVfxmImYR8llSz/YELxEbiY7drvgzWu0EnbGDIsmfGp/p7Gd3+MK0zTlEKInRdeVYT4PqAuIFJwDX7Z9Y2Ip8jJbDKXrYZitWERdu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990094; c=relaxed/simple;
	bh=T6vIuoyUbQEzka1q0syozSZLq9G6dfSOhyrsPyhHYkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4HQXcqN0SiE0E7+4UYzX3xWMIaDHDMkXwJjFH+j5k11cq5z2z1heu9ukuYSx2sn2rxqgX3I8qfMR0PdaGA/ZYwM7BmTE3BQMCNDw1yf3gh7/g83zHn0v+PAzta5a8JWp2h6Uhs2vvS400oWxoedQYNElbVJE6hwfhUHxcZF6FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0Urk2aT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0Urk2aT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E3FC433F1;
	Mon,  1 Apr 2024 16:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990093;
	bh=T6vIuoyUbQEzka1q0syozSZLq9G6dfSOhyrsPyhHYkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0Urk2aTKRx2q9EnS/bAvjURdsTCxePiRiyH1U9rjpAiEaVN0Qe8K3W/0UGyRlFxG
	 bKT4rVqkEHjMklIcD/O8oVa3YWXwEv14F3JqPJSDmAYz5J2TAmn5tVD+OtDGqfsZSZ
	 W8uwAhnczF9orO2sPXetkpcnewUTSP8a2x5fqDvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 215/396] SEV: disable SEV-ES DebugSwap by default
Date: Mon,  1 Apr 2024 17:44:24 +0200
Message-ID: <20240401152554.334076078@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 arch/x86/kvm/svm/sev.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a132547fcfb5..a8ce5226b3b5 100644
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
@@ -612,8 +612,11 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
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
-- 
2.44.0



