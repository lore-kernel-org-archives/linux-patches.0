Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54FF146D4E;
	Thu, 11 Apr 2024 10:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831298; cv=none; b=HcfNWVUIQrMKe5wmY+TtjKvVNTosdnmgQ84XIraDeXP+yLEtoAfioBMfRA7b7nj8/tGH9XhDSDarChXEGzBK8jyhCdpt+UAOWo0r9VDuWKa287bJ0Pz1ydaWUNwIDi/69TC8ksTGmymWVfZ0W5EF7EYOOSzm3gJliF6A2j5lGC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831298; c=relaxed/simple;
	bh=ZO6Sgarui4uwepfsw47kn+VJ6H7Fuoc1jaK8mGglfAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rE01wfVasRBPmuGi93Pn/kFdarwaFJ4o2aePc3FWtiM5c5vFDJJKIbRB6UwKbYTbeLyGhvIuNVenOB4KZ+JPszBSKJ3y9au4TWnuqhQMxNdSHUi+KBTO66yMEk7hn1uSopEhaPmScyrEXXw/RMv9w12ZqPi2nmJhzGI4/j7nlOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKvH/ymO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKvH/ymO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6E0C433F1;
	Thu, 11 Apr 2024 10:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831298;
	bh=ZO6Sgarui4uwepfsw47kn+VJ6H7Fuoc1jaK8mGglfAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKvH/ymOlGt+GLFByKBBZbKAnqP5AKnIE4lNnrojpWWlU+bjScPjccGv3OBn122gL
	 s1faSjiXy1XIOxoGaAW43Ep02nRqoM23hUH/d6LD23TGlnXIaTaDqptgiDDbSxucdn
	 Tpauh72/n0zntPi1xeASZ4X22Qo//6wcPhyHk8UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Smirnov <r.smirnov@omp.ru>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/114] block: prevent division by zero in blk_rq_stat_sum()
Date: Thu, 11 Apr 2024 11:56:43 +0200
Message-ID: <20240411095419.181868030@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Smirnov <r.smirnov@omp.ru>

[ Upstream commit 93f52fbeaf4b676b21acfe42a5152620e6770d02 ]

The expression dst->nr_samples + src->nr_samples may
have zero value on overflow. It is necessary to add
a check to avoid division by zero.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20240305134509.23108-1-r.smirnov@omp.ru
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-stat.c b/block/blk-stat.c
index 7ff76ae6c76a9..e42c263e53fb9 100644
--- a/block/blk-stat.c
+++ b/block/blk-stat.c
@@ -27,7 +27,7 @@ void blk_rq_stat_init(struct blk_rq_stat *stat)
 /* src is a per-cpu stat, mean isn't initialized */
 void blk_rq_stat_sum(struct blk_rq_stat *dst, struct blk_rq_stat *src)
 {
-	if (!src->nr_samples)
+	if (dst->nr_samples + src->nr_samples <= dst->nr_samples)
 		return;
 
 	dst->min = min(dst->min, src->min);
-- 
2.43.0



