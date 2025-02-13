Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA3919C54B;
	Thu, 13 Feb 2025 15:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459130; cv=none; b=b+l3l+DSA/wGDFK8ro3tlZXERFAG/f5T6D1iRUBw5uAXkgA8vaLWFptS4sOcDWEZUuWyk18idLmN6VvqRzM+/bwQMC+GKLPTO9yByCNJj8L3152SvX7RLh77jEgErj/7Z767lnH/kFpNm+HYyTeZi5fdZtkfJfDnORzcGbECK2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459130; c=relaxed/simple;
	bh=hCCfmW7D7AhzFnzTOP8M17VoeDJkfx5m9ILcNwAwA1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GScIkVqy7aaubqH7uXdVRbmp9E88n3VriJfgx+MjrCOYvheZ+/o8YSrGC42/VjxMkMcPKqMdrKmgrY833mGMNzbzp+QEbCMG7h5LGVoEtgOJ5AelHMRZAaCymbIIuj43+AQZGJHMvDZ57EjNSU+AdzEpa2M3YjiDHT3bTMVcDm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iLOoZAp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iLOoZAp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A5FC4CED1;
	Thu, 13 Feb 2025 15:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459129;
	bh=hCCfmW7D7AhzFnzTOP8M17VoeDJkfx5m9ILcNwAwA1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLOoZAp2ZFhf6Tm0chbl7T/PITJuEyGgO8Bo2eAtTpm0IVdlpLkuWJX+4ez1U18RB
	 pnQYUw8Ykb/9SjJpre9xYGy/LLiNfjXBNTwTv2AvG2nHilDQP4cTD6WiHoCxs3n4U2
	 UfPNkiBL+y7lM9oiuTL1h4FG/00soRmQKCRJQW+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Michal Luczaj <mhal@rbox.co>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.13 169/443] KVM: Explicitly verify target vCPU is online in kvm_get_vcpu()
Date: Thu, 13 Feb 2025 15:25:34 +0100
Message-ID: <20250213142447.124485000@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 1e7381f3617d14b3c11da80ff5f8a93ab14cfc46 upstream.

Explicitly verify the target vCPU is fully online _prior_ to clamping the
index in kvm_get_vcpu().  If the index is "bad", the nospec clamping will
generate '0', i.e. KVM will return vCPU0 instead of NULL.

In practice, the bug is unlikely to cause problems, as it will only come
into play if userspace or the guest is buggy or misbehaving, e.g. KVM may
send interrupts to vCPU0 instead of dropping them on the floor.

However, returning vCPU0 when it shouldn't exist per online_vcpus is
problematic now that KVM uses an xarray for the vCPUs array, as KVM needs
to insert into the xarray before publishing the vCPU to userspace (see
commit c5b077549136 ("KVM: Convert the kvm->vcpus array to a xarray")),
i.e. before vCPU creation is guaranteed to succeed.

As a result, incorrectly providing access to vCPU0 will trigger a
use-after-free if vCPU0 is dereferenced and kvm_vm_ioctl_create_vcpu()
bails out of vCPU creation due to an error and frees vCPU0.  Commit
afb2acb2e3a3 ("KVM: Fix vcpu_array[0] races") papered over that issue, but
in doing so introduced an unsolvable teardown conundrum.  Preventing
accesses to vCPU0 before it's fully online will allow reverting commit
afb2acb2e3a3, without re-introducing the vcpu_array[0] UAF race.

Fixes: 1d487e9bf8ba ("KVM: fix spectrev1 gadgets")
Cc: stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>
Cc: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20241009150455.1057573-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kvm_host.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -963,6 +963,15 @@ static inline struct kvm_io_bus *kvm_get
 static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
 {
 	int num_vcpus = atomic_read(&kvm->online_vcpus);
+
+	/*
+	 * Explicitly verify the target vCPU is online, as the anti-speculation
+	 * logic only limits the CPU's ability to speculate, e.g. given a "bad"
+	 * index, clamping the index to 0 would return vCPU0, not NULL.
+	 */
+	if (i >= num_vcpus)
+		return NULL;
+
 	i = array_index_nospec(i, num_vcpus);
 
 	/* Pairs with smp_wmb() in kvm_vm_ioctl_create_vcpu.  */


