Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F0A3370F7;
	Fri, 17 Oct 2025 15:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713951; cv=none; b=ESQjCkbRAVGqCBWGUsrEBiqf8kDw/3WgZ+k0gqj2zEXJncDb/iMtLTLFlTs3taLDSqsSxoLWTTSBYKAT7UvCOMVVWjF82uzoUpFu9h+1S0hwFu5akCIBGywfh00/S9NVNUEYMcFJen5N8sARbK+azQ7vUM/y5W4EzaZYR+Nq2hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713951; c=relaxed/simple;
	bh=kHoqUqS1KoBJijEGj0RtRdeHNdnfGC8mVbC3KSUufGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORTI6ZoGszxg6HZvL3crkl+wAGMOIvvV6V1nb+VIMiK2vH28iuxt6VmfYeleplOUPKGnmc4Fy3lhnakyA4bmYNLnqzQZ3hxMZk4ysdbu1QD/X7CcIXGMyGNP12GPZ/Lbxdzx0AUOAmfpTwBZo9H84p3hhQ/ClzZeLTSPjutBv40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJQs+mnk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJQs+mnk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32F2C4CEE7;
	Fri, 17 Oct 2025 15:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713951;
	bh=kHoqUqS1KoBJijEGj0RtRdeHNdnfGC8mVbC3KSUufGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJQs+mnkl61kME3q7Fm+fLDan8Kt9FV1LJY1Tfv48tUEOpae/Kb5xESPH3Ak4Azpc
	 UA2oyRfN9mQV6CHOSWyRoFVK9zWL2XanpLhzrx15N6JI1MTXDHp19xRnUQ6Q+kVfiI
	 DUh57lzQ+nuRzRf0EMvh1gN0+3Jy3nCyvYRogdVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Shi <yang@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 176/201] arm64: kprobes: call set_memory_rox() for kprobe page
Date: Fri, 17 Oct 2025 16:53:57 +0200
Message-ID: <20251017145141.217151538@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Shi <yang@os.amperecomputing.com>

[ Upstream commit 195a1b7d8388c0ec2969a39324feb8bebf9bb907 ]

The kprobe page is allocated by execmem allocator with ROX permission.
It needs to call set_memory_rox() to set proper permission for the
direct map too. It was missed.

Fixes: 10d5e97c1bf8 ("arm64: use PAGE_KERNEL_ROX directly in alloc_insn_page")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
[ kept existing __vmalloc_node_range() instead of upstream's execmem_alloc() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/probes/kprobes.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -131,9 +131,15 @@ int __kprobes arch_prepare_kprobe(struct
 
 void *alloc_insn_page(void)
 {
-	return __vmalloc_node_range(PAGE_SIZE, 1, VMALLOC_START, VMALLOC_END,
+	void *addr;
+
+	addr = __vmalloc_node_range(PAGE_SIZE, 1, VMALLOC_START, VMALLOC_END,
 			GFP_KERNEL, PAGE_KERNEL_ROX, VM_FLUSH_RESET_PERMS,
 			NUMA_NO_NODE, __builtin_return_address(0));
+	if (!addr)
+		return NULL;
+	set_memory_rox((unsigned long)addr, 1);
+	return addr;
 }
 
 /* arm kprobe: install breakpoint in text */


