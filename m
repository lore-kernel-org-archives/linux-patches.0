Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587231CAA7D;
	Thu, 17 Apr 2025 18:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913361; cv=none; b=bYQOpq+9L5s8IyCBFVt2d0fbvTFGXJ7UeC5iq0hJw/9cDgWTnZB9n3Z/BXevNYWGawrFfZOZQGZGby0SIaMe5JRxxoQsODB9TuPSghWL4HWkuLK8CcpuXjYRgtG+btbSmBGFHOHVaLcDY3NoS9LPj76jYpKGkiRoSMRt+uxvR5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913361; c=relaxed/simple;
	bh=QRXpcipO6/H2CnAWzHz2G/FX0ACbybgzRGGk3UZi+xA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBDHsCmXCNabEcULJoxUh6lLIhCptoaCN/7JnvJMdLkHE/4oVYIF7N9t8gNTQG43POwPEWRu25HtHZeu2QmzZMtYoGSfEci3HejJ9v2AbMXkR6g1UhBxceayslfocLoBhILZSDjcyikRRid1ZMSY83KYYhxuW6FySPana/GWzUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyjHQYG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyjHQYG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1245C4CEE7;
	Thu, 17 Apr 2025 18:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913361;
	bh=QRXpcipO6/H2CnAWzHz2G/FX0ACbybgzRGGk3UZi+xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyjHQYG/Zbosecmvuo1gD7QZLzEeQ67IS3H6N4i+vgRDAGPSab4/lU/km84+cg33O
	 j1JiU/XaaGIFiY0zHg/n8g5xF7GUpiQbgB2bhgDseiD1r0XtTKjGwg6zJGHMa9cgWN
	 32cWfme5v716urQZUxg2oyuxcCKVH5cQJxxacNiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.14 313/449] soc: samsung: exynos-chipid: Add NULL pointer check in exynos_chipid_probe()
Date: Thu, 17 Apr 2025 19:50:01 +0200
Message-ID: <20250417175130.709924351@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -134,6 +134,8 @@ static int exynos_chipid_probe(struct pl
 
 	soc_dev_attr->revision = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 						"%x", soc_info.revision);
+	if (!soc_dev_attr->revision)
+		return -ENOMEM;
 	soc_dev_attr->soc_id = product_id_to_soc_id(soc_info.product_id);
 	if (!soc_dev_attr->soc_id) {
 		pr_err("Unknown SoC\n");


