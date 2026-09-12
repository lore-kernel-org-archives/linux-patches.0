Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22A935F602;
	Sat, 12 Sep 2026 09:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203842; cv=none; b=Utr4R/UNt0bIfKXJ2pQFQ8YMAe55fNt94x12SsuXcluPdL/xB8w7QQRQ9j2zQLGeQa+riwtxMHzOd4oE2xNS2x4ktJs9Rf8vxpAINAIe76qKs3GIADDXvRJWOX25GyIFLfcO7JsNIaZUCxwQgH92FD5bAsDpJcpHRMLDBf1+H0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203842; c=relaxed/simple;
	bh=ti7KJtyxlyxzqNFRzdv8hCWT5GBmViVsbaooz8VdelU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uq97wYRl82Fvvyw7vq5J4CgZJXjgukdqdcIlQt5OIB+P0d1CV8VYr83WILEACOrI4pP/R8HCT0amXUKdpmz9ww1r3CCupx3jrtb/gQKDX61PlT+hbpG/kBSoso+jKaWtxsGG8rwpzebQPpEOsknPmks8IuGEqCqJ0U1fk8Nh+1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KLrGzncY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KLrGzncY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915FB1F000FF;
	Sat, 12 Sep 2026 09:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203840;
	bh=5kq3RjcR46pseWMgvelC57IfhisZNT4QXFVwN0xfNbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KLrGzncYzWpfEfLFw5Dsv3zAqEp4ohqrX+R3xWlcrd66CPJ2Lav+N9sIY7jQIOZwl
	 S1F0Bs0L3/VrxS9+GWgcgFKFwzSeJ2SHTpO6OWUOu39F4nGlio5do/gMdINeJxiqwX
	 YmhPo6k/+FyyHD+klNr2mCYh9BCmS8sf18QrVWt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Sang <sangyao@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1490/1815] ublk: reject non-power-of-2 zone sizes in SET_PARAMS
Date: Sat, 12 Sep 2026 08:54:00 +0200
Message-ID: <20260912065723.983433997@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Sang <sangyao@kylinos.cn>

[ Upstream commit 2707acf1856da266139986c9398ad722fd4f48c0 ]

UBLK_F_ZONED uses params.basic.chunk_sectors as zone size. ublk uses
ilog2(chunk_sectors) to get number of zones, so the value must be power
of 2.

If chunk_sectors is 96 and dev_sectors is 96 * 16, userspace asks for
16 zones. But the shift calculation gets 24 zones.

Block layer rejects such zone size when the disk is started. But
SET_PARAMS has already returned success, which is confusing for
userspace. Reject it in SET_PARAMS with other zoned parameter checks.

Fixes: 29802d7ca33b ("ublk: enable zoned storage support")
Signed-off-by: Yao Sang <sangyao@kylinos.cn>
Link: https://patch.msgid.link/20260814023226.354288-2-sangyao@kylinos.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index a5b120b42e493..0bbf1d5a4fbc6 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -970,7 +970,7 @@ static int ublk_validate_params(const struct ublk_device *ub)
 		if (p->max_sectors < PAGE_SECTORS)
 			return -EINVAL;
 
-		if (ublk_dev_is_zoned(ub) && !p->chunk_sectors)
+		if (ublk_dev_is_zoned(ub) && !is_power_of_2(p->chunk_sectors))
 			return -EINVAL;
 	} else
 		return -EINVAL;
-- 
2.53.0



