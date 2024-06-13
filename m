Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B766EB56;
	Thu, 13 Jun 2024 12:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280833; cv=none; b=nHOGVoL7vgkDqhDUyOVXhVO1BOv69DQXHlKDYpMKglOzm39RTlAHvm7pThSHQfOa/jctc9KkJIswQiJ/Tfz0agn9AtshDYOradni3aOPqicZqUNn6uTCpbhcsIEC15TsaAX15RKR+OXreVzLto01MPvLEg0xvcNVDn/P67H39Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280833; c=relaxed/simple;
	bh=8rR1WV+HFESfGx/gtYFXLpD2hahDzyfTdB4SDva+3K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2zcmU9rLUbvuQCCSZpTJuH2KCeuue7zNEA/N6XR9SFhJeaxWSKZNcNTQ1pC9xEB4B8LbI+xzwzTk6yBGJWqYyHSf79KYA3ApwqEaQEWpfuCVp5oteq4CFdiSaT+9Y46cQIsU45sx1uZ8NI6vqaGpNl4+2SM8A1y3HYgJdhiFEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XETviQ1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XETviQ1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9619AC2BBFC;
	Thu, 13 Jun 2024 12:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280833;
	bh=8rR1WV+HFESfGx/gtYFXLpD2hahDzyfTdB4SDva+3K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XETviQ1/ZID+kFozoLbOeWuaSDVkg8AvLbzdvHEYe6v5GOEVdgE0UrXgFJx+wjFW+
	 np+fkzTlo5eI3zyDtqFKy5Ck+n624mU5JtlQLvvqz+O51RSTbHPCFIxgIqAllUv+ND
	 ILzDrMo+hBFhyptRSzmiuppOkR9IvgeCTLGftwlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/317] null_blk: Fix missing mutex_destroy() at module removal
Date: Thu, 13 Jun 2024 13:30:50 +0200
Message-ID: <20240613113248.784579109@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 35b390a785dd4..ee1c3f476a3a0 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2032,6 +2032,8 @@ static void __exit null_exit(void)
 
 	if (g_queue_mode == NULL_Q_MQ && shared_tags)
 		blk_mq_free_tag_set(&tag_set);
+
+	mutex_destroy(&lock);
 }
 
 module_init(null_init);
-- 
2.43.0



