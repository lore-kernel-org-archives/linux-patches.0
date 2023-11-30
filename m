Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1004878B;
	Thu, 30 Nov 2023 16:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yy3gkJrX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE37CC433C8;
	Thu, 30 Nov 2023 16:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361898;
	bh=L8kqfVHqCRlotTapj0I1gMnBGu5+AOCIe3jWn2TAmWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yy3gkJrX4Jzwi97HemhOeoEV7OV3ZOz1v2pHD564I5jBV8MJw2dKBWgFU7CHO4tbP
	 hlDG6Pr3+ocutXVx/iyjkbLlb52/uZdW7p5LvnDRtlFL/ip3EmQ1717ELH8aWh5t6f
	 YKohjXvvxwcL1k8D9y6RPFyfFWPSw4kQGjApnQPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 82/82] io_uring: fix off-by one bvec index
Date: Thu, 30 Nov 2023 16:22:53 +0000
Message-ID: <20231130162138.585659057@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 io_uring/rsrc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1351,7 +1351,7 @@ int io_import_fixed(int ddir, struct iov
 		 */
 		const struct bio_vec *bvec = imu->bvec;
 
-		if (offset <= bvec->bv_len) {
+		if (offset < bvec->bv_len) {
 			iov_iter_advance(iter, offset);
 		} else {
 			unsigned long seg_skip;


