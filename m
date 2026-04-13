Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE11C313298;
	Mon, 13 Apr 2026 16:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099101; cv=none; b=tIM00VX6fhL9a1GgPNa+3XS6cAWGrAeiABzdeveBuCMM83cK6+M8cCDqsxMxKenx9haJtP8nDt9LzXDII9ZrHyE2x6e3JE6Cr/uLnOwqTKDVn+4tIyEz61IHBvS0Hl9KDNrDJGAl6seBE5MX0FiY07Aelp+Wl23W/6QEbWEMyfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099101; c=relaxed/simple;
	bh=X2oHp2ePKIMxne7IMsxfF9+jANnyWKgPSS+hXbO1Sr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGUIRA+qFrbHUG7uhREYVOtfKqLH8ioujRHLCIhByzPrOxvigPqn8HdSrTuscB/9fioGDKCkc6eWe3jxI0oNL2jYQdVF+VSXM47X4LmKdGwnVzGsjkhdZW+uJcJ07nD2IwjvLEvuWHk49QtyTP876/fU5/BGxFsN8GIlut+N+64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdvimBQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdvimBQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE25C2BCAF;
	Mon, 13 Apr 2026 16:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099101;
	bh=X2oHp2ePKIMxne7IMsxfF9+jANnyWKgPSS+hXbO1Sr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdvimBQJRSOOBRUFMKiAiq43nLD8icGpDae2SlvkZY5S8PnTVN8YXRhqbt/fr9/qT
	 u4bh075ORAsb06zfjTAOKixqkm1NJF3GKEhiBFW0RMuf/YW2AsFC69MUjOW8ssOta9
	 SedZ4Ysm8yTULcV67OkRQty2wPSQcFer7m4kBmmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 179/491] crypto: atmel-sha204a - Fix OOM ->tfm_count leak
Date: Mon, 13 Apr 2026 17:57:04 +0200
Message-ID: <20260413155825.756284054@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit d240b079a37e90af03fd7dfec94930eb6c83936e ]

If memory allocation fails, decrement ->tfm_count to avoid blocking
future reads.

Cc: stable@vger.kernel.org
Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ adapted kmalloc_obj() macro to kmalloc(sizeof()) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-sha204a.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -52,9 +52,10 @@ static int atmel_sha204a_rng_read_nonblo
 		rng->priv = 0;
 	} else {
 		work_data = kmalloc(sizeof(*work_data), GFP_ATOMIC);
-		if (!work_data)
+		if (!work_data) {
+			atomic_dec(&i2c_priv->tfm_count);
 			return -ENOMEM;
-
+		}
 		work_data->ctx = i2c_priv;
 		work_data->client = i2c_priv->client;
 


