Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294B1471421;
	Tue, 21 Jul 2026 20:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665423; cv=none; b=TmukzEjwDqToGNUnB4nWVYuJ4WUkX3hdzo+yvERGxkv5gxXs6g6aRu8I0TFgkNDAhWB1KZFFSyn+/r17g8qZvd47Ytrv5115gTuIk+OD2PZrKCHQfAHn98Qw+ULIw8/XzPKoPz2wo3WUmgWN3cZci3aWoyrfmcZW9pvVxzQ7Yw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665423; c=relaxed/simple;
	bh=DJJeqWGH63W4IDVrfyXhCtimhrqNzzInOJEfBX+PCxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkpQguXrBRA4dfca4HI8LrzhPjVJ974ax077O05/p4JYdvtFKNtKIq6+Kh7bfCyoJ6Q3lgkrHF75PkLgnWnqTr8+8tW1UZtKqF1l7bjsRUdqbg3HEQmyOSq3iOGB51vISRU2oqdE2ZcXKpFB0/XVFKKJ400XdwTQOi7HObkd8sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnzOxvkZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnzOxvkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE1D1F000E9;
	Tue, 21 Jul 2026 20:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665422;
	bh=IB6yf/UWMSaIALGguaVW4W9XNCXVv+3D+h4VDOYs9Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vnzOxvkZ/6Wbgz4KN3Q3BamHJ/C9l2VK6KQiibaAGDuf/+QO8pd7cyXTmPvI0YJMA
	 /9fNeFxFGRHojz2v4rUAyJvvEbYOpqWjs6qDr5N9r+mNcWUhqIWorbwTO4a22ufTNX
	 ah4NXgtmAzQ6hKY1ga4q4iFuga7MP/TuERY7zEvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.6 0298/1266] NTB: epf: Fix request_irq() unwind in ntb_epf_init_isr()
Date: Tue, 21 Jul 2026 17:12:15 +0200
Message-ID: <20260721152448.495061245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


