Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937BB202C34;
	Thu, 13 Feb 2025 14:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458260; cv=none; b=cEHSmTTAXfdNwbuPvTgA390XRcqeJJd58H1ayE6HtfYptLOkUjfViZhBF2PQrwXzbA1WJ5IrlMhofKX7HYML3Ar2ftMVQVyTMibFHLYk5lKuElP/sl49n41KNi+PQO9MI2bYblOzI0y91ZNSvg9ncKI+VBH0rMWUx5w0ztmFycM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458260; c=relaxed/simple;
	bh=Y9+4uPbX7Cptrk9Aa9QXjpcMRqSXdAacaYooAEeltv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFF6ZdoIfOlaC9zITtGtyaD3LaHcv9XuUzxxK/4Hfp79PFM6bVhC4sBbKbrXnd1AMMc88DMoIzBTbc0GdPFqTi81IRoSMiBmkQQGHhf+9/wtBQuj9+YweTSD2sy/gccXbUYhBOv0EGlHxTGdOAPsyZQMbyYLlUDMqFMpy0uuJyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WP6jbRKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WP6jbRKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03131C4CED1;
	Thu, 13 Feb 2025 14:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458260;
	bh=Y9+4uPbX7Cptrk9Aa9QXjpcMRqSXdAacaYooAEeltv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WP6jbRKXW+HPUioA4uPs0QgbA5lmUQ1oFiBNI/jr/jE2mHxnSK8ATvmtfLlYfBRPB
	 wEznfEID5PveGqhy+lgG/5xIyCMlCXkWIYdCgyln5L9nwrH8NY8luyy5UTVKtoWSr/
	 g1HBUyDvud1VwHpKrMcmZwX3gj8PvWzwRIicTHR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 348/422] crypto: qce - fix goto jump in error path
Date: Thu, 13 Feb 2025 15:28:17 +0100
Message-ID: <20250213142449.982466710@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit 5278275c1758a38199b43530adfc50098f4b41c7 upstream.

If qce_check_version() fails, we should jump to err_dma as we already
called qce_dma_request() a couple lines before.

Cc: stable@vger.kernel.org
Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qce/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -247,7 +247,7 @@ static int qce_crypto_probe(struct platf
 
 	ret = qce_check_version(qce);
 	if (ret)
-		goto err_clks;
+		goto err_dma;
 
 	spin_lock_init(&qce->lock);
 	tasklet_init(&qce->done_tasklet, qce_tasklet_req_done,


