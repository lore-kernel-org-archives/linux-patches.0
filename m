Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5B81D0E01;
	Wed,  2 Oct 2024 14:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878646; cv=none; b=JZtaKbIMEPFko26v/GOZDBw07/s/dn5BjN64lNF/Nl49d+rKDtfpRVAmIjgbHdLESsd4N6zG77qRABN9GH7v4DIpowXJcN6TqB1TzmFBVdRPy0fGFcGNa8CT1uPQwRBT6EpZQ0SEYKbhKq75fwc6V4RehNXfym82gQ11ltfCHi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878646; c=relaxed/simple;
	bh=oh31ieN68fx4VDaqsiDK6NSH7eLUBoHOunP3iZB2leI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unfyJb3cZARqkYX5eqUg3t4l8RlhEH79v10aaa1g49he4UaLrtOmq3QnLwo5mwasRC6m75VSPcZKwOmOMBoQSwxX+EM+nfQuiMsfbRHOomMvGKTAzx7Sm9mWSnpbLE7Ycj3P7PlQCsi2+7Dd8Zsf/Wkr8UCD5nAGcbCl3z5y0MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WyfTue8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WyfTue8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E89C4CEC2;
	Wed,  2 Oct 2024 14:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878646;
	bh=oh31ieN68fx4VDaqsiDK6NSH7eLUBoHOunP3iZB2leI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WyfTue8pCA67u/3DVxhRyDOn3ds5E2EVzbZiZY2rtnGyZsG15jzop+siv6z834o2p
	 tOmw4Qbna/Uizd5a5pXpHs1uhKJH9FbYYJUnHadIinU5/+nOWbGFUXJhyNslXNXBWe
	 OwEjXCYiOCxwu8YwTXlnb8njK/mrHx8uivYwo7WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ene <sebastianene@google.com>,
	Snehal Koukuntla <snehalreddy@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.10 485/634] KVM: arm64: Add memory length checks and remove inline in do_ffa_mem_xfer
Date: Wed,  2 Oct 2024 14:59:45 +0200
Message-ID: <20241002125830.246401472@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -423,9 +423,9 @@ out:
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
@@ -437,9 +437,6 @@ static __always_inline void do_ffa_mem_x
 	u32 offset, nr_ranges;
 	int ret = 0;
 
-	BUILD_BUG_ON(func_id != FFA_FN64_MEM_SHARE &&
-		     func_id != FFA_FN64_MEM_LEND);
-
 	if (addr_mbz || npages_mbz || fraglen > len ||
 	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
 		ret = FFA_RET_INVALID_PARAMETERS;
@@ -458,6 +455,11 @@ static __always_inline void do_ffa_mem_x
 		goto out_unlock;
 	}
 
+	if (len > ffa_desc_buf.len) {
+		ret = FFA_RET_NO_MEMORY;
+		goto out_unlock;
+	}
+
 	buf = hyp_buffers.tx;
 	memcpy(buf, host_buffers.tx, fraglen);
 
@@ -509,6 +511,13 @@ err_unshare:
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


