Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09800BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7175DC433D2;
	Tue,  7 Mar 2023 18:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213947;
	bh=2c0Hl4KnWY6gymvdTT1rcKnuFq5+3UPkgvzrN6puVMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gv3bnVAO7lGbA/MPMI40SiOXRvShrRrKimBo8wy2T0zhIu+o3HJ6QHEMHXK5TAqhO
	 XKHVqEZxgOxUmo9jCYJtw3272+KKnbMSBCeJrJvMnXuoltGbacKOKo+finmbc8XGsk
	 +iIpsz/Q1E8XbwKnBwZzEIkVExcqcBhM01Fap/f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 640/885] dm thin: add cond_resched() to various workqueue loops
Date: Tue,  7 Mar 2023 17:59:34 +0100
Message-Id: <20230307170029.960764229@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit e4f80303c2353952e6e980b23914e4214487f2a6 ]

Otherwise on resource constrained systems these workqueues may be too
greedy.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-thin.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 196f82559ad6b..d28c9077d6ed2 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2207,6 +2207,7 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 			throttle_work_update(&pool->throttle);
 			dm_pool_issue_prefetches(pool->pmd);
 		}
+		cond_resched();
 	}
 	blk_finish_plug(&plug);
 }
@@ -2289,6 +2290,7 @@ static void process_thin_deferred_cells(struct thin_c *tc)
 			else
 				pool->process_cell(tc, cell);
 		}
+		cond_resched();
 	} while (!list_empty(&cells));
 }
 
-- 
2.39.2



