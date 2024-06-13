Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4F3EC4;
	Thu, 13 Jun 2024 12:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281851; cv=none; b=KTjGmgrAz44JW+uee+HwJgygHlbSM72ZmOLMj37EFx51GCRk7JgFDrV3ysmcXffsWo27kVYl8UylT4BslDFWsNtuI6wN3MOHjt3fUo/GYY5e/VZcbq8Fv3CNmg3klVeBrj/U4vlXGd+dTgvQPH1H4cR3jakNT+iMClk3OGGDKJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281851; c=relaxed/simple;
	bh=zeGMXY25KJkEqoDUDvmkxI16Wg4Iwt2tSslZwZzvgEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNoY5GVuBbPZmqiHCsHbb/6K1nRono0Yw1VpWOn2HkprR/21+XWW8zqKzGF2RDV6Bo0kL/XTUE107OEsvN0DlbBZDQH6wx4TFCuQuAK14tY39BvIxqPPtUDg3qhJ1CprGv79QBGgpV5vzys8juJQR0q3PygzO9IL9q2PFSNWJxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVb9CiIU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVb9CiIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6B3C2BBFC;
	Thu, 13 Jun 2024 12:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281851;
	bh=zeGMXY25KJkEqoDUDvmkxI16Wg4Iwt2tSslZwZzvgEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVb9CiIUw30rnCNjYX+miqTfU+dY3pCbwCZc/bpXWBTgtPHhyuI8r1mJK8OmGuDlZ
	 xVfoIWYXjVmsgiXGEgz90sRxv//+NsPoEIF00Bi3ZJH/jaoQ7vj7kM6wqvk0L75j/H
	 PopV1lI+Jhl5WVyapC1858NCyWnp0jzU+6OG00nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/402] null_blk: Fix missing mutex_destroy() at module removal
Date: Thu, 13 Jun 2024 13:30:07 +0200
Message-ID: <20240613113304.090460844@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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
index 87791265e09bf..1fe5d33a5798d 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2045,6 +2045,8 @@ static void __exit null_exit(void)
 
 	if (g_queue_mode == NULL_Q_MQ && shared_tags)
 		blk_mq_free_tag_set(&tag_set);
+
+	mutex_destroy(&lock);
 }
 
 module_init(null_init);
-- 
2.43.0



