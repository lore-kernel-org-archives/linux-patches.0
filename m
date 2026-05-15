Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E37303CB0;
	Fri, 15 May 2026 16:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860896; cv=none; b=fU1kl6EG6wPGQfwBxWMQyQkDfUNti9Gwoc4ual2Fh3tC80I8RKuhuh1Fz+iebcWdCV7j+GNHZ3Ww989B7gku0Rj+1I9+h1Y8I31V5IBUTba2nnZRyOLqMUXZhL/xltSUtFV1LLOb04qJf6cWlKutfS9tGgAYwgiQLmngx2rHN8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860896; c=relaxed/simple;
	bh=IhvB4bemQKh4eNkQapHBtq5lH1MTDev1us0aUYxtgYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrfGRy8vyAQH5KwxpyaA40mZySBaGNCwvfG/JgYcHmc7yUlP9p+bh1BXWAaSFsXPqVp1jAeYM44GvKho1dfWHDsd+S1NAJx4bG/cjC7zrrVRCXT6YxjSlWMO6ZxwJHqcMtzmcW8NvrE02JFejvo7AonBAB2mIN1SxhqQ2x+3oFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFAbAJG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFAbAJG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F141C2BCB0;
	Fri, 15 May 2026 16:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860895;
	bh=IhvB4bemQKh4eNkQapHBtq5lH1MTDev1us0aUYxtgYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFAbAJG73WE0TNio+96W3anBGHkz+ZGnLH5Qbdf9K4CFeWLTI93t7zjHRWoKt94Mg
	 0EDI+K42GEx3OgIBT7QUTD/mR6Ys3mQYe5V4gIB28VCqguG7mfv5Mfi3LSCdvscnCo
	 J/RV86zHufwaOKD5cxdap72wQIkSZXbZ49CRRLTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 121/474] crypto: atmel-aes - Fix 3-page memory leak in atmel_aes_buff_cleanup
Date: Fri, 15 May 2026 17:43:50 +0200
Message-ID: <20260515154717.655181031@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2323,7 +2323,7 @@ static int atmel_aes_buff_init(struct at
 
 static void atmel_aes_buff_cleanup(struct atmel_aes_dev *dd)
 {
-	free_page((unsigned long)dd->buf);
+	free_pages((unsigned long)dd->buf, ATMEL_AES_BUFFER_ORDER);
 }
 
 static int atmel_aes_dma_init(struct atmel_aes_dev *dd)


