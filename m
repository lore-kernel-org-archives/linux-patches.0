Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8477C3C0601;
	Sat, 17 Oct 2026 17:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259013; cv=none; b=gaQJiftV7I+ck76PZCmYrK75THateHCTS8iqx94/QsGU9vbTyPygojkQcJIRbrq9e9nAoJ0RlpCTe41rrSkETuEj/MN56xR8U+vsz8oAxOUmDCsXl54gpU/bEFk2ywWAKWUy0w4J2vE7AH5M4HGuDLqF9ezGvdvSJQ4JKeL+2QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259013; c=relaxed/simple;
	bh=mgn984U467veAGD7jhdQEZGgxjeRaSkfxs1+YX0M4Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JP5XzFUXbRIYL7RLgsA/el9UF1B14WiG6IPMi/cvosdiePMA9V11FsLaWyV4XG8xscbmDKZX9eyIeRzo5YlRDXTPDUpl2MhzpryC78n+wQXj0FVdb5r/bS+q5B9fgucQKLclZ9wJegq7qfrr+kzd+k7KPV5vPRAHo6g9qdUjo1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtyDiM+j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtyDiM+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A731F000C4;
	Sat, 17 Oct 2026 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259012;
	bh=rGs3dGyUVIw5QuqXMFIXSgUK85/akXCLBQAV3NYxC7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QtyDiM+jUoPB4WC8W8qGx6+23Re1VW5dyKw1dRDTCpGv422kKWH072EAKL2fTC0NK
	 xXj3D0XDJCs8BUULGf9hS3QfOvbe6Lq5NjT9G8tTqe6lEBFU0YiHnwaxitakzLuXjq
	 qyjdAyBgYv/YSILusc5+Bn+y01bJtiIJXFGll1P8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanglong Wang <wangkanglong@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1074/1674] LoongArch: Move jump_label_init() before parse_early_param()
Date: Sat, 17 Oct 2026 17:55:46 +0200
Message-ID: <20261017160458.687742960@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Kanglong Wang <wangkanglong@loongson.cn>

[ Upstream commit ea68d444a658783234a06f05414e41cf93a18fb2 ]

When enabling both CONFIG_MEM_ALLOC_PROFILING=y and
CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT=y, then diabling memory
profiling by adding the boot parameter 'sysctl.vm.mem_profiling=0' will
cause the kernel failed to boot.

After analysis, this is because jump_label_init() must be called before
parse_early_param(), the early param handlers may modify static keys by
static_branch_enable/disable().

Fix this by moving jump_label_init() to before parse_early_param(). The
solution is similar to other architectures.

Cc: <stable@vger.kernel.org>
Signed-off-by: Kanglong Wang <wangkanglong@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 729b0660b61c1..55dda1eed069e 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -627,6 +627,7 @@ void __init setup_arch(char **cmdline_p)
 	memblock_init();
 	pagetable_init();
 	bootcmdline_init(cmdline_p);
+	jump_label_init(); /* Initialise the static keys for early params */
 	parse_early_param();
 	reserve_initrd_mem();
 
-- 
2.53.0



