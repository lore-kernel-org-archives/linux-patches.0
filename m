Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA043154C18;
	Tue, 30 Jul 2024 16:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357885; cv=none; b=H6Nir1vaHaE76vyTSEsjgiv9fFlCCbQXwQ6pP463sEx7I3W0xB4BVV9PdOjoT8HRZQ6wxAzspGwBGEjibryb9c29rPxfp/Ore2RK8OGXeSoWu8cVlj+BB9JnJ1LViuqmSbpZi57jBUodEPo6SH4Rf7/ft5iohczhQU1rMyU7Q18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357885; c=relaxed/simple;
	bh=/UblkWw53UL+DW2t1XRjjaicnUH+vIJ49s1XwUwo/4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSLPjc0i+lsNa3h+DtGDQnex5PFzGiXRvRf0SXCHZ+X61AwqW/14IIdpoHeUMjfQ3jSStRzsObb/Z87aoDjD6gydJu3OBFWxSZAO8cUt091NUQhhDRxSvy+pMHY4dFGX5j/jKElDY8BDwi5whR/vMtAKIXX6SDSDa6WvyC5QuA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYAMFtr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYAMFtr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EB3C4AF0E;
	Tue, 30 Jul 2024 16:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357885;
	bh=/UblkWw53UL+DW2t1XRjjaicnUH+vIJ49s1XwUwo/4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LYAMFtr1H4ZhHPCojXyhTNGB82bwaMHbjegybjqtyjFfign4xrwIbkBZb2oC7b2vw
	 ZYmNaKIa4Ry7rRuDx5v0XRoY0IZhC7zFjI7SZQPD+zFUFTjQD88hBaNEacLEch0D3r
	 +yExv2wQ8r2AyD7hCtWd08YV0AFrZfGXIX4Zrgos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 321/440] parisc: Fix warning at drivers/pci/msi/msi.h:121
Date: Tue, 30 Jul 2024 17:49:14 +0200
Message-ID: <20240730151628.356353633@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave@mx3210.local>

commit 4c29ab84cfec17081aae7a7a28f8d2c93c42dcae upstream.

Fix warning at drivers/pci/msi/msi.h:121.

Recently, I added a PCI to PCIe bridge adaptor and a PCIe NVME card
to my rp3440. Then, I noticed this warning at boot:

 WARNING: CPU: 0 PID: 10 at drivers/pci/msi/msi.h:121 pci_msi_setup_msi_irqs+0x68/0x90
 CPU: 0 PID: 10 Comm: kworker/u32:0 Not tainted 6.9.7-parisc64 #1  Debian 6.9.7-1
 Hardware name: 9000/800/rp3440
 Workqueue: async async_run_entry_fn

We need to select PCI_MSI_ARCH_FALLBACKS when PCI_MSI is selected.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Cc: stable@vger.kernel.org	# v6.0+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -75,6 +75,7 @@ config PARISC
 	select HAVE_SOFTIRQ_ON_OWN_STACK if IRQSTACKS
 	select TRACE_IRQFLAGS_SUPPORT
 	select HAVE_FUNCTION_DESCRIPTORS if 64BIT
+	select PCI_MSI_ARCH_FALLBACKS if PCI_MSI
 
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used


