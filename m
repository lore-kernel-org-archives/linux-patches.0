Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF2145C1C;
	Mon, 14 Oct 2024 15:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918566; cv=none; b=SU8GLXpufj8RlNnoFlUdSdJygyqjKGCTbkUWKyyLxQ1jXaI1/645FXD1ec8UWyVJmaYPhNc5ELTFbePq5GTQmJ4UoLiaN90jP81gP5AB6CDTjLRICUaxpoIfSuiQNR8X8C6vdzBMnocqITiBZfgzCpOhcUJNXYAKiLSVqEXKaqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918566; c=relaxed/simple;
	bh=9fVwBKUKPPUiN8/HD++Z6GkQBiPLqzNZ19XAkZacvIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7B2kOn8I4HoHhI1TzBLRwh8mZkbEx/kF+Aco0G6G/AtAzwIdK0G58ftfC4UONrrya+sRnXyMch3RHnDb/M+Dg+VTMpgWHSNTYDXJ+imbNTCueGIVkGRxQ++EZs1eF3bHB05l1XVqdZUUEAJMOU+pVjytybiF9Va+4CD/ADIbvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yruR/pGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yruR/pGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC5AC4CEC7;
	Mon, 14 Oct 2024 15:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918566;
	bh=9fVwBKUKPPUiN8/HD++Z6GkQBiPLqzNZ19XAkZacvIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yruR/pGRyiAsuBy6wIcAihXa6n62mYNDkE4zEiEjtqm/X7rcSPbsMz75bBGPiiKLJ
	 KvM5ZHc0jMq5jrezkGcJq8orFcCrDOYOgPKG520ExvfngM5UANc+M+qThjmoXwfVqA
	 J/iv6rgVO6dIcQTOo+Etrpzfwoo/9+YOpe0p6XAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 328/798] f2fs: prevent possible int overflow in dir_block_index()
Date: Mon, 14 Oct 2024 16:14:42 +0200
Message-ID: <20241014141230.837443056@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 47f268f33dff4a5e31541a990dc09f116f80e61c upstream.

The result of multiplication between values derived from functions
dir_buckets() and bucket_blocks() *could* technically reach
2^30 * 2^2 = 2^32.

While unlikely to happen, it is prudent to ensure that it will not
lead to integer overflow. Thus, use mul_u32_u32() as it's more
appropriate to mitigate the issue.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 3843154598a0 ("f2fs: introduce large directory support")
Cc: stable@vger.kernel.org
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/dir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -190,7 +190,8 @@ static unsigned long dir_block_index(uns
 	unsigned long bidx = 0;
 
 	for (i = 0; i < level; i++)
-		bidx += dir_buckets(i, dir_level) * bucket_blocks(i);
+		bidx += mul_u32_u32(dir_buckets(i, dir_level),
+				    bucket_blocks(i));
 	bidx += idx * bucket_blocks(level);
 	return bidx;
 }


