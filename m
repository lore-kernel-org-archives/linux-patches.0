Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B782C08AC;
	Thu, 15 Jan 2026 17:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499761; cv=none; b=eU5hIgCqzmECGfF6qkINo4SunlxlINRSe4AH+8tqWGQEyWnxekRf95cCj94iKP0rgZ4gotQrMba641o9jab7IxnfNypaXQtJnw96GJGgIT3d+be8xNe47Y6uI5fjLlYzRThAigH80uxN1t7parQ5AckxmeDnFFRHne4HC5Il/kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499761; c=relaxed/simple;
	bh=ohHpblvu/51f5mMKgs777BLjDivQpakemmrORkUicYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5YAr1Cjg0UdW2+bJTpfUDA+78gBgFNicdDOTxNR0QqYH0A4Jo6LqJ1A9Dsz50syezoXrLHn8dlHuEKIHD5nr7K3/Aa1/6QOWI7whZanl5zpvCRDzb65870VMbeWdsAwAKGJsLqzWGaDTAei3/MBbCgHgar72H/5rX1WNamRLYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BD8sT9Gz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BD8sT9Gz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77182C16AAE;
	Thu, 15 Jan 2026 17:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499760;
	bh=ohHpblvu/51f5mMKgs777BLjDivQpakemmrORkUicYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BD8sT9GzmRPLVXeCRra0DB6OK9/a69HQk8EZMVbffC3n0ErGcQ8MnpwWmg2tPEfhO
	 HKPyNHKd0Fep4SpYOHpX9ho6OmgHflEdrsHFRcCtohCHf7NvbBnr8Jq+TzpX2T9PCC
	 r9ssk/ZrSay4531Yj/AsII8gxsVCQj/B/DMBjUqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5.10 307/451] iommu/sun50i: fix device leak on of_xlate()
Date: Thu, 15 Jan 2026 17:48:28 +0100
Message-ID: <20260115164242.003864203@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -767,6 +767,8 @@ static int sun50i_iommu_of_xlate(struct
 
 	dev_iommu_priv_set(dev, platform_get_drvdata(iommu_pdev));
 
+	put_device(&iommu_pdev->dev);
+
 	return iommu_fwspec_add_ids(dev, &id, 1);
 }
 


