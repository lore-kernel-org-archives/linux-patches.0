Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9A81FF5EC;
	Wed,  7 May 2025 18:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643989; cv=none; b=lwhSOR8t7SQjQ742/oKx18CGU6AsBpT2fidioTR2NwOeK4hO8PPCsEAeyguKIAH8T/HvFeVaoUMLAvfZz7H4aeNdM40/StZ5Ql1dc1QCN4M0muaFyZKrad7HF8xoMAmoW4lsLCeYmSlTnh7/R8jTrmsJzmzyNNmgrHpsED+Nc5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643989; c=relaxed/simple;
	bh=75uT/rhCOfEDVGFn+ISlm8TGr4vBkhxx9e83mSUe7K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QC0ERTKqWwysBFkxH8oGKWCc7CSBgY8zJoWHK9FFLyt11rpSVB9O/rjTc4UG6AACfRltLQpRkLVpQOVOxt+mFBdO0PO4CQ4DgUuy4xfV2u8aOG7rv3XB+ZeiJtvTXP6MnDvPKNTWyxQ1wk1PsLw8+4Rdmfrha97LwgtXT0dEmOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAy9Qxm8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAy9Qxm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6FDC4CEE2;
	Wed,  7 May 2025 18:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643989;
	bh=75uT/rhCOfEDVGFn+ISlm8TGr4vBkhxx9e83mSUe7K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAy9Qxm8JxxtWPSqpEANUMKtTu5NaAxcuD+3l9qQt24Sij7LAyGr1W1SfteD3ElUq
	 ARo9lIvgDrlpL74ZG5UZCFStt/qOK70A08LPCzBhQWcSDPgW27OzHIqmD1wTURa7nd
	 BH3eOBw5qR+bzxLTz3dlGW/UirzGdVaMhVvVY71E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Iliopoulos <ailiop@suse.com>,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 054/183] powerpc64/ftrace: fix module loading without patchable function entries
Date: Wed,  7 May 2025 20:38:19 +0200
Message-ID: <20250507183826.876727838@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Iliopoulos <ailiop@suse.com>

[ Upstream commit 534f5a8ba27863141e29766467a3e1f61bcb47ac ]

get_stubs_size assumes that there must always be at least one patchable
function entry, which is not always the case (modules that export data
but no code), otherwise it returns -ENOEXEC and thus the section header
sh_size is set to that value. During module_memory_alloc() the size is
passed to execmem_alloc() after being page-aligned and thus set to zero
which will cause it to fail the allocation (and thus module loading) as
__vmalloc_node_range() checks for zero-sized allocs and returns null:

[  115.466896] module_64: cast_common: doesn't contain __patchable_function_entries.
[  115.469189] ------------[ cut here ]------------
[  115.469496] WARNING: CPU: 0 PID: 274 at mm/vmalloc.c:3778 __vmalloc_node_range_noprof+0x8b4/0x8f0
...
[  115.478574] ---[ end trace 0000000000000000 ]---
[  115.479545] execmem: unable to allocate memory

Fix this by removing the check completely, since it is anyway not
helpful to propagate this as an error upwards.

Fixes: eec37961a56a ("powerpc64/ftrace: Move ftrace sequence out of line")
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250204231821.39140-1-ailiop@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/module_64.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
index 34a5aec4908fb..126bf3b06ab7e 100644
--- a/arch/powerpc/kernel/module_64.c
+++ b/arch/powerpc/kernel/module_64.c
@@ -258,10 +258,6 @@ static unsigned long get_stubs_size(const Elf64_Ehdr *hdr,
 			break;
 		}
 	}
-	if (i == hdr->e_shnum) {
-		pr_err("%s: doesn't contain __patchable_function_entries.\n", me->name);
-		return -ENOEXEC;
-	}
 #endif
 
 	pr_debug("Looks like a total of %lu stubs, max\n", relocs);
-- 
2.39.5



