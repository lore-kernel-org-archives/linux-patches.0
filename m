Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062886;
	b=FbX2mQho0lY3OwDN7IG9m3Z9RAPgV1IyZiUzVv4BuypyglzbbUhfbuCZHzJc44rl3iR2
	 sPWwsvpcDk4rLBmU78K23MZnyTxd7/bPom0mUu9qg3Zy/06/PNkWJOuJ9ZV98M7udh6mR
	 uyqZmSciYYfQYzCXbJ42bX1j1xbooI88pFqDQh34UE0+kcnMZ4fqLjYb1HiA9EoGU5hxv
	 Mt33j9L8hrygAsGJbt3gmL7QIrHaGJ9U/cClfPEiJENG+9UUkaH6AXIPdHIEE27ai1aiE
	 YAslNfqCsG/8Bm6Z7mn7WFFmlTWxAxFRlufAebBjBOcDaxMCFIJ/y5qmQG3BSvT3Nzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062886;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vR9Ndl4+wBCFaRS7zldUr5RV+/k91ZtVDqVN4ldec9s=;
	b=st/5is/CJKy68wnT2Q3tQhtoGnJOZ2PyzG3pZnQNZTms8sctUFOa/XKDLNo2pLAYicNK
	 sqRH/LWZcO/O2iWPJkZbthO3m735nlctpq544l71mTAXgS7AbeEcbTwRXUPpcvh/XTkZz
	 1at/gBhEY21csVHK1fKGK495UoRekT9pE7EwBkDiue906k2Gi00FiET+5VNfWDrTq+h4e
	 dJuVdqi2ZTWu3bns9K0ppz0ijwIjd6nQ/0YJqrSMuL8JcHMewnJkbzgLC3uCWVGYfy1zr
	 igOO6P/X4XpLSXwC0obyqSOuEx8BBHY8fHQl9pgvKCe2JFe0ablzAmtGugrNPWZ5GrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tRuPMr3z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED94606A32C;
	Sat,  7 Nov 2026 14:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tRuPMr3z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8171F0089F;
	Sat,  7 Nov 2026 14:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062886;
	bh=vR9Ndl4+wBCFaRS7zldUr5RV+/k91ZtVDqVN4ldec9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRuPMr3zJCRhRo7rK5LBVnVsMuPhNQUDDkt3rFa68JqHtKflM337Oq0SIYonJpV/T
	 7vaTJnhjRjZp5gPEoQcv2sWDZX8Uz8I4+fxyjmzAriGdLsxQzkgmFjRtswtQfR8+aR
	 vk8Y3zBjwhZqXuZL7ODg+IX8c3TiGA+jHEz2gaG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 165/869] crypto: omap-des - fix crypto engine cleanup
Date: Sat,  7 Nov 2026 08:47:27 -0500
Message-ID: <20261107134857.846248310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 5d69ed4cd4f9c68ff9a6ebb2e8a1079223a4ec6e ]

omap_des_probe() allocates and starts a crypto engine, but the remove
path does not call the matching crypto_engine_exit(). The probe failure
path already performs this cleanup.

crypto_engine_alloc_init() creates a kthread worker for processing
requests. Without crypto_engine_exit() during driver removal, the
worker is left running after the device is removed.

Call crypto_engine_exit() after unregistering the algorithms and before
tearing down the remaining request handling resources. This stops the
engine and destroys its worker.

This issue was found by manual code inspection.

Fixes: f1b77aaca85a ("crypto: omap-des - Integrate with the crypto engine framework")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-des.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 16d5c617d5ee8..96b399c7eca69 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1084,6 +1084,8 @@ static void omap_des_remove(struct platform_device *pdev)
 
 	omap_des_unregister_algs(dd->pdata);
 
+	crypto_engine_exit(dd->engine);
+
 	cancel_work_sync(&dd->done_task);
 	omap_des_dma_cleanup(dd);
 	pm_runtime_disable(dd->dev);
-- 
2.53.0



