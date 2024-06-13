Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F96387;
	Thu, 13 Jun 2024 12:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281810; cv=none; b=BKeNP4HCWITz/jq5S2AoQUma2dxGkm41INox+wqhjHe74wkVSrcX2CiPc/UM7IoLty+U2/VogWEu5gDjZWfPTaZZsRjDksWqrEOvMVBsM2omczy6S5WdEcVliXl7lp6krEPYFfkIWrEX8tJ/vYRf+3PVVHSLiRnXsjAGbGMwFwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281810; c=relaxed/simple;
	bh=OHYeKGHF5DkyET55PLb7whaUjOQPPS8EGLFzc+w9wms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qhtg4COi8D9BmYd2hETjTAzpgAfpAxHjjXL6D305NNopNEwA48P/kg3E8E75Wg7bAPSdW+bdoWIF24/um6RbcF5O+evxVnOCD98VVkgz6FlF6aCt9nSELXNovcnZXh0vSEKB3a1r5F9I5mR2Fur2CrT2XP0yfijo281ykDaSEWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PS/Egfep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PS/Egfep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0BCC2BBFC;
	Thu, 13 Jun 2024 12:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281810;
	bh=OHYeKGHF5DkyET55PLb7whaUjOQPPS8EGLFzc+w9wms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PS/Egfep9SLFAbgFyqaBLgm7P2Ii1Qa5NXG/qBbXV9iXLxdEhd/n6Oc1NkmFBx/AX
	 oUlBIRTtsaLG+7QhJjzkcGS9W9YHB2dLs4i4Xl3CbJFO+Rph1bN0fa92LTsIrvfunL
	 MzErlczlVCJcbnybczF26VK6Q20SUmNQEf+mX560=
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
Subject: [PATCH 5.15 064/402] scsi: ufs: core: Perform read back after disabling interrupts
Date: Thu, 13 Jun 2024 13:30:21 +0200
Message-ID: <20240613113304.634127017@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 03b33c34f7024..1b8fdeb053529 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9500,7 +9500,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	 * Make sure that UFS interrupts are disabled and any pending interrupt
 	 * status is cleared before registering UFS interrupt handler.
 	 */
-	mb();
+	ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 
 	/* IRQ registration */
 	err = devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
-- 
2.43.0



