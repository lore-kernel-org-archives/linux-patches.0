Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A57126C18;
	Wed,  5 Feb 2025 13:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763406; cv=none; b=mzJo5IBZwpIlDYGv3RLS8LzE6ehnZVV/JrUZATl+A7NXRgLfozR4LiVId380pi0H5D5ZHWTaaZErqfsU8zcKbMD1bCpw73buy/393md96HxzvWvryeljCROqVVXcm1YYcsuY7ZWnEGATcWVsB80CIxLqLfDudXI9woUdWM9rZCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763406; c=relaxed/simple;
	bh=SZvKcqii7oeOY18DpuZSqBDIebjRq7a7OoN4deolcSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMh3Ge7WI1RbvW19/uT7p0lbxXjSm1we3bSZ7ojGbaIdPGDSd5u8LUPboGoYCf/5GKxkDeFSzkYGN9iB1WUTxP8/rhg4vpe9REP4NVuWbq4z7PtZWXsFuMkdyYODrhVtex2jQHyI0Q3V+aa5eeueGEFaDgCkGL5jrb2vALg0Oh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7hCkx+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7hCkx+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BFEC4CED1;
	Wed,  5 Feb 2025 13:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763406;
	bh=SZvKcqii7oeOY18DpuZSqBDIebjRq7a7OoN4deolcSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7hCkx+rBptepcUaKbGCZJoAqYZ9b45jhNXXg75wzzNz5xR8/tVji7vta3DgdLU2q
	 D3GwqXoKWfVolP3/oOTwYtP4zk939ukBFuPLp6dqw4a8rqJpzAgh8UO8vu7aqA+/8B
	 hkQw29MB8I64VyiKYOal4yNNCuiwGWzmcLdwXV7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/590] block: copy back bounce buffer to user-space correctly in case of split
Date: Wed,  5 Feb 2025 14:36:04 +0100
Message-ID: <20250205134455.589063243@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 031141976be0bd5f385775727a4ed3cc845eb7ba ]

Copy back the bounce buffer to user-space in entirety when the parent
bio completes. The existing code uses bip_iter.bi_size for sizing the
copy, which can be modified. So move away from that and fetch it from
the vector passed to the block layer. While at it, switch to using
better variable names.

Fixes: 492c5d455969f ("block: bio-integrity: directly map user buffers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Link: https://lore.kernel.org/r/20241128112240.8867-3-anuj20.g@samsung.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 88e3ad73c3854..9aed61fcd0bf9 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -118,17 +118,18 @@ static void bio_integrity_unpin_bvec(struct bio_vec *bv, int nr_vecs,
 
 static void bio_integrity_uncopy_user(struct bio_integrity_payload *bip)
 {
-	unsigned short nr_vecs = bip->bip_max_vcnt - 1;
-	struct bio_vec *copy = &bip->bip_vec[1];
-	size_t bytes = bip->bip_iter.bi_size;
-	struct iov_iter iter;
+	unsigned short orig_nr_vecs = bip->bip_max_vcnt - 1;
+	struct bio_vec *orig_bvecs = &bip->bip_vec[1];
+	struct bio_vec *bounce_bvec = &bip->bip_vec[0];
+	size_t bytes = bounce_bvec->bv_len;
+	struct iov_iter orig_iter;
 	int ret;
 
-	iov_iter_bvec(&iter, ITER_DEST, copy, nr_vecs, bytes);
-	ret = copy_to_iter(bvec_virt(bip->bip_vec), bytes, &iter);
+	iov_iter_bvec(&orig_iter, ITER_DEST, orig_bvecs, orig_nr_vecs, bytes);
+	ret = copy_to_iter(bvec_virt(bounce_bvec), bytes, &orig_iter);
 	WARN_ON_ONCE(ret != bytes);
 
-	bio_integrity_unpin_bvec(copy, nr_vecs, true);
+	bio_integrity_unpin_bvec(orig_bvecs, orig_nr_vecs, true);
 }
 
 /**
-- 
2.39.5



