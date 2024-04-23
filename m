Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A2085274;
	Tue, 23 Apr 2024 21:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908568; cv=none; b=n68Y8kIoWU/fJ5y+bm1wwIJfvTE1mSRhYNP8+K1LcMxEsuSJ206KwhDWSzaKgcCZE1+W4om2iW3aOM0ywXU4PvHSW1uCMR0nxmOZdChTwqmmDIXp2hexVk3nbnfJDTHGAsNh4xEfxxn4dc8dfqqnVZhTMieYNhKJuunR6zm4qN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908568; c=relaxed/simple;
	bh=5qfcQsJ11VJDHWcL6albcm6k/9d62aZm5FogVVVdAxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFgqShNrFUE7srgDnIBwyTvGHRU+7XDk2WozO2SDFmttCAbKLc4ZFHl6odklhUei3zTmwAUHr81IxJNoleU8CaKKIw23yZwLmYcZRM709h4PE4KSZsdHOaNImyVP0nj/6fMXPlU+Q6oGaoRmdorCe4bnUtRb7M53VS6jIirtOew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZi797Uq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZi797Uq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE168C32782;
	Tue, 23 Apr 2024 21:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908567;
	bh=5qfcQsJ11VJDHWcL6albcm6k/9d62aZm5FogVVVdAxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZi797Uq+Q0LSf5r5BD+NhLt41lADiFPofMtXaMvVyCtAxT1QnPHMPtrp3iErElj9
	 c6EoA7X2AnxWH0/ExIoxcsMPRiL7TD2w/zFcQ17NlfABmnqevRQD+Cb+EvcX4WRF0A
	 JiI4N2ez13YR3GzYjZp37pubchGgO39w8JbBCsjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/158] smb3: show beginning time for per share stats
Date: Tue, 23 Apr 2024 14:37:20 -0700
Message-ID: <20240423213855.802187668@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

[ Upstream commit d8392c203e84ec7daa2afecdb8f4db69bc32416a ]

In analyzing problems, one missing piece of debug data is when the
mount occurred.  A related problem is when collecting stats we don't
know the  period of time the stats covered, ie when this set of stats
for the tcon started to be collected.  To make debugging easier track
the stats begin time. Set it when the mount occurred at mount time,
and reset it to current time whenever stats are reset. For example,

...
1) \\localhost\test
SMBs: 14 since 2024-01-17 22:17:30 UTC
Bytes read: 0  Bytes written: 0
Open files: 0 total (local), 0 open on server
TreeConnects: 1 total 0 failed
TreeDisconnects: 0 total 0 failed
...
2) \\localhost\scratch
SMBs: 24 since 2024-01-17 22:16:04 UTC
Bytes read: 0  Bytes written: 0
Open files: 0 total (local), 0 open on server
TreeConnects: 1 total 0 failed
TreeDisconnects: 0 total 0 failed
...

Note the time "since ... UTC" is now displayed in /proc/fs/cifs/Stats
for each share that is mounted.

Suggested-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 062a7f0ff46e ("smb: client: guarantee refcounted children from parent session")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifs_debug.c | 6 ++++--
 fs/smb/client/cifsglob.h   | 1 +
 fs/smb/client/misc.c       | 1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 6c85edb8635d0..c53d516459fc4 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -663,6 +663,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 					spin_lock(&tcon->stat_lock);
 					tcon->bytes_read = 0;
 					tcon->bytes_written = 0;
+					tcon->stats_from_time = ktime_get_real_seconds();
 					spin_unlock(&tcon->stat_lock);
 					if (server->ops->clear_stats)
 						server->ops->clear_stats(tcon);
@@ -743,8 +744,9 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 				seq_printf(m, "\n%d) %s", i, tcon->tree_name);
 				if (tcon->need_reconnect)
 					seq_puts(m, "\tDISCONNECTED ");
-				seq_printf(m, "\nSMBs: %d",
-					   atomic_read(&tcon->num_smbs_sent));
+				seq_printf(m, "\nSMBs: %d since %ptTs UTC",
+					   atomic_read(&tcon->num_smbs_sent),
+					   &tcon->stats_from_time);
 				if (server->ops->print_stats)
 					server->ops->print_stats(m, tcon);
 			}
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index a878b1e5aa313..01d7031194671 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1208,6 +1208,7 @@ struct cifs_tcon {
 	__u64    bytes_read;
 	__u64    bytes_written;
 	spinlock_t stat_lock;  /* protects the two fields above */
+	time64_t stats_from_time;
 	FILE_SYSTEM_DEVICE_INFO fsDevInfo;
 	FILE_SYSTEM_ATTRIBUTE_INFO fsAttrInfo; /* ok if fs name truncated */
 	FILE_SYSTEM_UNIX_INFO fsUnixInfo;
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index ef573e3f8e52a..51413cb00e199 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -140,6 +140,7 @@ tcon_info_alloc(bool dir_leases_enabled)
 	spin_lock_init(&ret_buf->stat_lock);
 	atomic_set(&ret_buf->num_local_opens, 0);
 	atomic_set(&ret_buf->num_remote_opens, 0);
+	ret_buf->stats_from_time = ktime_get_real_seconds();
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	INIT_LIST_HEAD(&ret_buf->dfs_ses_list);
 #endif
-- 
2.43.0



