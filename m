Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2EA47042E;
	Tue, 21 Jul 2026 18:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658819; cv=none; b=sbfJH/GvGUAASA8A6aVo5YWCXBXHMg1yi2EPCnyY6Qd80cFqDFGO1BuT/evdykpdN2YCqTnVa6/uI6wx+HNHXc2tIXj8axjUey3l5XXqmNiJH69e4PVCLeYo9x+97sd9LRCJPnH2VfisaywqIpZLFMvpNnqgDsQJiqxHDoLfvdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658819; c=relaxed/simple;
	bh=XAE0p7onbJuZ5V/bSPjK6BxYoWatZgvbD293y7WVkHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6IhZGB2Wf6V21+N2XM0tbyIwRhYs7ZMmumJnLKjV9RyLw/IwKJhIv58uHd57UfcN9uDvkfCoasQliOv+BJ3Z5wd3tM5qCSs9KAAp5yBgRU7hBytnUbIPXhZgI6tHZ2tLm3+QdOeVaKcr/xwTLui79/dFYt7OHVTtdijBb3nafI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIFCvQHB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIFCvQHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B341F00A3A;
	Tue, 21 Jul 2026 18:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658817;
	bh=nebtSEi2ijzYjwqig0BhJqWeBAUXLVabkYtfut1LT8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yIFCvQHBjt3Tqk28A2VlLVZjd74D6fPlRCv3CsvhIK3yDWXsuDiai8wIS2nr5T7hD
	 I7C+7FGzcOZAjcEZI1VyNJhQcg7kOAokV9GYyKxv2BJw+MmDEiUYIuBVVOmDzrHU/w
	 mxrThwOcqZYuRSPDsumWBH1LJfXJG9vhGFuG4jwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stafford Horne <shorne@gmail.com>
Subject: [PATCH 6.18 1286/1611] openrisc: Fix jump_label smp syncing
Date: Tue, 21 Jul 2026 17:23:22 +0200
Message-ID: <20260721152544.369514860@linuxfoundation.org>
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

From: Stafford Horne <shorne@gmail.com>

commit aca063c9024522e4e5b9a9d1927433f6a01785a3 upstream.

The original commit 8c30b0018f9d ("openrisc: Add jump label support")
copies from arm64 and does not properly consider how icache invalidation
on remote cores works in OpenRISC.  On OpenRISC remote icaches need to
be invalidated otherwise static key's may remain state after updating.

Fix SMP cache syncing by:

 1. Properly invalidate remote core icaches on SMP systems by using
    icache_all_inv.  The old code uses kick_all_cpus_sync() which runs a
    no-op IPI function call on remote CPU's which does execute a lot of
    code and flushes many cache lines in the process, but does not flush
    all and it's not correct on OpenRISC.
 2. For architectures that do not have WRITETHROUGH caches be sure
    to flush the dcache after patching.

To test this I first reproduced the issue using a custom test module
[0].  The test confirmed that some icache lines maintained stale
static_key code sequences after calling static_branch_enable().  After
this patch there are no longer jump_label coherency issues.

[0] https://github.com/stffrdhrn/or1k-utils/tree/master/tests/smp_static_key_test

Cc: stable@vger.kernel.org # depends on openrisc: Add icache_all_inv
Fixes: 8c30b0018f9d ("openrisc: Add jump label support")
Signed-off-by: Stafford Horne <shorne@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/openrisc/kernel/jump_label.c |    2 +-
 arch/openrisc/kernel/patching.c   |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/openrisc/kernel/jump_label.c
+++ b/arch/openrisc/kernel/jump_label.c
@@ -47,5 +47,5 @@ bool arch_jump_label_transform_queue(str
 
 void arch_jump_label_transform_apply(void)
 {
-	kick_all_cpus_sync();
+	icache_all_inv();
 }
--- a/arch/openrisc/kernel/patching.c
+++ b/arch/openrisc/kernel/patching.c
@@ -49,6 +49,9 @@ static int __patch_insn_write(void *addr
 	waddr = patch_map(addr, FIX_TEXT_POKE0);
 
 	ret = copy_to_kernel_nofault(waddr, &insn, OPENRISC_INSN_SIZE);
+	if (!IS_ENABLED(CONFIG_DCACHE_WRITETHROUGH))
+		local_dcache_range_flush((unsigned long)waddr,
+					 (unsigned long)waddr + OPENRISC_INSN_SIZE);
 	local_icache_range_inv((unsigned long)waddr,
 			       (unsigned long)waddr + OPENRISC_INSN_SIZE);
 


