Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2BF47208D;
	Sat, 12 Sep 2026 11:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211385; cv=none; b=o1ubea85Q2IpMKfo2+bd5eGFX+ZZqwgPAxeD8+6LWV3pXoKBPaIn3xYvR1FFum4GA51K/JjyUUUxtDGjm98B3nROdg4Rh+G3VppezNNwE779VCauL2woOQvG0bddooWOe7bzwD5J9VaESZ3iwnaQwkCXe+E3R90gwN9qpxyFdEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211385; c=relaxed/simple;
	bh=AQeVDJgKaSEmQV8C4zJpaC8ZunWeFPLRJx8ZxOqg7+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPeqEJKOy/xoyuPiobQR6Qp6Bz+YD0DmKJIwCZRWdXiPSH556jWXYqddrZBNBUeaE9ziJJ87qk2eQEaBf5Zc+Tbv/MbeS1G7Ba7kLmMhTaZoFbRxz9A7NaUm6DRv8dItfZ9le0NRlSq+v/qveuGLCEsLWL/IsKX8YEGv0VWrinU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdj5RTkp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdj5RTkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4301F000FF;
	Sat, 12 Sep 2026 11:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211384;
	bh=qh1SWR4yruUzwwWR7kstPGyUFgDKxF71KaWaerlvsC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdj5RTkpRhDNKSgsfGs1d8RCPGW71GSPBXaeYJuH7eDYQEWj15iar9fMSaAsJRaEV
	 gbwhs/gY+ks+kjgD8POl/P5rpzRVb6bAJLiaYmSStVmZ1t9ljEAX9wfwxAXfW/T7lE
	 uQODHi8e45LHEChrN6F9Vf6ZciC7zHqHnjVRYx9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Sang <sangyao@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1220/1518] ublk: reject non-power-of-2 zone sizes in SET_PARAMS
Date: Sat, 12 Sep 2026 08:56:29 +0200
Message-ID: <20260912065651.094552571@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d71407fc1f4c8..a11805b29b630 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -603,7 +603,7 @@ static int ublk_validate_params(const struct ublk_device *ub)
 		if (p->max_sectors < PAGE_SECTORS)
 			return -EINVAL;
 
-		if (ublk_dev_is_zoned(ub) && !p->chunk_sectors)
+		if (ublk_dev_is_zoned(ub) && !is_power_of_2(p->chunk_sectors))
 			return -EINVAL;
 	} else
 		return -EINVAL;
-- 
2.53.0



