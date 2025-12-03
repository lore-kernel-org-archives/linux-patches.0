Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45EA30FF2F;
	Wed,  3 Dec 2025 15:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777518; cv=none; b=puSSuwUed5OeiYtnQfmubvw3t6JttS6AqSRqUr9lM5z+PlrcrCh1/6jpn9NZJg4hYHLgPPcIpbm2HFH1oDUryfgVT4JWYUc6uC9Nx1wEHxRay49LtHZ+3X9HY6emaqJrZtEtHCfslwYFZ+lpJUx4JrvDRULnodtfbQVtFmGjeTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777518; c=relaxed/simple;
	bh=GM5xW2oW1B0gmbRJx0EkNHotaMT1Ix9ZG6MAjAy63e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnEeklipng2R5NpQEugv8nIJ1fRUkaUMkuPgjq92Lv3HeDs8uHJ6Iypsy3HyswYJ4J1KsMXoolyyMaplxVoxmsJ6ktPpI4p6mox9crstQuvup8UUuFPodICZFh68n0eMJZLbzsCz6a1i9Vw9t3OyyXKrV1Mxhn9KX6oHDjcuj0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBKZVVtv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBKZVVtv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF98C116C6;
	Wed,  3 Dec 2025 15:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777517;
	bh=GM5xW2oW1B0gmbRJx0EkNHotaMT1Ix9ZG6MAjAy63e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBKZVVtvlh0KVumLidsMwezNRqSq/z0E8r8wlnF7BHPjr/5sM9qPafH5ZlQMsM/L7
	 b/7lQQE6u9WjWyFGR3qXvFGfy9vHwiYQIloyHOs2jTzAf5rPZjFOmsQ8U41qMkivwe
	 qd5mgH+WQM4oml7N7RYt5piNS/bAoCfNQ/IXAfLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 030/392] block: fix op_is_zone_mgmt() to handle REQ_OP_ZONE_RESET_ALL
Date: Wed,  3 Dec 2025 16:23:00 +0100
Message-ID: <20251203152415.209230742@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 12a1c9353c47c0fb3464eba2d78cdf649dee1cf7 upstream.

REQ_OP_ZONE_RESET_ALL is a zone management request. Fix
op_is_zone_mgmt() to return true for that operation, like it already
does for REQ_OP_ZONE_RESET.

While no problems were reported without this fix, this change allows
strengthening checks in various block device drivers (scsi sd,
virtioblk, DM) where op_is_zone_mgmt() is used to verify that a zone
management command is not being issued to a regular block device.

Fixes: 6c1b1da58f8c ("block: add zone open, close and finish operations")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blk_types.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -481,6 +481,7 @@ static inline bool op_is_zone_mgmt(enum
 {
 	switch (op & REQ_OP_MASK) {
 	case REQ_OP_ZONE_RESET:
+	case REQ_OP_ZONE_RESET_ALL:
 	case REQ_OP_ZONE_OPEN:
 	case REQ_OP_ZONE_CLOSE:
 	case REQ_OP_ZONE_FINISH:


