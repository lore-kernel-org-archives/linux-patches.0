Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF2B1F4711;
	Tue,  3 Dec 2024 14:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236608; cv=none; b=K+lb4zfgH807RokRDax6KjPpEqtAPMWp/Sn2MmzOxJoQT8SC+irMTvZ/X9wybxzxpjFs5Yp5rVLDaz7blDp02Tea72xs/T7bjVnxbMmkN7WmOFbu6r+bqYb/qjktSi9GBGHTNXId1ZGfSN9lvPcWDakGip3iyyiGoVkt3RZaQck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236608; c=relaxed/simple;
	bh=oNpbSf9rAeLeIuS11f1iYDpygsREBgycYBDwGOFNvI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blFNggyMqI8ebf/AhlwtExGcN/anbvEBSweSdMiAJJwhSafiJ7kH/JlVVbVXPdUdtEW144CKT6QiG3yjIqdU+mvI/7WUUuqSijsSyblKCKEISpFU5vdZIZ0B43odCI1iccXUSAlq63OTg2Cda84pcbd9NoXlYOEBKrreHTyHW+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0BXcDjR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0BXcDjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8AAC4CECF;
	Tue,  3 Dec 2024 14:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236608;
	bh=oNpbSf9rAeLeIuS11f1iYDpygsREBgycYBDwGOFNvI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0BXcDjR7Ha+NNC3svF1OHLR5+Ib6i3FNHvJT9fCdx2BJQLVF59z6XOHehMvFW//w
	 ev58psh64vRxDpeplbWXlnkW+Qh45i2l5PlEiIG3QHGxjUYQ6lYF6MXhAF9tH1jmRr
	 V500i+F1vynco2DMMDIev/tnGtoxKcdOm+TOQ3/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 028/138] crypto: cavium - Fix an error handling path in cpt_ucode_load_fw()
Date: Tue,  3 Dec 2024 15:30:57 +0100
Message-ID: <20241203141924.628773706@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 7e1d95b85b270..c6781bbbdc5ff 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -306,6 +306,8 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
 
 	ret = do_cpt_init(cpt, mcode);
 	if (ret) {
+		dma_free_coherent(&cpt->pdev->dev, mcode->code_size,
+				  mcode->code, mcode->phys_base);
 		dev_err(dev, "do_cpt_init failed with ret: %d\n", ret);
 		goto fw_release;
 	}
-- 
2.43.0



