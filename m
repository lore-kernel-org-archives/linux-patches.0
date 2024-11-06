Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CC31DF740;
	Wed,  6 Nov 2024 12:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895748; cv=none; b=Gcp3QnjXrM1Pe8ZdmgnErjjcrNXdYf/4ZWiqHyQh1IVe8DO9vwXn2gVSjfQp1u6936SyhBgilxaKMO4mrNlZTcqSZMzLM5ZWG5Q3MNIQ8Vdsb9RvVmC6q4VPFfd4Uqqp16HobDTLBhTkqiiFl7tJNc63K3dxEsQJIfL3fpsmDEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895748; c=relaxed/simple;
	bh=xYpermFpmgWSwtG1urM2hnKREQbaU99gaH7EflsmcpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkPcXMJTmwmekK1L5e5YEvRNFDi9nJxDI5jLpR3k5iJIwkRNtmRVlEmxfXrx7hAuyHhQRWskUc2AAMvvHP3bWTBP9loP4LZ02N69t2CSdtpcDt1vAk0+wXCGU+s7EnrgN1MOFJYL3o+c2NEznJKqyRy1o5/QFqOkNAF1kH8Y3l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VR7jv74m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VR7jv74m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F1EC4CECD;
	Wed,  6 Nov 2024 12:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895748;
	bh=xYpermFpmgWSwtG1urM2hnKREQbaU99gaH7EflsmcpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VR7jv74mbSRRyLbZ0WgpUAcG8Vhu9BtujprwP+P+lrxdM9z2gdXpxdrun6if6L1lr
	 845Q8DokKPjy44iuoXIqq8pZQa+lit00yeo6M5oW+vuuTc0xE756XkpUV6sN7zRrZQ
	 iD7sPFUOV9c8Q4IY3ksborHqBiWikwGhvzhFaVx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	junhua huang <huang.junhua@zte.com.cn>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 4.19 321/350] arm64/uprobes: change the uprobe_opcode_t typedef to fix the sparse warning
Date: Wed,  6 Nov 2024 13:04:09 +0100
Message-ID: <20241106120328.676359809@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: junhua huang <huang.junhua@zte.com.cn>

commit ef08c0fadd8a17ebe429b85e23952dac3263ad34 upstream.

After we fixed the uprobe inst endian in aarch_be, the sparse check report
the following warning info:

sparse warnings: (new ones prefixed by >>)
>> kernel/events/uprobes.c:223:25: sparse: sparse: restricted __le32 degrades to integer
>> kernel/events/uprobes.c:574:56: sparse: sparse: incorrect type in argument 4 (different base types)
@@     expected unsigned int [addressable] [usertype] opcode @@     got restricted __le32 [usertype] @@
   kernel/events/uprobes.c:574:56: sparse:     expected unsigned int [addressable] [usertype] opcode
   kernel/events/uprobes.c:574:56: sparse:     got restricted __le32 [usertype]
>> kernel/events/uprobes.c:1483:32: sparse: sparse: incorrect type in initializer (different base types)
@@     expected unsigned int [usertype] insn @@     got restricted __le32 [usertype] @@
   kernel/events/uprobes.c:1483:32: sparse:     expected unsigned int [usertype] insn
   kernel/events/uprobes.c:1483:32: sparse:     got restricted __le32 [usertype]

use the __le32 to u32 for uprobe_opcode_t, to keep the same.

Fixes: 60f07e22a73d ("arm64:uprobe fix the uprobe SWBP_INSN in big-endian")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: junhua huang <huang.junhua@zte.com.cn>
Link: https://lore.kernel.org/r/202212280954121197626@zte.com.cn
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/uprobes.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/uprobes.h
+++ b/arch/arm64/include/asm/uprobes.h
@@ -17,7 +17,7 @@
 #define UPROBE_SWBP_INSN_SIZE	AARCH64_INSN_SIZE
 #define UPROBE_XOL_SLOT_BYTES	AARCH64_INSN_SIZE
 
-typedef u32 uprobe_opcode_t;
+typedef __le32 uprobe_opcode_t;
 
 struct arch_uprobe_task {
 };


