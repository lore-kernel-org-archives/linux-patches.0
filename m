Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6092629D;
	Mon, 30 Jun 2025 21:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317326; cv=none; b=A6Eud/H5FWYC+igmfQ3BbFhdrD3vAZm4rfDszA+ST3YpPHkccAdIJbvbVF4/eGvJS6N9r881kXqWAk8AX1rbun9Jv9Tb+Zm8sUKY4x9sWLyvOtcYAG8Mwf1dira6Wb9Xrshex/962yszw2x/rvWvxtWGKQTv2sPCS8HEgVGEuhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317326; c=relaxed/simple;
	bh=BygzauRyQcFAE/85y7f6Py8tXm5kRUtUY9HwRTNhWQk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lx9aeAAmBjY4QOKabYofYE2H2EwGD8mSt5rrqhD2Mo/h8EEGK/zt8pNiAc6DlW9x73XbPWMuvZjXO8/QnnplDcUOViaGd4nUtKnF28lePsD+BIyRz8YpVCeIMIBSWrqe+yWso7+096SMaz4Oe4VcsUiohKLhQx0iOD+Ch9KLKg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gB+frJU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gB+frJU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09332C4CEE3;
	Mon, 30 Jun 2025 21:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317326;
	bh=BygzauRyQcFAE/85y7f6Py8tXm5kRUtUY9HwRTNhWQk=;
	h=From:To:Cc:Subject:Date:From;
	b=gB+frJU0SBdeQOeI1ABAVxN39b3BpD4TQYIMd4B7Ci1bekDyj4u5KawxqXlTllNaS
	 6aXpdyCk/E+bldLPYBvzhUKzokGYfGPeii1OwN53/Ypod5zs1PDnJVRx+K9IMckWcy
	 eMXO+LbIfZMW5y08ha2hF3WH351hb1+ZUuwS+qsnUwB8Dw3TG52oy6HL1EmovL5CTU
	 DsbXC8C6z073z3JKmraXC1ZcitN3TQGr5nJm/JieEy/EPZS34QrkjsfsDJOA+7iM49
	 5ePRguG0M5j1W4GthlGTqrppc0zblHElq42fRRNPzVObYvxLGkNQfmsNS9xPv5/PS3
	 9DN5hoszXWqAg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	3chas3@gmail.com,
	linux-atm-general@lists.sourceforge.net,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 1/6] atm: idt77252: Add missing `dma_map_error()`
Date: Mon, 30 Jun 2025 17:01:58 -0400
Message-Id: <20250630210203.1359628-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.239
Content-Transfer-Encoding: 8bit

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit c4890963350dcf4e9a909bae23665921fba4ad27 ]

The DMA map functions can fail and should be tested for errors.

Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250624064148.12815-3-fourier.thomas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees.

## Detailed Analysis:

**Nature of the fix:**
The commit adds missing error checking for `dma_map_single()` calls in
two locations within the idt77252 ATM driver:

1. **In `queue_skb()` function (line 853-854):**
  ```c
  IDT77252_PRV_PADDR(skb) = dma_map_single(&card->pcidev->dev,
  skb->data,
  skb->len, DMA_TO_DEVICE);
  +if (dma_mapping_error(&card->pcidev->dev, IDT77252_PRV_PADDR(skb)))
  +    return -ENOMEM;
  ```
  This correctly returns -ENOMEM before reaching the errout label,
  avoiding any cleanup issues since the DMA mapping never succeeded.

2. **In `add_rx_skb()` function (line 1857-1860):**
  ```c
  paddr = dma_map_single(&card->pcidev->dev, skb->data,
  skb_end_pointer(skb) - skb->data,
  DMA_FROM_DEVICE);
  +if (dma_mapping_error(&card->pcidev->dev, paddr))
  +    goto outpoolrm;
  ```
  This properly jumps to the new `outpoolrm` label which removes the SKB
  from the pool before freeing it, maintaining correct cleanup order.

**Why this qualifies for stable backporting:**

1. **Fixes a real bug**: Missing DMA mapping error checks can cause
   system crashes or data corruption, especially on systems with IOMMU
   or SWIOTLB where DMA mapping failures are more likely.

2. **Simple and contained**: The fix adds only 5 lines of error checking
   code with no architectural changes.

3. **Similar to approved backports**: This follows the exact same
   pattern as Similar Commits #1 (eni driver) and #2 (aic94xx driver)
   which were both marked "YES" for backporting.

4. **Long-standing issue**: The driver has existed since at least 2005
   (Linux 2.6.12-rc2), meaning this bug has been present for nearly 20
   years.

5. **Minimal regression risk**: The changes only add error checking;
   they don't modify any existing logic paths.

6. **Proper error handling**: Both error paths are correctly implemented
   with appropriate cleanup sequences.

The commit clearly meets all stable tree criteria as an important bug
fix with minimal risk and should be backported to protect users from
potential DMA-related crashes.

 drivers/atm/idt77252.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 25fd73fafb371..89b0ed8e51430 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -852,6 +852,8 @@ queue_skb(struct idt77252_dev *card, struct vc_map *vc,
 
 	IDT77252_PRV_PADDR(skb) = dma_map_single(&card->pcidev->dev, skb->data,
 						 skb->len, DMA_TO_DEVICE);
+	if (dma_mapping_error(&card->pcidev->dev, IDT77252_PRV_PADDR(skb)))
+		return -ENOMEM;
 
 	error = -EINVAL;
 
@@ -1863,6 +1865,8 @@ add_rx_skb(struct idt77252_dev *card, int queue,
 		paddr = dma_map_single(&card->pcidev->dev, skb->data,
 				       skb_end_pointer(skb) - skb->data,
 				       DMA_FROM_DEVICE);
+		if (dma_mapping_error(&card->pcidev->dev, paddr))
+			goto outpoolrm;
 		IDT77252_PRV_PADDR(skb) = paddr;
 
 		if (push_rx_skb(card, skb, queue)) {
@@ -1877,6 +1881,7 @@ add_rx_skb(struct idt77252_dev *card, int queue,
 	dma_unmap_single(&card->pcidev->dev, IDT77252_PRV_PADDR(skb),
 			 skb_end_pointer(skb) - skb->data, DMA_FROM_DEVICE);
 
+outpoolrm:
 	handle = IDT77252_PRV_POOL(skb);
 	card->sbpool[POOL_QUEUE(handle)].skb[POOL_INDEX(handle)] = NULL;
 
-- 
2.39.5

