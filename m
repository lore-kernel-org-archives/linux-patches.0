Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309C6143867;
	Thu, 13 Jun 2024 11:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278648; cv=none; b=ucdxUTFxVC8x9cd6jU2MTOw/ZuIPCbxc+rQOV+uKvlkQAsr7zL8u6FUfkNv1c2Z99DjRsS2bYVJIHVYfhcidlFdBhNHfYKyXGur/5E0BAtKCWf45uRpOOxPJ601IW6JXAcJD3ndUSZgIf/oR7E/FlJ34k5dHKBy1ZMTvgBypR0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278648; c=relaxed/simple;
	bh=DXzmzQho5KlpoNA/jG+V16LAIggr3owZk1YCKpKXVfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mr7g8hVZQQK8YmIuOaDsp/hwcY1BdGZ5K6PdxRAEIU5uNzGH4rwbX+ij3cNqH2ooYrD9vAhO1p2ua8KGgpeCpmUVQA9MINg/24c/MPRvIBq4zJgZSkIZXMwYL24SUDnntLlhrvNTt8SZq9mA/Q2L75WJVyw/GxLa5zwAm/M598Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahrZ5Wnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahrZ5Wnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA918C2BBFC;
	Thu, 13 Jun 2024 11:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278648;
	bh=DXzmzQho5KlpoNA/jG+V16LAIggr3owZk1YCKpKXVfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahrZ5Wnm+7I6XIdq+A4zLroXEdO/NXcWAkhkstNkPTuvKWCbgG/r+71dMOVWKP99+
	 6mKtsMz9B32xBt/3rKUZ13IGw7cKvWmNgRhMBpmXq6+T314GhiAaIs/gvTFBwXtn+r
	 nJJA3T0emOjbzrpo9p58NnolNTLsM0t0lxYXXoIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 023/213] null_blk: Fix missing mutex_destroy() at module removal
Date: Thu, 13 Jun 2024 13:31:11 +0200
Message-ID: <20240613113228.888301511@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit 07d1b99825f40f9c0d93e6b99d79a08d0717bac1 ]

When a mutex lock is not used any more, the function mutex_destroy
should be called to mark the mutex lock uninitialized.

Fixes: f2298c0403b0 ("null_blk: multi queue aware block test driver")
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://lore.kernel.org/r/20240425171635.4227-1-yanjun.zhu@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 5553df736c720..fb20ed1360f99 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1967,6 +1967,8 @@ static void __exit null_exit(void)
 
 	if (g_queue_mode == NULL_Q_MQ && shared_tags)
 		blk_mq_free_tag_set(&tag_set);
+
+	mutex_destroy(&lock);
 }
 
 module_init(null_init);
-- 
2.43.0



