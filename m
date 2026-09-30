Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACA55187EB;
	Wed, 30 Sep 2026 18:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792924; cv=none; b=OxYSmUQVqVMNRQx4sgX7uMFiPxutoYZ+YYXvEqEQdw6SvH47b/gshiYKTm7sTKdCs129Fj3uTJ4REbn9fsXEOwiT47hEJq18RssZ1t/JBFKz7ZmP/rbTgKK8S7fjIj/n4NXG7Xpux0vf1kG59OP8NynDydF3spUOVW7+Z2AOuBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792924; c=relaxed/simple;
	bh=9KldRNAxw6qkkB8Wrie4QNbiHpT7fOalJvpfiMbV6pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqRPRMDBEKcbAx7yrpwGyvAoTydtLUflrupv4OqwBwyQqiBSAoxfjmk9JQ98XsUH8yyTUiTcGzV7+zxbufd7/ofHQFZrqR+n+lLrGT3Gc/KYLs8PSBah9+L942cZqPpqxXDiDVpHXRn0QSyzrejv4xExhf8Pn9gCDuJkrEk+x98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUuG7JzX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUuG7JzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE841F000FF;
	Wed, 30 Sep 2026 18:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792922;
	bh=gyvkO+otZwZPs7A0wpfj2hThEzeQhEPAKvRQRzP4bqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUuG7JzX5dWTufupSwKzSn/1DYHsOTt1y1VcC7g8qFGa8yZhT2FqMRerC5IlvdnHA
	 6vYcJSgRZw+v8UXKIO/kDpS3QuPOOLRQVCI28vrQ2nq3uc7qTjbXU8U802GKl70J3a
	 lgJf0d7qqA3dFGm3bbTiePxJhHrcKu/BRGENYzvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 071/395] arm64: io: Reject non-user protection in ioremap_prot()
Date: Wed, 30 Sep 2026 17:25:33 +0200
Message-ID: <20260930152342.177981309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit bb756b11ad63832ebee58caf9e8f9381eaecff9f ]

Mapping a stack-top page via /dev/mem with PROT_NONE and then
reading that process's /proc/<pid>/cmdline triggers a spurious WARN
in ioremap_prot() through generic_access_phys():

  WARNING: ./arch/arm64/include/asm/io.h:275 at generic_access_phys
  Call trace:
    generic_access_phys+0x1c8/0x228 (P)
    __access_remote_vm+0x2b4/0x398
    access_remote_vm+0x14/0x30
    get_mm_cmdline+0xf8/0x2a0
    proc_pid_cmdline_read+0x68/0x120

generic_access_phys() passes the protection derived from the user PTE
to ioremap_prot(). On arm64, a PROT_NONE mapping is represented by a
present-invalid PTE, so pte_present() still returns true and the
protection reaches ioremap_prot().

A PROT_NONE mapping does not have PTE_USER, causing the existing
WARN_ON_ONCE() in ioremap_prot() to fire even though this is a valid
user mapping. Execute-only mappings have the same issue and must not
be readable through this path either.

ioremap_prot() should therefore reject protection values without
PTE_USER without warning. This makes the access fail cleanly for
PROT_NONE and execute-only mappings while retaining the existing
user-protection contract.

Fixes: 8f098037139b ("arm64: io: Extract user memory type in ioremap_prot()")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/io.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 8cbd1e96fd50b..a8507de4f84c3 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -272,7 +272,8 @@ static inline void __iomem *ioremap_prot(phys_addr_t phys, size_t size,
 	pgprot_t prot;
 	ptdesc_t user_prot_val = pgprot_val(user_prot);
 
-	if (WARN_ON_ONCE(!(user_prot_val & PTE_USER)))
+	/* Reject PROT_NONE and exec-only */
+	if (!(user_prot_val & PTE_USER))
 		return NULL;
 
 	prot = __pgprot_modify(PAGE_KERNEL, PTE_ATTRINDX_MASK,
-- 
2.53.0



