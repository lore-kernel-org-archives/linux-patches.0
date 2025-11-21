Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE64B3F9D2;
	Fri, 21 Nov 2025 13:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731935; cv=none; b=GqZSdY34TF+yhlsdkUhYHG3diNMB1uoPUA9Orokisuuz1Ev75k8BFkZYEylqYMrUJdxbDOAMNTfufSwpi+DRHsDfuYemowfBm0WO8wQMU0CHapcHyWq4mXrwQRjYODalVQuuXioq0uwLdzT/ywOvgqsaja1z+JLUx7kMryFhgUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731935; c=relaxed/simple;
	bh=sJoJo+ULJAqVt05skj+fCbUnQdrGE7Ee+i/L1i99O5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/KLCOEiP2RMk+NNevc9UFPR2h6lqTKIVujm3PG/52vkIqsVm6uPD3nN96gIED4JR62Qe3vPHu0UyzkzQqIaBhxdmHbu55NJazsxWEZgtboKlkdAQ8O0irqPiCX8st0g3T2JP5/zNjEeAPYNZCNzyJJ7N7hPCGm7SWRjvnv6jA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fS9NAAJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fS9NAAJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2374DC4CEF1;
	Fri, 21 Nov 2025 13:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731935;
	bh=sJoJo+ULJAqVt05skj+fCbUnQdrGE7Ee+i/L1i99O5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fS9NAAJtDe72eSHFtALy5kWi5KVdqYrz3U0/6AV23aoSH3AU14y7PPI6ppoXkP4vc
	 XR3GakFbB4/f2PN57R2ayMBxan1HPf2up4UVk4F5yc21VBeURNHskMioomBuJq966H
	 O0UCKC2f9dHlCrfpMkyVtklSaGnYaZpS5o3K+o1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 133/185] crypto: hisilicon/qm - Fix device reference leak in qm_get_qos_value
Date: Fri, 21 Nov 2025 14:12:40 +0100
Message-ID: <20251121130148.675126729@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3688,10 +3688,12 @@ static ssize_t qm_get_qos_value(struct h
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


