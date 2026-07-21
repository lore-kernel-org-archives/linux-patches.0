Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2138633689F;
	Tue, 21 Jul 2026 17:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654101; cv=none; b=Z49UbTagdzGZfLh0yPG4AH5cauolvb1HXyMdourYZ74sLLCORtHRytKO9WJJPmeMDGpRa5qG3QJYKFlQlXPvCsj9ctl8zncGNr4cP37AM3NhBqQxhErHAb+foxcyCCxPvjMS8Lj10dHFcc+BNzo9HE1aU+AchBFFpESSokLyWwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654101; c=relaxed/simple;
	bh=aLjNFgArBhT4ecbOdfMcIVTVjh+4a2jYCj1JujIn6L0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzl/tY0EblzPdjNg3Gns/eNrLLHECaGptmslfV6JEp9pwN4IP67SbyserVQMDDxvmEb/60JXk7v4E1z7AiaqJk3wiySEcxlH2DhkYhIEjPDQ6cGMW++gV3+DKz8ZhFX2KyUqGezfbpKls8hbM0eHvny26VRFXTg3JFh3hGRIbhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLKIj/cB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLKIj/cB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DFC1F000E9;
	Tue, 21 Jul 2026 17:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654100;
	bh=DGt+9rPUiAa53ahVFTeT67X6DUekx3WJ2OBWE60DADE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLKIj/cBxkxoN0hqpfXqqhRx6PbcPn6zaw79Yxk4a13UT3vjMXZzizwKXCaKAL84l
	 Wo86aetWCY1y/3dI2VkM0D3G8HOrlft0nZta/Lev+ATHn1O7/vEnQYBtGQSw/bsl1C
	 g9pvVS3pgXXi6yvnYbqiBsF0mWain+Q29te/u230=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.1 1578/2077] KVM: arm64: nv: Inject SEA if guest VNCR isnt normal memory
Date: Tue, 21 Jul 2026 17:20:51 +0200
Message-ID: <20260721152629.998730138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Upton <oupton@kernel.org>

commit 4bd7dbe0b2243e6aa735cae4d5e1ff988b30b2a6 upstream.

When constructing an L1 VNCR mapping, KVM unconditionally uses cacheable
memory attributes, even if the underlying PFN isn't memory. This gets
particularly hairy if the endpoint doesn't support cacheable memory
attributes, potentially throwing an SError on writeback...

While KVM does permit cacheable memory attributes on certain PFNMAP
VMAs, kvm_translate_vncr() isn't currently grabbing the VMA. So do the
simpler thing for now and just reject everything that isn't memory.

Cc: stable@vger.kernel.org
Fixes: 2a359e072596 ("KVM: arm64: nv: Handle mapping of VNCR_EL2 at EL2")
Signed-off-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/20260618234207.1063941-5-oupton@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/nested.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1333,6 +1333,17 @@ static int kvm_translate_vncr(struct kvm
 		writable = !(memslot->flags & KVM_MEM_READONLY);
 	}
 
+	/*
+	 * FIXME: This check is too restrictive as KVM allows cacheable memory
+	 * attributes for PFNMAP VMAs that have cacheable attributes in host
+	 * stage-1.
+	 */
+	if (!pfn_is_map_memory(pfn)) {
+		kvm_release_faultin_page(vcpu->kvm, page, true, false);
+		fail_s1_walk(&vt->wr, ESR_ELx_FSC_EXTABT, false);
+		return -EINVAL;
+	}
+
 	scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
 		if (mmu_invalidate_retry(vcpu->kvm, mmu_seq)) {
 			kvm_release_faultin_page(vcpu->kvm, page, true, false);


