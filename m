Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C14315FCE9;
	Mon, 27 May 2024 19:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837791; cv=none; b=eNZDQPeFJ8VOXrDBULL/6mF/tkk6GwtbfBtLRG9lmYmtIrtxDXE+dbwiElM6+uXwHzQPFvwEBJzJs1pqTFcN13nQvq4bO9ikndImPsDYcYVYoyGesutL3tw+yzjcEi2JdBZ2J0D4QU1UFWxWI7XS/rFVpTxJc68ro9cvSgwbGMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837791; c=relaxed/simple;
	bh=9jw90apNMZ242h/QxdEcGxiIlTdi5Lo6XJJj2kW+QPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qs2uERaVjurlzH31k6aRlcAwKxLTmQTM0cvjKRPFhTalaqzjdgy+z+Nw3txTeheLgarxrSyK0FavNK+j3qr4j01gviUiDeQhXqi00CqVd7rQ1ekxd429DmmJTaeHG8d4H0iBu1G8/V4/gCTc0DaDJN1HWceiJoMa5rA0IRfi/NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6K/mdZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6K/mdZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75A9C2BBFC;
	Mon, 27 May 2024 19:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837791;
	bh=9jw90apNMZ242h/QxdEcGxiIlTdi5Lo6XJJj2kW+QPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6K/mdZjD/LpJuDzuiVRWmRCBqld6ECsbRTi3W2Benda3YG2LW0R3cp8PFhHSG6Wt
	 OzihEpHV5kb19KEez8o4cfZk+eVwuR9KMamssqjTDFV66GmQh40WYpa+9ws/9wfy2d
	 m3Q6D4e6MY8qPYUvvSRPlC/2/7x3ZPZnNzuM97fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 146/493] null_blk: Fix missing mutex_destroy() at module removal
Date: Mon, 27 May 2024 20:52:28 +0200
Message-ID: <20240527185635.221495327@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/block/null_blk/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 36755f263e8ec..3584f389b92ce 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2372,6 +2372,8 @@ static void __exit null_exit(void)
 
 	if (g_queue_mode == NULL_Q_MQ && shared_tags)
 		blk_mq_free_tag_set(&tag_set);
+
+	mutex_destroy(&lock);
 }
 
 module_init(null_init);
-- 
2.43.0



