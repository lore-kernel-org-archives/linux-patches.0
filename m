Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215080;
	b=gJ27buzBA5X0rnwF1zwNJP/lHAAhDhMqOsudSFj6yQCki/iejzppy/j4XciQkxGRbS52
	 ao+4XWEQoHEqZciimCXXYCOXmDk8ZR9D91yzTk9lQ+Rogev1lq4gKqCEov1Jccd7/cui+
	 9lcv/Q9KNDlMaI3saegjvfOBAGMVvCqRZqxySyoS4Mc1AVuNLSTNJrMKPucP6ii9bKuuy
	 sO9e8KGdAQ9k29x7Sql5fxrKUpCwVigTgEm7cOJahVFxuFd0GGjgFJfKN/DAGroVA3J8Y
	 6mLafLGt8njxRNVTWTildA+tlvfGcU4crc5WxLSpDKjSqS36005XD5o9CeViYTNbwPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/KOyYB4a3dp8RIEG9XbkONwq0RFunvZRIP+00KejeYE=;
	b=vkOCLJgJfWJG54ajVjdq10ToKDk9mxhAxyZHbYRxyqvs3oRh3eYozFOFkiI8NW51GL60
	 xklgue0CI4/1q6GmIYAJB0pcizj4QMK3cLwCWtEjf7+PYtHommv4n/GP3wT+JrUNEnX3E
	 NYYCvNRPvbVCA1QwvXe44RfEZ+gJv/99i0s8UJDC4thohJ8bXkiNiZ661/LRAF02z/+iM
	 cw+nz5+L5KvpA/Aodroe1ltnnKgdOG//Y53voxIYo+hwrZ9Z83gHS6PNjB63sNWavJYoZ
	 xzHhCAz1Rm8gByI0nURtplxwh4ZahdEuQ3we8Fpqi5l5hW0touWB6Bj3yYihZNYbIEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CSS65B+V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297E2606A31A;
	Wed, 28 Oct 2026 19:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CSS65B+V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448FD1F01825;
	Wed, 28 Oct 2026 19:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215079;
	bh=/KOyYB4a3dp8RIEG9XbkONwq0RFunvZRIP+00KejeYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSS65B+VjQV+leq8Xz+n95IH9BsUZxjRUMJGJTIhzo/hShGU/aCARwVKrdWYiC6qy
	 XBMkO7cvFGNVhQCY5i04DhJCR72CmqwBeSDzxFA+DFMmy6Ujov77lkYVWXUZBSPQ9F
	 PKFzxAnPQ/mybzmww3836UAcSbtaCMjKubHvi530=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1083/1887] iommu/amd: Fix clone_alias() to use the original devices devid
Date: Wed, 28 Oct 2026 17:52:59 +0100
Message-ID: <20261028170524.050715786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit faad224fe0f0857a04ff2eb3c90f0de57f47d0f3 ]

Currently clone_alias() assumes first argument (pdev) is always the
original device pointer. This function is called by
pci_for_each_dma_alias() which based on topology decides to send
original or alias device details in first argument.

This meant that the source devid used to look up and copy the DTE
may be incorrect, leading to wrong or stale DTE entries being
propagated to alias device.

Fix this by passing the original pdev as the opaque data argument to
both the direct clone_alias() call and pci_for_each_dma_alias(). Inside
clone_alias(), retrieve the original device from data and compute devid
from it.

Fixes: 3332364e4ebc ("iommu/amd: Support multiple PCI DMA aliases in device table")
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 79833cc4a524a..07d9d2f09417a 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -217,10 +217,11 @@ static struct iommu_dev_data *search_dev_data(struct amd_iommu *iommu, u16 devid
 	return NULL;
 }
 
-static int clone_alias(struct pci_dev *pdev, u16 alias, void *data)
+static int clone_alias(struct pci_dev *pdev_origin, u16 alias, void *data)
 {
 	struct amd_iommu *iommu;
 	struct dev_table_entry *dev_table;
+	struct pci_dev *pdev = data;
 	u16 devid = pci_dev_id(pdev);
 
 	if (devid == alias)
@@ -252,9 +253,9 @@ static void clone_aliases(struct amd_iommu *iommu, struct device *dev)
 	 * part of the PCI DMA aliases if it's bus differs
 	 * from the original device.
 	 */
-	clone_alias(pdev, iommu->pci_seg->alias_table[pci_dev_id(pdev)], NULL);
+	clone_alias(pdev, iommu->pci_seg->alias_table[pci_dev_id(pdev)], pdev);
 
-	pci_for_each_dma_alias(pdev, clone_alias, NULL);
+	pci_for_each_dma_alias(pdev, clone_alias, pdev);
 }
 
 static void setup_aliases(struct amd_iommu *iommu, struct device *dev)
-- 
2.53.0



