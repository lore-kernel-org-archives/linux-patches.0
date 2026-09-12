Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139243563FB;
	Sat, 12 Sep 2026 12:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214835; cv=none; b=lFeVdVxxLSFbO/YTlA4vKAx7fiWXELkrrgmE2OzufnBFxazd64jeoiF+0iNzvryiwISMkzzxjbtJrMtMNBWcDOwkUhY2ygnQ2KbFbhxfBXnEyeyRCSeoI+24sKt0IkER0vd/3P7oBd2SvyhlJEimF+rX+1nz6rfflPF5DP+1lCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214835; c=relaxed/simple;
	bh=nctViNHSylGAN/FunK6ynVcx+Jehb8x6qso+Msrq/QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5ReNehALTacXSs3LrI3WyIfJ4/i0m9nvikL++gDQ4ut6t77rJZlDddbMjqyZ8Ly+D+H1TpxH36iaUvHHQ5sKENjKqB5gaWwSIHP4qwDcMRsr0LC2CH+cxowrCqQ2JG8JcPKtxVg4lEApV/EesS/VcmSDFtT1F4JAwfzi5w6mhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGn+62Aj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGn+62Aj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C99B1F000FF;
	Sat, 12 Sep 2026 12:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214833;
	bh=K4Kennk1/KGhA9jwh7aUXhgVkVfp0LJHu97jVkjBCnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lGn+62AjCXu+eXT4kSwLgSa2LgGzOR9n18aqeUGjhbwYq41pU/ULFwYpiyiWwpoTP
	 dvNDurw4IBcJ+9sSgIXb4gvJU31qimRCZcQdCkih6Wi2g0h4RgLnUSPeSJ9o3SXpOg
	 KmGUTO2dDgsIF8341CjZrUyLiHGzdIcL4v3gTXIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0406/1376] crypto: sa2ul - stop probe if context pool creation fails
Date: Sat, 12 Sep 2026 08:47:12 +0200
Message-ID: <20260912065616.590430605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit d03f980a25853f6a380895119a572a3bb1194e8d ]

sa_ul_probe() calls sa_init_mem() to create the DMA pool used for
security context buffers, but ignores its return value. If pool creation
fails, probe still continues with DMA setup, algorithm registration and
child population even though later request setup depends on that pool.

Stop probing when sa_init_mem() fails, and route that failure to the PM
cleanup path without attempting to destroy an uncreated DMA pool.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index d1c2d129ad418..a8f5f475acbe6 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2426,7 +2426,10 @@ static int sa_ul_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	sa_init_mem(dev_data);
+	ret = sa_init_mem(dev_data);
+	if (ret)
+		goto disable_pm;
+
 	ret = sa_dma_init(dev_data);
 	if (ret)
 		goto destroy_dma_pool;
@@ -2461,6 +2464,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 destroy_dma_pool:
 	dma_pool_destroy(dev_data->sc_pool);
 
+disable_pm:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
 
-- 
2.53.0



