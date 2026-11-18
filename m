Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060365;
	b=ldGu4UI6IgO3GXEuF6r+F8TTFaXeJ3feJlccQ1c9BjsPnp8xdwjUOWaHy7nCHFaR6E5h
	 6Wk4CJnpbqfeLdwLjx4sx7RYsg0oW6S2iXb2/Pp1SH/GdMMtI3PK0cjaNiCNzT2MDpIIQ
	 og8KgY9q5yJ/B4n6MN1dJxBrwOVTIpFjTA4qa9V5NYOUrOaR1KtpOX/5FNcvIbCuvdIk3
	 y/7zRLAOqRrrIF9abRAdxyn2fvFtTbASw2qVNBNGE8cSMege/bLsjVpRN4jkaxhetEG12
	 54qgYwbWwga8xE2EufZywikVthBkhTCX/r7DDA+In0YEDSzk2nyzJelyC/MPoboSHfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HIUnWA6ox800umNifWBxki8NoXD08JlcZ3ocSTOEi44=;
	b=tP7uI/SsGsHiQX3oNTCpeAwAgD6ZWdiZAyXKNv96vnZr1UnP98OXNXKNslYZrqF7/hN4
	 2ijK36Q0MC7/ixGT1JQVPSOdMBkE7VwrkfmpIBmGG6I1YpAZ/SdPUAXGqU+zkgdSaL88R
	 Sq+2QHflTDuxuGD1cmu7VT+PZ46Qgu8EY4N1EtXk/rRvj5VJrfLraW/oL6e6OFu32P6/b
	 Ln83rVdnBap/pDH++kem/unPrtYulWbIFQnjJqc1nNfxUdg0VZ+SLOlsP/N3AnMF/UiGc
	 OKD29XsaXo+tHN8xl/x9nuCBBE6FMTJmTI1bjfqYwruWLortaG5yKhsthttpXD4acjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ex3tZiWV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CF8606A320;
	Thu, 19 Nov 2026 03:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ex3tZiWV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA3B1F000C4;
	Thu, 19 Nov 2026 03:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060365;
	bh=HIUnWA6ox800umNifWBxki8NoXD08JlcZ3ocSTOEi44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ex3tZiWVVcHRDr2A/13bS3TetnDToFbvhH+9kTonCtrHM/NeRbcVQqfMBEVj3Kv7w
	 Aq2J40OCtk5QkHHcnCImKtRjKKVmNnJMBwRVOeUMpLNCKCnqPRuEZS+6xNn7O3swJc
	 f+f1Y3ncecHugkC/3H0Ux02gN9qovOOShimvzldw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1173/1848] spi: mtk-nor: fix runtime PM usage count leak in probe error path
Date: Wed, 18 Nov 2026 15:53:31 +0100
Message-ID: <20261118150008.717403836@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 4cee1ed13e2687f1a9fec7dd50e31eb179506d75 ]

mtk_nor_probe() takes a runtime PM reference with
pm_runtime_get_noresume() before registering the controller, but the
error path never drops it.

Balance the get with pm_runtime_put_noidle() in the error path.

Fixes: 3bfd9103c7af ("spi: spi-mtk-nor: Add power management support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260904-mtk-nor-v1-1-cefdca098f83@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mtk-nor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-mtk-nor.c b/drivers/spi/spi-mtk-nor.c
index 899d2e76f7110..f99b59b51b639 100644
--- a/drivers/spi/spi-mtk-nor.c
+++ b/drivers/spi/spi-mtk-nor.c
@@ -847,6 +847,7 @@ static int mtk_nor_probe(struct platform_device *pdev)
 	return 0;
 
 err_probe:
+	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-- 
2.53.0



