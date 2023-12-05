Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6946B6FB1;
	Tue,  5 Dec 2023 03:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSMY+WAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39EBC433C8;
	Tue,  5 Dec 2023 03:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747417;
	bh=su2IBED/KfxjWr0u67oCnOgD66cOFsGAr+xnmEbJKzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSMY+WAUoyQVlW/CNSTxfVzRqJV5QaT5N+MfG6O4PiSxW8gHshqeXNvy2y4/YROxJ
	 3UfzSuXQ7I7RSdlZaVC+2P3kg02JLX+CTluwA0wmsH8g9AnF3+5D7Mc5XrFf8o3VdT
	 sEAwwTJAGC1AF8nfy28RoWDQhjWPaZc9NONiB3mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 069/135] io_uring: fix off-by one bvec index
Date: Tue,  5 Dec 2023 12:16:30 +0900
Message-ID: <20231205031534.804689098@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

commit d6fef34ee4d102be448146f24caf96d7b4a05401 upstream.

If the offset equals the bv_len of the first registered bvec, then the
request does not include any of that first bvec. Skip it so that drivers
don't have to deal with a zero length bvec, which was observed to break
NVMe's PRP list creation.

Cc: stable@vger.kernel.org
Fixes: bd11b3a391e3 ("io_uring: don't use iov_iter_advance() for fixed buffers")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Link: https://lore.kernel.org/r/20231120221831.2646460-1-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3149,7 +3149,7 @@ static int __io_import_fixed(struct io_k
 		 */
 		const struct bio_vec *bvec = imu->bvec;
 
-		if (offset <= bvec->bv_len) {
+		if (offset < bvec->bv_len) {
 			iov_iter_advance(iter, offset);
 		} else {
 			unsigned long seg_skip;


