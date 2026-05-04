Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9813DE457;
	Mon,  4 May 2026 14:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903503; cv=none; b=bSFG90IjXVolPFAON5UiF006mK17VuxfQo5yVqefuQvAGs4GuEWt8Lk9hY4nVlNCvoZ89bb4YzHsckCLuIgzEhVinsq70daEWLZnk7XQx99E/6UtJzYZwvpxi8+i3l8kZF66L+X2syCAcj33mdbEOadHj5U0WqBi0ImpuVHN+o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903503; c=relaxed/simple;
	bh=0dklnLm2zDUcpBvg4jDM4Sn7uVkMRtZQA9j68QFA1Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkJT2vMtu30Rf6+Hm73QyBMgerfiWETnJIuJeqWG2dHtWmcUafgGJtdMVKtYVGk4U3bsw3Q8S9PEaS0pu5wGKbVp/hP7gRTIOJ6k04uxIRkvlgpS/wje4eYy7knKMKZN565HO1EWXUoQXY+n1bPYnelTWpjdYMAjIl0IcSKJ+cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2miH5x9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2miH5x9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4064BC2BCC4;
	Mon,  4 May 2026 14:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903503;
	bh=0dklnLm2zDUcpBvg4jDM4Sn7uVkMRtZQA9j68QFA1Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2miH5x9B7ACxlubqha66t4fw/luUljO/aRnoK1lQddUotPVB9E+lFclZz4uXwMT0
	 AfSnw0gxbACuq3s1oKbmOiSe6TUqs80eTsnutITYZ521szgxSoQezWB5YR+H+7YZOK
	 Zl63cTOwIsy+/1JQ+65/hBdocOkVZZrvBZPzhCAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.0 259/307] crypto: atmel-aes - Fix 3-page memory leak in atmel_aes_buff_cleanup
Date: Mon,  4 May 2026 15:52:24 +0200
Message-ID: <20260504135152.561498745@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 3fcfff4ed35f963380a68741bcd52742baff7f76 upstream.

atmel_aes_buff_init() allocates 4 pages using __get_free_pages() with
ATMEL_AES_BUFFER_ORDER, but atmel_aes_buff_cleanup() frees only the
first page using free_page(), leaking the remaining 3 pages. Use
free_pages() with ATMEL_AES_BUFFER_ORDER to fix the memory leak.

Fixes: bbe628ed897d ("crypto: atmel-aes - improve performances of data transfer")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-aes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2131,7 +2131,7 @@ static int atmel_aes_buff_init(struct at
 
 static void atmel_aes_buff_cleanup(struct atmel_aes_dev *dd)
 {
-	free_page((unsigned long)dd->buf);
+	free_pages((unsigned long)dd->buf, ATMEL_AES_BUFFER_ORDER);
 }
 
 static int atmel_aes_dma_init(struct atmel_aes_dev *dd)


