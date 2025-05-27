Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3051DB34C;
	Tue, 27 May 2025 17:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366972; cv=none; b=fO5Z9QI3OEND4zueVgOLl7B+N4ejNKAKjeSN9rRl5WBtgLVG3aYT1wBnsko4JNP1xsoI6e/mA661efHu18DGarcbQn0oRJZT4CeSC3AhHU9OUsjzNSvGlkDBNPYjw/zRpg5kFQunAp7bDKDcQAS8zzgryNVi+a5qaDAEr/gJNXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366972; c=relaxed/simple;
	bh=SK6FzQPdmCJW2+hRsb2OQ0/+rc+BW4dbnnwT4MAdHTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbWkKMpUusG9hhCK/bZyozpchW5HQnz4gxkgkYFTM6SaMCiQvMoFcxCby7DPdA57+pgF7BJY6bIPmV4rpHp8v7KDArpKIGUFjpsEaxIKMeaZhsCfvFGhuO83RyIO+jkrcA33c2SN7H7ez3J8PXXd9hpTQFvffESDJ1nJ5hI7v5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y2ePQWPr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2ePQWPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611B8C4CEE9;
	Tue, 27 May 2025 17:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366971;
	bh=SK6FzQPdmCJW2+hRsb2OQ0/+rc+BW4dbnnwT4MAdHTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2ePQWPrddMNImnUcsYP9tOYb66uBW9fUqcnnl1IL4nXZRFHjwPfEEHBioHeZPhoZ
	 0Oj3QDWTvtcwlUxL7632BGmhQdOFrHEVbEaBC7avJVr4xKIIKT2To9yuZuXDy3687U
	 iOLz2xiW7OEiQg6o8h0fQ01DUMWTohFVSWH37I4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Coly Li <colyli@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 236/783] badblocks: Fix a nonsense WARN_ON() which checks whether a u64 variable < 0
Date: Tue, 27 May 2025 18:20:33 +0200
Message-ID: <20250527162522.732462487@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Coly Li <colyli@kernel.org>

[ Upstream commit 7e76336e14de9a2b67af96012ddd46c5676cf340 ]

In _badblocks_check(), there are lines of code like this,
1246         sectors -= len;
[snipped]
1251         WARN_ON(sectors < 0);

The WARN_ON() at line 1257 doesn't make sense because sectors is
unsigned long long type and never to be <0.

Fix it by checking directly checking whether sectors is less than len.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Coly Li <colyli@kernel.org>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20250309160556.42854-1-colyli@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/badblocks.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index dc147c0179612..23acdf7c6f363 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -1246,14 +1246,15 @@ static int _badblocks_check(struct badblocks *bb, sector_t s, sector_t sectors,
 	len = sectors;
 
 update_sectors:
+	/* This situation should never happen */
+	WARN_ON(sectors < len);
+
 	s += len;
 	sectors -= len;
 
 	if (sectors > 0)
 		goto re_check;
 
-	WARN_ON(sectors < 0);
-
 	if (unacked_badblocks > 0)
 		rv = -1;
 	else if (acked_badblocks > 0)
-- 
2.39.5



