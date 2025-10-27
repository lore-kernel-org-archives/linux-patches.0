Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C9C31D75F;
	Mon, 27 Oct 2025 19:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592963; cv=none; b=oX/hyKezQVIiA9dBUVt4po5rNwhi3gOdnLMrsQ+GWj6KiKQ9LFsmjXD4p44q7/SLHsloe1VKNFtOpfawzoNt+ZpU60oAXUBR1BE79xzNoZHk2ZMxPJe7RJYXkE2VkKn9ywb4533b43v/CMDNO7+90FyblvJbfBJ5PdsI/AF9Phg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592963; c=relaxed/simple;
	bh=0q5cn0SRCYm5Xjiq/ZkVH0Hfbh1hw37rBkBYrG+R5+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J21ZisrTJPK4z4hKbI3LOklaoO8Cni7nS+4N1f+iMiakj/19ieiZHIJoZqtjOSdeHh5nTAXmcrrEhzX7IcIGYjasR9jO0gkFwIoH7/2SrK3rSiSCIb+PX1y8Q8WFvWH38cjGmtBVgDXzi5kURe9CS8NJs+TKtj4IWQXogOjEBxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s19yQtCF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s19yQtCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1324C4CEFD;
	Mon, 27 Oct 2025 19:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592963;
	bh=0q5cn0SRCYm5Xjiq/ZkVH0Hfbh1hw37rBkBYrG+R5+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s19yQtCF+mi5LHpc7TbRr31TyL7yDGVJ0Flkxuqd4tSyu6TQAXuSzTyYdxov+uveG
	 dE8sut5eiuKGUf/VyhRF7Ym7CM8NhpiWxwXdCzfNHuWGPcf4swG20SnLb1FkrYUY56
	 h2tJC3VObxO0cfQaoj2i3bDN4/EToZIe/z9lDDXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <apatel@ventanamicro.com>,
	Han Gao <rabenda.cn@gmail.com>,
	"Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/117] RISC-V: Define pgprot_dmacoherent() for non-coherent devices
Date: Mon, 27 Oct 2025 19:36:46 +0100
Message-ID: <20251027183456.188950414@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anup Patel <apatel@ventanamicro.com>

[ Upstream commit ca525d53f994d45c8140968b571372c45f555ac1 ]

The pgprot_dmacoherent() is used when allocating memory for
non-coherent devices and by default pgprot_dmacoherent() is
same as pgprot_noncached() unless architecture overrides it.

Currently, there is no pgprot_dmacoherent() definition for
RISC-V hence non-coherent device memory is being mapped as
IO thereby making CPU access to such memory slow.

Define pgprot_dmacoherent() to be same as pgprot_writecombine()
for RISC-V so that CPU access non-coherent device memory as
NOCACHE which is better than accessing it as IO.

Fixes: ff689fd21cb1 ("riscv: add RISC-V Svpbmt extension support")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Tested-by: Han Gao <rabenda.cn@gmail.com>
Tested-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
Link: https://lore.kernel.org/r/20250820152316.1012757-1-apatel@ventanamicro.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/pgtable.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 03881122506a7..87c7d94c71f13 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -655,6 +655,8 @@ static inline pgprot_t pgprot_writecombine(pgprot_t _prot)
 	return __pgprot(prot);
 }
 
+#define pgprot_dmacoherent pgprot_writecombine
+
 /*
  * THP functions
  */
-- 
2.51.0



