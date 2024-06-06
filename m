Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02511A01AD;
	Thu,  6 Jun 2024 14:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683172; cv=none; b=fJCx9dxv784lFYXBXGthzRfItuTAHm2ix4WctOmsvqcgiXH1cUpzLCsOqDMhsGSfbvnjchaH3MLI2sIGh6L8NHz7/nRMIYZQgzDFzWe0X+6t+tA/nuq0O3ypFatwT+XWoIqH+nUftTHGSWo3JYs2cR3bb8Ma2pTihMj2QQFm8fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683172; c=relaxed/simple;
	bh=XKrpJX1RMpfLzoq07XUZ5BYJUG0fI/19K2hqO3kgvVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkK+3WkFBW6TpEfR1V5DXr0bhx/Lj3SEqKcmN1ishVocjEzfVNfIht6IsbP4NA7dVjpbHOc3asFal5rD70XlrYsrhHJFD4U2q7IYxwtrp2s1V4WQQxCiA2T1XAioD8sDCnTMX87adMRUv99vXv8EmN6ana01R16O0nmTk8TTX2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3FB6IBw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3FB6IBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BE8C32781;
	Thu,  6 Jun 2024 14:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683172;
	bh=XKrpJX1RMpfLzoq07XUZ5BYJUG0fI/19K2hqO3kgvVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3FB6IBwGe0b/nXE4qbr3FmZedMLg0gYjmKKdxUlvlhf+Yz5zg2gvDw3kA9LTx3Ow
	 MZiWCMxaF9B1zFaLkGWwcSMTpDxL4hZjwfZZ9Pv0cZ8AT+cb0lgLCU84TrLrXdRSGw
	 wRHRRJhnNajzupMIgqnztKj0ak9FrKRC3mWz8pyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/744] null_blk: Fix missing mutex_destroy() at module removal
Date: Thu,  6 Jun 2024 15:56:29 +0200
Message-ID: <20240606131736.163307320@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9544746de1683..cc4dcb951fd24 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2352,6 +2352,8 @@ static void __exit null_exit(void)
 
 	if (g_queue_mode == NULL_Q_MQ && shared_tags)
 		blk_mq_free_tag_set(&tag_set);
+
+	mutex_destroy(&lock);
 }
 
 module_init(null_init);
-- 
2.43.0



