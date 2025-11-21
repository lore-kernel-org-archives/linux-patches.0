Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4502340A62;
	Fri, 21 Nov 2025 13:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733468; cv=none; b=cNgt+mVixlOkGwIq/Oli3USJUo9q6X5l8/uO3fFofl8/D0qHM1NTy09frRcZwXiWkFT2+No1/xnBHayRFkFdqp4m59f75+lLT4IOccOJ5eaEUU6p/Z67pmlJmTbSX+LXWq8GKAC5+zhFAFK9wQrT+7WA8Td6oeW3VuRlUwDpcMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733468; c=relaxed/simple;
	bh=XppOyGUFoUue6Y9ismFbTU7rWhLfJ9PgKCWm0n07MME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsKXhmb/jhmI4LGjOGvAhq+VqAPe1xCrtT7VfaCY1KNG2i/cKE5r3El8kB30LU8Re75z0Y7bXPRSXbt0JE81ahoiwAAFIPKrBX7SECyUCLFf832olHOBQoJoXGqm+lf5mF4HJrkpGNuYVPkHlUSJjLRLDc5b8nhvVy2fIiuknAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROV+SxMx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROV+SxMx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BB5C4CEF1;
	Fri, 21 Nov 2025 13:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733468;
	bh=XppOyGUFoUue6Y9ismFbTU7rWhLfJ9PgKCWm0n07MME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROV+SxMxUHJ9xZJBoeZe5u0JE7sRfKwXdYiK9401J+lELuq+EoCZSjm98O0xzkH7i
	 FugrgI9K6nieAkATZ3ZV1AZp9mqO51NJjMb3PFvb3QIlKMoHMBnj3+OTdTNyh/T13L
	 oqosaALnD2mHUc3aJRPikPD5f6cSJEnXuVeFWEiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 478/529] crypto: hisilicon/qm - Fix device reference leak in qm_get_qos_value
Date: Fri, 21 Nov 2025 14:12:57 +0100
Message-ID: <20251121130248.016899998@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
@@ -3750,10 +3750,12 @@ static ssize_t qm_get_qos_value(struct h
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


