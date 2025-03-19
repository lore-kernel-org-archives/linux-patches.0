Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE90209F54;
	Wed, 19 Mar 2025 14:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395231; cv=none; b=XsoWHfuIhyVwH21sYiBMGkWm16odFYjfFURzZRr99DkNNOEsRxtdKT5YUnC0uDx72bhSCTstQUGfc6dkIXHq/i7M/ABJ7V0nRlS0PVRtPZpZNuAy9mQmzHySCY5GIOysOWbIr9X2EIbotQhMgwKuBg5IyNwyj9gpDEOSjb1J+XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395231; c=relaxed/simple;
	bh=pw2BG4Gdzzxd+eZRH4o0TdfAInWR0UeSqVCilMPVk4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCI3E5bDm0lc0MhiV55vONDmCjouLzYXKusS9upLkhzbPNtwKskULbtwT34neDcW+Xs/xo1wrvZsoTv/jphydjIYwR39936rjJ7UOCzHm5GkjUtlLRSgWvtQ78y8l3/hiNFxDO68Z8J5x86YaKVs7YRNmc2hp/jcXeWLWY3t7X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzlbZiHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzlbZiHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4AEC4CEE8;
	Wed, 19 Mar 2025 14:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395231;
	bh=pw2BG4Gdzzxd+eZRH4o0TdfAInWR0UeSqVCilMPVk4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzlbZiHDmjYuZO/RBNgMnmLdlNzPp07gwR+tVSHauphZLlr0pXwJcu2m/fsSZ7evT
	 CLbAxrk/V7ji6rMwz8ta8zuCTDo6GDcotatMw0BZzgzeiGq1D5XZvrN2Wu62laVr65
	 zzEx8FHCHIS8FDJuN6oHyJlQun7cTCasT29j8RQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 102/166] io_uring: use unpin_user_pages() where appropriate
Date: Wed, 19 Mar 2025 07:31:13 -0700
Message-ID: <20250319143022.780661414@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 18595c0a58ae29ac6a996c5b664610119b73182d upstream.

There are a few cases of open-rolled loops around unpin_user_page(), use
the generic helper instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -458,8 +458,8 @@ static int io_pin_pbuf_ring(struct io_ur
 			    struct io_buffer_list *bl)
 {
 	struct io_uring_buf_ring *br = NULL;
-	int nr_pages, ret, i;
 	struct page **pages;
+	int nr_pages, ret;
 
 	pages = io_pin_pages(reg->ring_addr,
 			     flex_array_size(br, bufs, reg->ring_entries),
@@ -495,8 +495,7 @@ static int io_pin_pbuf_ring(struct io_ur
 	bl->is_mmap = 0;
 	return 0;
 error_unpin:
-	for (i = 0; i < nr_pages; i++)
-		unpin_user_page(pages[i]);
+	unpin_user_pages(pages, nr_pages);
 	kvfree(pages);
 	vunmap(br);
 	return ret;


