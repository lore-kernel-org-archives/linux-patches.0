Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEC630E831;
	Wed,  3 Dec 2025 15:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775908; cv=none; b=ErvWXAJSA4ZypyDXK3QTjXpYanyJdWXebjgS9GXLpy/DgN5Dt9wKGlYBhFQNIMYxFHWB34K1zjS0Ei28COTvzSyfcq0JcalqUIU4T4+x3RkvOIMHVEk3PpovJb8vG3+PFLGxNI6/6U+DMBpcOC+LG/XrCckEgI4kjsdb76t/RUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775908; c=relaxed/simple;
	bh=Dq4xM9iqSr/GH88OdaErtwmlJ4LgD38Ti4fvAMzFdPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJzaNeoVrsyfLKfysuCcdPBzJpiGHPb0H3qClMOZTsP0nHLvzDy/j5Oydz8tvgTVsYs+m/HXQZgP8IN1Jj3ppYEaDavGH1G9meMLkbdPVT95SzxJpbqrk1ITgI4Nhtye+OVugKLyZQ9P7dk2JcFO5LVONhtW4/1OM4sPcbbFuL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7nRtdFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7nRtdFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E71C4CEF5;
	Wed,  3 Dec 2025 15:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775908;
	bh=Dq4xM9iqSr/GH88OdaErtwmlJ4LgD38Ti4fvAMzFdPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7nRtdFbJlDjx+lzMGK+nr5EmMIXx2Q8wYSNBFcnsI/auh0K4z8dltR+9LweAM2ex
	 ZS2P0osXZxXXVQszN71y7Ctz/enuaORC3OI8g84FomepHbJPBaKJ6LCitPqqUNhAQv
	 vGy2USvLhvrSKOQSGAFMAeMRLGjeTE0pTAVqvSl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 023/300] block: fix op_is_zone_mgmt() to handle REQ_OP_ZONE_RESET_ALL
Date: Wed,  3 Dec 2025 16:23:47 +0100
Message-ID: <20251203152401.316473649@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -496,6 +496,7 @@ static inline bool op_is_zone_mgmt(enum
 {
 	switch (op & REQ_OP_MASK) {
 	case REQ_OP_ZONE_RESET:
+	case REQ_OP_ZONE_RESET_ALL:
 	case REQ_OP_ZONE_OPEN:
 	case REQ_OP_ZONE_CLOSE:
 	case REQ_OP_ZONE_FINISH:


