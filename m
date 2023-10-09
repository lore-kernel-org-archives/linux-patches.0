Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDB719448
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYwh+jl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36983C433D9;
	Mon,  9 Oct 2023 13:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857013;
	bh=U9wp2ydfRlmd5RmcTVGSjXOFug/S45Qn+x6dxwpQcIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYwh+jl9hMkz3e/66XzqBay/c45mqDlw1KM0h52nm36dNYQkY4r4vLimHUb1MGxhB
	 khncGdNMTO4XsOd9Sjf8uD5xo2/qdT7HNwkHptV4pn7nUXdxqzoZ5JxxWfLEGqEcNh
	 gOuXlsucTVrmjodE8kvc8hpeYtlRyClWro6H1aXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.5 040/163] io_uring: dont allow IORING_SETUP_NO_MMAP rings on highmem pages
Date: Mon,  9 Oct 2023 15:00:04 +0200
Message-ID: <20231009130125.112943803@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 223ef474316466e9f61f6e0064f3a6fe4923a2c5 upstream.

On at least arm32, but presumably any arch with highmem, if the
application passes in memory that resides in highmem for the rings,
then we should fail that ring creation. We fail it with -EINVAL, which
is what kernels that don't support IORING_SETUP_NO_MMAP will do as well.

Cc: stable@vger.kernel.org
Fixes: 03d89a2de25b ("io_uring: support for user allocated memory for rings/sqes")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2678,7 +2678,7 @@ static void *__io_uaddr_map(struct page
 {
 	struct page **page_array;
 	unsigned int nr_pages;
-	int ret;
+	int ret, i;
 
 	*npages = 0;
 
@@ -2708,6 +2708,20 @@ err:
 	 */
 	if (page_array[0] != page_array[ret - 1])
 		goto err;
+
+	/*
+	 * Can't support mapping user allocated ring memory on 32-bit archs
+	 * where it could potentially reside in highmem. Just fail those with
+	 * -EINVAL, just like we did on kernels that didn't support this
+	 * feature.
+	 */
+	for (i = 0; i < nr_pages; i++) {
+		if (PageHighMem(page_array[i])) {
+			ret = -EINVAL;
+			goto err;
+		}
+	}
+
 	*pages = page_array;
 	*npages = nr_pages;
 	return page_to_virt(page_array[0]);


