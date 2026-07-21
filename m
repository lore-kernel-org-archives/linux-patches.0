Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180A33909A9;
	Tue, 21 Jul 2026 18:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658411; cv=none; b=EPQyR9P5kD+Jz9zHLa76w79eg15BjDEqgPk+K09xwe946iF+O32D9lWvCw6oGTcozoMBOQXUTgdK7XXzNw2Y9F/8Xizb1ZlRHCFiUz8deQVNWGfVJn3EbkBSyOvrGNxwt8i50pfwCfjp/XTqdSTMkzhDJi1wSabfBiotw5zHZzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658411; c=relaxed/simple;
	bh=1qG2vKLApQuswuEo+o+YwunP3ZDFhHboI94Q9gJYoyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvoDO0ibRgbkxqrMps9bh+Fyt+1c0ttOvp25pFzVwGyDX5iQF7MNAzLzm1/b1RQLtoCLDUOzL5Qs8ArbMZ3dasI4a0uaS2D7Y6iuVjMtBvE7ItbPO/yPUR1lsCX2M7jd6NSrkQSWwRoxsfKisJ9YQJyf4fCIvzFPTcAKoH64RCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2VOv348; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2VOv348"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793B91F000E9;
	Tue, 21 Jul 2026 18:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658410;
	bh=9SY0rJGah4PZS61H0ETNf1XB//h5j9LJ1NJl4YtyHYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T2VOv348thgQJRHLt359rMpP9socgIa8bLoyGooWNbIRAYCBEWuI/kM9nlxS0bjtd
	 01zJuepG5fpeBYX+9mP8sSjRuWtLL/1T4bS6v9oCdn+2pca9jOyJgZPbqHFq0azoLq
	 WjwMpvsl0pTZbk6BiZxgZ/i5tZOoFLmyuF23R974=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Sashiko <sashiko-bot@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Atish Patra <atishp@meta.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 1133/1611] KVM: SEV: Do not allow intra-host migration/mirroring of SNP VMs
Date: Tue, 21 Jul 2026 17:20:49 +0200
Message-ID: <20260721152540.908869109@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atish Patra <atishp@meta.com>

commit 6ee4140788234a6fabf59e6a50e38cdb936008cd upstream.

The intra-host migration/mirroring feature is not fully implemented for
SEV-SNP VMs. The proper migration requires additional SNP-specific
state such as guest_req_mutex, guest_req_buf, and guest_resp_buf to be
transferred or initialized on the destination.

The SNP VM mirroring requires vmsa features to be copied as well otherwise
ASID would be bound to SNP range while VM is detected as a SEV VM.

Reject SNP source VMs in migration/mirroring until proper SNP state
transfer is implemented.

Fixes: 1dfe571c12cf ("KVM: SEV: Add initial SEV-SNP support")

Reported-by: Chris Mason <clm@meta.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Atish Patra <atishp@meta.com>
Link: https://patch.msgid.link/20260602-sev_snp_fixes-v3-1-24bfd3ae047c@meta.com
Cc: stable@vger.kernel.org
[sean: let lines poke past 80 chars, tag for stable]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2086,8 +2086,9 @@ int sev_vm_move_enc_context_from(struct
 	if (ret)
 		return ret;
 
+	/* Do not allow SNP VM migration until additional state transfer is implemented  */
 	if (kvm->arch.vm_type != source_kvm->arch.vm_type ||
-	    sev_guest(kvm) || !sev_guest(source_kvm)) {
+	    sev_guest(kvm) || !sev_guest(source_kvm) || sev_snp_guest(source_kvm)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -2831,8 +2832,9 @@ int sev_vm_copy_enc_context_from(struct
 	 * disallow out-of-band SEV/SEV-ES init if the target is already an
 	 * SEV guest, or if vCPUs have been created.  KVM relies on vCPUs being
 	 * created after SEV/SEV-ES initialization, e.g. to init intercepts.
+	 * Also do not allow SNP VM mirroring until additional state transfer is implemented.
 	 */
-	if (sev_guest(kvm) || !sev_guest(source_kvm) ||
+	if (sev_guest(kvm) || !sev_guest(source_kvm) || sev_snp_guest(source_kvm) ||
 	    is_mirroring_enc_context(source_kvm) || kvm->created_vcpus) {
 		ret = -EINVAL;
 		goto e_unlock;


