Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19BAFBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454C1C433EF;
	Mon, 15 May 2023 17:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171168;
	bh=W5PsV+3Yq3Z8XY+NSLRAjCZWEhpuHTyBF5RUo0GglHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wUBvTB8ZA0boezzwr3idNNSNBbR5w5Yx9PKQ12UTzWyedUHOABbfKqnIHL/87SvLr
	 c1k4D+NUGEON0+wXf6nrZkh2Y1Pc+o1BJqCG4fRxJN00rrlAisbcwNXfAccPtqLMX4
	 6WVNtNjzyFo2hkY1iwOk71YZImSRTdYMPdRxx/NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 122/242] cifs: check only tcon status on tcon related functions
Date: Mon, 15 May 2023 18:27:28 +0200
Message-Id: <20230515161725.565508791@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 2f0e4f0342201fe2228fcc2301cc2b42ae04b8e3 ]

We had a couple of checks for session in cifs_tree_connect
and cifs_mark_open_files_invalid, which were unnecessary.
And that was done with ses_lock. Changed that to tc_lock too.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 6be2ea33a409 ("cifs: avoid potential races when handling multiple dfs tcons")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c   | 10 +++++++---
 fs/cifs/dfs.c       | 10 +++++++---
 fs/cifs/dfs_cache.c |  2 +-
 fs/cifs/file.c      |  8 ++++----
 4 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 87527512c2660..af491ae70678a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4119,9 +4119,13 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	/* only send once per connect */
 	spin_lock(&tcon->tc_lock);
-	if (tcon->ses->ses_status != SES_GOOD ||
-	    (tcon->status != TID_NEW &&
-	    tcon->status != TID_NEED_TCON)) {
+	if (tcon->status != TID_NEW &&
+	    tcon->status != TID_NEED_TCON) {
+		spin_unlock(&tcon->tc_lock);
+		return -EHOSTDOWN;
+	}
+
+	if (tcon->status == TID_GOOD) {
 		spin_unlock(&tcon->tc_lock);
 		return 0;
 	}
diff --git a/fs/cifs/dfs.c b/fs/cifs/dfs.c
index 4c392bde24066..f02f8d3b92ee8 100644
--- a/fs/cifs/dfs.c
+++ b/fs/cifs/dfs.c
@@ -571,9 +571,13 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	/* only send once per connect */
 	spin_lock(&tcon->tc_lock);
-	if (tcon->ses->ses_status != SES_GOOD ||
-	    (tcon->status != TID_NEW &&
-	    tcon->status != TID_NEED_TCON)) {
+	if (tcon->status != TID_NEW &&
+	    tcon->status != TID_NEED_TCON) {
+		spin_unlock(&tcon->tc_lock);
+		return -EHOSTDOWN;
+	}
+
+	if (tcon->status == TID_GOOD) {
 		spin_unlock(&tcon->tc_lock);
 		return 0;
 	}
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 9ccaa0c7ac943..6557d7b2798a0 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1191,7 +1191,7 @@ static int __refresh_tcon(const char *path, struct cifs_tcon *tcon, bool force_r
 	}
 
 	spin_lock(&ipc->tc_lock);
-	if (ses->ses_status != SES_GOOD || ipc->status != TID_GOOD) {
+	if (ipc->status != TID_GOOD) {
 		spin_unlock(&ipc->tc_lock);
 		cifs_dbg(FYI, "%s: skip cache refresh due to disconnected ipc\n", __func__);
 		goto out;
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index bef7c335ccc6e..d037366fcc5ee 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -48,13 +48,13 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 	struct list_head *tmp1;
 
 	/* only send once per connect */
-	spin_lock(&tcon->ses->ses_lock);
-	if ((tcon->ses->ses_status != SES_GOOD) || (tcon->status != TID_NEED_RECON)) {
-		spin_unlock(&tcon->ses->ses_lock);
+	spin_lock(&tcon->tc_lock);
+	if (tcon->status != TID_NEED_RECON) {
+		spin_unlock(&tcon->tc_lock);
 		return;
 	}
 	tcon->status = TID_IN_FILES_INVALIDATE;
-	spin_unlock(&tcon->ses->ses_lock);
+	spin_unlock(&tcon->tc_lock);
 
 	/* list all files open on tree connection and mark them invalid */
 	spin_lock(&tcon->open_file_lock);
-- 
2.39.2



