Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B348E3DE458;
	Mon,  4 May 2026 14:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904200; cv=none; b=T6zm89y82PvC5YqaR5x47v2nV8Y1aAE7Y2pw4efM5gk7aYrC35rE9CgcrX79lYROnzCprEu200Okfb9vlTNyG0nht5Q8yFaLL00da5iiN9mFqZ3oZLF2sVLWXkaAv3bPMWAJJ0qDh2bafseSbY3Z6SC+KMd/n/xQzfTyTxY2kDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904200; c=relaxed/simple;
	bh=ghQbuL8R6Md1DCCsJHXaW1t3zSM59Q6h3UDZ4uv9tjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjb2QC75Ho0o7qM5ErWkkrR5FeC4moG5Bw4D/BSM1KB6sMAU/PvyE/vaHf2imufenfhsRl6QPFIfH4lntVAZzyQmpoeYHlsfX9eeXOhB297gmZQj+03n6Yr4G3ojhbJJrsOdZ5EB25le8+X6zQFxZ2NmbBBwIUFbfXMrAbJVcEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBoIQUDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBoIQUDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47318C2BCF4;
	Mon,  4 May 2026 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904200;
	bh=ghQbuL8R6Md1DCCsJHXaW1t3zSM59Q6h3UDZ4uv9tjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iBoIQUDJnrxZxWZxbwrE216kMhVrzeiheH81peYjSq4oQVvgwHqiFiC8nMWSgGVq5
	 /KsQtbIsVyiNYLHu5L1GiYGcgaa+yrfYXHAmeHTvbBqDcK7FW28THj0MNMkJIxMnAp
	 k9h5K6pLpwxvIvqIy4jGmmkCA5+hTHWSfejzy6LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 222/275] crypto: atmel-aes - Fix 3-page memory leak in atmel_aes_buff_cleanup
Date: Mon,  4 May 2026 15:52:42 +0200
Message-ID: <20260504135151.316311589@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


