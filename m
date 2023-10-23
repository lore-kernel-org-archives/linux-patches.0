Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2F5F4FE
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWO0Q+mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15ADEC433C7;
	Mon, 23 Oct 2023 11:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059471;
	bh=x6Ds/ZipGr23wXSXqpvYxfsIhRj44cU0qki0aR6f3RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWO0Q+mbDyPFbqrAfuYzWMt+moGohwsR+S7FWo7yJtu+6E81uQl1xmJnuB1xRI/0C
	 DwkH94P6SaVvtRysNTniBzzcItww+KTHYDaN0YKBj1GdRK7kSAzQX4dTEBuKlgsY5m
	 9TU2+K2Mq33IP1usKCGs5lrszyAZtGv4YiDZVIEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.5 189/241] nvme: sanitize metadata bounce buffer for reads
Date: Mon, 23 Oct 2023 12:56:15 +0200
Message-ID: <20231023104838.488352848@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

commit 2b32c76e2b0154b98b9322ae7546b8156cd703e6 upstream.

User can request more metadata bytes than the device will write. Ensure
kernel buffer is initialized so we're not leaking unsanitized memory on
the copy-out.

Fixes: 0b7f1f26f95a51a ("nvme: use the block layer for userspace passthrough metadata")
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/ioctl.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -108,9 +108,13 @@ static void *nvme_add_user_metadata(stru
 	if (!buf)
 		goto out;
 
-	ret = -EFAULT;
-	if ((req_op(req) == REQ_OP_DRV_OUT) && copy_from_user(buf, ubuf, len))
-		goto out_free_meta;
+	if (req_op(req) == REQ_OP_DRV_OUT) {
+		ret = -EFAULT;
+		if (copy_from_user(buf, ubuf, len))
+			goto out_free_meta;
+	} else {
+		memset(buf, 0, len);
+	}
 
 	bip = bio_integrity_alloc(bio, GFP_KERNEL, 1);
 	if (IS_ERR(bip)) {


