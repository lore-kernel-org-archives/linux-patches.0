Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B7A746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84C6C433C7;
	Sun, 17 Sep 2023 20:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982980;
	bh=k2ujbRPEzs9At8eKyeaYQw0VPvMAsERtRsQXu65/8mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ao62dWKilrNkxryXHJAJGuGoAhjlz8U8ct98azIHhSHv+rAUt9gsaNDjczypsk5XL
	 iG9BiIPrRMlrShWSqk7cLejvBSXznOSIKPXfCge7slHv8vkw7mMdxlJsK7vqMKXf+D
	 AD8Lbh9m+3nfVtB8QzWj38+E9w5N4zKJcHq4V8NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 408/511] gfs2: Switch to wait_event in gfs2_logd
Date: Sun, 17 Sep 2023 21:13:55 +0200
Message-ID: <20230917191123.639755240@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 6df373b09b1dcf2f7d579f515f653f89a896d417 ]

In gfs2_logd(), switch from an open-coded wait loop to
wait_event_interruptible_timeout().

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: b74cd55aa9a9 ("gfs2: low-memory forced flush fixes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/log.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index f0ee3ff6f9a87..924d7f0de1e83 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -1296,7 +1296,6 @@ int gfs2_logd(void *data)
 {
 	struct gfs2_sbd *sdp = data;
 	unsigned long t = 1;
-	DEFINE_WAIT(wait);
 
 	while (!kthread_should_stop()) {
 
@@ -1333,17 +1332,11 @@ int gfs2_logd(void *data)
 
 		try_to_freeze();
 
-		do {
-			prepare_to_wait(&sdp->sd_logd_waitq, &wait,
-					TASK_INTERRUPTIBLE);
-			if (!gfs2_ail_flush_reqd(sdp) &&
-			    !gfs2_jrnl_flush_reqd(sdp) &&
-			    !kthread_should_stop())
-				t = schedule_timeout(t);
-		} while(t && !gfs2_ail_flush_reqd(sdp) &&
-			!gfs2_jrnl_flush_reqd(sdp) &&
-			!kthread_should_stop());
-		finish_wait(&sdp->sd_logd_waitq, &wait);
+		t = wait_event_interruptible_timeout(sdp->sd_logd_waitq,
+				gfs2_ail_flush_reqd(sdp) ||
+				gfs2_jrnl_flush_reqd(sdp) ||
+				kthread_should_stop(),
+				t);
 	}
 
 	return 0;
-- 
2.40.1



