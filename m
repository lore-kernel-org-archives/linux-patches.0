Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C3B1D0B98;
	Wed,  2 Oct 2024 13:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876700; cv=none; b=WplwC5gCZTMuIzad0G8fTOh9vZwAFrnBK5mzJNddTwCrcl4PWSYD2PWvmgvMpvrDBfnI7ZvdNhgB8rC2fVkifsWy/zKlZmY91w7A2y85Ypo9zCQh7+Tdxlc4Y7KcID4lYpKVhs26JcHAG6V7+Y7SWM5KydKtKYsvYeQnd3kdK/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876700; c=relaxed/simple;
	bh=/9G44BmGyWgHGyzO+AwUGefGRczmP8wMQ90/OH/q5zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6gJAOeUtsIqdR6ATE9xwi680SiHhLJyE9Nb/fY5m2KiKEz3IfMUXsEhM68s0znSslZP9izvPYD9hBogkrth4U8z5P2WB6olZXZZ6V6TyH08TZK0MpPR79PzJII1f2wl64ismiqwxfjRgIRIs5ITJpjY1FK8/3d+IBa/NP6hwY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wohPo+xF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wohPo+xF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE78C4CEC5;
	Wed,  2 Oct 2024 13:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876700;
	bh=/9G44BmGyWgHGyzO+AwUGefGRczmP8wMQ90/OH/q5zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wohPo+xFPVjrGbZZ4L6XpJJCbPngWJ9BMNxotdjg4wyNmRBjwpRhwzVBGIhMcsutM
	 txbq09NYPB3vELRuFROmaDrmWDyUBq1OZlgOEkS2kG7lqH2Yny9TV+cxlnY9CtoCOZ
	 jl/npQaPPySYWi1Skei4+3vVNSQ3Zdb6CIkqFj6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ene <sebastianene@google.com>,
	Snehal Koukuntla <snehalreddy@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.11 534/695] KVM: arm64: Add memory length checks and remove inline in do_ffa_mem_xfer
Date: Wed,  2 Oct 2024 14:58:52 +0200
Message-ID: <20241002125843.815832529@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -426,9 +426,9 @@ out:
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
@@ -440,9 +440,6 @@ static __always_inline void do_ffa_mem_x
 	u32 offset, nr_ranges;
 	int ret = 0;
 
-	BUILD_BUG_ON(func_id != FFA_FN64_MEM_SHARE &&
-		     func_id != FFA_FN64_MEM_LEND);
-
 	if (addr_mbz || npages_mbz || fraglen > len ||
 	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
 		ret = FFA_RET_INVALID_PARAMETERS;
@@ -461,6 +458,11 @@ static __always_inline void do_ffa_mem_x
 		goto out_unlock;
 	}
 
+	if (len > ffa_desc_buf.len) {
+		ret = FFA_RET_NO_MEMORY;
+		goto out_unlock;
+	}
+
 	buf = hyp_buffers.tx;
 	memcpy(buf, host_buffers.tx, fraglen);
 
@@ -512,6 +514,13 @@ err_unshare:
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


