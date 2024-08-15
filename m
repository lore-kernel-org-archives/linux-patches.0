Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEA01A7060;
	Thu, 15 Aug 2024 14:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732985; cv=none; b=i1jZWRyKZ66tLWgAY3L55yuJP49uoayM1l1zJVuyfX0f9mLtK0cWT8AEp7TNMaN+iKrYeJwp44P3OcwihYzu+VnrB34HiZrMBnv5kSFDJ2fXIovGaHmlxgEY9qyzyeleBOl1YjEqBopCd3wU2zocQ5NYchmX7W8+kq01R5MLEPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732985; c=relaxed/simple;
	bh=CmsCnkz3N1cTiMe3T30l8Lf7t+Wj6ak8j8baqd2Hsfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOgkUa08hhb18gm+gixcqv03ZBc2uF4jhvE3ZRMC8fa5F3BoQg+Ln07uqU2OZITVM2ZOr62b3WqzhfxIFAo1ZOBtHRADys5U0UHUcoHdC99l1X9fR3Z5chBoOa/NlIcTqGYn09fZA54kb/P7MM4+pTiT1tmswi9VZdjqwXEeNNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9VXpiY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9VXpiY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C35C4AF0D;
	Thu, 15 Aug 2024 14:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732985;
	bh=CmsCnkz3N1cTiMe3T30l8Lf7t+Wj6ak8j8baqd2Hsfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9VXpiY+2U6Y+cUhtebDYwgkcvSdM0KNFh9nnW02HbG9DEedneN5VMPibw2Alrj1/
	 J6gEkHXzSfbKFxkq5ukGM1XqwQFTzW2DFuROp2xjg8gaIzOd6IGNLWhfDlmYuswNod
	 mAWlE4/dvTGx/l2HgE4bRs3IzsFABz/IVULRGtHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 319/352] irqchip/xilinx: Fix shift out of bounds
Date: Thu, 15 Aug 2024 15:26:25 +0200
Message-ID: <20240815131931.785564104@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

commit d73f0f49daa84176c3beee1606e73c7ffb6af8b2 upstream.

The device tree property 'xlnx,kind-of-intr' is sanity checked that the
bitmask contains only set bits which are in the range of the number of
interrupts supported by the controller.

The check is done by shifting the mask right by the number of supported
interrupts and checking the result for zero.

The data type of the mask is u32 and the number of supported interrupts is
up to 32. In case of 32 interrupts the shift is out of bounds, resulting in
a mismatch warning. The out of bounds condition is also reported by UBSAN:

  UBSAN: shift-out-of-bounds in irq-xilinx-intc.c:332:22
  shift exponent 32 is too large for 32-bit type 'unsigned int'

Fix it by promoting the mask to u64 for the test.

Fixes: d50466c90724 ("microblaze: intc: Refactor DT sanity check")
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/1723186944-3571957-1-git-send-email-radhey.shyam.pandey@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-xilinx-intc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-xilinx-intc.c
+++ b/drivers/irqchip/irq-xilinx-intc.c
@@ -201,7 +201,7 @@ static int __init xilinx_intc_of_init(st
 		irqc->intr_mask = 0;
 	}
 
-	if (irqc->intr_mask >> irqc->nr_irq)
+	if ((u64)irqc->intr_mask >> irqc->nr_irq)
 		pr_warn("irq-xilinx: mismatch in kind-of-intr param\n");
 
 	pr_info("irq-xilinx: %pOF: num_irq=%d, edge=0x%x\n",


