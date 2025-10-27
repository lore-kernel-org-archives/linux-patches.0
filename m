Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85071FBC92;
	Mon, 27 Oct 2025 19:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592384; cv=none; b=RK72Mb7x+K/v0rPUuPWHxrJhvsxg8w/hFFef3WFIXLllVKOsGjSlz1KDYoPaTfcX4GPZffv5cr1epLvDpH5MlcjpSTU+lnKM7xHTcAZtv7wUdVVhZTNwP0mY6Wzw5jlXz4fcssraqQfokaCDcoNBFrrV0YliFix/ffIFlhLDTjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592384; c=relaxed/simple;
	bh=HRJCLDY6QxOFQfjObeL1prKbGPGEXPpSGH53ZNSwv7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tH/0CWeqYluZBhFXKBbpCxjiEkmERigfGbjoFMqRQpL0pIFQEu5mrDN13idY8HuvRSa9DbYHNKMnPgyXCmXQ8ZuwHikLRs+TeF819RvMjERiqukw8JQDuQZD4YkRSYr2TS8p9Vy5AzHEe0fxKRoWC30Ffd1iNOOFHcmbU38M25I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvvVGAyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvvVGAyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20810C4CEF1;
	Mon, 27 Oct 2025 19:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592384;
	bh=HRJCLDY6QxOFQfjObeL1prKbGPGEXPpSGH53ZNSwv7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvvVGAytEDYrqn1IffSiy4Qr3IScpTsVmqVwRBWUcjA9jf04eH6YRGgrQ9XJ8u7gp
	 CrSFHRvCFwWDLIEXL+uGKgkcUproNuUlu2u9gx6xRrYyMUC4gUkvELiYtaYmBpN4+t
	 DOXXBzKEhTfz08WuNbtzj6s+l+eLGIekIZfMv7hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <apatel@ventanamicro.com>,
	Han Gao <rabenda.cn@gmail.com>,
	"Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/157] RISC-V: Define pgprot_dmacoherent() for non-coherent devices
Date: Mon, 27 Oct 2025 19:36:01 +0100
Message-ID: <20251027183503.945373670@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bb19a643c5c2a..1a94e633c1445 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -555,6 +555,8 @@ static inline pgprot_t pgprot_writecombine(pgprot_t _prot)
 	return __pgprot(prot);
 }
 
+#define pgprot_dmacoherent pgprot_writecombine
+
 /*
  * THP functions
  */
-- 
2.51.0



