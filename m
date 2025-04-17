Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E98725F962;
	Thu, 17 Apr 2025 18:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914644; cv=none; b=s+EuwQnDPYU/a+CvY0OnqMk29eDxMedOnBCLv/doTEgycWGGYfzqZ2c6l7VXUXu4b4nK4xLFMdfTGR5/XBshEU4asnJHloWTq3gHheTn1oG72V3I1fywUZ3DI+MG4ATWyPwP+2D6QnMwf4d/bAzNFfqQZ95wRaAtPpaMrtizCDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914644; c=relaxed/simple;
	bh=pCEsjaM8TZOiEUDakTtyf8wGY5W5pVFOgwOZjDY1dPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puXrj8aleiz1W4+zCBWuAY5a9JNSbq8wgbENN83agSKXJsbsqNmm/tDbvXlxRy6vz+9ohtG7nDYOYtB54V+GMHl6HHxNLtrTnok94JRCsq3kqewrtIrbzPGF9DqgYkpJqC8mM9Yjs3d6vZ5pDSd2w13Tkn8ml6531kPbrPHTOGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b649+cE2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b649+cE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DFFC4CEE4;
	Thu, 17 Apr 2025 18:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914644;
	bh=pCEsjaM8TZOiEUDakTtyf8wGY5W5pVFOgwOZjDY1dPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b649+cE25tMKB1ZuwRBjdKZXOieWgUWZzNQ3LmCl1UC0zH7rPczzxGxcJElaXXmgA
	 ZjCOdgZeg/NZkrT+gkx+K+Y0P7BnuyjwZaI4iV37kRXeKJRmp+3nr5p4Q9kMN5QrUN
	 zONCJvm0JcwCKkAuH3HOWPgMZJc74KrnbmJXh42M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.13 284/414] soc: samsung: exynos-chipid: Add NULL pointer check in exynos_chipid_probe()
Date: Thu, 17 Apr 2025 19:50:42 +0200
Message-ID: <20250417175122.851471230@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


