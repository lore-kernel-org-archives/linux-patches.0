Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E651AD3E5;
	Thu, 15 Aug 2024 14:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731132; cv=none; b=danfSeZF7agzIFClULeZJmB5WPP4JmFphOLRwAfpdEE6epizuhcOmIoMt6Scpu7R26OJKgTMxxbhysQ7RJjTUR+BttO+UnkguoOTEp1dEgfZCExM3i0vFOxFJN5ut9EP+bbqmP8p6LZHRSVFExK86yvnf7YctOUDNDGV2eBruT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731132; c=relaxed/simple;
	bh=nkNVeNka2XQn964XDUpYI+H0RxgyPK4uxz8p0CW256M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FNVAW+kFGIn1/eWGaNam6U8bLIwB4LQypnkdVsVgb3p/m+cZintl6qXHNPUX0UYRK1iAPO0dLfUVJdl8+unVhyOXZIH5jveSvIsrRQtOPt1RPrN7eCMly0tWmi7UGizE+WOOwuiUrDE8GG7Zt8LItFuDH/4PlpqPHkZXxsrwCa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v78wvWA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v78wvWA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DD7C32786;
	Thu, 15 Aug 2024 14:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731131;
	bh=nkNVeNka2XQn964XDUpYI+H0RxgyPK4uxz8p0CW256M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v78wvWA8+Dzs3z15y7hhiPaioujM07zL8XY5j5Sr17w4NAy3hSjOucZhKYCK8TpgA
	 mrWOOPNrdFaHHEQLDpJVrKeqhmFwKZeJ9t+KOqKGE2smiHYAih41uH8pkMQ3VI15Ia
	 Spx79V+/Vz9yE3QC0XZuDkqaEKyp9E9DLiwZQvM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/259] x86/pci/xen: Fix PCIBIOS_* return code handling
Date: Thu, 15 Aug 2024 15:22:22 +0200
Message-ID: <20240815131903.151707996@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit e9d7b435dfaec58432f4106aaa632bf39f52ce9f ]

xen_pcifront_enable_irq() uses pci_read_config_byte() that returns
PCIBIOS_* codes. The error handling, however, assumes the codes are
normal errnos because it checks for < 0.

xen_pcifront_enable_irq() also returns the PCIBIOS_* code back to the
caller but the function is used as the (*pcibios_enable_irq) function
which should return normal errnos.

Convert the error check to plain non-zero check which works for
PCIBIOS_* return codes and convert the PCIBIOS_* return code using
pcibios_err_to_errno() into normal errno before returning it.

Fixes: 3f2a230caf21 ("xen: handled remapped IRQs when enabling a pcifront PCI device.")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20240527125538.13620-3-ilpo.jarvinen@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/pci/xen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 9cf8f5417e7f4..f93e03b236457 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -37,10 +37,10 @@ static int xen_pcifront_enable_irq(struct pci_dev *dev)
 	u8 gsi;
 
 	rc = pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &gsi);
-	if (rc < 0) {
+	if (rc) {
 		dev_warn(&dev->dev, "Xen PCI: failed to read interrupt line: %d\n",
 			 rc);
-		return rc;
+		return pcibios_err_to_errno(rc);
 	}
 	/* In PV DomU the Xen PCI backend puts the PIRQ in the interrupt line.*/
 	pirq = gsi;
-- 
2.43.0



