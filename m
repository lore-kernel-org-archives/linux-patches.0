Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2551DF749;
	Tue, 11 Mar 2025 15:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706910; cv=none; b=Qos6hn9XqgZeu45Rabaw3dE1zGxErgWXEMSh4C4EL3OlmaLdfObovC/SuN884xE3poKcGcJ8eGzseWmaclj4nGOJskGDATvuMPx6BWNTr3m2/0Q/E0GMvOs0kFRjX5jiP88Fa7odwAPT0ruPwYjtrf6qRpkS/AHRdpwLZBQKwG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706910; c=relaxed/simple;
	bh=aEnQ6sFAbR+YyVUS1asUnRQAcHTgfCmeGVGYU+6ugqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/NaWjjNrRh6jMXUsi8b/XwCsfAUujWL0D239no2XFbEosR9hta2h8Uf7vghbanoPsWs9O68ErKWJlnCGZBBcRy7NtcWuum6xYm3oILgbBkgh3HLiyjdxD7JKcxD33zvpRjDKm+huG8XcUWKjbHX4lzbeYHJSdsvBUHhdwP1GXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rD0nYNiV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rD0nYNiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C36C4CEE9;
	Tue, 11 Mar 2025 15:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706909;
	bh=aEnQ6sFAbR+YyVUS1asUnRQAcHTgfCmeGVGYU+6ugqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rD0nYNiVik66OGUlTag90EPyL6KL782gAqZKLi6azUIOQZkJyuKq8liReBPyr0N6d
	 sZEzPR9POheCbHSoCQBqvyk2blaeEkbs3RqasdxCUI87RtJwr8sZekfiYmHhZVvEE1
	 bsWTU0+kBV3yfuyyAIiEbr++WV4vlhJXsUkjXI6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 208/462] crypto: qce - fix goto jump in error path
Date: Tue, 11 Mar 2025 15:57:54 +0100
Message-ID: <20250311145806.579850112@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -219,7 +219,7 @@ static int qce_crypto_probe(struct platf
 
 	ret = qce_check_version(qce);
 	if (ret)
-		goto err_clks;
+		goto err_dma;
 
 	spin_lock_init(&qce->lock);
 	tasklet_init(&qce->done_tasklet, qce_tasklet_req_done,


