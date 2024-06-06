Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904E3199386;
	Thu,  6 Jun 2024 14:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683213; cv=none; b=O1xfUi8rXs7zUXvFRC+Jktu1oVUhCfAcWOZBlZVXLYZ8n4vY5qETqOmT4CqpzIkAV1SASbKopipWgKH1eQ3JcQ0OyONahqWmJL01NetZ7ZP1d2HfGgihpsHco8CIFFLHuzncq95fIhHvJjZEeFJ+5V6z5ymqKWqpOaPd6SKjm88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683213; c=relaxed/simple;
	bh=lUetS9aPcw0Lo/PcYI7E2cnu5l9TpvvUSxOPFk7+jcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6A6mSQJnd3d4UWhU5JUA104Xky0GTdYWllQDnxVXYn1sHtmZ7gXZ8PN7XHLeQNVVBxDHXatQLrvyJF9gBdFLOemGv9179jeGF6wBVON5Prbcdg/+99u94v5ulw42XH0ATBV5wndOofQOFXksZIX191WWZcIc95SRDsTdVTS0F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+Rc+VSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+Rc+VSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5D5C2BD10;
	Thu,  6 Jun 2024 14:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683213;
	bh=lUetS9aPcw0Lo/PcYI7E2cnu5l9TpvvUSxOPFk7+jcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+Rc+VSOVJelgsanUvj443OE5c159hR+HDtL4260xYQ9PhSe7OC1F7n6rGs2YXUmX
	 cIgZJVWXBdnUBS1jt/m/DNgVIQoIAB5aPqwzslnz/KzLrzV1kyzx8jw9xdW9MPW3D1
	 FVCOZNSudmJSM+FIREu0I5NoNzC+AvqmpWiiold4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/744] scsi: ufs: core: Perform read back after disabling interrupts
Date: Thu,  6 Jun 2024 15:57:08 +0200
Message-ID: <20240606131737.424026055@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit e4a628877119bd40164a651d20321247b6f94a8b ]

Currently, interrupts are cleared and disabled prior to registering the
interrupt. An mb() is used to complete the clear/disable writes before the
interrupt is registered.

mb() ensures that the write completes, but completion doesn't mean that it
isn't stored in a buffer somewhere. The recommendation for ensuring these
bits have taken effect on the device is to perform a read back to force it
to make it all the way to the device. This is documented in device-io.rst
and a talk by Will Deacon on this can be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure these bits hit the device. Because the mb()'s
purpose wasn't to add extra ordering (on top of the ordering guaranteed by
writel()/readl()), it can safely be removed.

Fixes: 199ef13cac7d ("scsi: ufs: avoid spurious UFS host controller interrupts")
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20240329-ufs-reset-ensure-effect-before-delay-v5-8-181252004586@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index cd1b9db8543dc..2371b00c56be9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10369,7 +10369,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	 * Make sure that UFS interrupts are disabled and any pending interrupt
 	 * status is cleared before registering UFS interrupt handler.
 	 */
-	mb();
+	ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 
 	/* IRQ registration */
 	err = devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
-- 
2.43.0



