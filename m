Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFD035C68A;
	Thu, 30 Jul 2026 14:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421893; cv=none; b=h/h3an1j8EPXyl+YzNU8MI6SZ0amr8rw2y5yiXx2DyWXqw1EMT5wJ8FZa8xpJVbbNCCeYfxY1WKZJcWJtiTdH3kmsuDQzj+LnOv6AsxxaM7kPggS56izuclaH52uaTrg8vhQcwj4gL43P76D0guVUVhUrTeI9Hm8eL9v4GdpYNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421893; c=relaxed/simple;
	bh=/CMJ3O2NtZhMFkeAfP7VwjMalZruhmh23XFQTJ+WrKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2KevtBJd7Icht1fJ09cHyNq1y/efj2xq1a8uInfmdlPtU77A4FovZnf8FBR4Tdlxba/cbR8e7TIkIonhLVyB92ilN0qgRj1RGx8fH2paxXcghbCuQUBkBMx3pYtSM+q+ee5Iyoi6HVnaBptsR1JE97E2OBZvyfUiku+kxd5qSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03+BDZ5k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03+BDZ5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B631F000E9;
	Thu, 30 Jul 2026 14:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421892;
	bh=BWtWqGZhs7DS5JFmIngcj65CLgC+snmXhb8HGPpIJKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=03+BDZ5kzXLwb+iGnRui/JBJqg2pjQvvq3mT1ddkqLSUNRyFb8cR/U4yeB79ny99P
	 BhxtQdUD+GzJY8TKI8xqApQvdsE0ErDPe2DjD0v+LzR9CXmICd0Mtr/Ms4uIdfJMuq
	 mW2fULjnxZIgOG8eiZta56CvxFW5Mqt9dYE0zXJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 254/744] arm64: Correct value returned by ESR_ELx_FSC_ADDRSZ_nL()
Date: Thu, 30 Jul 2026 16:08:47 +0200
Message-ID: <20260730141449.691693180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Price <steven.price@arm.com>

[ Upstream commit b877075d0baa22c225842c2f19e3ea0a9cbcbe39 ]

Address size fault, level -1 is encoded as 0b101001 or 0x29 according to
the Arm ARM. Correct the value to match the spec. This also matches the
offset of "level -1 address size fault" in the fault_info array in
fault.c.

Fixes: fb8a3eba9c81 ("KVM: arm64: Only read HPFAR_EL2 when value is architecturally valid")
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/esr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 7e86d400864e03..64e9bd137b603c 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -131,7 +131,7 @@
  * Annoyingly, the negative levels for Address size faults aren't laid out
  * contiguously (or in the desired order)
  */
-#define ESR_ELx_FSC_ADDRSZ_nL(n)	((n) == -1 ? 0x25 : 0x2C)
+#define ESR_ELx_FSC_ADDRSZ_nL(n)	((n) == -1 ? 0x29 : 0x2C)
 #define ESR_ELx_FSC_ADDRSZ_L(n)		((n) < 0 ? ESR_ELx_FSC_ADDRSZ_nL(n) : \
 						   (ESR_ELx_FSC_ADDRSZ + (n)))
 
-- 
2.53.0



