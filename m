Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E7E13B2B4;
	Tue, 27 Feb 2024 13:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041569; cv=none; b=qyCdLeGIf7e297BzHV5j50poCNhzNjLS/VBfeXLEfYDTvvCpmOX0tFTddT59wHG/hi8y5AOrWZrhyAlojFGVGgEm7QxU8Rtz1ctEjEnJhsrPXBwu3QOXCdCl0z5O3MSO9hEtzj+BiZHthY35YygjooZN2rjxEoWyDqNCX5NyVCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041569; c=relaxed/simple;
	bh=wKRF9y5npCfRuo1IdHI5zx/sJ/73I3xB/mG3+YV4fHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fx7Ki8Uxywhu/rdxgsOcRQ1FciAmtVY1FeqAM+N2tcIhExJjQGqfFNlsJLZ19stDKPJtF8zBa/yp6T+6S7IRcfqsL6E+xwfWdNMAvSjtscyOsYCU7NTriZwzyQ/P3luJfP8VjN2YSlXeYzNua70IaiPdPoFCaH+zZZn13cMXXVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTOST/5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTOST/5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E37C433F1;
	Tue, 27 Feb 2024 13:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041569;
	bh=wKRF9y5npCfRuo1IdHI5zx/sJ/73I3xB/mG3+YV4fHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTOST/5TsxzdInoH5i8+k/pV3M0D+SqpKcj80RqDijX7wZKLuRBbU2vFrzPo0nk91
	 7Jt3s+LVcUW3hMlmTxUgj5CshbENKJSlBR3FX1iB1GgfcCZOP5G7TVEHmLw2V3TJpM
	 UjZZlZ088GH8+7cNTqnw3m8geZG2CWb+bt36gAXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/52] s390: use the correct count for __iowrite64_copy()
Date: Tue, 27 Feb 2024 14:26:34 +0100
Message-ID: <20240227131550.080328801@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 arch/s390/pci/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -273,7 +273,7 @@ resource_size_t pcibios_align_resource(v
 /* combine single writes by using store-block insn */
 void __iowrite64_copy(void __iomem *to, const void *from, size_t count)
 {
-       zpci_memcpy_toio(to, from, count);
+	zpci_memcpy_toio(to, from, count * 8);
 }
 
 /* Create a virtual mapping cookie for a PCI BAR */


