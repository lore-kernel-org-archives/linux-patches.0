Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722984252A4;
	Thu, 16 Jul 2026 13:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209646; cv=none; b=UngwUImnQzH9ZTtj+SV82gQHfjkyQHKmgw9pcYiVYj2AaY0r/tSYldoL5FCziUGVIVQ/ko9MxDGNuy02X05A4svySf7bZSusjVPTWkYNMfLqSmuhN3+gZP2QC+eFbA+xjTN3twL3joVu+HNLunnoWakgttIfSPhMZFn/QMOV4ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209646; c=relaxed/simple;
	bh=4ROVlXXVbhDNylh2387RIhC+A4VQS4IsclPPQhDKHY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAUQGdV/TI1SmLiSooJJWJJ6t8+l8OTrGvJ8aX1bNfOa0g14IboLk/K4bwIYVpj+v9njuyh0pRJXDWAA4WB4quIcot+JlHPUvQNspqibRB6kiGltUx87/UDZVb8Hr1ANnRbgfMBhbDe1beZJIfy/vFkC76YNgoJRJ/Eps9m5Oh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8JnEl7X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8JnEl7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37BC1F00A3D;
	Thu, 16 Jul 2026 13:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209639;
	bh=MF9yoWwba3YxGrtvZuJzUNDJGsd2OoyHZCGT6rCT+MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8JnEl7X6J2xCXCVBvJyyhKcyzjscQ5kJOTk4CzCGEdZAYCs4AVaMdREZtJDhIUuG
	 6rff/Vj8XSlNafFpeMt8Xo3U1iITgkPzbx+qEaXJec82/Vp9fAcHS+H/UuuTSWapWJ
	 gPZhcW6mG0ywJCMi/mmOR2YYqSESenOaakKnP4GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 7.1 219/518] ksmbd: serialize QUERY_DIRECTORY requests per file
Date: Thu, 16 Jul 2026 15:28:07 +0200
Message-ID: <20260716133052.608487966@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit be6d26bf27499977c746abc163659915082348d8 upstream.

smb2_query_dir() stores a pointer to its stack-allocated private data in
the ksmbd_file readdir_data. Concurrent QUERY_DIRECTORY requests using the
same file handle can overwrite this pointer while an iterate_dir() callback
is still using it, resulting in a stack use-after-free.

Add a per-file mutex and hold it while accessing the shared directory
enumeration state. The lock covers scan restart, dot entry state,
readdir_data setup and iteration, and response construction. This prevents
another request from replacing readdir_data.private before the current
request has finished using it and also serializes the shared file position.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-30527
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c   |    4 ++++
 fs/smb/server/vfs_cache.c |    1 +
 fs/smb/server/vfs_cache.h |    2 ++
 3 files changed, 7 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4470,6 +4470,8 @@ int smb2_query_dir(struct ksmbd_work *wo
 		ksmbd_debug(SMB, "Search pattern is %s\n", srch_ptr);
 	}
 
+	mutex_lock(&dir_fp->readdir_lock);
+
 	if (srch_flag & SMB2_REOPEN || srch_flag & SMB2_RESTART_SCANS) {
 		ksmbd_debug(SMB, "Restart directory scan\n");
 		generic_file_llseek(dir_fp->filp, 0, SEEK_SET);
@@ -4574,6 +4576,7 @@ no_buf_len:
 			goto err_out;
 	}
 
+	mutex_unlock(&dir_fp->readdir_lock);
 	kfree(srch_ptr);
 	ksmbd_fd_put(work, dir_fp);
 	ksmbd_revert_fsids(work);
@@ -4581,6 +4584,7 @@ no_buf_len:
 
 err_out:
 	pr_err("error while processing smb2 query dir rc = %d\n", rc);
+	mutex_unlock(&dir_fp->readdir_lock);
 	kfree(srch_ptr);
 
 err_out2:
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -790,6 +790,7 @@ struct ksmbd_file *ksmbd_open_fd(struct
 	INIT_LIST_HEAD(&fp->node);
 	INIT_LIST_HEAD(&fp->lock_list);
 	spin_lock_init(&fp->f_lock);
+	mutex_init(&fp->readdir_lock);
 	atomic_set(&fp->refcount, 1);
 
 	fp->filp		= filp;
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -8,6 +8,7 @@
 
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/spinlock.h>
 #include <linux/idr.h>
@@ -113,6 +114,7 @@ struct ksmbd_file {
 
 	/* if ls is happening on directory, below is valid*/
 	struct ksmbd_readdir_data	readdir_data;
+	struct mutex			readdir_lock;
 	int				dot_dotdot[2];
 	unsigned int			f_state;
 	bool				reserve_lease_break;


