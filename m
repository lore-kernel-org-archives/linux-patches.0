Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AB61EFFA6;
	Mon, 23 Jun 2025 21:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714197; cv=none; b=ciM10xQ4TcX6jmRl6OPYgOjaUTQzNyuV2oMb3JSBrEh3PLB3ZNxF8ZmEQvQc7HA4kHgqQdguY36vPP+Yzgawp4mtLbTL1txs1h2b2nKXgE3tipdEXX1h4Q4Fdv0hB5vWKFxu0mbQqo7z8t7hxB0TPaK8W+sqi2dTNz5E5xHpnpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714197; c=relaxed/simple;
	bh=8PxUgTCD63yTPiqWBLyjUGhdZlILm/p5mzfA1oq2Oic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnUJbNI09Ql4nax2KxqtbbtWSjv75GELuwfjln8MVLptK6YcVqPMSXWUQ/iRWzkwX05ra+xPb+/aCCIAtWeKPqp3o/Kyp6Hy6P/KpeNbV4bpBRjMhSrWexq5oWvkHM9OWq0e1PLMoZ1dxGLq0isVwWT9gWJcY4qpoHKOh/3w/m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1susaDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1susaDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366BCC4CEEA;
	Mon, 23 Jun 2025 21:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714196;
	bh=8PxUgTCD63yTPiqWBLyjUGhdZlILm/p5mzfA1oq2Oic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1susaDNg5dqOTNRDdAaCe/0pYf2YbPSTWaIrTsa9SSfk5NB+sxd+f1/cmWktsf8x
	 B6UyBR9npY2bemcWl23rvMQnpDVMDqtzpf6UF2IEjYnLIY7aVH5j165OkTBTCvRhQg
	 I6WMvaq44Yh09twmiL1wxmzaqfEkNqLK5IfZKMZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.12 108/414] EDAC/altera: Use correct write width with the INTTEST register
Date: Mon, 23 Jun 2025 15:04:05 +0200
Message-ID: <20250623130644.794794308@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>

commit e5ef4cd2a47f27c0c9d8ff6c0f63a18937c071a3 upstream.

On the SoCFPGA platform, the INTTEST register supports only 16-bit writes.
A 32-bit write triggers an SError to the CPU so do 16-bit accesses only.

  [ bp: AI-massage the commit message. ]

Fixes: c7b4be8db8bc ("EDAC, altera: Add Arria10 OCRAM ECC support")
Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
Signed-off-by: Matthew Gerlach <matthew.gerlach@altera.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Cc: stable@kernel.org
Link: https://lore.kernel.org/20250527145707.25458-1-matthew.gerlach@altera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1746,9 +1746,9 @@ altr_edac_a10_device_trig(struct file *f
 
 	local_irq_save(flags);
 	if (trig_type == ALTR_UE_TRIGGER_CHAR)
-		writel(priv->ue_set_mask, set_addr);
+		writew(priv->ue_set_mask, set_addr);
 	else
-		writel(priv->ce_set_mask, set_addr);
+		writew(priv->ce_set_mask, set_addr);
 
 	/* Ensure the interrupt test bits are set */
 	wmb();
@@ -1778,7 +1778,7 @@ altr_edac_a10_device_trig2(struct file *
 
 	local_irq_save(flags);
 	if (trig_type == ALTR_UE_TRIGGER_CHAR) {
-		writel(priv->ue_set_mask, set_addr);
+		writew(priv->ue_set_mask, set_addr);
 	} else {
 		/* Setup read/write of 4 bytes */
 		writel(ECC_WORD_WRITE, drvdata->base + ECC_BLK_DBYTECTRL_OFST);


