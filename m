Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447F627055D;
	Wed, 25 Feb 2026 01:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983635; cv=none; b=SEHW+PZi6Q0bK3KCIUxAjS4+Ox+4z5o9yT7ETvf++67tkg7lET418zORFRI7qzORLRmCfgKIEEFcDGuIJewX6QDYeI/Ov9lZ1Ye+nKK8xnBPiT2hXpyiNgUFMJm1bhFWs8/7JZNVEPbDbG/dr6w6nuzjbQpkzxtZ+Y1gaxNmEvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983635; c=relaxed/simple;
	bh=7QRl7dcYFsP/2ctfEjG0ZTN+INSb4LDdHo/48rAwGXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JOsW9kEWcjE1rHq3qXVmoB79NQuWzwxbDrD8ZoO8sp1soXqeAVQWHxgln2dEvrVtD6R/I23RONm00Rx7D4NhkAJ5bRNpLOrg2Iy5qy+A4aK3xlJrIgERl4c35YF5NTifAhhT0zOELd1wrdtNYAPAYaDMIUVCG2mF+4bLVquZbLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MF0+ctLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MF0+ctLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048CCC116D0;
	Wed, 25 Feb 2026 01:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983635;
	bh=7QRl7dcYFsP/2ctfEjG0ZTN+INSb4LDdHo/48rAwGXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MF0+ctLDcvDheSybWlZgkgwUCFMXb93woqFexDcXpx7Lutk6kXthjr/dE5myTCbgd
	 bRVbuob7vbEhC2iZ/R7fDP+CBHngiWWNiOghqtzGVgEIGsDe2Q9rOCv3bP88fGgRDI
	 Gi2Vg70iLvLGON4VjpokB1jWmgzpNLp2wCUP78Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	"=?UTF-8?q?J . =20Neusch=C3=A4fer?=" <j.ne@posteo.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 724/781] spi: wpcm-fiu: Fix potential NULL pointer dereference in wpcm_fiu_probe()
Date: Tue, 24 Feb 2026 17:23:53 -0800
Message-ID: <20260225012417.493649178@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 888a0a802c467bbe34a42167bdf9d7331333440a ]

platform_get_resource_byname() can return NULL, which would cause a crash
when passed the pointer to resource_size().

Move the fiu->memory_size assignment after the error check for
devm_ioremap_resource() to prevent the potential NULL pointer dereference.

Fixes: 9838c182471e ("spi: wpcm-fiu: Add direct map support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: J. Neuschäfer <j.ne@posteo.net>
Link: https://patch.msgid.link/20260212-wpcm-v1-1-5b7c4f526aac@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-wpcm-fiu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-wpcm-fiu.c b/drivers/spi/spi-wpcm-fiu.c
index a9aee2a6c7dcb..c47b56f0933f1 100644
--- a/drivers/spi/spi-wpcm-fiu.c
+++ b/drivers/spi/spi-wpcm-fiu.c
@@ -459,11 +459,11 @@ static int wpcm_fiu_probe(struct platform_device *pdev)
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "memory");
 	fiu->memory = devm_ioremap_resource(dev, res);
-	fiu->memory_size = min_t(size_t, resource_size(res), MAX_MEMORY_SIZE_TOTAL);
 	if (IS_ERR(fiu->memory))
 		return dev_err_probe(dev, PTR_ERR(fiu->memory),
 			       "Failed to map flash memory window\n");
 
+	fiu->memory_size = min_t(size_t, resource_size(res), MAX_MEMORY_SIZE_TOTAL);
 	fiu->shm_regmap = syscon_regmap_lookup_by_phandle_optional(dev->of_node, "nuvoton,shm");
 
 	wpcm_fiu_hw_init(fiu);
-- 
2.51.0



