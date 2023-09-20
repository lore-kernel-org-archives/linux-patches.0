Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350BA2E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC135C433C8;
	Wed, 20 Sep 2023 12:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211888;
	bh=vukZFeq21dUfQA8lr0mMtuQdOi/JVGiNAcE9BPH/LL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YrmA+P7ygjt5oaTd8J0bKIHBit+bPJpJpMUiJmrTpfT7Lg1TdzUDDAZiJTy6yzYmr
	 1u9IOOCvTJxVlM6HhlBrZeEVeRD7T4zqWl8euLqMAiqsyH3eaVtuSCS/eC7CAV3hqo
	 SpgWdUboh+rkj0R9EAxyqaFk7L484M6/tPt82FSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengguang Xu <cgxu519@zoho.com.cn>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 073/273] quota: avoid increasing DQST_LOOKUPS when iterating over dirty/inuse list
Date: Wed, 20 Sep 2023 13:28:33 +0200
Message-ID: <20230920112848.716766950@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

From: Chengguang Xu <cgxu519@zoho.com.cn>

[ Upstream commit 05848db2083d4f232e84e385845dcd98d5c511b2 ]

It is meaningless to increase DQST_LOOKUPS number while iterating
over dirty/inuse list, so just avoid it.

Link: https://lore.kernel.org/r/20190926083408.4269-1-cgxu519@zoho.com.cn
Signed-off-by: Chengguang Xu <cgxu519@zoho.com.cn>
Signed-off-by: Jan Kara <jack@suse.cz>
Stable-dep-of: dabc8b207566 ("quota: fix dqput() to follow the guarantees dquot_srcu should provide")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/dquot.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 01bec330d54b1..50aaa5b0706e8 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -594,7 +594,6 @@ int dquot_scan_active(struct super_block *sb,
 		/* Now we have active dquot so we can just increase use count */
 		atomic_inc(&dquot->dq_count);
 		spin_unlock(&dq_list_lock);
-		dqstats_inc(DQST_LOOKUPS);
 		dqput(old_dquot);
 		old_dquot = dquot;
 		/*
@@ -649,7 +648,6 @@ int dquot_writeback_dquots(struct super_block *sb, int type)
 			 * use count */
 			dqgrab(dquot);
 			spin_unlock(&dq_list_lock);
-			dqstats_inc(DQST_LOOKUPS);
 			err = sb->dq_op->write_dquot(dquot);
 			if (err) {
 				/*
-- 
2.40.1



