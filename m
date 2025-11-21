Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494D734CFDB;
	Fri, 21 Nov 2025 13:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733149; cv=none; b=T078Qzc8eivFR0uCRa+obtOh3HYbXMB50V6A/4dR/wW9fdAk+W/R0OeePp6GBt9TjUdftMk73sbrjP9/w5+tkwQfoaIPezxMHFUIqgB8kWTGQXrNPqKXaEpdHGLQNuQqxNMyOku/AxS+8i9wV4i5tAXu899k7Ikj6vj7y9FdMpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733149; c=relaxed/simple;
	bh=hwEQ++xL32SxkEakiWnH/ZEaSbVhksbN4bGn4bNtt8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wg1yS+HgxYNkB++57qtalH0cbGgzwA3h4ab1rvCImJq1fT0xaGupZAn6jrYmLCIiMwixwFwqjXodhVnvvSSHzTIYP8jL0hbvlwMpwFOCs2jDaKkm2b8SYIVwR8uLjFBuRKbPACaLe504q73lVTHD8nVGaQPix2UGgHb9TNZB67Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StKJVJcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StKJVJcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA573C4CEF1;
	Fri, 21 Nov 2025 13:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733149;
	bh=hwEQ++xL32SxkEakiWnH/ZEaSbVhksbN4bGn4bNtt8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StKJVJcLCgvRoA1QsRRVEqezL1+bf1mavjHBXD7XqRUVqKOsdPwFEsqvy788/3KIT
	 +B+zd+/vemHJrf6mu0xktERTDAaMOXfYyUeWXeHKqCdCWLj9kiiAG48zcrYKMzbxDu
	 oeZfIVJiRDVHCYta6h7E+F7KOB+P1dXMla48PYmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Shin <jaeshin@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 368/529] smb: client: fix potential UAF in smb2_close_cached_fid()
Date: Fri, 21 Nov 2025 14:11:07 +0100
Message-ID: <20251121130244.121385841@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Henrique Carvalho <henrique.carvalho@suse.com>

commit 734e99623c5b65bf2c03e35978a0b980ebc3c2f8 upstream.

find_or_create_cached_dir() could grab a new reference after kref_put()
had seen the refcount drop to zero but before cfid_list_lock is acquired
in smb2_close_cached_fid(), leading to use-after-free.

Switch to kref_put_lock() so cfid_release() is called with
cfid_list_lock held, closing that gap.

Fixes: ebe98f1447bb ("cifs: enable caching of directories for which a lease is held")
Cc: stable@vger.kernel.org
Reported-by: Jay Shin <jaeshin@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cached_dir.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -362,11 +362,11 @@ out:
 			 * lease. Release one here, and the second below.
 			 */
 			cfid->has_lease = false;
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
+			close_cached_dir(cfid);
 		}
 		spin_unlock(&cfids->cfid_list_lock);
 
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		close_cached_dir(cfid);
 	} else {
 		*ret_cfid = cfid;
 		atomic_inc(&tcon->num_remote_opens);
@@ -406,12 +406,14 @@ int open_cached_dir_by_dentry(struct cif
 
 static void
 smb2_close_cached_fid(struct kref *ref)
+__releases(&cfid->cfids->cfid_list_lock)
 {
 	struct cached_fid *cfid = container_of(ref, struct cached_fid,
 					       refcount);
 	int rc;
 
-	spin_lock(&cfid->cfids->cfid_list_lock);
+	lockdep_assert_held(&cfid->cfids->cfid_list_lock);
+
 	if (cfid->on_list) {
 		list_del(&cfid->entry);
 		cfid->on_list = false;
@@ -446,7 +448,7 @@ void drop_cached_dir_by_name(const unsig
 	spin_lock(&cfid->cfids->cfid_list_lock);
 	if (cfid->has_lease) {
 		cfid->has_lease = false;
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		close_cached_dir(cfid);
 	}
 	spin_unlock(&cfid->cfids->cfid_list_lock);
 	close_cached_dir(cfid);
@@ -455,7 +457,7 @@ void drop_cached_dir_by_name(const unsig
 
 void close_cached_dir(struct cached_fid *cfid)
 {
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
+	kref_put_lock(&cfid->refcount, smb2_close_cached_fid, &cfid->cfids->cfid_list_lock);
 }
 
 /*
@@ -566,7 +568,7 @@ cached_dir_offload_close(struct work_str
 
 	WARN_ON(cfid->on_list);
 
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
+	close_cached_dir(cfid);
 	cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cached_close);
 }
 
@@ -743,7 +745,7 @@ static void cfids_laundromat_worker(stru
 			 * Drop the ref-count from above, either the lease-ref (if there
 			 * was one) or the extra one acquired.
 			 */
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
+			close_cached_dir(cfid);
 	}
 	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
 			   dir_cache_timeout * HZ);


