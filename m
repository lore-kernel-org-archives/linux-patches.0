Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AB0246333;
	Tue, 11 Nov 2025 00:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822336; cv=none; b=ar+Dlvc4R8qbLWUaKLKLTzLQ18z0eBG/Ti70OCSWIlho0wPXWIzdB2wkSLR9fFnSAp65C7DjUrYWu+NyNLVZJpRbFop2M4pPzS/NXOSqp+CarbzT3kFVm7u3ZDV6miQjYr6wcYKFkubKvalyT5oBPkgZ/c7yPL01I0LacvsR578=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822336; c=relaxed/simple;
	bh=s+5jTAvKU5MMKmi9ur0O0+vIEa8JRmd4GTKnRmQqbdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKjPCDZA6dqu1f3q0cHXy4bcCo6Go4WXg4ADwqAoC8u+sXqt9hGhAn585o/Jda0a8PlnQsKGO9t1l30UJtqjRmr37utTSgqohHIHS0ucJXzzawVw0SMmfWCAaO9fV2MMIdqp0o+8DMIiLYyBlmPnseffwM7zDN/oOWjop4Uwbko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDthhZVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDthhZVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC67C16AAE;
	Tue, 11 Nov 2025 00:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822336;
	bh=s+5jTAvKU5MMKmi9ur0O0+vIEa8JRmd4GTKnRmQqbdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDthhZVlkJdphRafd/ipZENIQVTnDJpozwtBdwTG1JSEluQtIOOqAG+avQX3yurWB
	 oHWYejTWX4amfJrf+Jjc6bAE7xtfUQj2rTSVOkZ97UJpx2PKxIPkvmgb5sHQPx/UOR
	 LTwLEUqjvuYVcOjqr/Z+rzWDqCrDYoa2OyVBRDKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.17 088/849] block: fix op_is_zone_mgmt() to handle REQ_OP_ZONE_RESET_ALL
Date: Tue, 11 Nov 2025 09:34:18 +0900
Message-ID: <20251111004538.544210756@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -480,6 +480,7 @@ static inline bool op_is_zone_mgmt(enum
 {
 	switch (op & REQ_OP_MASK) {
 	case REQ_OP_ZONE_RESET:
+	case REQ_OP_ZONE_RESET_ALL:
 	case REQ_OP_ZONE_OPEN:
 	case REQ_OP_ZONE_CLOSE:
 	case REQ_OP_ZONE_FINISH:


