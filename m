Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AAD208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UyT8YnXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11184C433C8;
	Tue, 31 Oct 2023 17:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774380;
	bh=n3qf/tWenvb9AAJnV6xGTwRlo8tSthU+RlkakyYGKI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UyT8YnXCH2DMbVip00I0LuXVtGspbaJ38m+jOpbLTL3ZbgTpKVmhrbqK9cd/otHj3
	 xgjpnFmHD6i/DkUdqdvyB1IWwQD1Xi6cyV/Ve62UXh6bg7/Ma0WACpXqREAy6PXblL
	 tH8sReCfZg3zx/175NKkC4z84d8I9ZAWax9T9bKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 008/112] smb: client: prevent new fids from being removed by laundromat
Date: Tue, 31 Oct 2023 18:00:09 +0100
Message-ID: <20231031165901.575225050@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 81ba10959970d15c388bf29866b01b62f387e6a3 ]

Check if @cfid->time is set in laundromat so we guarantee that only
fully cached fids will be selected for removal.  While we're at it,
add missing locks to protect access of @cfid fields in order to avoid
races with open_cached_dir() and cfids_laundromat_worker(),
respectively.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c | 56 ++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 21 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index a9e5d3b7e9a05..fe1bf5b6e0cb3 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -170,15 +170,18 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		return -ENOENT;
 	}
 	/*
-	 * At this point we either have a lease already and we can just
-	 * return it. If not we are guaranteed to be the only thread accessing
-	 * this cfid.
+	 * Return cached fid if it has a lease.  Otherwise, it is either a new
+	 * entry or laundromat worker removed it from @cfids->entries.  Caller
+	 * will put last reference if the latter.
 	 */
+	spin_lock(&cfids->cfid_list_lock);
 	if (cfid->has_lease) {
+		spin_unlock(&cfids->cfid_list_lock);
 		*ret_cfid = cfid;
 		kfree(utf16_path);
 		return 0;
 	}
+	spin_unlock(&cfids->cfid_list_lock);
 
 	/*
 	 * Skip any prefix paths in @path as lookup_positive_unlocked() ends up
@@ -295,9 +298,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			goto oshr_free;
 		}
 	}
+	spin_lock(&cfids->cfid_list_lock);
 	cfid->dentry = dentry;
 	cfid->time = jiffies;
 	cfid->has_lease = true;
+	spin_unlock(&cfids->cfid_list_lock);
 
 oshr_free:
 	kfree(utf16_path);
@@ -306,24 +311,28 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 	spin_lock(&cfids->cfid_list_lock);
-	if (rc && !cfid->has_lease) {
-		if (cfid->on_list) {
-			list_del(&cfid->entry);
-			cfid->on_list = false;
-			cfids->num_entries--;
+	if (!cfid->has_lease) {
+		if (rc) {
+			if (cfid->on_list) {
+				list_del(&cfid->entry);
+				cfid->on_list = false;
+				cfids->num_entries--;
+			}
+			rc = -ENOENT;
+		} else {
+			/*
+			 * We are guaranteed to have two references at this
+			 * point. One for the caller and one for a potential
+			 * lease. Release the Lease-ref so that the directory
+			 * will be closed when the caller closes the cached
+			 * handle.
+			 */
+			spin_unlock(&cfids->cfid_list_lock);
+			kref_put(&cfid->refcount, smb2_close_cached_fid);
+			goto out;
 		}
-		rc = -ENOENT;
 	}
 	spin_unlock(&cfids->cfid_list_lock);
-	if (!rc && !cfid->has_lease) {
-		/*
-		 * We are guaranteed to have two references at this point.
-		 * One for the caller and one for a potential lease.
-		 * Release the Lease-ref so that the directory will be closed
-		 * when the caller closes the cached handle.
-		 */
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
-	}
 	if (rc) {
 		if (cfid->is_open)
 			SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
@@ -331,7 +340,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		free_cached_dir(cfid);
 		cfid = NULL;
 	}
-
+out:
 	if (rc == 0) {
 		*ret_cfid = cfid;
 		atomic_inc(&tcon->num_remote_opens);
@@ -583,15 +592,18 @@ static void cfids_laundromat_worker(struct work_struct *work)
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
-		if (time_after(jiffies, cfid->time + HZ * dir_cache_timeout)) {
+		if (cfid->time &&
+		    time_after(jiffies, cfid->time + HZ * dir_cache_timeout)) {
+			cfid->on_list = false;
 			list_move(&cfid->entry, &entry);
 			cfids->num_entries--;
+			/* To prevent race with smb2_cached_lease_break() */
+			kref_get(&cfid->refcount);
 		}
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
-		cfid->on_list = false;
 		list_del(&cfid->entry);
 		/*
 		 * Cancel and wait for the work to finish in case we are racing
@@ -608,6 +620,8 @@ static void cfids_laundromat_worker(struct work_struct *work)
 			spin_unlock(&cfids->cfid_list_lock);
 			kref_put(&cfid->refcount, smb2_close_cached_fid);
 		}
+		/* Drop the extra reference opened above */
+		kref_put(&cfid->refcount, smb2_close_cached_fid);
 	}
 	queue_delayed_work(cifsiod_wq, &cfids->laundromat_work,
 			   dir_cache_timeout * HZ);
-- 
2.42.0



