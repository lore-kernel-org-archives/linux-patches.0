Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FFA1B95E;
	Sat,  3 Feb 2024 04:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933741; cv=none; b=Onop9sbN8lw6pQ7AHd6MdzwyDmXu9Gq2Wx7pnIu6cIODXfevf7kk4W1Xiq9uIiP9atYTRX3BjLWwM25HeP4jliW0MPMKR683iMdqfFT6GhKQFi989JdYxuJGQOuXAmBCLNYzZEzlhmDXkHbkNu+SY8M1zBGRuK2iJju7fAb5HV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933741; c=relaxed/simple;
	bh=eMkdW3ynW9W4y71yt+OdZGgYw7K/HEh2AqFSZpkZAYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ktCuaQNuLxp4PV6Jln8IAZx4JrHmHSWLT6nMk9DSH/MHOzo/wCefMNlb2C8l9cJzFNFpXQGra56OWapbZJ2VzdUV2u5vu2fJh86pnoLaluMtf5LKeP9IIOh4sCqTZ4jNoS4ZOiKnyNDYyfBSIvytFLeLmR/I+/R0MriOJD+qtFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQCakN9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQCakN9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE160C43390;
	Sat,  3 Feb 2024 04:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933740;
	bh=eMkdW3ynW9W4y71yt+OdZGgYw7K/HEh2AqFSZpkZAYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQCakN9jYc4h3TwJe69y1+aVeKxU64CM6p/WdxpVeTMsTccd1bCfJajKs8eZerAy1
	 +uVMs0hztKtTFvHEDOUZVYI27tnITtLB9XDgLx1KUm7gBzlkKYLC6BFUbPGbRvQAiV
	 ralUblQUOc2k8zLPSynyWBMeSZ9Xl5k01M/ecjyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 007/353] powerpc/64s: Fix CONFIG_NUMA=n build due to create_section_mapping()
Date: Fri,  2 Feb 2024 20:02:05 -0800
Message-ID: <20240203035403.925747461@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit ede66cd22441820cbd399936bf84fdc4294bc7fa ]

With CONFIG_NUMA=n the build fails with:

  arch/powerpc/mm/book3s64/pgtable.c:275:15: error: no previous prototype for ‘create_section_mapping’ [-Werror=missing-prototypes]
  275 | int __meminit create_section_mapping(unsigned long start, unsigned long end,
      |               ^~~~~~~~~~~~~~~~~~~~~~

That happens because the prototype for create_section_mapping() is in
asm/mmzone.h, but asm/mmzone.h is only included by linux/mmzone.h
when CONFIG_NUMA=y.

In fact the prototype is only needed by arch/powerpc/mm code, so move
the prototype into arch/powerpc/mm/mmu_decl.h, which also fixes the
build error.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231129131919.2528517-5-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/mmzone.h | 5 -----
 arch/powerpc/mm/mmu_decl.h        | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/mmzone.h b/arch/powerpc/include/asm/mmzone.h
index 3764d3585d30..da827d2d0866 100644
--- a/arch/powerpc/include/asm/mmzone.h
+++ b/arch/powerpc/include/asm/mmzone.h
@@ -43,10 +43,5 @@ u64 memory_hotplug_max(void);
 #define memory_hotplug_max() memblock_end_of_DRAM()
 #endif /* CONFIG_NUMA */
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-extern int create_section_mapping(unsigned long start, unsigned long end,
-				  int nid, pgprot_t prot);
-#endif
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_MMZONE_H_ */
diff --git a/arch/powerpc/mm/mmu_decl.h b/arch/powerpc/mm/mmu_decl.h
index 7f9ff0640124..72341b9fb552 100644
--- a/arch/powerpc/mm/mmu_decl.h
+++ b/arch/powerpc/mm/mmu_decl.h
@@ -181,3 +181,8 @@ static inline bool debug_pagealloc_enabled_or_kfence(void)
 {
 	return IS_ENABLED(CONFIG_KFENCE) || debug_pagealloc_enabled();
 }
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+int create_section_mapping(unsigned long start, unsigned long end,
+			   int nid, pgprot_t prot);
+#endif
-- 
2.43.0



