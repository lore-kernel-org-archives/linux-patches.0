Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00E56FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A37C433C8;
	Sun, 17 Sep 2023 19:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979973;
	bh=b6+Teqn3MsVkiRvhqsl4jTNsMlG9qFqCXKY7cPWT8Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPkBYt7EhxfYPwsbfpRFGC3hQC9SwIAyLld3fElpOSMjDX20x/WUGFiwmR4qkU6fQ
	 //6jIWsEwVZwaVqRv4Nq4cDw9iKBPLk+nijCPvjUguSyag4BaitcBV+mDXgiKa0vV4
	 hbpbJcwyDb9cbJtDQwUTQpjDNVH5QJ+ERL41E6TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 060/285] gfs2: Switch to wait_event in gfs2_logd
Date: Sun, 17 Sep 2023 21:11:00 +0200
Message-ID: <20230917191053.784057107@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index aa568796207c0..d3da259820e30 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -1301,7 +1301,6 @@ int gfs2_logd(void *data)
 {
 	struct gfs2_sbd *sdp = data;
 	unsigned long t = 1;
-	DEFINE_WAIT(wait);
 
 	while (!kthread_should_stop()) {
 
@@ -1338,17 +1337,11 @@ int gfs2_logd(void *data)
 
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



