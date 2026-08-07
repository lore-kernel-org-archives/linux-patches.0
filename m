Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D61D3AD50F;
	Fri,  7 Aug 2026 14:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114286; cv=none; b=HccXYEnFtEflW6jDuHtGEcZi/4NUaw7dcIhivLrrFHpQGAWXtKEJ4vq7a3zzH4PdYVz0zqKULcpTqMfqtl1kdDXpAg/vfTg1Topzw6tgHFfszrvEjTlqoFwy4QgiLvBhH75cqTci4K3B1AeUvq1XnQRYAy1GQaAz7KQt+Y3NtMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114286; c=relaxed/simple;
	bh=zuVKBi9PrUEyOzd2x7iofXSbpO8p3sqThtEz8FA0IfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISlr+vJZgtXADvDbQ3JWOZbr7qPUFSIgqB0Uck8Gk+rFb64mPuQDCKfsJPithI8lpqBQUG62FaY5BrgzzUyoz75dNeR1P5RIhJ1+nzFTuLH4MvQUZlL2SbXz0R3ypQNdzLQY36VrDjVOPe3WbFNvgX0dhm0YLU0ZZ0wO9xSgm9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cq7pl+9/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cq7pl+9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013DA1F000E9;
	Fri,  7 Aug 2026 14:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114283;
	bh=FiyB3u+lfHK3LHp0Om7NF/pJyBrKWf5/ctvP1LSF7fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cq7pl+9/B2pfL24b008pO12YMsADJ89eKWyJKZXLOY330UQ8VHDAuQwE534rSslST
	 7GNl+dH2vECzuIZit4xObR2xjfzJS7+kDEgkz2BN1RdEaI4E3ERirNaMexBs6TFBJS
	 iGBqb6AYWUBhxkayYmBAIu6iZEMy0yEnk5Ei0K6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Ruess <julianr@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.12 208/337] s390/pci: Fix s390_pci_mmio_write syscall error return without MIO
Date: Fri,  7 Aug 2026 16:36:51 +0200
Message-ID: <20260807143423.065555552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit b7ab86bdc65eadcfc43a0e3faf682a3f750cfb96 upstream.

On a machine without PCI memory-I/O (MIO) support or when running with
pci=nomio the s390 specific PCI MMIO write syscall checks if the MMIO
cookie is above ZPCI_IOMAP_ADDR_BASE as a sanity check before even
trying to perform the MMIO. If this check fails the return value was
left unchanged and thus 0 from prior operations falsely indicating
success. This could potentially confuse user-space into falsely
believing the MMIO, on a mapping not valid for MMIO was successful.

Fix this by setting the return value to -EFAULT prior to the check
following the same pattern as elsewhere in the same function.

Cc: stable@vger.kernel.org
Reviewed-by: Julian Ruess <julianr@linux.ibm.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Fixes: a67a88b0b8de ("s390/pci: remove races against pte updates")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_mmio.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -178,6 +178,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, uns
 			goto out_unlock_mmap;
 	}
 
+	ret = -EFAULT;
 	io_addr = (void __iomem *)((args.pfn << PAGE_SHIFT) |
 			(mmio_addr & ~PAGE_MASK));
 


