Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10B11A76A1;
	Tue, 30 Jul 2024 17:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360227; cv=none; b=F4/7HTFB/XumFcVqIIRdwlDQcxQp80T+leZmi5a1Cg8hI9BcoPG8eFivicZC+/3H9SG2BQ/PFgElnKmtRbFBrH+Ny4xOKwaw7L8DX8xVcPk7mGmOC9Wx+h2yZ1UXcOcIDdNeHCY7QTDdPcoEBqRFSe5L0WBgFIytoGt61TxRJJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360227; c=relaxed/simple;
	bh=kShYshOLKEqY1KpN4dqxf2ECvMPSpEaPss4hF0MTGKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNqbmcl+QBgSXO+/YW2ClFUEPy6JqCLxxq5FKy5kIoMW83O577OWqUP6HNI7hCG1Vvug0mj4Xx/OpMNqIVZ9EKANxwiRXi3TdctBXa5RCoSw/bqfQ8+4S9bJwCLkEbisHjk3fpPjl4QFmT+gr3u8a8WCHHdWc2gkNKXuLR+Q0+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qBRBsdaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qBRBsdaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A8AC32782;
	Tue, 30 Jul 2024 17:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360227;
	bh=kShYshOLKEqY1KpN4dqxf2ECvMPSpEaPss4hF0MTGKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qBRBsdaqKxoemqMFLR4pSWWiXuvLR7R1tugIQZU5CZLtkaSnKec9JHjJ/zwd3XBpf
	 SHre+efIvwYb4nJGaI+ni28If61JPZQqnzJdyfMUIWRrltkGZ6vN1QZfou6ZhmRpDs
	 ziCYs05CtPkV/Adbld4r2Zn0bRf5PLiEjE72KmUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.10 636/809] parisc: Fix warning at drivers/pci/msi/msi.h:121
Date: Tue, 30 Jul 2024 17:48:32 +0200
Message-ID: <20240730151749.965565131@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -86,6 +86,7 @@ config PARISC
 	select HAVE_SOFTIRQ_ON_OWN_STACK if IRQSTACKS
 	select TRACE_IRQFLAGS_SUPPORT
 	select HAVE_FUNCTION_DESCRIPTORS if 64BIT
+	select PCI_MSI_ARCH_FALLBACKS if PCI_MSI
 
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used


