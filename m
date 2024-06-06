Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0AC196DBD;
	Thu,  6 Jun 2024 14:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682965; cv=none; b=c906XMM6nyDDyqp0iYHJ5Tp7uF0n+2DDIcTfOD/8yBSEudMz+m+9eGzfZCzXJxO+E8Leq2gQvhibkkob+QVNk7YsGNOYtnx9TTYsJWgPQAUSiv1F2ptSf/itU4zkA4UQ/4774w4iOp8a4fGPR7vTqnyTUtD9fp3R6Aler2gRIfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682965; c=relaxed/simple;
	bh=F/6xiXzz8i4lY2PxmgXn1KhjtrwgWn3E/KvrabuG9N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzR0hELcx27l0VzobUGWaD16vdIMMC7/NU/nJuxRJQj4GWH5zg2k/4yXEkxC93NWYssNexu5u8pdIBdexGgnlFxSqRS+fMGVizo8SNr+vD4nMLNioWMBVmpuQTccmJlJ8RKGCCWlzmI8V1cl+YODiAGz3h80lddSBGfik1GwVQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=slGb6Lh/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="slGb6Lh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4A0C2BD10;
	Thu,  6 Jun 2024 14:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682965;
	bh=F/6xiXzz8i4lY2PxmgXn1KhjtrwgWn3E/KvrabuG9N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slGb6Lh/Zb6vwRgzCuBjQAcZE/LMu4KPAGqqB21sxB0x2gmd1hr/S/mt91OZnSeGY
	 RoLOes3vsAMpa+9dPtenfNWd3DxiPcmLS9MH/kUi9iNnJKJ/b5BbqYqQgzLV4JNo5R
	 eKIjNRXriKDkUuafg7fdqD5n893reAoJdBZmXCsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Remus <jremus@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 133/374] s390/stacktrace: Improve detection of invalid instruction pointers
Date: Thu,  6 Jun 2024 16:01:52 +0200
Message-ID: <20240606131656.357635533@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit cd58109283944ea8bdcd0a8211a86cbd2450716a ]

Add basic checks to identify invalid instruction pointers when walking
stack frames:

Instruction pointers must

- have even addresses
- be larger than mmap_min_addr
- lower than the asce_limit of the process

Alternatively it would also be possible to walk page tables similar to fast
GUP and verify that the mapping of the corresponding page is executable,
however that seems to be overkill.

Fixes: aa44433ac4ee ("s390: add USER_STACKTRACE support")
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/stacktrace.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
index 1c9e3b7739a22..b4485b0c7f06b 100644
--- a/arch/s390/kernel/stacktrace.c
+++ b/arch/s390/kernel/stacktrace.c
@@ -77,6 +77,21 @@ static inline bool store_ip(stack_trace_consume_fn consume_entry, void *cookie,
 	return consume_entry(cookie, ip);
 }
 
+static inline bool ip_invalid(unsigned long ip)
+{
+	/*
+	 * Perform some basic checks if an instruction address taken
+	 * from unreliable source is invalid.
+	 */
+	if (ip & 1)
+		return true;
+	if (ip < mmap_min_addr)
+		return true;
+	if (ip >= current->mm->context.asce_limit)
+		return true;
+	return false;
+}
+
 void arch_stack_walk_user_common(stack_trace_consume_fn consume_entry, void *cookie,
 				 struct perf_callchain_entry_ctx *entry,
 				 const struct pt_regs *regs, bool perf)
@@ -87,6 +102,8 @@ void arch_stack_walk_user_common(stack_trace_consume_fn consume_entry, void *coo
 
 	if (is_compat_task())
 		return;
+	if (!current->mm)
+		return;
 	ip = instruction_pointer(regs);
 	if (!store_ip(consume_entry, cookie, entry, perf, ip))
 		return;
@@ -101,15 +118,16 @@ void arch_stack_walk_user_common(stack_trace_consume_fn consume_entry, void *coo
 		sf = (void __user *)sp;
 		if (__get_user(ip, &sf->gprs[8]))
 			break;
-		if (ip & 0x1) {
+		if (ip_invalid(ip)) {
 			/*
 			 * If the instruction address is invalid, and this
 			 * is the first stack frame, assume r14 has not
 			 * been written to the stack yet. Otherwise exit.
 			 */
-			if (first && !(regs->gprs[14] & 0x1))
-				ip = regs->gprs[14];
-			else
+			if (!first)
+				break;
+			ip = regs->gprs[14];
+			if (ip_invalid(ip))
 				break;
 		}
 		if (!store_ip(consume_entry, cookie, entry, perf, ip))
-- 
2.43.0



