Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC601C68F;
	Mon,  4 May 2026 14:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904739; cv=none; b=LdUn3eq/JXfDieptvla9TS5ZzKgCM1x2OdAK+gzZoTyT6CyFK+vs4d6l6Y9ViXykTxpgMk5qie/bQ/H9SVPoj24uo9mw1XqK9vNXhPoPLVQCM02A+50NY6Z4X/vcI3j0gkXeCwKJhB3VwBZNIfl/ErGn7f86Vms5rgz/uzysgaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904739; c=relaxed/simple;
	bh=PDbSPQ/oVAMj0pzR4ei45S4HXWKXloe7qHmmBB0Z1PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZM1Oq+xACT1KunId4B4Z+AYgcL3IznjvRoctSlo3MyKLb7rDV5metJq8A+Dj5oIMyiCO6E80BcZ/LMz2RYG9n8bQI1rWQ2mc8Ez9GcISni78yRMVTdAS9t6GpJvdwyRepSht3bX6f6JxVJqUJaE3sR/M3D2tACNvdncsVCiYC+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rmsb0lZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rmsb0lZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85A0C2BCB8;
	Mon,  4 May 2026 14:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904739;
	bh=PDbSPQ/oVAMj0pzR4ei45S4HXWKXloe7qHmmBB0Z1PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rmsb0lZlINYWkLccG4LPdiC4Rm0DxXPYd6LfVVmVASIKkitYoSY8vL5Dwnv/DLNsf
	 AzbOXflNDz+zWliS5pbuhQ3Vhjj7gruJc1kvyPQg9j2nFYDNupv6YC8M4ztOFFZMpE
	 jdOwjDfsEfpSuptr/IPmhCxwtqPRIpZoDYI4dtL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 155/215] crypto: atmel-aes - Fix 3-page memory leak in atmel_aes_buff_cleanup
Date: Mon,  4 May 2026 15:52:54 +0200
Message-ID: <20260504135135.840225518@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2130,7 +2130,7 @@ static int atmel_aes_buff_init(struct at
 
 static void atmel_aes_buff_cleanup(struct atmel_aes_dev *dd)
 {
-	free_page((unsigned long)dd->buf);
+	free_pages((unsigned long)dd->buf, ATMEL_AES_BUFFER_ORDER);
 }
 
 static int atmel_aes_dma_init(struct atmel_aes_dev *dd)


