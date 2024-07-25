Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9549B19D08C;
	Thu, 25 Jul 2024 14:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918585; cv=none; b=dxpM2G9v7VtEcS3hFOKyMZsfMiGOXBzI/aqSSN5lEJkwgloHXtepQxiSfUhxPjghKLLP6U8RcIe1vJvk1PIQyMz4lMW5KhCggcEeyq8sE3tUFflNI28KlaBjB2t+GrWDEmDZ3FIsNqNu1uf/+9UudgPN8+qUQARP7Hp+kG5m8Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918585; c=relaxed/simple;
	bh=h+u/cLSwTkBQaq97ovpfMAQ7iXN5/iUZ5bITaHrJV0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsIEOwf1UcMzSY1O9intyo0fbGeS8UO6XRs9oUoUuRSCjY1tXAIuPfAMByFmBobSEUKIUYEke7naLgCUhi9rtKYGUQKh7IB84Bb46GQh0drXQYDR4QWOmG+ODITQvqoBA2F95j7GJffpP/0BfSx011dYSawqMfI+vY5i2dBMJbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vy+e2gol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vy+e2gol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FE3C116B1;
	Thu, 25 Jul 2024 14:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918585;
	bh=h+u/cLSwTkBQaq97ovpfMAQ7iXN5/iUZ5bITaHrJV0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vy+e2golWpPpqcqda0oPi2qIkWADmFSZLGCzJE6cOrqOHslBUV3rJO466CQFMkYFc
	 HzD7NZdZdS5Gvh4R7XReyYx5d+pWaD+JZRgL3h0OFExb21nyaXFzC7eN1hCY70yXV3
	 v0HSqZpcO3D4P+gWZpnvIforwkatsLjvT9DZ5eqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ganesh Goudar <ganeshgr@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/43] powerpc/eeh: avoid possible crash when edev->pdev changes
Date: Thu, 25 Jul 2024 16:36:52 +0200
Message-ID: <20240725142731.572772992@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ganesh Goudar <ganeshgr@linux.ibm.com>

[ Upstream commit a1216e62d039bf63a539bbe718536ec789a853dd ]

If a PCI device is removed during eeh_pe_report_edev(), edev->pdev
will change and can cause a crash, hold the PCI rescan/remove lock
while taking a copy of edev->pdev->bus.

Signed-off-by: Ganesh Goudar <ganeshgr@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240617140240.580453-1-ganeshgr@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh_pe.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/eeh_pe.c b/arch/powerpc/kernel/eeh_pe.c
index 177852e39a253..4b6b1846e4d23 100644
--- a/arch/powerpc/kernel/eeh_pe.c
+++ b/arch/powerpc/kernel/eeh_pe.c
@@ -922,6 +922,7 @@ struct pci_bus *eeh_pe_bus_get(struct eeh_pe *pe)
 {
 	struct eeh_dev *edev;
 	struct pci_dev *pdev;
+	struct pci_bus *bus = NULL;
 
 	if (pe->type & EEH_PE_PHB)
 		return pe->phb->bus;
@@ -932,9 +933,11 @@ struct pci_bus *eeh_pe_bus_get(struct eeh_pe *pe)
 
 	/* Retrieve the parent PCI bus of first (top) PCI device */
 	edev = list_first_entry_or_null(&pe->edevs, struct eeh_dev, entry);
+	pci_lock_rescan_remove();
 	pdev = eeh_dev_to_pci_dev(edev);
 	if (pdev)
-		return pdev->bus;
+		bus = pdev->bus;
+	pci_unlock_rescan_remove();
 
-	return NULL;
+	return bus;
 }
-- 
2.43.0



