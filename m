Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8FA268C44;
	Tue,  8 Apr 2025 11:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110669; cv=none; b=cNRYRZ9BnJgdaMFzdeTJqKwF4o39GIjOPmbK/Ih0Rin9qM3UbW+eauq5zqOsz0vrx+GqTBOK0lFhFIS0o7vh6XsnVCtB1rjM6/6tLjK0VTzFhfAAxGIwQi5mitgdX4NmT3s4IQ/dMfZwkdJeH39907AalE8PVcitOV8SCV3LqtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110669; c=relaxed/simple;
	bh=E9UdKD+s0fQXuOFO7uASKP8Up7LOXLo/OyCzPd1o5rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnFz1jPJla64ZjxIW1aC8xAcGwpfI4ZvdOCwBzzfJ32o4mkcFKbnCwX28cOAX15eKuN2sWT62YWHdeTq+k9efQiO/yANxWYw4vK7b9nItH4RxB+H4E9p4g7neRy397ZCAuR2RqLSRyh3RXTUqTBEu5LEKkxjvtsTkfkkL1eFpV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=knE9Sdph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="knE9Sdph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCDCC4CEE5;
	Tue,  8 Apr 2025 11:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110668;
	bh=E9UdKD+s0fQXuOFO7uASKP8Up7LOXLo/OyCzPd1o5rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knE9Sdph9t/K+DYB394dSkkSp9F3V2gctSO2CRn8uP1HX9sNSgF1jy2voS6cXgMQh
	 wKaO30wD8qWLuG9XMvx1FrMEzvxORuxobV9uFXpLXmJNj6PKXyV0EdfGvXfHuAnarA
	 yajjsMOzswWXY6Hs1pxHR7vYiJACKi28FQS4Qz/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Coly Li <colyli@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 149/731] badblocks: Fix error shitf ops
Date: Tue,  8 Apr 2025 12:40:46 +0200
Message-ID: <20250408104917.741745701@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Li Nan <linan122@huawei.com>

[ Upstream commit 7d83c5d73c1a3c7b71ba70d0ad2ae66e7a0e7ace ]

'bb->shift' is used directly in badblocks. It is wrong, fix it.

Fixes: 3ea3354cb9f0 ("badblocks: improve badblocks_check() for multiple ranges handling")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Coly Li <colyli@kernel.org>
Link: https://lore.kernel.org/r/20250227075507.151331-2-zhengqixing@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/badblocks.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index db4ec8b9b2a8c..bcee057efc476 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -880,8 +880,8 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 		/* round the start down, and the end up */
 		sector_t next = s + sectors;
 
-		rounddown(s, bb->shift);
-		roundup(next, bb->shift);
+		rounddown(s, 1 << bb->shift);
+		roundup(next, 1 << bb->shift);
 		sectors = next - s;
 	}
 
@@ -1157,8 +1157,8 @@ static int _badblocks_clear(struct badblocks *bb, sector_t s, int sectors)
 		 * isn't than to think a block is not bad when it is.
 		 */
 		target = s + sectors;
-		roundup(s, bb->shift);
-		rounddown(target, bb->shift);
+		roundup(s, 1 << bb->shift);
+		rounddown(target, 1 << bb->shift);
 		sectors = target - s;
 	}
 
@@ -1288,8 +1288,8 @@ static int _badblocks_check(struct badblocks *bb, sector_t s, int sectors,
 
 		/* round the start down, and the end up */
 		target = s + sectors;
-		rounddown(s, bb->shift);
-		roundup(target, bb->shift);
+		rounddown(s, 1 << bb->shift);
+		roundup(target, 1 << bb->shift);
 		sectors = target - s;
 	}
 
-- 
2.39.5



