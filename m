Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408C51C4A24;
	Mon, 10 Mar 2025 17:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629496; cv=none; b=juWivxxcYRM1sInoOMt+Ic4mF9V+UFXC3slDdTUIFKl6cMYQVTSVz2WWx1u7Syd/2O9h3IBtO2JzwUAP/ZiFFJyYA/oxQpxsJDmhzsKSPPTz7vV1U3iXAEFNY8DMnr9sJRW+1InWZ5v2zm52tglwZzDFozWyrgM2tzb4dNDFf/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629496; c=relaxed/simple;
	bh=phRGjCLMo8O2ijsGUHNGIQ+86TZHYu0I4bjFyFVPHfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPCrkLvLbXeG2zb2B5ti9bqHlA4kTwJLg66FLB0kH7enKeDUQNQVGIkiF0YaYHn0hovjmOifJCUNQBVUzdIIMzXTcd6/qo88EuXabejNoHo+wP1tNEuktAMWGotld1/PgL10uu/H/yN9marAW5aI7sxdIaF5sPyTyjZO51ivUNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snW3DqEL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snW3DqEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE82C4CEE5;
	Mon, 10 Mar 2025 17:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629496;
	bh=phRGjCLMo8O2ijsGUHNGIQ+86TZHYu0I4bjFyFVPHfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snW3DqELSJ7wmGONwpoZbAuti90UCIZGSq1Q/9W1MwGG4kF1j3NKdafFC2KwqpaAO
	 reY7wDEOzfpbyN+LL3BJQYq8pCci8kEynPNlq5Mx9B0FSQeEw7oqjr/uP6tt9wnZV5
	 SET56qfazpG/APKk0kTMBTsedkQm1B2Tt1XpuzZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 313/620] crypto: qce - fix goto jump in error path
Date: Mon, 10 Mar 2025 18:02:39 +0100
Message-ID: <20250310170557.972154895@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -236,7 +236,7 @@ static int qce_crypto_probe(struct platf
 
 	ret = qce_check_version(qce);
 	if (ret)
-		goto err_clks;
+		goto err_dma;
 
 	spin_lock_init(&qce->lock);
 	tasklet_init(&qce->done_tasklet, qce_tasklet_req_done,


