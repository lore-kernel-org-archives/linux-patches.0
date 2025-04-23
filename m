Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A76293B4D;
	Wed, 23 Apr 2025 15:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421181; cv=none; b=NxRyyhmioQP/1YDlkqGXxbYae0N6gU4zO/FgAPDPa885VqCBJmifKtw3/+ylg2sHorYv2dm0Kt7HHwrvW9/6dNwrKtieqkSumcx3LFpqIrjvxNucOsS1ACeuBki7shAR+0VcmnXSN/T+Hg74hPCCXSOiFYplvuUdnlL/66WEzmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421181; c=relaxed/simple;
	bh=cvOBVADpuRffSN+7Gk7WNkGAOxzwpUsExqDQV7D/cck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uR2+4AvQ99IoK6aXE6etg1ik0GpXm2D6JFt4jhGy3fYcqRHh6WzqVbLAm7JWmhCMP0SxKyRehw8KZSlXAWqiCo9lXj7IPxgf7qz5fni6SaQ41zyR2Ny0imxN7S+adQ472ZbUTdKZ00ElUowBnsTh9aXzwv71C58Ow+PvY1u0Y0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xM+Zg2bO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xM+Zg2bO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A27C4CEE2;
	Wed, 23 Apr 2025 15:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421181;
	bh=cvOBVADpuRffSN+7Gk7WNkGAOxzwpUsExqDQV7D/cck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xM+Zg2bO4K+2+2RTGg/g50CSKx76VOn0zJUvGssX4+XMlsPfBfg+7I30yog4m/eSi
	 NwHX6SqxH4Ebb5Tk0RLfhq7ciiDMNexH6lUexe0Vxk8f6lWABt+CeNuh5bDH+kBake
	 d+JK2bxZfmiaqfnfJu7D/uDZiyWu2WHuxcwlRKQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.1 115/291] soc: samsung: exynos-chipid: Add NULL pointer check in exynos_chipid_probe()
Date: Wed, 23 Apr 2025 16:41:44 +0200
Message-ID: <20250423142629.073946404@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


