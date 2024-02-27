Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA4313F016;
	Tue, 27 Feb 2024 14:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042845; cv=none; b=maeDzH2OaiJ3xNnFLOlLwKfutSeqJrd/QNAjdDEXTFFvYSzsqSdhVOSUIjvjTrhefyWFS1kK2orUZcb8yqshgqboqLnK81k6dh8eQNKZWD9baF6PP0CChQ2voEfNjBAiaF58lZhP+NR8Dg8uUPIg7+lIeT7q7H2EZf89Su5xvIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042845; c=relaxed/simple;
	bh=LUKLz1YQGC/+oH/eXus/9fD7fUdlm/2eE3stRmaXPsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGF/xvVfALZnF1VknZeaIRC6qXpqmz5JxdVXkwmAbbLClKyjPkLCm2eysiT53723P9jeokv23OIPEoO8XjLlNRynQoQBNMUnJEUqozV+q2cE0yhEgFYENYdeaz0LxEWM6pjYzIZxHMxdDpJ6a56SQGNtG1NkB7+4EyC+hfjnE4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+29EW+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+29EW+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAF8C433C7;
	Tue, 27 Feb 2024 14:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042845;
	bh=LUKLz1YQGC/+oH/eXus/9fD7fUdlm/2eE3stRmaXPsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+29EW+u3WWPDgEb66cJMtCzsNUMTHJsi8BeZd/LSm/DKlYJ0UYr4DiaasYops56B
	 LiREAHGoX2P1ZtlibZa4r7vythQSI6fTwS4UUCAc4Gvv2g5tbLLe90u1aZC39PD1yO
	 i97mTDbaomYZe6d1xOwgFmS6FeF4UZwOQor3ir9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao.yu@oppo.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/245] f2fs: dont set GC_FAILURE_PIN for background GC
Date: Tue, 27 Feb 2024 14:25:29 +0100
Message-ID: <20240227131619.798727314@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 642c0969916eaa4878cb74f36752108e590b0389 ]

So that it can reduce the possibility that file be unpinned forcely by
foreground GC due to .i_gc_failures[GC_FAILURE_PIN] exceeds threshold.

Signed-off-by: Chao Yu <chao.yu@oppo.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 7010440cb64c8..d016504fad4b9 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1199,7 +1199,8 @@ static int move_data_block(struct inode *inode, block_t bidx,
 	}
 
 	if (f2fs_is_pinned_file(inode)) {
-		f2fs_pin_file_control(inode, true);
+		if (gc_type == FG_GC)
+			f2fs_pin_file_control(inode, true);
 		err = -EAGAIN;
 		goto out;
 	}
-- 
2.43.0



