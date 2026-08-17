Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0C92236FD;
	Mon, 17 Aug 2026 15:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980119; cv=none; b=PSBPuLwtrho0h7Q6I45x2CXKTpiot611JsSL2N60Z1CQSI7NbnmFJT85bXBx9KrJSjjkk2BuKU+Qnl2X5tXdSCrbQb/BAlrNYM3j/h2twsx7cJT5L7R6XmRKtDmXhEC05rh2UyD1KcnYfi8f92v8xmCk+hLC1fOOje8bYpb+deM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980119; c=relaxed/simple;
	bh=gO5IVoswmmlmSSXEoReEqAXsIpAD5O03gfNCsXDCDqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3gCDe66KJ62oS2/C4PmxMhxTz0dqjRvWwJCaqeuMeHFvH+YPRyEShVH6/qavLBISxCVDkfcURIQcS5OKYLPQB1I/GipQXdB6z67JhWXFsGIUiyEpUZTDDvZcEWTl3g+zfxesEM3CfSKdJ1ZPpPavzM88o5reg6D8sbhrXB4Onw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxb5t3mc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxb5t3mc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1529B1F000E9;
	Mon, 17 Aug 2026 15:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980118;
	bh=X14LfAddzqNr8vl8HV2l07giHCfSEDoO+kNzmM/MJxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yxb5t3mcBcMU+y6/FtocW+Cgs0oSQzb34P9gqWO+vinomgha1R7T8vlgGOgFessLL
	 51ftDEnzKiZkob5PtuaFVzUwjkk7JQQx3srUGyChFwSZ14oEM0qrWw4RrYQRijS0Mu
	 J8SxY7VcAiclmLPkOaI1AL8G6bSjH6nsHuNe6RtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Pavel Pisa <pisa@fel.cvut.cz>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 462/609] can: ctucanfd: unmap BAR0 using base address
Date: Mon, 17 Aug 2026 15:32:38 +0200
Message-ID: <20260817132559.469166596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -202,7 +202,7 @@ err_free_board:
 	pci_set_drvdata(pdev, NULL);
 	kfree(bdata);
 err_pci_iounmap_bar0:
-	pci_iounmap(pdev, cra_addr);
+	pci_iounmap(pdev, bar0_base);
 err_pci_iounmap_bar1:
 	pci_iounmap(pdev, addr);
 err_release_regions:


