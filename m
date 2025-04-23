Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DC9288C9E;
	Wed, 23 Apr 2025 15:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421283; cv=none; b=adtexMA9cqtyFEhqLB5shVRQI/vzY8PPm1DuK/b7hJ8Mf5q1L+CPBWyJEDpzoXLvvutc0dZdhus0dFPoXkws4KP3/8fQ6m/ykC8fWGiWjfjxUvW7BsBsXI55IpbkcFViGl2RW8z29Qv2nshOWXa5zDCca+ReyMX7Kp7gUW171SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421283; c=relaxed/simple;
	bh=OTDMyaOVWOkTZ7QdDyxCPDXbMLqusy1N3le4pHrhlp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jv3y1TnBpfHlkSX5Ng1ipDUDJn/HweyQSZkq92biY2Fp1FMMAiLlMH2T6tS2u3xm/XZTjrniVnOtADPWI1lrSl6LmYvkzBhjN3Ep7dF5x9gfLmyBXpfGsKG0UbyuzIS9yk+xfuHEFNXMIFYw3uczN74IdguWVR4YU/JZcIBwuV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nl6fKNlb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nl6fKNlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BB7C4CEE2;
	Wed, 23 Apr 2025 15:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421282;
	bh=OTDMyaOVWOkTZ7QdDyxCPDXbMLqusy1N3le4pHrhlp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nl6fKNlbIa36QSx2wGiqXhiFU0SZoB7FTHmPXm0m7VfZugNWK/bdA/BsPchSyD76q
	 mgko/FBITnLFgdihYIvmofe+ruBM1/5b1m+fQSKni1SqyoCdOWYOhZmWjox8zwTOVb
	 EjIHD89MO0RqtkzdVTlZrie7HYTmPyeU7jtqlaS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.6 165/393] soc: samsung: exynos-chipid: Add NULL pointer check in exynos_chipid_probe()
Date: Wed, 23 Apr 2025 16:41:01 +0200
Message-ID: <20250423142650.186910308@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

commit c8222ef6cf29dd7cad21643228f96535cc02b327 upstream.

soc_dev_attr->revision could be NULL, thus,
a pointer check is added to prevent potential NULL pointer dereference.
This is similar to the fix in commit 3027e7b15b02
("ice: Fix some null pointer dereference issues in ice_ptp.c").

This issue is found by our static analysis tool.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://lore.kernel.org/r/20250212213518.69432-1-chenyuan0y@gmail.com
Fixes: 3253b7b7cd44 ("soc: samsung: Add exynos chipid driver support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/samsung/exynos-chipid.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/soc/samsung/exynos-chipid.c
+++ b/drivers/soc/samsung/exynos-chipid.c
@@ -130,6 +130,8 @@ static int exynos_chipid_probe(struct pl
 
 	soc_dev_attr->revision = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 						"%x", soc_info.revision);
+	if (!soc_dev_attr->revision)
+		return -ENOMEM;
 	soc_dev_attr->soc_id = product_id_to_soc_id(soc_info.product_id);
 	if (!soc_dev_attr->soc_id) {
 		pr_err("Unknown SoC\n");


