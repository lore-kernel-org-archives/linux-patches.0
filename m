Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8451A7076;
	Thu, 15 Aug 2024 14:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730537; cv=none; b=lwNeKEg8a8LDrXH6QHXszP4l2MWXFMgmIRKUC5Sygoyb/mixI3pYbtX4EYwl39D3aS80QvxdkodHMb9dU+nmPAXBxTsaoCHkGQhHB7osTPtrHJDxGquUUqKgCG8o4mDvqrdfnj/qxAbRfMRj3SOxNDRlDrz98Sck9EDHBq/9Upg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730537; c=relaxed/simple;
	bh=Vgmhrf3GQiynlVqTAR+E+IoV9sU5hSoMnaTQr9Vq8H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+qBO/+3fs2yQStoLs47f0YMr0o5i5ULvzMa559Jj/SBUx/5FNjyCEnr6NjeTmoKOtdPehN18qPK8Ohq67uZ/XEfw3W1XA+DJ6ZrsBVrSdMt1qah290zFd4UEFzHQpnyHfn8JfXSne80S7OWw04adMpjT7Wpp0+czcKIigEbO68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvpuA2NU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvpuA2NU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C19EC4AF0A;
	Thu, 15 Aug 2024 14:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730537;
	bh=Vgmhrf3GQiynlVqTAR+E+IoV9sU5hSoMnaTQr9Vq8H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvpuA2NUXtkx57J2kuhR4D4vB3BivH6oE5Feurgt0uUiOGFtFhQ9xQqr4aRYsee1N
	 WQ9zHrQ9WJSasdN5T1CbWVRG7EDad33FKutWesA5j2Cm9U4j1zDhtctDm8gIPm27LN
	 39LJpP80K72Wc67eGJ5cl4xxIgX1NnSaBycXniP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 440/484] irqchip/xilinx: Fix shift out of bounds
Date: Thu, 15 Aug 2024 15:24:58 +0200
Message-ID: <20240815131958.454179329@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -188,7 +188,7 @@ static int __init xilinx_intc_of_init(st
 		irqc->intr_mask = 0;
 	}
 
-	if (irqc->intr_mask >> irqc->nr_irq)
+	if ((u64)irqc->intr_mask >> irqc->nr_irq)
 		pr_warn("irq-xilinx: mismatch in kind-of-intr param\n");
 
 	pr_info("irq-xilinx: %pOF: num_irq=%d, edge=0x%x\n",


