Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E891A6192;
	Tue, 30 Jul 2024 17:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359042; cv=none; b=QI98Z7+ya+lNff6eA5Mt8aMYYri5BKgzHsDC0+mnDsUcUmwXaQ5uVm/4sJZ4Q4sKplHnU/VEo041I1OpHfmfqZ4bHMowIxMZxH2il9pufQJRJuU2JFCdixWKVUY/d/V8dSghyg1lwjmi4c+7al/SQdpK6RBYbiQZpvZSSw/Uy5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359042; c=relaxed/simple;
	bh=6r1T7BMXOHkU6MSPpb2BS3c5xuIvmGqPYPC7dXVh1ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/eAEXfod9OXiVUPjOEAjrdbUtQcdrU2JeQCthRB72C1uQoms9Um6+3oFnPzBbn8DHrIB0wwrlJJqNedIx3Qnxe/TATp8WawsYhG/lkV1rMlfi5umqIwTOBqu75rH0G9v4ObTVZHdD6eaS4Cdbqu0g3oeDMofX1dYPMKbYa5Xs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5hl/4v3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5hl/4v3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D302FC4AF0A;
	Tue, 30 Jul 2024 17:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359042;
	bh=6r1T7BMXOHkU6MSPpb2BS3c5xuIvmGqPYPC7dXVh1ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5hl/4v3hsd7dRgquYEMmggULDwDOagqHEWSs8kS61DQdWEyIJg7LydZoPysEuhhw
	 A0qGl9A5AXs7zxlL0dq06VYTtOMGgJsbCrzVaP06KJw3TPYK0I0/zYmF9lVkvIFL/v
	 9EJIDgm62S351Br6jcBcMzkJNOhXBJSEr+L6xMT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 424/568] parisc: Fix warning at drivers/pci/msi/msi.h:121
Date: Tue, 30 Jul 2024 17:48:51 +0200
Message-ID: <20240730151656.438286325@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
@@ -83,6 +83,7 @@ config PARISC
 	select HAVE_SOFTIRQ_ON_OWN_STACK if IRQSTACKS
 	select TRACE_IRQFLAGS_SUPPORT
 	select HAVE_FUNCTION_DESCRIPTORS if 64BIT
+	select PCI_MSI_ARCH_FALLBACKS if PCI_MSI
 
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used


