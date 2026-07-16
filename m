Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116712FDC53;
	Thu, 16 Jul 2026 14:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211358; cv=none; b=hIahRgTMoYD7K47vLl8PnYYn2dDQgbT8TIMwlXMCRdUkQtwZ81pzU/0UWAEcVr9Ymg30yr9q1uo1k0i5e9sMC4BAv99lKg9Ba8Z4XplJ6hCw0vybGgKAtbkMsHrlBxCjqwvuXgsDzJR25nFIQKc+Gc3pqPrG2eOckEDtbJceI8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211358; c=relaxed/simple;
	bh=XrgWso5JjmFBCKzcJxqoEB5Q6Co+yTuM9Un3OBI0RP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NENlS5EqT40Qx/vUdjzSjX2RXnOiFyrQxeUMfto8gINsL+COQeHk3BvTc7seFE8JF+RuMFddncI/nzTDy86OKU8qBy6R9Eqtc9d2CXlGSyMjXdEiKhF4flZeuO9MEY36+StE1mBRedxWATu5C7HmbWnViuCxBHjx18+ORaObeXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iJHNm8+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iJHNm8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759A31F00A3E;
	Thu, 16 Jul 2026 14:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211357;
	bh=cHWujoV1YDkv04GiwjpsMgxHZspYluJzO920uwLp8ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2iJHNm8+6GJNmVS3xOkmjtwzwcGUl2E3MqdS1KSvDiatFaRRtKWgO9VIDKkYAd/+l
	 eJOvzyToWStdF6fT9nm5VOSsATCRewDdD7W2ackVvGX+wdY6Chl71RoOcUGhei9mV4
	 sBppFhVc4R0a9swBXKe/1jVZthlP2Xz2K68YOULs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.18 397/480] NTB: epf: Fix request_irq() unwind in ntb_epf_init_isr()
Date: Thu, 16 Jul 2026 15:32:24 +0200
Message-ID: <20260716133053.391500224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit fcba26efe5efc7441f5505f4ccc69791214b40be upstream.

ntb_epf_init_isr() requests multiple MSI/MSI-X vectors in a loop. If
request_irq() fails part-way through, it jumps straight to
pci_free_irq_vectors() without freeing already requested IRQs.

Fix the error path by freeing any successfully requested IRQs before
releasing the vectors.

Fixes: 812ce2f8d14e ("NTB: Add support for EPF PCI Non-Transparent Bridge")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Cc: stable@vger.kernel.org # v5.12+
Link: https://patch.msgid.link/20260304083028.1391068-2-den@valinux.co.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/hw/epf/ntb_hw_epf.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/ntb/hw/epf/ntb_hw_epf.c
+++ b/drivers/ntb/hw/epf/ntb_hw_epf.c
@@ -357,7 +357,7 @@ static int ntb_epf_init_isr(struct ntb_e
 				  0, "ntb_epf", ndev);
 		if (ret) {
 			dev_err(dev, "Failed to request irq\n");
-			goto err_request_irq;
+			goto err_free_irq;
 		}
 	}
 
@@ -367,16 +367,14 @@ static int ntb_epf_init_isr(struct ntb_e
 				   argument | irq);
 	if (ret) {
 		dev_err(dev, "Failed to configure doorbell\n");
-		goto err_configure_db;
+		goto err_free_irq;
 	}
 
 	return 0;
 
-err_configure_db:
-	for (i = 0; i < ndev->db_count + 1; i++)
+err_free_irq:
+	while (i--)
 		free_irq(pci_irq_vector(pdev, i), ndev);
-
-err_request_irq:
 	pci_free_irq_vectors(pdev);
 
 	return ret;


