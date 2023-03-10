Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EBC848C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A766C433D2;
	Fri, 10 Mar 2023 14:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458226;
	bh=ls1WHr+NDdpwY4I4HK+pOTbER55f6Fx0nziaxrJOC/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQgi5YcqFrEfLa7u0kN13A0+QDsks2Ytqd2G+pTIxXGal8/xDGI8It4FMOTyFeskN
	 gr84VUwl7ZNXqdojj1YfoPGE3wB3aX83Be/RQPo8qxPwL6VQvCPHBfp5kIaDi8tNlY
	 UhPzWm81Eua87216DAXurHIaUSeQS0KUMWQT7mKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 206/252] ubifs: Reserve one leb for each journal head while doing budget
Date: Fri, 10 Mar 2023 14:39:36 +0100
Message-Id: <20230310133725.313538288@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit e874dcde1cbf82c786c0e7f2899811c02630cc52 ]

UBIFS calculates available space by c->main_bytes - c->lst.total_used
(which means non-index lebs' free and dirty space is accounted into
total available), then index lebs and four lebs (one for gc_lnum, one
for deletions, two for journal heads) are deducted.
In following situation, ubifs may get -ENOSPC from make_reservation():
 LEB 84: DATAHD   free 122880 used 1920  dirty 2176  dark 6144
 LEB 110:DELETION free 126976 used 0     dirty 0     dark 6144 (empty)
 LEB 201:gc_lnum  free 126976 used 0     dirty 0     dark 6144
 LEB 272:GCHD     free 77824  used 47672 dirty 1480  dark 6144
 LEB 356:BASEHD   free 0      used 39776 dirty 87200 dark 6144
 OTHERS: index lebs, zero-available non-index lebs

UBIFS calculates the available bytes is 6888 (How to calculate it:
126976 * 5[remain main bytes] - 1920[used] - 47672[used] - 39776[used] -
126976 * 1[deletions] - 126976 * 1[gc_lnum] - 126976 * 2[journal heads]
- 6144 * 5[dark] = 6888) after doing budget, however UBIFS cannot use
BASEHD's dirty space(87200), because UBIFS cannot find next BASEHD to
reclaim current BASEHD. (c->bi.min_idx_lebs equals to c->lst.idx_lebs,
the empty leb won't be found by ubifs_find_free_space(), and dirty index
lebs won't be picked as gced lebs. All non-index lebs has dirty space
less then c->dead_wm, non-index lebs won't be picked as gced lebs
either. So new free lebs won't be produced.). See more details in Link.

To fix it, reserve one leb for each journal head while doing budget.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216562
Fixes: 1e51764a3c2ac0 ("UBIFS: add new flash file system")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/budget.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index 2971a2c140d57..30c7bd63c2ad1 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -224,11 +224,10 @@ long long ubifs_calc_available(const struct ubifs_info *c, int min_idx_lebs)
 	subtract_lebs += 1;
 
 	/*
-	 * The GC journal head LEB is not really accessible. And since
-	 * different write types go to different heads, we may count only on
-	 * one head's space.
+	 * Since different write types go to different heads, we should
+	 * reserve one leb for each head.
 	 */
-	subtract_lebs += c->jhead_cnt - 1;
+	subtract_lebs += c->jhead_cnt;
 
 	/* We also reserve one LEB for deletions, which bypass budgeting */
 	subtract_lebs += 1;
-- 
2.39.2



