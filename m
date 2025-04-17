Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B4D258CE0;
	Thu, 17 Apr 2025 18:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915867; cv=none; b=cAs1CzVwRowEUOrVE0s/U4Jx+92dHf+Vxhb/ystYZJD8AhUuYGvc4lK3NQtwlG1u5pt/PdONsvAaVITKZx+22ZrCGt88Hhk5kQFtDnKnyzqg4wbZNwH44GNrwu+xTLnwHtIQFzbg7jAJDCdJire2sabD3R6VdaDEw19diw+zmrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915867; c=relaxed/simple;
	bh=51AwOjpO7MFHRvz10cIVWxhZjXs/qfaVJtHC6W3zJxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnn7A+0VicxVTBxHozvvy7Chta8rDHALh70KW1UFNpc1JM1GUWjkoZ8SmMu+4h+ot/O5nTzpa+iorigJi93pQxhaea+a2mfjsGlJRFUMxZy/RESa794xmZ7aEt9tQe47qA1yYYD97iNCuKWN0/GjVNvT/kgWHi7GMG7ntoWBNEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tr7eHu07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tr7eHu07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D71C4CEE4;
	Thu, 17 Apr 2025 18:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915867;
	bh=51AwOjpO7MFHRvz10cIVWxhZjXs/qfaVJtHC6W3zJxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tr7eHu07oMZdQoNNjYDUHMd7OX5HHJdkHyRI3dAvd+EegpXbaASjRKTk5lilVtm5N
	 xi3SpQkxEMWYO1HR1VO3nQN7qt/dRGzlSrfR6rskKrp4N9nC+w5MKLUyopDXFuwrCC
	 KAHDBEEPAajZiRw/jk3F9xYbebtetF2PcP0Maa8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.12 266/393] soc: samsung: exynos-chipid: Add NULL pointer check in exynos_chipid_probe()
Date: Thu, 17 Apr 2025 19:51:15 +0200
Message-ID: <20250417175118.305826567@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -131,6 +131,8 @@ static int exynos_chipid_probe(struct pl
 
 	soc_dev_attr->revision = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 						"%x", soc_info.revision);
+	if (!soc_dev_attr->revision)
+		return -ENOMEM;
 	soc_dev_attr->soc_id = product_id_to_soc_id(soc_info.product_id);
 	if (!soc_dev_attr->soc_id) {
 		pr_err("Unknown SoC\n");


