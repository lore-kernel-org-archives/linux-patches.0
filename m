Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DD6284B4F;
	Tue, 27 May 2025 16:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364895; cv=none; b=Qdnd2Syji89IsI5dLELU84918o2nPxB7OicyV5FNKu0vEFlYMNkQmUqRTCSgZ4ElJbfFGmqReKmk/cj0FzzdrQFTNz+4RRDoi8shypSX2j/EVPBX+np7J45Q+Jy4YKWQv9fWxEbkujkM+NK1uan4ZvuGAfsGGSEM7PDYnJ0YKbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364895; c=relaxed/simple;
	bh=TmBjkiVzRYvBT1R4KUXU/LDGDz/420Hl6OSy/gmjWrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXGKPzLt2aQguCRBjUCPV8zUjWnhAioP3IrGvKxjdI9UY1XEvEe6ta5yZTIcjAdG4KHFCXiHsDVrMAugUAoBeNegocvBwnVDO6OG3SFetTKqnOJQtKLBOUmDvRoLUD7YMVxaXi/ys5TCR6mKDQAXHMMtvzRhvY79mX24vJHIvX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STbmnChL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STbmnChL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A8AC4CEEF;
	Tue, 27 May 2025 16:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364895;
	bh=TmBjkiVzRYvBT1R4KUXU/LDGDz/420Hl6OSy/gmjWrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STbmnChL+KEF972KFy2et6QcFbqY8ZU/HAIG16ejr7O/iYKQInCzSkX5eAxS1hCKd
	 r+ifbu3D7qw0DO4rho9cAggxnep3Yt9MV6yunIkkT/O8jZ5IrDGwOMX7xmdNoZGMac
	 +wG6BCuL4aCMA9ulV5948hkaBA7AQDDIK37hyHjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Coly Li <colyli@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 200/626] badblocks: Fix a nonsense WARN_ON() which checks whether a u64 variable < 0
Date: Tue, 27 May 2025 18:21:33 +0200
Message-ID: <20250527162453.147625775@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index db4ec8b9b2a8c..a9709771a1015 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -1349,14 +1349,15 @@ static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
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



