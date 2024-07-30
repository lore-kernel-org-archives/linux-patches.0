Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4236C1A6192;
	Tue, 30 Jul 2024 17:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358974; cv=none; b=sFm41LEUTRHVBXE3gVicC9OhG8lu1otEIq5z0yHNqTIXr3VRUP4Fpr8ms1c1d4wkkEVgLUgKz8FbL21wG33O46WbQjxS+XkSSkLzuSATeNSXuAZ2BlTpQk6DGgEc1kcnmXF54BaFDMpvBGHF9JcUfu9ykJHxi+pJ7jhRlIXJAqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358974; c=relaxed/simple;
	bh=i6OtoPhzHo3+z8bMi6O2Fr/O9hKFAdoEkpAic/ih6L0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYoJ33aB+UfoamTGWDLLei0DHPLQ3aDCXudmi7sikEUt57sDdBU7nAWY1oaTg4TYl0S2CkAJVuy7ld2ZZGE/s5XXjekCuKAjc1/umcbO+/AaV+eVqPY4SsMm//hpdN2TxQDUBMeGOrMS6cw8oT45fVko89/9NUr0GtU6ClcPwJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4DFX15C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4DFX15C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8173C32782;
	Tue, 30 Jul 2024 17:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358974;
	bh=i6OtoPhzHo3+z8bMi6O2Fr/O9hKFAdoEkpAic/ih6L0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4DFX15C3fCq8WZPQt+bEgj0DyRgQYJLowduZTAjWK+jwk9ohnEuHH2RvzyZfUTXu
	 BUcAJLRz4/NvqNuXvjw3Y8GakFC5db2dRMomXwKBxYHBiYADovNhvvIhDNyxDcptEQ
	 xHj2WvHbezWtnkgg5c3ZoG7pNV6nBlTVU0Abmyss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 390/809] crypto: tegra - Remove an incorrect iommu_fwspec_free() call in tegra_se_remove()
Date: Tue, 30 Jul 2024 17:44:26 +0200
Message-ID: <20240730151740.075123458@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 8d7c52cb4184d3dc26dde62b4f5acd48de0768ae ]

The only iommu function call in this driver is a
tegra_dev_iommu_get_stream_id() which does not allocate anything and does
not take any reference.

So there is no point in calling iommu_fwspec_free() in the remove function.

Remove this incorrect function call.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Tested-by: Akhil R <akhilrajeev@nvidia.com>
Acked-by: Akhil R <akhilrajeev@nvidia.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/tegra/tegra-se-main.c b/drivers/crypto/tegra/tegra-se-main.c
index 9955874b3dc37..f94c0331b148c 100644
--- a/drivers/crypto/tegra/tegra-se-main.c
+++ b/drivers/crypto/tegra/tegra-se-main.c
@@ -326,7 +326,6 @@ static void tegra_se_remove(struct platform_device *pdev)
 
 	crypto_engine_stop(se->engine);
 	crypto_engine_exit(se->engine);
-	iommu_fwspec_free(se->dev);
 	host1x_client_unregister(&se->client);
 }
 
-- 
2.43.0



