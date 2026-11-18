Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049383;
	b=qfIJtKoZBQ/uFgeKr7U5+N/w3dCOqIQzsmXFY2P7cJuF56qKJbHcZo9IAopNG4A7hPZy
	 2mlIYTwQlm3ajTalMKTzFChUJa9w5+V0BEwYq8LT8KgRJStuMfD7TagJ0lSu6pjtfx5MK
	 eXJG/dzoFKkjWCsZi7HsK34dk7eO6frzZ+7d9yLtOU+6fgpbxSCDb+92fcKBojCZ8bwEU
	 9tRT1WzBuDRBfdLRzKa6YUSDdEehvdv1PeI+RHtCdk+bxZtGht0KB7Q7Hrh7rQx3bBm4i
	 o1Z+4o+d1FTTyQM4teD8uX0k9kDyOuSN79hwi/jvy8uo2SthlHppRQPyRiJqtbvomGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=st7QPHAVJ2uWwy2F2o5hlSpJqZ0f6oowJ/AvgiPdb7A=;
	b=4n5Wu6Zzz33U5pg8ucojhvZ2G3FQBgMXWVbDeKPppkQoFzeDM1A27u2x73fYxJ2oJrW3
	 P3tXASJWnx8e6zkaD3JwslwjBXKlPZjPU09u/OdG4b/Uapl3RKT1pXh7XNmU0ohMVHvyL
	 W+nyy0UwuxlZIMDU2R5T/5s7rUZib8pJUztT88EIALW34UjvNkrQ5MZ5MLsvtIf8MDJs9
	 jJzuBFw2MKa5GaacF9bqSuWprBT13/ILKUXcUWJy0Nxv1wgpgV2zCl3udk4O8AeseGZok
	 T3WnfIS4vCV5rmIfkI10DWvTEFjHJD0/pSGSx2GyIRiNJZfnCb3BUS/8TlZg+pPpw+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=03BWQ7+y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDDC606A31C;
	Thu, 19 Nov 2026 00:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=03BWQ7+y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08271F000C4;
	Thu, 19 Nov 2026 00:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049383;
	bh=st7QPHAVJ2uWwy2F2o5hlSpJqZ0f6oowJ/AvgiPdb7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=03BWQ7+ymjtwH7ls7W9ZvAvwewcvOBfGn9+MUnyN0+nKJwh0lChieW4UYTXC/x7hX
	 eIn9biQzdBpclCdZETHTy/92e7dndPAFaO7zs60ehltz2vPimFZ4XgN2boKSw/tvQe
	 FuHmSx/mVIEJm/Jnj6D9+EghunL6PsoKtBbwVzwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2333/2857] xen/pcifront: Fix PCI device reference leak in AER handling
Date: Wed, 18 Nov 2026 15:56:07 +0100
Message-ID: <20261118150325.538557481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 5d12c51bd98cdb5a32cbfb606963b05740ec42f2 ]

pci_get_domain_bus_and_slot() increments the reference count of the
returned PCI device. pcifront_common_process() drops that reference only
when the device or its driver is missing. All paths for a bound device
either return directly after invoking an error recovery callback or fall
through without calling pci_dev_put(). Consequently, each AER request for
a bound device leaks a reference and can keep the device allocated after
removal.

Declare the looked-up device with __free(pci_dev_put), so every return
path releases the reference after callback dispatch. This keeps the
device alive while its callback runs and balances the lookup without
restructuring the callback returns.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: 956a9202cd12 ("xen-pcifront: Xen PCI frontend driver.")
Suggested-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/20260813153138.3953222-1-ruoyuw560@gmail.com/
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260820135603.3901798-1-ruoyuw560@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/xen-pcifront.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 2c289b89cb8a2..7ff83b5f78425 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -580,16 +580,15 @@ static pci_ers_result_t pcifront_common_process(int cmd,
 	int bus = pdev->sh_info->aer_op.bus;
 	int devfn = pdev->sh_info->aer_op.devfn;
 	int domain = pdev->sh_info->aer_op.domain;
-	struct pci_dev *pcidev;
+	struct pci_dev *pcidev __free(pci_dev_put) =
+		pci_get_domain_bus_and_slot(domain, bus, devfn);
 
 	dev_dbg(&pdev->xdev->dev,
 		"pcifront AER process: cmd %x (bus:%x, devfn%x)",
 		cmd, bus, devfn);
 
-	pcidev = pci_get_domain_bus_and_slot(domain, bus, devfn);
 	if (!pcidev || !pcidev->dev.driver) {
 		dev_err(&pdev->xdev->dev, "device or AER driver is NULL\n");
-		pci_dev_put(pcidev);
 		return PCI_ERS_RESULT_NONE;
 	}
 	pdrv = to_pci_driver(pcidev->dev.driver);
-- 
2.53.0



