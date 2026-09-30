Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CFF3750CF;
	Wed, 30 Sep 2026 17:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787883; cv=none; b=YeGsSKN/FIP7tg0uIspo7+aaQlh+EwDLTk2XBTxa9k8YmntIEkdNyk7mObkVtL5PxBtcWHJ2mjBV7g+FwGBqV/+VRJ4ghK7d97DZunYq1MNHCg+rtDhdcfZzrJ4+eSxVZpzSDKyOR/vPHtEHjzomVMWQFadogTwLvKUU6RNCY8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787883; c=relaxed/simple;
	bh=+3HeP4eiVbITF5XXX4lVRTVfjgpCcR10hv3+mM+sHz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f//go95LiBMBMqfvcZXfn9sWUN1dAAJE271ooyuo6soDee6UHiFvc+bVvKqHWLuhnlhCFEUFQzYZeBmSSg0VryK0Js5pU3g//jNmAOmwNFncWVO/zzj12MvBGIQhzKuNnMYmGF6cIIchJnn1H2/L6bQInx+x+lkloTuKy8ies/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ll9DPXAo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ll9DPXAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9CB1F000FF;
	Wed, 30 Sep 2026 17:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787882;
	bh=XcoyxctK6u7VI8YKGQd0CmyEVqcUKl5+fpNZRY2ysL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ll9DPXAox27lx/S6AZUbSHH4yNvFjLdI+1CFBSHbrGxIjV3GC7gBESFR08diMU4tu
	 aOZqo6rNiEYFAuT3hDXDeEEeBiu6QFdlI3HuV+pzQwrvI2/RDfyO1MX3wsILRKQVw0
	 6/e0T7tP3sOukH9LtP6u/hBoq1Wzqj5cfgZOvSF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.2 385/457] KVM: SEV: Free have_run_cpus during VM destruction even if VM is no longer SEV
Date: Wed, 30 Sep 2026 17:28:10 +0200
Message-ID: <20260930152354.305485174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 12c1f6e03f944e399bd2c88441dca5dc702b95a5 upstream.

Unconditionally free SEV's "have run CPUs" cpumask in the VM destroy path,
i.e. even for what appear to be non-SEV VMs, as an SEV VM becomes a non-SEV
VM if its state is intra-host migrated.  Alternatively, the mask could be
freed in sev_migrate_from() when "converting" the source VM, but that gets
annoying because ideally KVM would nullify the mask to guard against UAF,
and nullifying the mask would need be conditioned on CPUMASK_OFFSTACK=y.

Freeing the mask during sev_migrate_from() is also not robust against other
KVM bugs, though that's kind of a moot point since any such bugs would show
up even if sev->active is never set.  I.e. KVM must get that side of things
correct.  But, that's not a great reason to add more code just to make
things marginally less robust.

Fixes: 6f38f8c57464 ("KVM: SVM: Flush cache only on CPUs running SEV guest")
Cc: stable@vger.kernel.org
Reported-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260923163721.1584779-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2981,13 +2981,17 @@ void sev_vm_destroy(struct kvm *kvm)
 	struct list_head *head = &sev->regions_list;
 	struct list_head *pos, *q;
 
+	/*
+	 * Free the mask even if the VM is not *currently* an SEV VM, as it may
+	 * have been an SEV VM prior to intra-host migration.
+	 */
+	free_cpumask_var(sev->have_run_cpus);
+
 	if (!sev_guest(kvm))
 		return;
 
 	WARN_ON(!list_empty(&sev->mirror_vms));
 
-	free_cpumask_var(sev->have_run_cpus);
-
 	/*
 	 * If this is a mirror VM, remove it from the owner's list of a mirrors
 	 * and skip ASID cleanup (the ASID is tied to the lifetime of the owner).


