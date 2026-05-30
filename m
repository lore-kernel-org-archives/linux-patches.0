Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B5F332919;
	Sat, 30 May 2026 16:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160142; cv=none; b=OiLBnOo5HMO6ruUqtMZ63GlOrifBz1ttBOs0FCEGA5x46x72G6U/hSZtpWZQ2K9KvcigGKT99T+EOTWgxulqM3/96B0iDFnSPGCzUgd6PY7YbDMHNQ+ySi/0E9wEQVuQ6t8d4U1WPU0l+M3PDinjt1dkC7WXZqUE60LI0UspUZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160142; c=relaxed/simple;
	bh=rBPR1JN9bsp4boJqTFmkWD3hnkcNtNwSGRmZdEkwOU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDc4Wl9Ufromxw35LHFU+H3XrQxZfnrQDKiGYTOZ4R15SPbCpTkbfGuAOspRTMHupVXb/o42yRxGnn+4y0Npp4WbFq377iQ1rwNGZJHzLuZ5yd+n9oq9kCg8jN0PC/TaKWDpUOGy/xCZlYsvME35F0Yr4s6NMqt6X6P8HClJYFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHkf7OR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHkf7OR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5593A1F00893;
	Sat, 30 May 2026 16:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160141;
	bh=n6HJvQ/ZjKgD4XAKk8KWD2ffj1Rdlb48/XB7nTG6jOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oHkf7OR/5WBKXE/b/iDjzdMpW1z6/lf0IQ+NkU5rin6PmuhSFo4yqmn1Ja/lpQNmf
	 FYJw5VvFNzArFI8RZV+3Ggf8Qh8V7H1DkJ2xR3xCAvqItJJvsVUb70lW16f5gkcbUa
	 BaIDuhHOey9/L4BA2v0HClSpTZAMYxS7VJfcJp20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 256/969] crypto: atmel-aes - Fix 3-page memory leak in atmel_aes_buff_cleanup
Date: Sat, 30 May 2026 17:56:20 +0200
Message-ID: <20260530160307.548962415@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2329,7 +2329,7 @@ static int atmel_aes_buff_init(struct at
 
 static void atmel_aes_buff_cleanup(struct atmel_aes_dev *dd)
 {
-	free_page((unsigned long)dd->buf);
+	free_pages((unsigned long)dd->buf, ATMEL_AES_BUFFER_ORDER);
 }
 
 static int atmel_aes_dma_init(struct atmel_aes_dev *dd)


