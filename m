Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E75D34029C;
	Fri, 21 Nov 2025 13:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731410; cv=none; b=KxhohYKITXWzj7noGc0DkD7fEmpOTPAakBnktFV7Q6CDft+sZ+ZYwsJlW2vcbyJSl/UWBG8c/ZVqZRV3oL7wOLXEJgJSvMycHNkZD4fWktqudJ7jurkeDRE1qp3bXB4b1LgYO9M5WBYHNJBEmG2zXDsDEVQaYw49yqa61tq6G+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731410; c=relaxed/simple;
	bh=uME8xnOkd0b6wZfY9zX2MiyGrZ30eaRuTryxn4RphIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcRNO6cCAgg/sE+eKmtfeqs9hImwgnjR1diAzyqnEu6JIZ36opcEUkd9VHjzFUZ7wz0/k2d1EPSBhCloZG9CoMbjLe5m8tRVztbiq06dLPNdbfrhpfj3hHXd4gXSqFmEy/Y/FzjekebMgHi5nyZ/SX6pif6mTcyaDTyO1R4w5gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSCFUv3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSCFUv3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC94C4CEF1;
	Fri, 21 Nov 2025 13:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731410;
	bh=uME8xnOkd0b6wZfY9zX2MiyGrZ30eaRuTryxn4RphIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSCFUv3Km2N1vewnk52QfopHqe/sipePD14b/SCziBz+67Yxy0e9o1J9gD+jL63OI
	 A1plqhe3NEbXs0nZahunBVHUTs2mKUQ8mnHh0XnOHmZqepj/DF8H6N2Yb6lNwQM5c4
	 FRJTWXz52oP2hXnORIs+hwaL4Uxy+cbJGDV+Z7ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.17 199/247] crypto: hisilicon/qm - Fix device reference leak in qm_get_qos_value
Date: Fri, 21 Nov 2025 14:12:26 +0100
Message-ID: <20251121130201.866891497@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit 59b0afd01b2ce353ab422ea9c8375b03db313a21 upstream.

The qm_get_qos_value() function calls bus_find_device_by_name() which
increases the device reference count, but fails to call put_device()
to balance the reference count and lead to a device reference leak.

Add put_device() calls in both the error path and success path to
properly balance the reference count.

Found via static analysis.

Fixes: 22d7a6c39cab ("crypto: hisilicon/qm - add pci bdf number check")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/hisilicon/qm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3857,10 +3857,12 @@ static ssize_t qm_get_qos_value(struct h
 	pdev = container_of(dev, struct pci_dev, dev);
 	if (pci_physfn(pdev) != qm->pdev) {
 		pci_err(qm->pdev, "the pdev input does not match the pf!\n");
+		put_device(dev);
 		return -EINVAL;
 	}
 
 	*fun_index = pdev->devfn;
+	put_device(dev);
 
 	return 0;
 }


