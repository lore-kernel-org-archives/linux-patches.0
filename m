Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EC1222D7C;
	Thu, 12 Dec 2024 17:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025157; cv=none; b=OS5O+KrIO0UOpvd/+iRqzrMkGX6G+AXpKprBCwZZxkG41MbvPMR4nSFpx3+AY93sz9tbasWfawEOqtiFK95llnmg+3qqWJVKQ+wsiiHAlg1YTVvoe6v+6v4ONUFz9IkdhT2q8E04DYhNdZYYDFKXaUg4LyVxrB/FwTiNDUHcOKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025157; c=relaxed/simple;
	bh=5Wj/ub8yRUKQ8I8YEhOKicPTgfqLFgZwrIZWmMD330E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6yXOIPLCDdChP87VoIKrRRajd6EjFoVZkFmJlP/KZMwAk0S6zNY5YwUMIqR5KYlWDWoAK6q9JqKgKaUSZOlE3sPJ6+npzIphp0VFnVwxcqprse12EpOnU1qQUEoWaeD4ljSNfxcOBTtyRns6UaUgZVE1Z/BtIRjQPX8MGw+OP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1/i8vVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1/i8vVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F0AC4CECE;
	Thu, 12 Dec 2024 17:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025157;
	bh=5Wj/ub8yRUKQ8I8YEhOKicPTgfqLFgZwrIZWmMD330E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1/i8vVKBeRzIq5q95dCdH+P1SHklq0MTq++OTl/HR7PkAHH8J5Hpi7r8QjozX+ia
	 I4TMO5ULKIZhRyHwT/8vCqeVj3WGgzFXLYVFruzGNfin4zTzKIdAk1Q8h91VzFkHmb
	 yKWkj3pAb21i7I+WkN7Qh4CTW56LG0DGpc5a8/M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/321] crypto: cavium - Fix an error handling path in cpt_ucode_load_fw()
Date: Thu, 12 Dec 2024 15:59:23 +0100
Message-ID: <20241212144231.772385052@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 572b7cf08403b6c67dfe0dc3e0f2efb42443254f ]

If do_cpt_init() fails, a previous dma_alloc_coherent() call needs to be
undone.

Add the needed dma_free_coherent() before returning.

Fixes: 9e2c7d99941d ("crypto: cavium - Add Support for Octeon-tx CPT Engine")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/cavium/cpt/cptpf_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index b3db27b142afb..52101755d0ddf 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -303,6 +303,8 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
 
 	ret = do_cpt_init(cpt, mcode);
 	if (ret) {
+		dma_free_coherent(&cpt->pdev->dev, mcode->code_size,
+				  mcode->code, mcode->phys_base);
 		dev_err(dev, "do_cpt_init failed with ret: %d\n", ret);
 		goto fw_release;
 	}
-- 
2.43.0



