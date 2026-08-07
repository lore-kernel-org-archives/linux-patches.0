Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B674433C1AD;
	Fri,  7 Aug 2026 15:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115423; cv=none; b=cYMeTu8EeaB/tHwikjLzXvG8RN6OYljRhG84O4fc2ACu1fFgP6febaZrrfcZuBS6c0dEk4JOuhCPVXdSLEFAqzqWJTLCtBUYtP2SB6s9PaJBRheUj/7zij0tfO3pj1dxbSFJ9xK0ZCL8pj89t8VKm4AEn+iQOrYu5Gm6p7vmtL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115423; c=relaxed/simple;
	bh=KErT/lpAGy/9wp5OogWJBeDRxPpP+1YOnNhdcJD1fxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKELItgD6+ciF/AKd7x5rQ4tNmyiLxNLRYR/ya4kpE5LG/LosLAPGRANhQRozhwadJQPxfEtcBGDXIHkrWXEuZ2v8RYrW+eKjYLjbxAlxxDJB5vo94E09f0BUSdW54Hc//efkGuJGcNsFznIyUp/KMPpsBm1TOB299JY/ds2J88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SB04GamU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SB04GamU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87791F000E9;
	Fri,  7 Aug 2026 15:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115422;
	bh=Il4ueJPv2HuI0GunrVCKfAW5uwYvcwfNUi+sEb7lBQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SB04GamU/4Ozlj7EAwjQnFag83NsRj+oXg8L/asdb9cJggje/oTepFRAjTnjRooH1
	 +xbFmAR9uydwCuLEDl9WmErUJZ1Xe0Lkc1HzCLlrKe4WzajK09qEUJQsh+vWEOnBX5
	 yBUo8p18M70snegxmQ+CNg0wN1iv19KBzi/mlyFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Ruess <julianr@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 270/396] s390/pci: Fix s390_pci_mmio_write syscall error return without MIO
Date: Fri,  7 Aug 2026 16:37:10 +0200
Message-ID: <20260807143430.080032388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -188,6 +188,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, uns
 			goto out_unlock_mmap;
 	}
 
+	ret = -EFAULT;
 	io_addr = (void __iomem *)((args.pfn << PAGE_SHIFT) |
 			(mmio_addr & ~PAGE_MASK));
 


