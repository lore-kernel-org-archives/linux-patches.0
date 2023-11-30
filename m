Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19C3495C2;
	Thu, 30 Nov 2023 16:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukR/qywP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B87CC433C7;
	Thu, 30 Nov 2023 16:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361413;
	bh=Aqf+vWjiWYpd+68Zia4UaT4U4Tft1vJ5bXbCqGfeONA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukR/qywP+Uh9E6DAALcvYTKnglbcVi7DEf/Ea+sgg9ZN90oR08Biux3KX0JXsO376
	 Hlm0880TeO7eJEuCRO8f9q1498Ngq046pXLPw3hukPl1RkCRGSOPW85Nog2J5uhAU8
	 uuVD+lzqBHaZAOnHUSfsVTBREgeu+QOrFvISkoyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changhui Zhong <czhong@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/112] blk-cgroup: avoid to warn !rcu_read_lock_held() in blkg_lookup()
Date: Thu, 30 Nov 2023 16:21:00 +0000
Message-ID: <20231130162140.742841691@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 35a99d6557cacbc177314735342f77a2dda41872 ]

So far, all callers either holds spin lock or rcu read explicitly, and
most of the caller has added WARN_ON_ONCE(!rcu_read_lock_held()) or
lockdep_assert_held(&disk->queue->queue_lock).

Remove WARN_ON_ONCE(!rcu_read_lock_held()) from blkg_lookup() for
killing the false positive warning from blkg_conf_prep().

Reported-by: Changhui Zhong <czhong@redhat.com>
Fixes: 83462a6c971c ("blkcg: Drop unnecessary RCU read [un]locks from blkg_conf_prep/finish()")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20231117023527.3188627-3-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 624c03c8fe64e..fd482439afbc9 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -249,8 +249,6 @@ static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg,
 {
 	struct blkcg_gq *blkg;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
-
 	if (blkcg == &blkcg_root)
 		return q->root_blkg;
 
-- 
2.42.0



