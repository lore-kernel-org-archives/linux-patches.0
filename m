Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC37322C76;
	Mon, 18 Aug 2025 14:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526490; cv=none; b=lh03g3ea3YFYiwAlUeAF7a2+5y0BbHr2zFEt+coYEy5EKnzKgrEZdygld2rinJAMr5lfC7Ws47aTQBEjgFiSlJYHINtkD5WlyOQfz/Uph4G9lo5UXoU72HC7DyDBPjDIBd0/7yJfSDGlfirFHuBzjJyL8f4wIyQvXLznb2i+i6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526490; c=relaxed/simple;
	bh=0mzw33OvuhkoKZ5td+4GnAUakp1bZbYeMO7lL2osx4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIwWbeNxJUvfoa9/AaRhSIDGu2StI51JfqHPIOYjVwrhtje3ZxellOqoHwz/xKhT7gKVWvb8rW+pqciPiLnZb7AAg3orvkA2Nf1Ti/6q/uMLwPDg9tElUBmQCgp1CYWFSMMpPrVMdMipkjOED+e55OF2w07kC0/Klq/TYKOLY10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEYKkTyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEYKkTyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D664C4CEEB;
	Mon, 18 Aug 2025 14:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526490;
	bh=0mzw33OvuhkoKZ5td+4GnAUakp1bZbYeMO7lL2osx4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEYKkTykYa5eHpPDg+o2IXp+B7pGzBR6ZmGckQnOreZm0u+2BMsoxa9ftC3DvOmSB
	 vrNC2Q63J0PrYeZioASZkahSvdPDfj+/jMCIUig7nte0Qr7n588PbGWh5rIKJ1g3z+
	 Nurr5MrKzxMxCPMTAKUE9/cV2Ar0XGAZl3H7aFLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.16 570/570] io_uring/zcrx: dont leak pages on account failure
Date: Mon, 18 Aug 2025 14:49:17 +0200
Message-ID: <20250818124527.838787416@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 6bbd3411ff87df1ca38ff32d36eb5dc673ca8021 upstream.

Someone needs to release pinned pages in io_import_umem() if accounting
fails. Assign them to the area but return an error, the following
io_zcrx_free_area() will clean them up.

Fixes: 262ab205180d2 ("io_uring/zcrx: account area memory")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/e19f283a912f200c0d427e376cb789fc3f3d69bc.1753091564.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/zcrx.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -187,15 +187,13 @@ static int io_import_umem(struct io_zcrx
 
 	mem->account_pages = io_count_account_pages(pages, nr_pages);
 	ret = io_account_mem(ifq->ctx, mem->account_pages);
-	if (ret < 0) {
+	if (ret < 0)
 		mem->account_pages = 0;
-		return ret;
-	}
 
 	mem->pages = pages;
 	mem->nr_folios = nr_pages;
 	mem->size = area_reg->len;
-	return 0;
+	return ret;
 }
 
 static void io_release_area_mem(struct io_zcrx_mem *mem)


