Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DBA1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB5AC433EF;
	Wed, 28 Dec 2022 16:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244019;
	bh=lW47Zq3rjECz9ZU6QsCCbhl4iuPIOuwieoLM9/cOrjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BRnsL6owfQ2uUrYRMezyMxmNCdlntdPtJGuDerA7Nb3NW9VkTJ6aMLWuFYoqrKR8V
	 NRQmZxJ7Hvd94qSqV4/Raqnmkr//nivIs6QTBat9D4zMkccB03gvx0H5QhuKifR+Qs
	 HHpxGnvmb+U1fH64/Of2Q7pRpRDrbRppdeK9hLjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0596/1146] f2fs: fix gc mode when gc_urgent_high_remaining is 1
Date: Wed, 28 Dec 2022 15:35:35 +0100
Message-Id: <20221228144346.359029144@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 6359a1aaca527311b7145ec6eb16890a5ddf5214 ]

Under the current logic, when gc_urgent_high_remaining is set to 1,
the mode will be switched to normal at the beginning, instead of
running in gc_urgent mode.

Let's switch the gc mode back to normal when the gc ends.

Fixes: 265576181b4a ("f2fs: remove gc_urgent_high_limited for cleanup")
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 2a9d825b84f7..f46e4dcaa252 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -96,16 +96,6 @@ static int gc_thread_func(void *data)
 		 * invalidated soon after by user update or deletion.
 		 * So, I'd like to wait some time to collect dirty segments.
 		 */
-		if (sbi->gc_mode == GC_URGENT_HIGH) {
-			spin_lock(&sbi->gc_urgent_high_lock);
-			if (sbi->gc_urgent_high_remaining) {
-				sbi->gc_urgent_high_remaining--;
-				if (!sbi->gc_urgent_high_remaining)
-					sbi->gc_mode = GC_NORMAL;
-			}
-			spin_unlock(&sbi->gc_urgent_high_lock);
-		}
-
 		if (sbi->gc_mode == GC_URGENT_HIGH ||
 				sbi->gc_mode == GC_URGENT_MID) {
 			wait_ms = gc_th->urgent_sleep_time;
@@ -162,6 +152,15 @@ static int gc_thread_func(void *data)
 		/* balancing f2fs's metadata periodically */
 		f2fs_balance_fs_bg(sbi, true);
 next:
+		if (sbi->gc_mode == GC_URGENT_HIGH) {
+			spin_lock(&sbi->gc_urgent_high_lock);
+			if (sbi->gc_urgent_high_remaining) {
+				sbi->gc_urgent_high_remaining--;
+				if (!sbi->gc_urgent_high_remaining)
+					sbi->gc_mode = GC_NORMAL;
+			}
+			spin_unlock(&sbi->gc_urgent_high_lock);
+		}
 		sb_end_write(sbi->sb);
 
 	} while (!kthread_should_stop());
-- 
2.35.1



