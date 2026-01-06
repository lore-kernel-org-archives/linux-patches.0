Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEB832ED2F;
	Tue,  6 Jan 2026 17:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721948; cv=none; b=ZEITqRW3LiyoGMdvAH8n4jVZtoVtQrlv7ZLgqzbiYDJuwk78wGmi1nV+EKqiY5chReXv/PTs7VBuRGqofQn9uOd0G0bnEDL5mKk6ts4UCMYQsQ44kHeOcIpAdxdZHdK5AfuTGXKkGBlbv277SrrCY16MWThG0B5zj6dtxJyoIG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721948; c=relaxed/simple;
	bh=OMV9meG4eqQL/wFkV4mXhcJxg1UPlFkKIQAzozJpGT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQAvSEzdMM9dFJ4VsoJooyjuptNIyOPo+kdNtt6Ju+pEmyLUZa33oFpfngfnUqTmCI75f8As7vn7Fb4dg6/dus9BWGXnDzxNF27Uxm0XSNcOLJqZjatoxUITE65z7Crsw56t8SXCQ9GjdeHNl3/tZWpm75pEcHoDWKMlVqqviuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1J7B9rUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1J7B9rUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C404C116C6;
	Tue,  6 Jan 2026 17:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721948;
	bh=OMV9meG4eqQL/wFkV4mXhcJxg1UPlFkKIQAzozJpGT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1J7B9rUjYd1ydN/c0RPX2mikFLtZ0QeN5oSdk0qj54nySaqscct/RrG+WD8OaO+yA
	 b2FEa/vW4Uke47PNnGwanXm6KIP8H+Wlv+0TCXs9Bpj1cWC/EavrdPe5qIoPIYaOJ4
	 HFCoqBtLL8Tc+jrU87w/2wxpS+hO3TMx6oY8uK7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Johan Hovold <johan@kernel.org>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 118/312] iommu/sun50i: fix device leak on of_xlate()
Date: Tue,  6 Jan 2026 18:03:12 +0100
Message-ID: <20260106170552.112385635@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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
@@ -839,6 +839,8 @@ static int sun50i_iommu_of_xlate(struct
 
 	dev_iommu_priv_set(dev, platform_get_drvdata(iommu_pdev));
 
+	put_device(&iommu_pdev->dev);
+
 	return iommu_fwspec_add_ids(dev, &id, 1);
 }
 


