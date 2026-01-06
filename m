Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943CF28C037;
	Tue,  6 Jan 2026 17:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720859; cv=none; b=d28n+amqYlKvZA70gR69cB4cgsuyNnQBMeA66/B7LTn5raulHosT5xT+L1Et+DK4+5eI4xl3m5VK2aswtMOkxsKWFsZvLSVMkduMozBNc/SHp5SeKf63wo8KBCVa5Q998CKxFxwMhmkuG+UQ4KBRPAgPKAmXD0fkCJ53AqFgtm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720859; c=relaxed/simple;
	bh=fmFfUEv721q8xxb1rnBRovK1i50VmTzYASxh1a+4gwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=da/S7hvYO78nbDVEY/mFkxXsAicjgHuUpl0kQ+5K8n604X6p5izjD9t5CKu9SZaonIL43+NZQSoWCYc/A8ZB55EY4hngsoluFDe1Kili3MZX4geQRZjztOIJL8oKa1JyN6nXTrz2ts8G+oIpYRJ0LTE4R2iy/Cn8E10HjuXb5Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPBoTScr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPBoTScr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04203C116C6;
	Tue,  6 Jan 2026 17:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720859;
	bh=fmFfUEv721q8xxb1rnBRovK1i50VmTzYASxh1a+4gwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPBoTScrBllAEfqCp1YXuLjzJbQEjJlI2RkRIdEln/wHvXqZztXooZeJtPQJ9yGF+
	 b5W78QYyHKhr6kGD4owwVQJ7Kwk6r7TKCQLZ4LgJp6QwSGhJpzSn+Dsg9S4ko2+48Z
	 Jk14pHgVL+I8o8Lxa5VUHw2OmG0gSz3JyDpCLMU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.12 364/567] iommu/sun50i: fix device leak on of_xlate()
Date: Tue,  6 Jan 2026 18:02:26 +0100
Message-ID: <20260106170504.803929426@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit f916109bf53864605d10bf6f4215afa023a80406 upstream.

Make sure to drop the reference taken to the iommu platform device when
looking up its driver data during of_xlate().

Fixes: 4100b8c229b3 ("iommu: Add Allwinner H6 IOMMU driver")
Cc: stable@vger.kernel.org	# 5.8
Cc: Maxime Ripard <mripard@kernel.org>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/sun50i-iommu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -837,6 +837,8 @@ static int sun50i_iommu_of_xlate(struct
 
 	dev_iommu_priv_set(dev, platform_get_drvdata(iommu_pdev));
 
+	put_device(&iommu_pdev->dev);
+
 	return iommu_fwspec_add_ids(dev, &id, 1);
 }
 


