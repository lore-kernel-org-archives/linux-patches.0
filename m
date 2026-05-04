Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE3D3D9029;
	Mon,  4 May 2026 14:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903437; cv=none; b=W+D90OEkuSherWgivFIIXdDeW8zd2vzNGKRcILs00+2TTaEtltLLlJdGxdPW03/Pu99WzjH/mXHoWqEO+OQAR3oUuDTkvoV/R7/z+WGq22zNGYB5kkmrZn/2rQCnSfHRuCaOl590y5bKJzEEkOam2CkMOy/oKZMB7hYdM49kqGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903437; c=relaxed/simple;
	bh=FHWAm6V3sNa8XxWbwLxZVLgkMX4u/ewYWx3UOHD25co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdZilPqprk59aR9H4o1ZyE/YvCmzEsFTvCi4rp49OedgBoYDhuPwnWVzHtV9x6VLfF+cdR6FWW36nKOE1BRA4Ksmm6ErWV/mmwAAQciBIfyRp7k/O+AR8aotgCJTr3dYCC+yqHWyHqCGqQXFPMBakRFVAunL2JvPFTy7lyLNil0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2Tq6KZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2Tq6KZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B756C2BCB8;
	Mon,  4 May 2026 14:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903436;
	bh=FHWAm6V3sNa8XxWbwLxZVLgkMX4u/ewYWx3UOHD25co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2Tq6KZR20Iwin1veTxWMcDsP+ZfVuTsKObgA9Y9kY2rWVnTCtxsp+A113PnvRV/Y
	 4fZ/QETVP3ctKn+AmIp3ZpaXE6qbz8LshmnXwk0xH8e9i9elt2YwGtEkG7+0LCZm97
	 nM6IbTz/suOgUT9CjblQUCfMSSIaPXRXdOhMBveI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.0 206/307] KVM: SVM: Explicitly mark vmcb01 dirty after modifying VMCB intercepts
Date: Mon,  4 May 2026 15:51:31 +0200
Message-ID: <20260504135150.626871725@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit d5bde6113aed8315a2bfe708730b721be9c2f48b upstream.

When reacting to an intercept update, explicitly mark vmcb01's intercepts
dirty, as KVM always initially operates on vmcb01, and nested_svm_vmexit()
isn't guaranteed to mark VMCB_INTERCEPTS as dirty.  I.e. if L2 is active,
KVM will modify the intercepts for L1, but might not mark them as dirty
before the next VMRUN of L1.

Fixes: 116a0a23676e ("KVM: SVM: Add clean-bit for intercetps, tsc-offset and pause filter count")
Cc: stable@vger.kernel.org
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20260218230958.2877682-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -128,11 +128,13 @@ void recalc_intercepts(struct vcpu_svm *
 	struct vmcb_ctrl_area_cached *g;
 	unsigned int i;
 
-	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
+	vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_INTERCEPTS);
 
 	if (!is_guest_mode(&svm->vcpu))
 		return;
 
+	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
+
 	c = &svm->vmcb->control;
 	h = &svm->vmcb01.ptr->control;
 	g = &svm->nested.ctl;


