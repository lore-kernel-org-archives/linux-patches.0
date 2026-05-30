Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4593A7848;
	Sat, 30 May 2026 18:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165810; cv=none; b=kuDtd7caeP0qvMfmKj6hJCsYK/Xe4khEHzKrM1DInzpJn2qEzRALiUkGjO1a8qHKpGGx8teFB5el53GhOQ52qeK6/WLTosJUGBkKEKC3jcw5Czo4ULkmISoDYVTM620kyCqpbugzivxDVSslN+WvzzOIbehp70igMBlMVR9j/Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165810; c=relaxed/simple;
	bh=9FcjaCRUPmHDJxddPQI3wp9R46WYLTxwvxIjwcYh9sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUvtpEl+OwVoq6Dw2BQircPe9p7mPYcSttfzGWBld7UCgGGxZbSuVU95LE4CmtYVfTPBB6dZ5l9UIFms+2GOIIfvysMaagCnBV+DXTngZjODtoadqmy9aVTi/uEmfWqJwG3/3lPEqNi5clKcViIA0PWLGleto9PVlnQDa26smAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbqDfaoF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbqDfaoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922E11F00893;
	Sat, 30 May 2026 18:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165809;
	bh=ck5DRlDOsl/88rzjwFKdOTFB42FhJSSlHIaktyVhDkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EbqDfaoFun0ly/ZozUu/y+c5Hwpq8EfA1gGXCesnZ8QTT8fNwFrcQY5UeYfSd/ytC
	 BUQtqg7ahMGSbzuv+vzwJGYKqPfiD1zJFsAzYtJJNhv5i+MDKzrPOF1G6wxYqvkxDn
	 eWTKELsn/2sfyENTDFm+/u79pXKlIxr1WHAR8FTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 189/589] crypto: atmel-aes - Fix 3-page memory leak in atmel_aes_buff_cleanup
Date: Sat, 30 May 2026 18:01:10 +0200
Message-ID: <20260530160229.867249943@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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
@@ -2265,7 +2265,7 @@ static int atmel_aes_buff_init(struct at
 
 static void atmel_aes_buff_cleanup(struct atmel_aes_dev *dd)
 {
-	free_page((unsigned long)dd->buf);
+	free_pages((unsigned long)dd->buf, ATMEL_AES_BUFFER_ORDER);
 }
 
 static int atmel_aes_dma_init(struct atmel_aes_dev *dd)


