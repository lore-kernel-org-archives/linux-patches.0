Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285B08801;
	Tue, 30 Apr 2024 11:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475594; cv=none; b=TXHX3G3vY/+U/93+V0u46ctgigTrsS5S2WMCfXJgb7hzrf1xet05W4KXobPe6xoM9mGap6ApwZBt6iMXTcm/MUqlk0VvTwt6yqUXdU793HBhbiOm61QbbVl0+hCVaL5dq8uiqvXti3DETps33TNp0MUI+OFghQCX3efa17bbwaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475594; c=relaxed/simple;
	bh=4Dm8+4qJZ3jTxmAeVM0tTcaoHfvLUtUz+Dtohh1PH7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrcYZChiAYXj/YMxs4VcDyyzt+wZEC+iFWtZzQ1oamfcBRA5Q80kNT52M2BtnMBgn6x+UqRE9kY8eRhPHNdNrnLUDVRsuotBlcqpIOJt10LkE3GwKHvXciwaqgH6aGTwvKuYt0SbXdHykKSlxeH39JDE+Z/Xj85lhPwZDAi2cAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0vGu3+wT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0vGu3+wT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB51C2BBFC;
	Tue, 30 Apr 2024 11:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475594;
	bh=4Dm8+4qJZ3jTxmAeVM0tTcaoHfvLUtUz+Dtohh1PH7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0vGu3+wTKs4PW/LNmS2yMRjhkyxBnpgDEGpRvNTmwj19rPzhcx6EQPmsfD7a45+sn
	 HnQALix5y5O43h17+hHKrF6oVlSLp3ImdDarJsVcjbNJjW/nXe7Fh193SJoB8PBvY7
	 zKMZ3aoI3hR0PtIn0je7gXvU4pdZopoEUwYT6gXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanrui Huang <guanrui.huang@linux.alibaba.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 6.6 144/186] irqchip/gic-v3-its: Prevent double free on error
Date: Tue, 30 Apr 2024 12:39:56 +0200
Message-ID: <20240430103102.212953553@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: Guanrui Huang <guanrui.huang@linux.alibaba.com>

commit c26591afd33adce296c022e3480dea4282b7ef91 upstream.

The error handling path in its_vpe_irq_domain_alloc() causes a double free
when its_vpe_init() fails after successfully allocating at least one
interrupt. This happens because its_vpe_irq_domain_free() frees the
interrupts along with the area bitmap and the vprop_page and
its_vpe_irq_domain_alloc() subsequently frees the area bitmap and the
vprop_page again.

Fix this by unconditionally invoking its_vpe_irq_domain_free() which
handles all cases correctly and by removing the bitmap/vprop_page freeing
from its_vpe_irq_domain_alloc().

[ tglx: Massaged change log ]

Fixes: 7d75bbb4bc1a ("irqchip/gic-v3-its: Add VPE irq domain allocation/teardown")
Signed-off-by: Guanrui Huang <guanrui.huang@linux.alibaba.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240418061053.96803-2-guanrui.huang@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4561,13 +4561,8 @@ static int its_vpe_irq_domain_alloc(stru
 		irqd_set_resend_when_in_progress(irq_get_irq_data(virq + i));
 	}
 
-	if (err) {
-		if (i > 0)
-			its_vpe_irq_domain_free(domain, virq, i);
-
-		its_lpi_free(bitmap, base, nr_ids);
-		its_free_prop_table(vprop_page);
-	}
+	if (err)
+		its_vpe_irq_domain_free(domain, virq, i);
 
 	return err;
 }


