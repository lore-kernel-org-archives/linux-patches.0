Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EE513AA50;
	Tue, 27 Feb 2024 13:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042352; cv=none; b=teDdFcp2OpsS30mV4Bg9t9DKdPnNaTf6lxMgcv6opaTolVLAbKJFkfl8HIYgzXyQDm2ybe+dKgHNNKX2nalPRvFsqjc+EooSFLc3BU8NOk09Kx5Gkes8y99+rAq5lmEITXlTVKnXrtxKuN3r9m1U1jZlZPB5Jl8dpMFylZtlg0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042352; c=relaxed/simple;
	bh=K8HXgNJ9RVQPcynis8KbdnPNn39u8hsOuoJVeP6ZJMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ug3W21CTNCXPK2I3dBVyqbgJvhQJrBSQ2qKydUnt8hwDwJ7Pd6LztglrnoODxo6Kjhf8sDD1ZHMl4rS0XCg8sXwksdbpBouyYCG5tfsqNwU3Cdn63z6ve9giBd+tVl0wMebMJMKmtljughGN37U2v0HYn/auFkTywtGRExzARHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WBi6mYZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WBi6mYZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114D7C433F1;
	Tue, 27 Feb 2024 13:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042352;
	bh=K8HXgNJ9RVQPcynis8KbdnPNn39u8hsOuoJVeP6ZJMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WBi6mYZiNGNaDbHblFHIvCpb0kFQDIxTD9WqIK4PvnVNr7SumtMW6Pi6FOAj3gUs4
	 vrg3fM8fcHMxYtUw0yS8JtCSzEuwTWt+TDY0kcNTXuZrrR83H26avLUMXMNYT2I1tK
	 a6JvNvdv/OVPr/3qvR/Fau4Qxb51I/dQ3T9iOGY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 264/299] s390: use the correct count for __iowrite64_copy()
Date: Tue, 27 Feb 2024 14:26:15 +0100
Message-ID: <20240227131634.189771997@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 723a2cc8d69d4342b47dfddbfe6c19f1b135f09b ]

The signature for __iowrite64_copy() requires the number of 64 bit
quantities, not bytes. Multiple by 8 to get to a byte length before
invoking zpci_memcpy_toio()

Fixes: 87bc359b9822 ("s390/pci: speed up __iowrite64_copy by using pci store block insn")
Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/0-v1-9223d11a7662+1d7785-s390_iowrite64_jgg@nvidia.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index d34d5813d0066..777362cb4ea80 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -241,7 +241,7 @@ resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 /* combine single writes by using store-block insn */
 void __iowrite64_copy(void __iomem *to, const void *from, size_t count)
 {
-       zpci_memcpy_toio(to, from, count);
+	zpci_memcpy_toio(to, from, count * 8);
 }
 
 void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
-- 
2.43.0



