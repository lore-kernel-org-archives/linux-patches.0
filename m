Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65433537FF;
	Sat, 12 Sep 2026 13:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218580; cv=none; b=YSc6dEKk3bdVEQINVfC8wbzF42Qnl4dRa9vRsKRwosl1qaHZQcmmuHeASkmoQaEQosgYThSOf7kOQ0+hzoppmkug2lRwApM3UAMNTg4yYWnPg5ujM8MDQuiY/i7AMQP83XAmTV/lkcNwQEtPNuDAUUYt7I6fCEkxc9x8QY+ocig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218580; c=relaxed/simple;
	bh=xBMDiiJ4EBI41yeKHxSCaWEf542vNAAcahQd3NIbXJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4G+Z9cU7mQyGKMM3DUdODq+7mt+jHaFs06EGvmlEPzdX/8PJapVeGPOBdEmi74a9fbch3nIBlLr6MIOexvzJ/mngsBEW9O4nYjIfQd8wJUsNbKeQc6HCVm4G2X7bWj9QNyYMFHvOciN6zYeks+AcKgA8w3Vlry69GdCAfpewwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1davAMt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1davAMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD931F000FF;
	Sat, 12 Sep 2026 13:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218579;
	bh=1H0KD6RMfV9u3Gb2ORPTRYNClZqaKyRm0JTDB4s7Vdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1davAMtwZjsstqHiMLi1P1RIRPeQ2/2N0uuBVkSEET4stlFQswYXsuUVHLJyow5q
	 of5NjpJuD++bXKEUtwCIEat1trIJwdxkkWj/HNPR0w7CQPZbupExI/qML6gKetOCtP
	 gWuYOAOt99wp6f9YbeVtyxs+oKNdyBfNF4UwJ48Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Sang <sangyao@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1157/1376] ublk: reject non-power-of-2 zone sizes in SET_PARAMS
Date: Sat, 12 Sep 2026 08:59:43 +0200
Message-ID: <20260912065633.340578164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index aecac3b6749bb..6d5523058bed8 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -543,7 +543,7 @@ static int ublk_validate_params(const struct ublk_device *ub)
 		if (p->max_sectors < PAGE_SECTORS)
 			return -EINVAL;
 
-		if (ublk_dev_is_zoned(ub) && !p->chunk_sectors)
+		if (ublk_dev_is_zoned(ub) && !is_power_of_2(p->chunk_sectors))
 			return -EINVAL;
 	} else
 		return -EINVAL;
-- 
2.53.0



