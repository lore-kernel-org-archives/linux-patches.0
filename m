Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F2834DB6D;
	Wed,  3 Dec 2025 16:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778779; cv=none; b=Z9YZNULFeplGnic7St6c7sBo907fk03kBgIFikPw17261AC5lcuv1H7boHUaNpzvT0oP3nkhpZ6xBpbdYcBGlse95GkiE8ZTAj8BOJEbUmRi/SW1KsC6fFHlj6e2XaTyU6C2vZMcYPmxPN4E4a/7iSZOdMKYtkCCoQQpTdP1f1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778779; c=relaxed/simple;
	bh=pxBwxhE2SowLXuXWwdyoqoNKMuD17lG3phktFh2KsRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0lskbg3v5u4T4yLbYcB2+1KoBBd9kJ10s+0q6GwNZtUP2Y1Ut32d2PbgQBmP9V02ZbBe1q02AeeaTbZSWHdl7SOkmdX7RDvEcAqH1vV0Vykiix0D8SSLo5zERm6U8okoxPcaZY333ztVKEHHdWmqy9YIdmMaJICY3C87gXFfog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9n4QTHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9n4QTHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE4EC4CEF5;
	Wed,  3 Dec 2025 16:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778779;
	bh=pxBwxhE2SowLXuXWwdyoqoNKMuD17lG3phktFh2KsRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9n4QTHAa1J37hzt0bvvymugAA3EsSJ7klsAXnresl+Z8vuRsieyQwSdV5m27JPhr
	 /FqBx2wPBPpKdxx7AhTTxPooUDO5YLjxSNyIuMdUDTly0vtz1lNhXOV+8k2IRYlXBY
	 9kFNKW9aWJs3WV4QnR4tCyUVQXlRRsgpW6QRx08I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 056/568] block: fix op_is_zone_mgmt() to handle REQ_OP_ZONE_RESET_ALL
Date: Wed,  3 Dec 2025 16:20:58 +0100
Message-ID: <20251203152442.749308248@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -519,6 +519,7 @@ static inline bool op_is_zone_mgmt(enum
 {
 	switch (op & REQ_OP_MASK) {
 	case REQ_OP_ZONE_RESET:
+	case REQ_OP_ZONE_RESET_ALL:
 	case REQ_OP_ZONE_OPEN:
 	case REQ_OP_ZONE_CLOSE:
 	case REQ_OP_ZONE_FINISH:


