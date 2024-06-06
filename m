Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4EB199EB5;
	Thu,  6 Jun 2024 14:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683263; cv=none; b=kWX8Rz7POfP3NnfkKkfrEAXEtQGCWsTGqk9JGRe8vIiH0JEJw6hBXPYgKFaskPZBc4T3yZHUCmMR6WPCYi9RWYfuEALhCEpB0WSLMDPey73n1aDdJzuC6NYJz8zYYVqej96W1Ysc4DDL99GnCJc5Q+QrWEGpy3RWAj6pOu6DZvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683263; c=relaxed/simple;
	bh=7gaNmKwFAO5emZ8lUYlajImcZ84miBjaT/sKrV/rGg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfQ0bHg+sfVpdCOAKAvBqXX2UJCxZmeD0u866tVv5lMh20y3iKjD3CB+J42gs+fEw4Vs++pAUfeZsK8Wd7ZIwc7fD2vgnKzCFQtzE6qcdA7Mctzk7Z3gnxCyygmEl4EidsWVT69k2MvfhdtwEA9goU4fBng2z+UNSKrzD/Z0dF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igBtu7VH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igBtu7VH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABA1C32782;
	Thu,  6 Jun 2024 14:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683263;
	bh=7gaNmKwFAO5emZ8lUYlajImcZ84miBjaT/sKrV/rGg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igBtu7VHT1ixwg3KvqEhjAX+pm66riyPoW3hHVoIkvcU0KthHergCQjJ94IbhwIN+
	 7loSJL0MV0lTSAkRFqUSu/44vA86oD/rOu+IgJYqO66i2IOrym/josxx66gWNuOUnp
	 o+JoJ6HkhBnUzdaabLEL8/wnUy+208rGQLgABGeU=
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
Subject: [PATCH 6.1 110/473] scsi: ufs: core: Perform read back after disabling interrupts
Date: Thu,  6 Jun 2024 16:00:39 +0200
Message-ID: <20240606131703.555546737@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 948449a13247c..f54260d7873f1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9817,7 +9817,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	 * Make sure that UFS interrupts are disabled and any pending interrupt
 	 * status is cleared before registering UFS interrupt handler.
 	 */
-	mb();
+	ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 
 	/* IRQ registration */
 	err = devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
-- 
2.43.0



