Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA1119924F;
	Thu,  6 Jun 2024 14:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683207; cv=none; b=XaCujQ55qDvKzgiDsbOyoMIEXjaTIcQp48gCDAbKIIPXSKRboR11BxUyWx35wAB5Yn8jLRwkH6g1P5Yy+W9ScCCXpjlE5ixaIgNnZW9P+kg3J/g5+ZIGLKfn1Pcu4BNcY1Y2v0gOxhiN964g5fxu06GyVNN7TgCMURaBHt9bNcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683207; c=relaxed/simple;
	bh=ptJgIJiTSdwXcVvVQcRArzc04QZXFsrqnQdH5spL9NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TChvTHezKFCBmyxUUjnz3qvldan8qcsFQBxckuviGQTDEze8IbnD3q9Ls1a6lNAcbeB+EBDbINIU42ssOZ/YsUMnJP42rmrJGiXUjtGBVSsWB7wNFs4ZCHo3jtFT44Adj5s3fpZSp9wXpYPkJEdUIhINwW7uLolar16PRnOns28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itfynmR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itfynmR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5DEC2BD10;
	Thu,  6 Jun 2024 14:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683207;
	bh=ptJgIJiTSdwXcVvVQcRArzc04QZXFsrqnQdH5spL9NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itfynmR+pDdHqnvgkQkr/VEAXMYK9jBPDsLp2tNSOEf3eJqh+7XTmaCm3PkpclsnL
	 qWd9FVSlbpqgYm4koJTo+JQL7W4srcSbsViNFK5C6FUHtK4AbAMnUUaUnhhq2gHaiW
	 YhnnsKZUtbSnmN+ReooIcTsXAKHFnepN3arqqtiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/473] null_blk: Fix missing mutex_destroy() at module removal
Date: Thu,  6 Jun 2024 16:00:14 +0200
Message-ID: <20240606131702.715595282@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index 959952e8ede38..b7a26a12dc656 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2298,6 +2298,8 @@ static void __exit null_exit(void)
 
 	if (g_queue_mode == NULL_Q_MQ && shared_tags)
 		blk_mq_free_tag_set(&tag_set);
+
+	mutex_destroy(&lock);
 }
 
 module_init(null_init);
-- 
2.43.0



