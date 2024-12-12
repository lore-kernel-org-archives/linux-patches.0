Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426082153FA;
	Thu, 12 Dec 2024 16:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021936; cv=none; b=aQTaeX4G2bfSCh4plqyyqv7p8WOh/ZhZk4Lj7Mr1wmw5rb+YB2QfKi+CYRTl+gJqLMYn5U/RS+jTiHg5QKSev6e2/cpgqrhFAXIjkL8FTPDKcYSKkBBalPOchTFA8RIbsE/13WksPGLL+N3/Dr4+Vtnd5jJdvCOTCbwjtTQXHlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021936; c=relaxed/simple;
	bh=wCE+g1nSjR9wKxqM2YMBZXZfBU7DsDvWcBtFmnB1qIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgO5xXHj2VitVyCH9HrIAvRifJPeixqTb2fKPpRAs2FKFV6Qp+GvBYuqHewzXPengSzBRRAbgi3ERqk7o/Kso8squ4Zw1V1vuC9TOlyHxsSDburj8REGPMcqksvgmOoiNFMUO3QJyf/g6KyIpzO3Pyoukfkz63qwUiA+MBawHHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D2DZgxO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D2DZgxO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7EBC4CECE;
	Thu, 12 Dec 2024 16:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021936;
	bh=wCE+g1nSjR9wKxqM2YMBZXZfBU7DsDvWcBtFmnB1qIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2DZgxO4GnNzaZ+ZtKLE4nZNGgFnNRkwMuN0laaKBt3n0xcyXoUpXZi5eqOsWxrEG
	 uwJlP4qmER2QQb//Xwfs1olmX6IcMAogZ9y3g/Aiq9W+/zB61I8D4Jt36GGmiUnHK9
	 RDpE/Uciwfkk6S7t5yQ5cd1y+iuQKrGB+dRrLg1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/565] crypto: cavium - Fix an error handling path in cpt_ucode_load_fw()
Date: Thu, 12 Dec 2024 15:54:58 +0100
Message-ID: <20241212144315.553608324@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ec17beee24c07..54de869e5374c 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -302,6 +302,8 @@ static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
 
 	ret = do_cpt_init(cpt, mcode);
 	if (ret) {
+		dma_free_coherent(&cpt->pdev->dev, mcode->code_size,
+				  mcode->code, mcode->phys_base);
 		dev_err(dev, "do_cpt_init failed with ret: %d\n", ret);
 		goto fw_release;
 	}
-- 
2.43.0



