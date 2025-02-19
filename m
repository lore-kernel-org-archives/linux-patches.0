Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258C82AE74;
	Wed, 19 Feb 2025 09:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957178; cv=none; b=FMwB7bA3DzhWAiFiadI9Myg+eNbn5n4kqQ0qsZ9R5JVtbuHE24FE4k/KnoCdw+vu6/dBPPK8Obzjp+537poInr3G3XRroW4JNvbr70NfLSi7ymzo7dXIl4QGmj/eVjHjsOU2frXomvYZtuvoLBkv1SOeuZ2xZv0WyUdYQGPbnkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957178; c=relaxed/simple;
	bh=fYptBRfxZ10SvvtB++cyiwUAZqxvlVY6hu6SxKd31sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=derjblh12cop8LwaaeMCPn/0l57lnMuscsteyiz1DYZKqKIpnf4WITDTjhmkCugp2cKKmM6uzRQqDT6jKta2fl13B0ZnD91QvneNwPUKeP0M3+BYdGBb2x9M4/oPuarP8znybdJNKPUiClquDS0vdEaWxkpHKnrVViI49FoWtzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPJx+bxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPJx+bxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A55C4CED1;
	Wed, 19 Feb 2025 09:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957178;
	bh=fYptBRfxZ10SvvtB++cyiwUAZqxvlVY6hu6SxKd31sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPJx+bxSkSP3COe8RqeBgoNfK2EsQZVGAHcARJXR2qYpNW0XDUDuCJpQ7iqdqseGf
	 5J0mwj9OsyqvWW1gXmYzFuPGbeYFeeuTKOu6OgxkVBP1iyDI7/+ZDXfZV2Cydc96KW
	 ZD4rJrWSxxd8ZVvXtRzIEQAT/yebDwG7uW2iQKkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 418/578] crypto: qce - fix goto jump in error path
Date: Wed, 19 Feb 2025 09:27:02 +0100
Message-ID: <20250219082709.462982990@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


