Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9317134104B;
	Sat, 30 May 2026 17:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163416; cv=none; b=r4DMOOsiraCvduB2LS5JahNUBpdQip8Q8+sOI51sknnqP20PHve6AhATMa2QabrDW4HxZNp2s6X21p3nYFpMMWQCQGaH0kFV6ymH0pxbe9ioAuHIwzivBhqYUyW93i3D0Xiav9P485BPkQhKkjLCFsNRxvOb2jw8NrvxQW5VrQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163416; c=relaxed/simple;
	bh=+Yo2JfMOnsmZ6JjUMEOsuI7Yhj6BzwRCVYwkgQ/lAfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tl8VRAG9ARARoMzO8lrtQtnCLbJ5u9HsQQiCWh0uJSrhdHzPiytnOsI78YvZogem3eCoU1Odw8Un+Smx+SefUS27199RNrIlCQKg6TRPun97epA3E8MCAsQmy7sAziM3u3eJC7x2PoXss3SqoJg+mDJUh45BjAwIZ0AMwGTV1IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRiuUBHl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRiuUBHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B951F00893;
	Sat, 30 May 2026 17:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163415;
	bh=77l2UOKurVcI1k9ezP6vzJ2aCSoW9jPyw5fZ4z0Xe8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mRiuUBHluc5CF98Fo5wXSGYD/1YI/71YogdS7AYszXRkyiXk7HHYRNHYKRwIJ9La2
	 QSI7/xA4GHqF+s8vpM1pp4A658U2AaRMngqPlEihKVwRTzmGT5XSW/CF0vVcLCJu4x
	 D2qRKtx2nQzeiokxYl1iconqdEuNemy1Vt3aDQ/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 251/776] crypto: atmel-aes - Fix 3-page memory leak in atmel_aes_buff_cleanup
Date: Sat, 30 May 2026 17:59:25 +0200
Message-ID: <20260530160247.019586031@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


