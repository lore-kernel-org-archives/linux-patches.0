Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B86E5227;
	Mon, 30 Jun 2025 21:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317307; cv=none; b=h1gv72HsiLbZxTqkRXV5m/h0yXdrtPNp248nB/F/aqgfjL373xLmE9XyoIWtlgahCUNQqYzqVDXbvUYh36ML1jVipYIMfGvYUpgSsh0R0aWgBHpGS8MJiuZTN9UXii/6jnEu7fZ7Rz7DFC7AZoW9uzLT1Yjludz5hqNVZ1QEpuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317307; c=relaxed/simple;
	bh=SamdNGppUiINvuhSrfUmG2vy1KDD8uY/v/DqHqQec9E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GUBFBfO/j4ZGo9sGUYwNa3Cmi5+vs8UmAC0yWisjYz7ufIZpafDAsIGuQfl4y6LM3gnuINnGxGoUwD1xcvRHmdd0nHTH9Y+f+PiM6kRTnmOBvgG0kV+mt099cppGkERlIPZZeEupBfWhteIQaSWso+BwW5Vd7DBFNAtm3fxiP+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=patlZlJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="patlZlJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B03C4CEE3;
	Mon, 30 Jun 2025 21:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317307;
	bh=SamdNGppUiINvuhSrfUmG2vy1KDD8uY/v/DqHqQec9E=;
	h=From:To:Cc:Subject:Date:From;
	b=patlZlJt4Scd1PLMBxJSv2VMfIpQ7L65da7dtDsNcp9MyvIsc4M1EOtC1vIfS0huW
	 nfa36j/tnxxjXitlAZzFcVOBHfnExGvqE4XSI3EY9dWvvSzeXEgax+nZMJLOq3KHPw
	 /rOzUBFeLD12hQkUF/4LlmUuPCsKbosQbMMCAcRzAcIisroWRlkYCOkKKeow3s98LO
	 ZHccNeXF+iSxK+CsIKlBBTkXzm2CPPvoYxXzfcnKlrWUo9xemKxGyofqfGBuFtq/Vp
	 utMt7doCuUyJmjkh4dtAgg4waZOa4DA1LaU8PwIDXZNHyA43GU+F8cHFBkYHnUqGut
	 pBNF+XZJeFmSA==
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
Subject: [PATCH AUTOSEL 5.15 1/7] atm: idt77252: Add missing `dma_map_error()`
Date: Mon, 30 Jun 2025 17:01:38 -0400
Message-Id: <20250630210144.1359448-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.186
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
index 7810f974b2ca9..d9ee20f0048fe 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -852,6 +852,8 @@ queue_skb(struct idt77252_dev *card, struct vc_map *vc,
 
 	IDT77252_PRV_PADDR(skb) = dma_map_single(&card->pcidev->dev, skb->data,
 						 skb->len, DMA_TO_DEVICE);
+	if (dma_mapping_error(&card->pcidev->dev, IDT77252_PRV_PADDR(skb)))
+		return -ENOMEM;
 
 	error = -EINVAL;
 
@@ -1857,6 +1859,8 @@ add_rx_skb(struct idt77252_dev *card, int queue,
 		paddr = dma_map_single(&card->pcidev->dev, skb->data,
 				       skb_end_pointer(skb) - skb->data,
 				       DMA_FROM_DEVICE);
+		if (dma_mapping_error(&card->pcidev->dev, paddr))
+			goto outpoolrm;
 		IDT77252_PRV_PADDR(skb) = paddr;
 
 		if (push_rx_skb(card, skb, queue)) {
@@ -1871,6 +1875,7 @@ add_rx_skb(struct idt77252_dev *card, int queue,
 	dma_unmap_single(&card->pcidev->dev, IDT77252_PRV_PADDR(skb),
 			 skb_end_pointer(skb) - skb->data, DMA_FROM_DEVICE);
 
+outpoolrm:
 	handle = IDT77252_PRV_POOL(skb);
 	card->sbpool[POOL_QUEUE(handle)].skb[POOL_INDEX(handle)] = NULL;
 
-- 
2.39.5

