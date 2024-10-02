Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3141D1F43;
	Wed,  2 Oct 2024 14:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880293; cv=none; b=SfU2hk+NMAFDPIr7vl9iPrhJMsTyLKljFgQEzq1/eNuS9Fl8ge8lodiSsdKAVcJqaoiXeZPGy7LOZ3VBolkApMalw15oEXxpblSk0+MBt5ny29nPHVvTuJCZ7A6UcWfKaS9CZh9zmhiwo2u6P2WcO24C2eGQYW9QTkbgSRGqUfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880293; c=relaxed/simple;
	bh=ZZpuYskhMeYO3Jdk8o8Pk1YEL2RyryU5602dsRnfvm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTw4iiVsdLzgsw66G29HBRyKK0+2snznFpEqRsinwXcvKGVp3p0HTGXP+HgB7JELLrKPkKNl74/K1YaDM2wghWSAvx2GjlQ4WG1+BBuXBqWC3aqPiIISn4zWo9qG9JE2Vlxn5BlMKZ+EkLH/IFTZSG5S7YlBE5uP+BFGW9U2kB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D37CCO4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D37CCO4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9FA7C4CEC2;
	Wed,  2 Oct 2024 14:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880293;
	bh=ZZpuYskhMeYO3Jdk8o8Pk1YEL2RyryU5602dsRnfvm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D37CCO4znZjaMpSx9widClJFYXLRB/B01Zfz+qVWBEZexxZq/oaC42gFzvuqub5YH
	 Sld6hzRJbCMP3EY1ui4HkFBZh6LiE5quInkzZ5fusFsCLjzaNodvzx0eFYRN4p+Gqu
	 ohU8ugBqWkB6IaqrM4sjxyfFlbC6vYCUWVsPCo/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ene <sebastianene@google.com>,
	Snehal Koukuntla <snehalreddy@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 410/538] KVM: arm64: Add memory length checks and remove inline in do_ffa_mem_xfer
Date: Wed,  2 Oct 2024 15:00:49 +0200
Message-ID: <20241002125808.618589390@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Snehal Koukuntla <snehalreddy@google.com>

commit f26a525b77e040d584e967369af1e018d2d59112 upstream.

When we share memory through FF-A and the description of the buffers
exceeds the size of the mapped buffer, the fragmentation API is used.
The fragmentation API allows specifying chunks of descriptors in subsequent
FF-A fragment calls and no upper limit has been established for this.
The entire memory region transferred is identified by a handle which can be
used to reclaim the transferred memory.
To be able to reclaim the memory, the description of the buffers has to fit
in the ffa_desc_buf.
Add a bounds check on the FF-A sharing path to prevent the memory reclaim
from failing.

Also do_ffa_mem_xfer() does not need __always_inline, except for the
BUILD_BUG_ON() aspect, which gets moved to a macro.

[maz: fixed the BUILD_BUG_ON() breakage with LLVM, thanks to Wei-Lin Chang
 for the timely report]

Fixes: 634d90cf0ac65 ("KVM: arm64: Handle FFA_MEM_LEND calls from the host")
Cc: stable@vger.kernel.org
Reviewed-by: Sebastian Ene <sebastianene@google.com>
Signed-off-by: Snehal Koukuntla <snehalreddy@google.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20240909180154.3267939-1-snehalreddy@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -415,9 +415,9 @@ out:
 	return;
 }
 
-static __always_inline void do_ffa_mem_xfer(const u64 func_id,
-					    struct arm_smccc_res *res,
-					    struct kvm_cpu_context *ctxt)
+static void __do_ffa_mem_xfer(const u64 func_id,
+			      struct arm_smccc_res *res,
+			      struct kvm_cpu_context *ctxt)
 {
 	DECLARE_REG(u32, len, ctxt, 1);
 	DECLARE_REG(u32, fraglen, ctxt, 2);
@@ -428,9 +428,6 @@ static __always_inline void do_ffa_mem_x
 	u32 offset, nr_ranges;
 	int ret = 0;
 
-	BUILD_BUG_ON(func_id != FFA_FN64_MEM_SHARE &&
-		     func_id != FFA_FN64_MEM_LEND);
-
 	if (addr_mbz || npages_mbz || fraglen > len ||
 	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
 		ret = FFA_RET_INVALID_PARAMETERS;
@@ -449,6 +446,11 @@ static __always_inline void do_ffa_mem_x
 		goto out_unlock;
 	}
 
+	if (len > ffa_desc_buf.len) {
+		ret = FFA_RET_NO_MEMORY;
+		goto out_unlock;
+	}
+
 	buf = hyp_buffers.tx;
 	memcpy(buf, host_buffers.tx, fraglen);
 
@@ -498,6 +500,13 @@ err_unshare:
 	goto out_unlock;
 }
 
+#define do_ffa_mem_xfer(fid, res, ctxt)				\
+	do {							\
+		BUILD_BUG_ON((fid) != FFA_FN64_MEM_SHARE &&	\
+			     (fid) != FFA_FN64_MEM_LEND);	\
+		__do_ffa_mem_xfer((fid), (res), (ctxt));	\
+	} while (0);
+
 static void do_ffa_mem_reclaim(struct arm_smccc_res *res,
 			       struct kvm_cpu_context *ctxt)
 {


