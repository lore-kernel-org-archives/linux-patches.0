Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C888825
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4C6C4339C;
	Fri, 10 Mar 2023 15:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460408;
	bh=JuAbwdvaJOZbRs4/1iziA5eoh8RYCb9yrvZ+u+UsY0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UhcWZJ9iG3GhVz2zrO8uICwXa323yN8i3ZG4uw2GEbEREDHMhP2F/6+uuyGx71Rti
	 T9CCsZcS3RpZyVKMuiKkmjCLNdNOfJY/TYyjFtPB2A0F4Pewg795zQ355l9kkWOKp9
	 FnY4WZyZ4mYB0cP86ayZczHhP61yH9kNx9pWwNO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 325/529] dm thin: add cond_resched() to various workqueue loops
Date: Fri, 10 Mar 2023 14:37:48 +0100
Message-Id: <20230310133820.060784198@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
index f3c519e18a12f..c890bb3e51852 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2217,6 +2217,7 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 			throttle_work_update(&pool->throttle);
 			dm_pool_issue_prefetches(pool->pmd);
 		}
+		cond_resched();
 	}
 	blk_finish_plug(&plug);
 }
@@ -2299,6 +2300,7 @@ static void process_thin_deferred_cells(struct thin_c *tc)
 			else
 				pool->process_cell(tc, cell);
 		}
+		cond_resched();
 	} while (!list_empty(&cells));
 }
 
-- 
2.39.2



