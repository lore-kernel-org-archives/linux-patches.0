Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC87B3B3BE6;
	Fri,  9 Oct 2026 14:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557404; cv=none; b=G4A7LSTDgJeKNXRB2/146zX2TkVnzswKrRWY77a7W1LTVWYQKz+TYVVXhAdu7ZkLhK8CMbuQZxU2sBkY4vlvpwBX8FhytnFh004e2euV0edVd1DZv1sOSdIhSlyPdCrL+bArZa3yJEK0/KkPSYU0A+UYVrWwH/vlVdraoGH5VBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557404; c=relaxed/simple;
	bh=Z47jHj5BvKsVbNF9o9ujkXo0kn2jcHHUava5zXDu0EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+EhiRQOr36wwQdeZCeujYdoMZhNKAPzwo/+DtQF6ygoVBWCAHZACVc/wdiuQYTGlNghMLPRLq5P9LO5xJg8GJIgHsip7C4NUCPdQqzps0CVJWPx9LFoab1US+u4+wP+pe1WHOadlsxy1RA9FFSJmqTI6Z/SdrR345F1egjWL1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qiz7pJd/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qiz7pJd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322151F000FF;
	Fri,  9 Oct 2026 14:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557403;
	bh=RL5PzjEBX8bWaRgURkrIHE87pXI4C2D5sNjkOPJsaxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qiz7pJd/9bKIzIXJZ/u6AidDqHxOBO1ZfQWHyaqpHZhK0kym4VrxKT540exVP62tN
	 w62LTMcgfXHKAb2LQZmKM33Mr6L7wuKB726wptTbOUwI2t1RYQl7HNN67gqBeDvpYV
	 gnv3bZEJM9p+AY8wl/EERHg6Bi+XfdTKrmwTlXTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko Bot <sashiko-bot@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.2 313/428] KVM: SEV: Do cache maintenance on the source VM *before* clearing SEV state
Date: Fri,  9 Oct 2026 16:10:50 +0200
Message-ID: <20261009140953.000037082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

commit 973ea70393e885e540f714904e51bc6cac80e3d7 upstream.

Explicitly flush caches after intra-host migration before clearing "SEV
active" on the source VM, as doing cache maintenance afterwards creates a
tiny window where memory reclaim could return memory to the host without
performing a cache flush, e.g. as pointed out by Sashiko:

  CPU1 in sev_migrate_from():
    src->active = false;

  CPU2 running concurrent unmap:
    Since active is false, the automatic cache flush in
    sev_guest_memory_reclaimed is skipped.
    The host frees and reallocates the page.

  CPU1 in sev_migrate_from():
    sev_writeback_caches(src_kvm);
    Executes a hardware cache flush (wbnoinvd), which writes the guest's old
    dirty ciphertext over the new page owner's data.

Fixes: 93de2a6a4b91 ("KVM: SEV: Do cache maintenance on the source VM during intra-host migration")
Cc: stable@vger.kernel.org
Reported-by: Sashiko Bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260923165304.1662E1F000FF@smtp.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20260928154644.2559454-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2048,6 +2048,13 @@ static void sev_migrate_from(struct kvm
 	struct kvm_sev_info *mirror;
 	unsigned long i;
 
+	/*
+	 * Do cache maintenance on the source VM *before* clearing "SEV active",
+	 * as memory reclaim flows won't trigger cache maintenance on the VM
+	 * once it's no longer an SEV VM.
+	 */
+	sev_writeback_caches(src_kvm);
+
 	dst->active = true;
 	dst->asid = src->asid;
 	dst->handle = src->handle;
@@ -2061,12 +2068,6 @@ static void sev_migrate_from(struct kvm
 	src->pages_locked = 0;
 	src->es_active = false;
 
-	/*
-	 * Do cache maintenance on the source VM as it is no longer an SEV VM,
-	 * i.e. memory reclaim flows won't trigger cache maintenance on the VM.
-	 */
-	sev_writeback_caches(src_kvm);
-
 	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
 
 	mutex_lock(&sev_mirror_lock);


