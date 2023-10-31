Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF11922301
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxHc2sJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AC6C433B9;
	Tue, 31 Oct 2023 17:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774317;
	bh=uj+NkztfoCAjdXGBb631aF9z1x1oa51ZnAnUWd/dYAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxHc2sJ0T0nOpIRZ0e+hni3ZmsFftLqc4Y3FzWE7otj5DHyjI8kV5vrFMwPGY4yPw
	 qZAC3o4dP6KOuRGKKqifPbqg4wtdzbfiX4UwCgMkFgvoODsnefKJJhGpTkfXyLI6p9
	 rn29FhOKF5tZ7TOOW8q1WJcSTKqyfyUcc+uYOrPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 003/112] smb3: allow controlling length of time directory entries are cached with dir leases
Date: Tue, 31 Oct 2023 18:00:04 +0100
Message-ID: <20231031165901.421990053@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 238b351d0935df568ecb3dc5aef25971778f0f7c ]

Currently with directory leases we cache directory contents for a fixed period
of time (default 30 seconds) but for many workloads this is too short.  Allow
configuring the maximum amount of time directory entries are cached when a
directory lease is held on that directory. Add module load parm "max_dir_cache"

For example to set the timeout to 10 minutes you would do:

  echo 600 > /sys/module/cifs/parameters/dir_cache_timeout

or to disable caching directory contents:

  echo 0 > /sys/module/cifs/parameters/dir_cache_timeout

Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c |  4 ++--
 fs/smb/client/cifsfs.c     | 10 ++++++++++
 fs/smb/client/cifsglob.h   |  1 +
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 2d5e9a9d5b8be..9d84c4a7bd0ce 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -145,7 +145,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	const char *npath;
 
 	if (tcon == NULL || tcon->cfids == NULL || tcon->nohandlecache ||
-	    is_smb1_server(tcon->ses->server))
+	    is_smb1_server(tcon->ses->server) || (dir_cache_timeout == 0))
 		return -EOPNOTSUPP;
 
 	ses = tcon->ses;
@@ -582,7 +582,7 @@ cifs_cfids_laundromat_thread(void *p)
 			return 0;
 		spin_lock(&cfids->cfid_list_lock);
 		list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
-			if (time_after(jiffies, cfid->time + HZ * 30)) {
+			if (time_after(jiffies, cfid->time + HZ * dir_cache_timeout)) {
 				list_del(&cfid->entry);
 				list_add(&cfid->entry, &entry);
 				cfids->num_entries--;
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index a4d8b0ea1c8cb..9a6d7e66408d1 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -117,6 +117,10 @@ module_param(cifs_max_pending, uint, 0444);
 MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server for "
 				   "CIFS/SMB1 dialect (N/A for SMB3) "
 				   "Default: 32767 Range: 2 to 32767.");
+unsigned int dir_cache_timeout = 30;
+module_param(dir_cache_timeout, uint, 0644);
+MODULE_PARM_DESC(dir_cache_timeout, "Number of seconds to cache directory contents for which we have a lease. Default: 30 "
+				 "Range: 1 to 65000 seconds, 0 to disable caching dir contents");
 #ifdef CONFIG_CIFS_STATS2
 unsigned int slow_rsp_threshold = 1;
 module_param(slow_rsp_threshold, uint, 0644);
@@ -1679,6 +1683,12 @@ init_cifs(void)
 			 CIFS_MAX_REQ);
 	}
 
+	/* Limit max to about 18 hours, and setting to zero disables directory entry caching */
+	if (dir_cache_timeout > 65000) {
+		dir_cache_timeout = 65000;
+		cifs_dbg(VFS, "dir_cache_timeout set to max of 65000 seconds\n");
+	}
+
 	cifsiod_wq = alloc_workqueue("cifsiod", WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
 	if (!cifsiod_wq) {
 		rc = -ENOMEM;
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 35782a6bede0b..f8eb787ecffab 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1987,6 +1987,7 @@ extern unsigned int CIFSMaxBufSize;  /* max size not including hdr */
 extern unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
 extern unsigned int cifs_min_small;  /* min size of small buf pool */
 extern unsigned int cifs_max_pending; /* MAX requests at once to server*/
+extern unsigned int dir_cache_timeout; /* max time for directory lease caching of dir */
 extern bool disable_legacy_dialects;  /* forbid vers=1.0 and vers=2.0 mounts */
 extern atomic_t mid_count;
 
-- 
2.42.0



