Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC143515964;
	Wed, 30 Sep 2026 16:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787028; cv=none; b=CQH772B5r2hW5TT/IyKWPOAgvSVs29ReFioJXgQUMVMheIGdKvLGt/IAoPaj9DeBo8SO9Qh4xKaixOfGAInOQ0E/pXRllpgnfHv7wnodJgOaY3pwilBAlZM3haIGETKod+zI+NfBK4J7c9ttsfEMlfEdF4lzuBOdXmeDCmJL+uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787028; c=relaxed/simple;
	bh=BAhPfQRE+SiugNkRSrF8LsTGhuhj1YD3gXvX5+lY4ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gk+NRyFtzkX0QC/Ch645iip+OTbUHnt1TNVnX/y6XEJtOy/89NNSrbmfpqrIsCJfr143wjgvInMLx3IZA+0WbcgVlTsKqBDTMTppRKKXh7bfkHy7AojTcycFI8Dhrujd2f7lulXnEd5yq6slP0KHd2ms+/9WPYD8oVACqyWDfK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vs5oh7qq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vs5oh7qq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535661F000FF;
	Wed, 30 Sep 2026 16:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787026;
	bh=kHrNzwwfkFRqnJdsOCqwvNaRD21t+/Vfi8fotZDEQNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vs5oh7qqtcfh1avDmZWon+kaL/+Qsum3Bwpwiq9wRRyLMsORz4yuCw3PLz8peliSq
	 EXPYWPFGhsAEgreJnxA/7++rk+qBf3QVaBGJRkGhRVgVjqH8DI2C6ACoZj9b0sAWxZ
	 P6xojdjwm4QbUjNzvFijoKXMQEqU8uM57kWU/6Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 086/457] arm64: io: Reject non-user protection in ioremap_prot()
Date: Wed, 30 Sep 2026 17:23:11 +0200
Message-ID: <20260930152347.904193017@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 21c8e400107ca..31e67f6bd4a70 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -272,7 +272,8 @@ static inline void __iomem *ioremap_prot(phys_addr_t phys, size_t size,
 	pgprot_t prot;
 	ptval_t user_prot_val = pgprot_val(user_prot);
 
-	if (WARN_ON_ONCE(!(user_prot_val & PTE_USER)))
+	/* Reject PROT_NONE and exec-only */
+	if (!(user_prot_val & PTE_USER))
 		return NULL;
 
 	prot = __pgprot_modify(PAGE_KERNEL, PTE_ATTRINDX_MASK,
-- 
2.53.0



