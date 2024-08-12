Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8A429CA;
	Mon, 12 Aug 2024 16:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479617; cv=none; b=sepc50O9Y/jEZWIyNr4owsw0Rt+SPzIV7KRYutsAtQNpF2qAd+M/gAkDiNF5vqZ9vP4qFej5GpySW1sL7Q4X9S4VwnjhKb4AhTBo0jT6FZwwJU3eNvz0w+TptVGCnyZHKz3vOWl+20kso6c93TSdCzaeBoE+lzZY4Do4JNqXwrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479617; c=relaxed/simple;
	bh=2S7wqsS9JmoHxdh4D/M+ZfTOAoybPNHqfjveBX1PkAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vmveyn0Ziq09t35il/O0hYhqbLxpHGCvsHsJRca71I+dMDL8w/UFF96fNQGnUMNHB1GK/cAL8qMRArJnM1rwA9c9nUIa+HmdyIjoWIlPvUawCm9nFPTJyNdNANIiiECaj1bz+ZMr49RWw+b6+1A5AVkPaXc5to2O5FFlfzvAla8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1AavnEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1AavnEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0C5C32782;
	Mon, 12 Aug 2024 16:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479617;
	bh=2S7wqsS9JmoHxdh4D/M+ZfTOAoybPNHqfjveBX1PkAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1AavnEhjkZZWCioXIzMikbDln6tS0TZX2kf3wFODF0EHwuIrWOLQGGrGcboZFCOw
	 nID4+LHAEHcsFWQIy/L3nfQMbblaso1Xn9CoIo8Op/KmfQoyXeS3tD/MyvXZhD6PMO
	 5dTbI0lumqgRkUc20uSGVrOWpqTJ+7DR++GD9fnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 142/189] irqchip/xilinx: Fix shift out of bounds
Date: Mon, 12 Aug 2024 18:03:18 +0200
Message-ID: <20240812160137.607716650@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -189,7 +189,7 @@ static int __init xilinx_intc_of_init(st
 		irqc->intr_mask = 0;
 	}
 
-	if (irqc->intr_mask >> irqc->nr_irq)
+	if ((u64)irqc->intr_mask >> irqc->nr_irq)
 		pr_warn("irq-xilinx: mismatch in kind-of-intr param\n");
 
 	pr_info("irq-xilinx: %pOF: num_irq=%d, edge=0x%x\n",


