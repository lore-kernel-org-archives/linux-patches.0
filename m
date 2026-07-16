Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348433BCD05;
	Thu, 16 Jul 2026 14:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210894; cv=none; b=QLDWEheD+gpBaDNqnazIJu4nlU+bLOTPVpAWPTmeXQ7TIOmeb2O1tRdO01ppTvoVCqmnx86Tm7RIf46Tp0ur8WnEjtOPDbLTJXQtqPGTaal9I0MelJA2qTxL4oR/5HOAQMG6IxXiS8Bro4hYIZo/3dT0/lq0JwF3MCHdkmYB/4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210894; c=relaxed/simple;
	bh=e9ra0Mw9eElmL8KPq+G9HVWmDLFJUfThsIOtRN416KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEShcvk9sFdKvn+uv7GWHxsVJ7sYbKhHzpCDx+ybkdPrOffXdIsgG/UCtaar3LJBAIPyidA66fh4Ang/gcc+DynGs9WA/sC9nDem+rAcqbB+ESFvJMsH+numDbIpOqTOQ66m/7+0XSziM15bYypV+1Yda74os4YVNs0wUA2g0A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvOXwXHC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvOXwXHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042541F00A3A;
	Thu, 16 Jul 2026 14:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210891;
	bh=BaHShmtWeIwp/OMU7MeC2bzVJX3kYNUaAXGNa4n55WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gvOXwXHC8lS7h7/cEyZX91MHJ71Wk3glPaW0MG91lSgzMRpfBaykpQr6Oc1489rL1
	 xnjxzJldfPFYNXFfMrzmcYypbVegBi0pwszJKkprA1h+tgRcJagZ4aIH0/PW23FSD+
	 +S1hCLehdYl9gssRb5n1i+z1aPJwpNdapoiPEbys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.18 219/480] ksmbd: serialize QUERY_DIRECTORY requests per file
Date: Thu, 16 Jul 2026 15:29:26 +0200
Message-ID: <20260716133049.471985042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4472,6 +4472,8 @@ int smb2_query_dir(struct ksmbd_work *wo
 		ksmbd_debug(SMB, "Search pattern is %s\n", srch_ptr);
 	}
 
+	mutex_lock(&dir_fp->readdir_lock);
+
 	if (srch_flag & SMB2_REOPEN || srch_flag & SMB2_RESTART_SCANS) {
 		ksmbd_debug(SMB, "Restart directory scan\n");
 		generic_file_llseek(dir_fp->filp, 0, SEEK_SET);
@@ -4576,6 +4578,7 @@ no_buf_len:
 			goto err_out;
 	}
 
+	mutex_unlock(&dir_fp->readdir_lock);
 	kfree(srch_ptr);
 	ksmbd_fd_put(work, dir_fp);
 	ksmbd_revert_fsids(work);
@@ -4583,6 +4586,7 @@ no_buf_len:
 
 err_out:
 	pr_err("error while processing smb2 query dir rc = %d\n", rc);
+	mutex_unlock(&dir_fp->readdir_lock);
 	kfree(srch_ptr);
 
 err_out2:
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -686,6 +686,7 @@ struct ksmbd_file *ksmbd_open_fd(struct
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


