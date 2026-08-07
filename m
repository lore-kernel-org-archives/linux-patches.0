Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72832306754;
	Fri,  7 Aug 2026 15:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117610; cv=none; b=AN1Nkv/i05YiggcCQo/QfMMUPV92glHOSNcuQclRuG4HsxyJd+h93iganUKGR8kzWb3PQApU/cPEVLrZ62MuIO0ddi8YBfbJmr8H7qR2+8dioga5mrSZ8+gq3YC7MkFi3JDm+N0pov5j8scDzOS+7vXpsxcEUdX77Mu2TskMBu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117610; c=relaxed/simple;
	bh=cTMlW/sNuzJgiMSm+Bsd6ujMGC+OuZCfnQ7vjgD4HNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lruRtc1nX+E/fO6tsQ70Dwi/OoUUHi4dByiNTRTYVgjUMc7bKG/CfGKkFXkX2NDL8913lteudr1EKKy0c1tHP9o6z1z43fj1MzwSBOV69cEEL44ghmPExv+LWToDeo9VCiSUcpzmWGlHPkVmSvpp/ZzwaJLvbDR50zTD5UH/BQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGI4R1cK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGI4R1cK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D044D1F000E9;
	Fri,  7 Aug 2026 15:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117609;
	bh=ohOV1UaqRBDFc7yOVc3rpwh0uGL+MfJhR7m4f9GLJj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGI4R1cKUKSSx4WGeTzzF9OqWBBuxN4acYA41Rko0v9POWmaGi1iCYKPTYx+kynp4
	 uoZYpz6GpnEvFxJ5cnHuC3vDe3o8lc5vSYNhAQRiEO7Vp+VSHbwrEocM9joSfS9EgX
	 ODaX7ByErtUeDQBi+BHd4mWbSgxf7Oqj2Q52Kkys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Pavel Pisa <pisa@fel.cvut.cz>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 7.1 379/438] can: ctucanfd: unmap BAR0 using base address
Date: Fri,  7 Aug 2026 16:39:35 +0200
Message-ID: <20260807143436.047873468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

commit a6873910f983096746d1a2e0af94f36b8003e839 upstream.

BAR0 is mapped into bar0_base, while cra_addr points to an offset
within that mapping and is used for other purposes.

Pass bar0_base to pci_iounmap(), instead of cra_addr, on the probe error
path so the address returned by pci_iomap() is used for unmapping.

Fixes: 792a5b678e81 ("can: ctucanfd: CTU CAN FD open-source IP core - PCI bus support.")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Acked-by: Pavel Pisa <pisa@fel.cvut.cz>
Link: https://patch.msgid.link/20260723095934.181042-1-thnkslprpt@gmail.com
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/ctucanfd/ctucanfd_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/ctucanfd/ctucanfd_pci.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_pci.c
@@ -194,7 +194,7 @@ err_free_board:
 	pci_set_drvdata(pdev, NULL);
 	kfree(bdata);
 err_pci_iounmap_bar0:
-	pci_iounmap(pdev, cra_addr);
+	pci_iounmap(pdev, bar0_base);
 err_pci_iounmap_bar1:
 	pci_iounmap(pdev, addr);
 err_release_regions:


