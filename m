Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E90CBA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8E0C433D2;
	Tue,  7 Mar 2023 17:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211204;
	bh=n6LUhVn7bdVk4clH3u1syOhGDn86LCozKVda6/RIdko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtpQr0p3BQdAPmCAkRX4GgtMLRyGMy7y26imJS7VUHGSsuZruAQ1NaKaXgI2vgEas
	 pZs4buNFLvxZWNIvPr768TrJZEuZuh6WnPJ+rQrsr5a+cV+HucN3r+PyCDBNM+ZVY7
	 xTQOzE5WPsqhiMmecD6Lhavm/yJzmddDTxJyHxeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 0759/1001] io_uring/rsrc: disallow multi-source reg buffers
Date: Tue,  7 Mar 2023 17:58:51 +0100
Message-Id: <20230307170054.677971181@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

commit edd478269640b360c6f301f2baa04abdda563ef3 upstream.

If two or more mappings go back to back to each other they can be passed
into io_uring to be registered as a single registered buffer. That would
even work if mappings came from different sources, e.g. it's possible to
mix in this way anon pages and pages from shmem or hugetlb. That is not
a problem but it'd rather be less prone if we forbid such mixing.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1162,14 +1162,17 @@ struct page **io_pin_pages(unsigned long
 	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
 			      pages, vmas);
 	if (pret == nr_pages) {
+		struct file *file = vmas[0]->vm_file;
+
 		/* don't support file backed memory */
 		for (i = 0; i < nr_pages; i++) {
-			struct vm_area_struct *vma = vmas[i];
-
-			if (vma_is_shmem(vma))
+			if (vmas[i]->vm_file != file) {
+				ret = -EINVAL;
+				break;
+			}
+			if (!file)
 				continue;
-			if (vma->vm_file &&
-			    !is_file_hugepages(vma->vm_file)) {
+			if (!vma_is_shmem(vmas[i]) && !is_file_hugepages(file)) {
 				ret = -EOPNOTSUPP;
 				break;
 			}


