Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C000E442393;
	Fri,  7 Aug 2026 15:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115535; cv=none; b=BDjuX/RpnA1pAR4Ws3C0WCzpdYj3RHsGlY9h8GhwiWvcFfVrk45Dr49kmGRk8Kxyui+o9dF3NPWuq6+45Pr5B+Pibdt8/sHJSebPDgx6wlIWbwxVMUhDYg0ykc26gBAg2gCFzF04quRfAuhJlfXF8JcyAtS7cvidKS5IhexLztg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115535; c=relaxed/simple;
	bh=RJ0f3ynKJ0kF9lwOh5xdubCwKsGLkPwv5Lv9ZkgdDs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O27Z9ClH10DiqSaZzcrrm9qz4cibg3cqhU09fYdiyQFgZgL4RGTclBiKqYswSNpxMBFZrzZ5EzBf/oPNb+9l7mpczBquIpe8/intxvsF838qigLjd4znxLblB78POJtSczXWPhVvftPa+MbVv798dUiv3BpmdnxVcKq0a9MGTJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXjJQ20s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXjJQ20s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1794C1F000E9;
	Fri,  7 Aug 2026 15:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115531;
	bh=bzWxm9c9K6n/L3Jykgs38OgA/unChgQqjms1KHeuciI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cXjJQ20sF7g0j6P/9gRXAFRXPloqdz4bXTmqWABJ3ZVLXO4tF3MW7NkBeH5HgmuUw
	 JZKfzdd3jfkgcYUXkRwecJ63zSHLHa6gOtI2TPib6RuM0qmYjglBBPppExavhp7AuF
	 UbvuGhLafACWnsDpt9bUr/SPVyDRbUZuwtgV8AIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Pavel Pisa <pisa@fel.cvut.cz>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 309/396] can: ctucanfd: unmap BAR0 using base address
Date: Fri,  7 Aug 2026 16:37:49 +0200
Message-ID: <20260807143430.935474960@linuxfoundation.org>
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


