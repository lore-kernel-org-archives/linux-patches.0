Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A1B7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3015EC433D2;
	Mon, 24 Apr 2023 13:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343019;
	bh=VWeaSIihX1UD1HpAC36qM6ZP2rDBKHTw1ESYWCVeS1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jy7sJ041zZ9e1KR9VSW4Y00BizO+s1xtZVUZbxtlG/mUFCEFAQw/aMP3h+ryOrkxo
	 SkRME+4tEjGiN0hPL301IZOvBx3dXvfNBcYuL2YiEi2Uo5TiGUYaRwx6B3iERGoxnq
	 wFlO9j9Djwx6Ahg/FZKZ9cHLT3GEOJTnCU6FTEZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Lu=C3=ADs=20Mendes?= <luis.p.mendes@gmail.com>,
	David Gow <davidgow@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Arunpravin Paneer Selvam <arunpravin.paneerselvam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 047/110] drm: buddy_allocator: Fix buddy allocator init on 32-bit systems
Date: Mon, 24 Apr 2023 15:17:09 +0200
Message-Id: <20230424131137.992320062@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Gow <davidgow@google.com>

[ Upstream commit 4453545b5b4c3eff941f69a5530f916d899db025 ]

The drm buddy allocator tests were broken on 32-bit systems, as
rounddown_pow_of_two() takes a long, and the buddy allocator handles
64-bit sizes even on 32-bit systems.

This can be reproduced with the drm_buddy_allocator KUnit tests on i386:
	./tools/testing/kunit/kunit.py run --arch i386 \
	--kunitconfig ./drivers/gpu/drm/tests drm_buddy

(It results in kernel BUG_ON() when too many blocks are created, due to
the block size being too small.)

This was independently uncovered (and fixed) by Luís Mendes, whose patch
added a new u64 variant of rounddown_pow_of_two(). This version instead
recalculates the size based on the order.

Reported-by: Luís Mendes <luis.p.mendes@gmail.com>
Link: https://lore.kernel.org/lkml/CAEzXK1oghXAB_KpKpm=-CviDQbNaH0qfgYTSSjZgvvyj4U78AA@mail.gmail.com/T/
Signed-off-by: David Gow <davidgow@google.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Arunpravin Paneer Selvam <arunpravin.paneerselvam@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230329065532.2122295-1-davidgow@google.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_buddy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_buddy.c b/drivers/gpu/drm/drm_buddy.c
index 3d1f50f481cfd..7098f125b54a9 100644
--- a/drivers/gpu/drm/drm_buddy.c
+++ b/drivers/gpu/drm/drm_buddy.c
@@ -146,8 +146,8 @@ int drm_buddy_init(struct drm_buddy *mm, u64 size, u64 chunk_size)
 		unsigned int order;
 		u64 root_size;
 
-		root_size = rounddown_pow_of_two(size);
-		order = ilog2(root_size) - ilog2(chunk_size);
+		order = ilog2(size) - ilog2(chunk_size);
+		root_size = chunk_size << order;
 
 		root = drm_block_alloc(mm, NULL, order, offset);
 		if (!root)
-- 
2.39.2



