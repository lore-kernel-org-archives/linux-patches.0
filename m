Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E71279C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21758C433C1;
	Wed, 30 Nov 2022 18:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833691;
	bh=+mdOOawsROZ05nKnWMg7Ny0gxbQnSYHhax8kFStudto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XhbMBsFS63D3L2bdnyWas+0Q0/20sZsuR8sux5LqYNEuAHgDKveMaiAXlU4jeV8+z
	 W0cZjv2AYanzPeaxknftCiy85rxKL5i8NNLut20R103DPMNwLhHl2+LutpenYGi0qz
	 sbcnYqVOTn7MmSDTgAKYPkC5K6mSvFtL+HcE7wR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 185/206] dm integrity: flush the journal on suspend
Date: Wed, 30 Nov 2022 19:23:57 +0100
Message-Id: <20221130180537.724286983@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 5e5dab5ec763d600fe0a67837dd9155bdc42f961 ]

This commit flushes the journal on suspend. It is prerequisite for the
next commit that enables activating dm integrity devices in read-only mode.

Note that we deliberately didn't flush the journal on suspend, so that the
journal replay code would be tested. However, the dm-integrity code is 5
years old now, so that journal replay is well-tested, and we can make this
change now.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index d5b827086962..bfdcb40f330a 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2575,10 +2575,6 @@ static void integrity_writer(struct work_struct *w)
 
 	unsigned prev_free_sectors;
 
-	/* the following test is not needed, but it tests the replay code */
-	if (unlikely(dm_post_suspending(ic->ti)) && !ic->meta_dev)
-		return;
-
 	spin_lock_irq(&ic->endio_wait.lock);
 	write_start = ic->committed_section;
 	write_sections = ic->n_committed_sections;
@@ -3085,8 +3081,7 @@ static void dm_integrity_postsuspend(struct dm_target *ti)
 	drain_workqueue(ic->commit_wq);
 
 	if (ic->mode == 'J') {
-		if (ic->meta_dev)
-			queue_work(ic->writer_wq, &ic->writer_work);
+		queue_work(ic->writer_wq, &ic->writer_work);
 		drain_workqueue(ic->writer_wq);
 		dm_integrity_flush_buffers(ic, true);
 	}
-- 
2.35.1



