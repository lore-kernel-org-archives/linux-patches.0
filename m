Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6A82BE037;
	Mon, 27 Oct 2025 19:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592675; cv=none; b=SCC52hgF9eng8ASTyKfpQKcWVXuGRMe5uVvHQJDis0B8Xi1fLsrPcqjZkqcBAwHOpJIs9HQ5mwCF8GyHJm84wQ79H6AShmTR5hF7ISjLBd6lGt03TNu5KPM7pdctI1+2rFs3uBypvUgnrFoP7ljy8P0e+RcNvdeOnE2aVdaNg8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592675; c=relaxed/simple;
	bh=PuKchAanZrFYkQDOOCczFg3gnbvcmm1Lj7BvKZLCQic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ui9pZESimyqpxd8Qf3ItwVv4mcQAzVSSnyUURgspG+7k2GJwOyu9flxSbk/adnQHeLnQRaZuYtZGb8xsdOChC6PL5i5uujdxJpFM0p5l79etNfC1Ge+psbRsI/MYl9xsv6sLxNDA+TQQe7EfiWB2S3qzdWG+gFP77G5RzoS0Ulg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EOXZcDpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EOXZcDpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA2EC4CEF1;
	Mon, 27 Oct 2025 19:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592673;
	bh=PuKchAanZrFYkQDOOCczFg3gnbvcmm1Lj7BvKZLCQic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOXZcDpfseIrc90Ou1p1dyDaggqh3ag4NgVaW7OU9LPbfzexJvanmyNH1AExD9HSW
	 jaE9CsKbS6GRJYtrXGXTQQd03p3wHM9QGXH6fNMEd+p7q7oopE6jKbwUyCamQcdJaW
	 pfnKZjLZnmwoG9Neyjw7XTrv++kbY11UCDHP98pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <apatel@ventanamicro.com>,
	Han Gao <rabenda.cn@gmail.com>,
	"Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 52/84] RISC-V: Define pgprot_dmacoherent() for non-coherent devices
Date: Mon, 27 Oct 2025 19:36:41 +0100
Message-ID: <20251027183440.204886734@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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
index 332a6bf72b1d5..987cfe87e7825 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -618,6 +618,8 @@ static inline pgprot_t pgprot_writecombine(pgprot_t _prot)
 	return __pgprot(prot);
 }
 
+#define pgprot_dmacoherent pgprot_writecombine
+
 /*
  * THP functions
  */
-- 
2.51.0



