Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D03F2DEA94;
	Tue,  6 Jan 2026 17:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720843; cv=none; b=jXceDEJhZuwFqGVv2ssPpq4V/aadgFKhjSFfqxgnpRXZLHnFwyEcIU+69Js6UznUoM+jFI+U+wxXUY7PnGPP1WAeubWsFlgoLrdTjylm9ZKjJf8B2afG/TQVosDJ3SORKU7ykA+U5wEDBDD1B87545OGJIe01yAG5ObKyAwyHoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720843; c=relaxed/simple;
	bh=BcK+XKJES4hK6cBHlpPUqrHG7zhFORAbWoZ0Ks3qkWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYAx/4bPzTu1BseqbNBNnc3S7D0FZT/z+yf/xaV268QX8vt//UtrWEGL+IYGKoRW0r2vPw35hYWGLz9dqaDeX1dBZAoiYLTRQck3rd7wxIvWkipxAV7aoqoFqp0R9n74rCTpqeKdcIEF5Acpb0IwcezgmpOcPZ+gNyWQVWTkXr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VopDnfuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VopDnfuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80958C116C6;
	Tue,  6 Jan 2026 17:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720843;
	bh=BcK+XKJES4hK6cBHlpPUqrHG7zhFORAbWoZ0Ks3qkWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VopDnfuCB5BboPtCGCrZzpu7e6811m1HYZGeG/1hwLtkkuCC/lEcS51jwVcCPJ07A
	 9q3SoDDcy4pXDpu55Gjrd9aEtIxY30zWH1gEJqjMj0NUKbx2uGDHiLsTLou6O5F9p4
	 +c9bS1PJIyM0LvHg+YcpA49qgBM/T1duvbgogs6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honghui Zhang <honghui.zhang@mediatek.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Yong Wu <yong.wu@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.12 359/567] iommu/mediatek-v1: fix device leak on probe_device()
Date: Tue,  6 Jan 2026 18:02:21 +0100
Message-ID: <20260106170504.615669082@linuxfoundation.org>
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

commit c77ad28bfee0df9cbc719eb5adc9864462cfb65b upstream.

Make sure to drop the reference taken to the iommu platform device when
looking up its driver data during probe_device().

Fixes: b17336c55d89 ("iommu/mediatek: add support for mtk iommu generation one HW")
Cc: stable@vger.kernel.org	# 4.8
Cc: Honghui Zhang <honghui.zhang@mediatek.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Yong Wu <yong.wu@mediatek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/mtk_iommu_v1.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -423,6 +423,8 @@ static int mtk_iommu_v1_create_mapping(s
 			return -EINVAL;
 
 		dev_iommu_priv_set(dev, platform_get_drvdata(m4updev));
+
+		put_device(&m4updev->dev);
 	}
 
 	ret = iommu_fwspec_add_ids(dev, args->args, 1);


