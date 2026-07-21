Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E9546AA71;
	Tue, 21 Jul 2026 15:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648477; cv=none; b=Y1GABJ9Hg0F/wu4yMmDxAFazDwn5/PyEoZYqX9ZLWgMzrLxgMwFzGYuViOa+S/VW4yzmeUyhnUbJgvF3p97/nfSTrTR7ovZAHAaC9OMq7c21sVWtU4fEVcI0e71jLz9/9fFz/jGHUk9tb7Y98Bfef+7HiEooxs8nA+U3s5A8UAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648477; c=relaxed/simple;
	bh=m+8olsdgTPZUmNWgrriVSAOj3T4TxPnvKMN6X9dcUdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbG1yzxObbwu2ORR41VAd4ijijwvJv1d0QW0CuWm0kdmFXyz9oCALzH3iAcNKElGGiQjWWy3ChrfwxsDrL7ezj7SHwwLc/VxZAuYQwlYFJSNM9fQ0Ho4xuSDEoimkyg6Tmet4V0Sk1I8h9jAWqCK9Os6a6PUw44skQndOjYacwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEIz3foo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEIz3foo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2011F00A3A;
	Tue, 21 Jul 2026 15:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648476;
	bh=2z1AdsjXWiDd+HPWljADdCiIaKZkBQwnjwjMhWO4qN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZEIz3fooYAaSVBzV6ECdrRDjPtHjeXAspENREavY5uh+Wn52KYrW8LbfAoezIcAYy
	 /iMBES2d/YsZpKLXQqIrc5gi47nGiHsYuSlTiwDxLuXIjf7IbjMlp+XclLs6+yqa0h
	 nEiJAL9UPMBGVZ8wPuFMat4qwTD4dn+nSrFIpyrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0213/2077] crypto: ccp/sev-dev-tsm - bail out early when pdev->bus is NULL
Date: Tue, 21 Jul 2026 16:58:06 +0200
Message-ID: <20260721152557.706820347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Stepan Ionichev <sozdayvek@gmail.com>

[ Upstream commit 930d9d36ea618a775985446a125aedeb401db522 ]

dsm_create() initially checks pdev->bus when computing segment_id:

	u8 segment_id = pdev->bus ? pci_domain_nr(pdev->bus) : 0;

But the next two lines unconditionally dereference pdev->bus via
pcie_find_root_port() and especially pci_dev_id(pdev), which expands
to PCI_DEVID(dev->bus->number, dev->devfn). If pdev->bus is in fact
NULL, segment_id is initialised to 0 but the very next statement
crashes the kernel.

smatch flags this:

  drivers/crypto/ccp/sev-dev-tsm.c:253 dsm_create() error: we
    previously assumed 'pdev->bus' could be null (see line 251)

Make the NULL handling consistent: if pdev->bus is NULL the device
has no PCI context to work with and SEV TIO setup cannot proceed,
so return -ENODEV before any of the bus-dependent lookups. The
remaining initialisation now runs only on the path where pdev->bus
is known to be valid.

No change for callers where pdev->bus is non-NULL, which is the
only case where dsm_create() did meaningful work before this change.

Fixes: 4be423572da1 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev-tsm.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index b07ae529b5910e..f303d8f55991b5 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -248,12 +248,19 @@ static void dsm_remove(struct pci_tsm *tsm)
 static int dsm_create(struct tio_dsm *dsm)
 {
 	struct pci_dev *pdev = dsm->tsm.base_tsm.pdev;
-	u8 segment_id = pdev->bus ? pci_domain_nr(pdev->bus) : 0;
-	struct pci_dev *rootport = pcie_find_root_port(pdev);
-	u16 device_id = pci_dev_id(pdev);
+	struct pci_dev *rootport;
+	u8 segment_id;
+	u16 device_id;
 	u16 root_port_id;
 	u32 lnkcap = 0;
 
+	if (!pdev->bus)
+		return -ENODEV;
+
+	segment_id = pci_domain_nr(pdev->bus);
+	rootport = pcie_find_root_port(pdev);
+	device_id = pci_dev_id(pdev);
+
 	if (pci_read_config_dword(rootport, pci_pcie_cap(rootport) + PCI_EXP_LNKCAP,
 				  &lnkcap))
 		return -ENODEV;
-- 
2.53.0



