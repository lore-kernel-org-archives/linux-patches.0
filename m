Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AA711C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 15:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EB1C433CB;
	Thu, 24 Aug 2023 15:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889228;
	bh=WnD/NyQGROt95QQ9H0NBvCBV7J/ybkP0Rgue35oAqHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IA33t4I4A99VK8+pCrD29PWHs1K57tbXbmnTJtSzYT4G8Mz1nU+jdOO7GvAjcywGw
	 q4hsiettBdnrsNq9nbP/c2eA1YnrQ7rOphlnpHHRdYB8C2pR1lfX3u25VLxJuIbOJ/
	 CqzuHob75RpMTWJsDHaY0mW8KUPRCAmAyOvuZZDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BassCheck <bass@buaa.edu.cn>,
	Tuo Li <islituo@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/135] gfs2: Fix possible data races in gfs2_show_options()
Date: Thu, 24 Aug 2023 16:49:35 +0200
Message-ID: <20230824145028.307215728@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tuo Li <islituo@gmail.com>

[ Upstream commit 6fa0a72cbbe45db4ed967a51f9e6f4e3afe61d20 ]

Some fields such as gt_logd_secs of the struct gfs2_tune are accessed
without holding the lock gt_spin in gfs2_show_options():

  val = sdp->sd_tune.gt_logd_secs;
  if (val != 30)
    seq_printf(s, ",commit=%d", val);

And thus can cause data races when gfs2_show_options() and other functions
such as gfs2_reconfigure() are concurrently executed:

  spin_lock(&gt->gt_spin);
  gt->gt_logd_secs = newargs->ar_commit;

To fix these possible data races, the lock sdp->sd_tune.gt_spin is
acquired before accessing the fields of gfs2_tune and released after these
accesses.

Further changes by Andreas:

- Don't hold the spin lock over the seq_printf operations.

Reported-by: BassCheck <bass@buaa.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index e01b6a2d12d30..b61de8dab51a0 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1017,7 +1017,14 @@ static int gfs2_show_options(struct seq_file *s, struct dentry *root)
 {
 	struct gfs2_sbd *sdp = root->d_sb->s_fs_info;
 	struct gfs2_args *args = &sdp->sd_args;
-	int val;
+	unsigned int logd_secs, statfs_slow, statfs_quantum, quota_quantum;
+
+	spin_lock(&sdp->sd_tune.gt_spin);
+	logd_secs = sdp->sd_tune.gt_logd_secs;
+	quota_quantum = sdp->sd_tune.gt_quota_quantum;
+	statfs_quantum = sdp->sd_tune.gt_statfs_quantum;
+	statfs_slow = sdp->sd_tune.gt_statfs_slow;
+	spin_unlock(&sdp->sd_tune.gt_spin);
 
 	if (is_ancestor(root, sdp->sd_master_dir))
 		seq_puts(s, ",meta");
@@ -1072,17 +1079,14 @@ static int gfs2_show_options(struct seq_file *s, struct dentry *root)
 	}
 	if (args->ar_discard)
 		seq_puts(s, ",discard");
-	val = sdp->sd_tune.gt_logd_secs;
-	if (val != 30)
-		seq_printf(s, ",commit=%d", val);
-	val = sdp->sd_tune.gt_statfs_quantum;
-	if (val != 30)
-		seq_printf(s, ",statfs_quantum=%d", val);
-	else if (sdp->sd_tune.gt_statfs_slow)
+	if (logd_secs != 30)
+		seq_printf(s, ",commit=%d", logd_secs);
+	if (statfs_quantum != 30)
+		seq_printf(s, ",statfs_quantum=%d", statfs_quantum);
+	else if (statfs_slow)
 		seq_puts(s, ",statfs_quantum=0");
-	val = sdp->sd_tune.gt_quota_quantum;
-	if (val != 60)
-		seq_printf(s, ",quota_quantum=%d", val);
+	if (quota_quantum != 60)
+		seq_printf(s, ",quota_quantum=%d", quota_quantum);
 	if (args->ar_statfs_percent)
 		seq_printf(s, ",statfs_percent=%d", args->ar_statfs_percent);
 	if (args->ar_errors != GFS2_ERRORS_DEFAULT) {
-- 
2.40.1



