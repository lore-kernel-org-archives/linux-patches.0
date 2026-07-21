Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839C43358C6;
	Tue, 21 Jul 2026 18:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658440; cv=none; b=UlSiUKxBTqv8x7l/V0xctm4xxQcPO4n9jF0FnIzf4BfPKu1hD1JkY/yB8yPgYKHmfItqMT2pnUrpYnO+UA9vy7Zg9GeN0PQpumiVOyxvZGadpMGRuTeJGmuMcD+P7ujr3FGOunTz3nD3fqcyTCol4js8pyrVxkyq75q5de2IbC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658440; c=relaxed/simple;
	bh=7LLOo3///RMPRivMAMyGgpQmuMOK9jWyjR52jmyc7I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQiX2Ihlauba10OpKFteufhnXGGU6VcOqloA053Qkow2fQQuMmWbsZWK5LoCVyBnvM71YTpPf7UwBhJdUdmGWWVJODanw3YhkkXULzyjEI7IE3w29wgFazrRqz21FcItdh2Zf42QE/yjAXrxie7zmNPujIZ7ZFVZfn5tq0AZ7/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Mtj0b7J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Mtj0b7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC211F000E9;
	Tue, 21 Jul 2026 18:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658439;
	bh=pY9RRq0AIbS7/V4vbv4AZilalov+UYcGQkL/jFedLAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Mtj0b7JHA62shtEAXenm7ALZlwVHau2f/5pe3EFvN/3MEnmPMO26YzS0sEcf+RAO
	 SrqAk2naeiUnJD1TAunbXTRtoApC4/zDnRMPXoXLwhpd7Y31W/ptjNbuKfDA387Exz
	 jJKfuEpnzQiTxDn4G+VKMJPMehXeZ8w/0KmKDUNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 1143/1611] KVM: arm64: nv: Inject SEA if guest VNCR isnt normal memory
Date: Tue, 21 Jul 2026 17:20:59 +0200
Message-ID: <20260721152541.131293961@linuxfoundation.org>
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
@@ -1244,6 +1244,17 @@ static int kvm_translate_vncr(struct kvm
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


