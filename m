Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E308034F484;
	Fri, 21 Nov 2025 13:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732213; cv=none; b=ferTVpUa0AXfyHJM+Qt1K6YjeVwCZW4bD+/Na6S8pHFEpSWOpCUnrEtocwxsCSC6yiBxWLgW+qg8a1I4HNLQH9qesxpgnPVASwikncFgN427XcdhyEWTibl2+RQCaFiY35EG3kzKDievwmZsHJwEiudcNiv/HDGAGJ4M2kBv1vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732213; c=relaxed/simple;
	bh=C92UeLsZ2HoJ/WDhw9EmuO5Uef4xm7aGyUD1c5vpoMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RW1AWmJuM2gG4bvGvy+MlSzRYGAoYGid6GSUUUK1wNZV+fCrcslTMw/qosvDsMMOedIlsKPkLQWWLhpLVUlZstPAmlPoM/j2Z+saLTTVCvAFlqurs+iX9FLYykdmAQGYfXNeoGqRr/mbmAAHFO+dzwEe+dFPCLxdsGNvzcuBW7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HEf2O0fK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HEf2O0fK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CFDC4CEF1;
	Fri, 21 Nov 2025 13:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732212;
	bh=C92UeLsZ2HoJ/WDhw9EmuO5Uef4xm7aGyUD1c5vpoMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HEf2O0fKhzz5AyRu1ns50oddbBHlswi+syi1grn5iDfdbQ5X7zoBmJkaWsEfvQt+0
	 PTv0bcV0v/2d79QE8/HB7tHWVRoCtbRFq4n9WTwgZWyhoXpnInQUKKfACEPBAtyi9H
	 CFXTiXWLdk/1ItbsZwjAe2yaLFhICmo7oYIa5W8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 042/529] block: fix op_is_zone_mgmt() to handle REQ_OP_ZONE_RESET_ALL
Date: Fri, 21 Nov 2025 14:05:41 +0100
Message-ID: <20251121130232.498712733@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -517,6 +517,7 @@ static inline bool op_is_zone_mgmt(enum
 {
 	switch (op & REQ_OP_MASK) {
 	case REQ_OP_ZONE_RESET:
+	case REQ_OP_ZONE_RESET_ALL:
 	case REQ_OP_ZONE_OPEN:
 	case REQ_OP_ZONE_CLOSE:
 	case REQ_OP_ZONE_FINISH:


