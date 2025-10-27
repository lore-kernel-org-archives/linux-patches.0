Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427CD320A02;
	Mon, 27 Oct 2025 19:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593434; cv=none; b=Dk3n3/6Txa/GqUoifhAsBGROYQnY8sOjXSusDxT6DgG5dAH6A12R+orPWz7IjoQaae9ox53/ceQagQk3zslSaOW/9KaZ71iWTichRbvXSVLVqrgJ4ajnoH8SGWKz7UOW2mDusbZvG37hOYabW88kZ13g6aLmYp8dqzgKLITJqsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593434; c=relaxed/simple;
	bh=2kiRAAdiiVx3uf8YiiVpya5p90qXsom+uj7vC5685CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTg4AqfBXmSVn51nncA4m9uXbdbMHMZ+dNAr6dDxvIrnxojU9jiW2kLZIAif24XI2iUpzP9U9jsm6AJP0X+WXmh5VpE3AyO2DkzEnDNi++mKC8PHyrB7eaS0NAdkgKQaBxj81N2jfFIPw8qZvC924BqWVZZX6MHSl24JudBruQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ga1R6z9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ga1R6z9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CD3C4CEF1;
	Mon, 27 Oct 2025 19:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593433;
	bh=2kiRAAdiiVx3uf8YiiVpya5p90qXsom+uj7vC5685CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ga1R6z9P3LCvlo/1eKy/KEyXE4f7Bw8U6z7DYqSZZMPNwWGiryCFHDvFQuwUC2Vnm
	 wPLMjMxfZHls91BuVAnPDNW6M12sDfCNi7dNJBD2GVAEQUyihkwU49wAyyYegqEFrS
	 rPBWonnIxMMdWFOnbmiCInQtjfzJ+oLv/pvjOe7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <apatel@ventanamicro.com>,
	Han Gao <rabenda.cn@gmail.com>,
	"Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 132/184] RISC-V: Define pgprot_dmacoherent() for non-coherent devices
Date: Mon, 27 Oct 2025 19:36:54 +0100
Message-ID: <20251027183518.500309367@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 8150677429398..4355e8f3670bb 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -653,6 +653,8 @@ static inline pgprot_t pgprot_writecombine(pgprot_t _prot)
 	return __pgprot(prot);
 }
 
+#define pgprot_dmacoherent pgprot_writecombine
+
 /*
  * Both Svade and Svadu control the hardware behavior when the PTE A/D bits need to be set. By
  * default the M-mode firmware enables the hardware updating scheme when only Svadu is present in
-- 
2.51.0



