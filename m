Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4431116131A;
	Mon, 27 May 2024 19:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836493; cv=none; b=I9eTbWziXzvj2kj2hm76vW+dIytAX3KTXt9lCMbMgoWPEE5vWyzEgmQ3xCsdGU7ER/RcR4JmgUh68jQw7Nb+nofGK/qMSDNviVzZE+/1fvTkjOyyOhlWI/unSMPQLB8rgoRYQ5/92SOvOo9/NRWK3rqcoeHmX2DjvD4cPH5PXGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836493; c=relaxed/simple;
	bh=vSgyyhzOQBJmJeZ4yj5BPdzcwFPcufp7pbNUNdErlMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/LUjcFKvXWtUxC8uCjWZq0VDvqdAzftxYwRK0H7v9g7wxH0LQnzQb3/jEoDG8gx3p9uPfwY8VWUMuiNAKOKC/RGHQCrdtzPaa8ByObgpqEvZ4l/Mwhtecwfi7RDr+/gv5ubCWUE0IjwMUWb/+7MSzQC/51wsTwI3ugY/UV2rMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXSddCTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXSddCTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD36BC32781;
	Mon, 27 May 2024 19:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836493;
	bh=vSgyyhzOQBJmJeZ4yj5BPdzcwFPcufp7pbNUNdErlMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXSddCTjGIszlXkcAvs20U7zRs5HPf1G6TCPuCBbsAGgqxsWPmYiHCm9BR6eg2dwe
	 uf0pQP4orEX4ni6YJaxbbh0/TyAu3wmzAJ4oSNKkt74xcltIjZpyZP5BSuDvnOVIMG
	 aUg0ohJ5P7pxJ83JjCYygfd2bRiGqYog1IYpXyaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 074/427] null_blk: Fix missing mutex_destroy() at module removal
Date: Mon, 27 May 2024 20:52:01 +0200
Message-ID: <20240527185608.741731012@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index ed33cf7192d21..eed63f95e89d0 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2113,6 +2113,8 @@ static void __exit null_exit(void)
 
 	if (tag_set.ops)
 		blk_mq_free_tag_set(&tag_set);
+
+	mutex_destroy(&lock);
 }
 
 module_init(null_init);
-- 
2.43.0



