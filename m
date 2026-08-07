Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8E74756C4;
	Fri,  7 Aug 2026 15:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116304; cv=none; b=vEKVifsWkjyA0JyqekbWlxnfHbFHvtlCdG3DD/PNM52uBYENQvwIpCFTMitJ8QGTgPrWzA8JSud9xguUOhOrEyA7lcWsTUSsmpOqCmD+X9yxyNiVzXmfMpxRRoD/A2ljmK52kuuXSC802IEs4eeIW593G09l0/W3IjYTWpBwEos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116304; c=relaxed/simple;
	bh=TpHH3JrXl6BUjfsu26r5BQevmoyOlNAqBUn8/BAXJpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=job/8q+fuCxOmHYoBBY4oQrL2qFuw+tH16hGJ4zq1Ky/Zx76Jk0iCzk7KiTS9RSEwOlF+kChuknsCpsQx58BLUbTh1EsTtvPU3rnh0oy4YeLNxAtde70EnL3b+M+p55bQwDQlZFc+wa7YBzDQzLM461usX9SJk55uZueeht3hFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDrnWbfw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDrnWbfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47D71F000E9;
	Fri,  7 Aug 2026 15:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116303;
	bh=fR/pFkjDpW/L/dUa5+AfSnr8x6hNYmpvotLMcJ8gxls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDrnWbfwxp3xdXVfDlOw/sK4i0ggYSuO8p/IiK0oBHGVmK7RsHyUQGS98J7Wp9CuK
	 AyziUf0gZVBZBzpnI4fQKsLE0VaCHRGtSG7pM2DzApTtiFa5b/HObqEgcDmQUHY8LZ
	 xDMAs+AFtVJn+dxaf1k4HRRcwatFqobFkYoK2xkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Pavel Pisa <pisa@fel.cvut.cz>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 184/261] can: ctucanfd: unmap BAR0 using base address
Date: Fri,  7 Aug 2026 16:39:01 +0200
Message-ID: <20260807143419.333473094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


