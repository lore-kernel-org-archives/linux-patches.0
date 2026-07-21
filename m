Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C2343E48D;
	Tue, 21 Jul 2026 21:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668339; cv=none; b=JnSlcHw0LMwEWfFdwB8Tr1tMusSomb4Q+GId6bR6pIBVOnkrZD0zz0ezSwb0+s9B5E26qiRTtNPKqAYW72vZrblw52aBJMebhONG45q3XG8tbw1649Y3n6S4QPLo5tVjiVyu8GGB7jNhx+cLSTNfNEbee53kNdItYTIHgzY/Yu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668339; c=relaxed/simple;
	bh=L7AU6uj7os4UgQtSLDZWJAS1GNjQcNCDDvSnc9/8dx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mb1tU4lUqkYFS5zqo6YflPc6gC7VnBhzNQMVPdNYm5tLETpkxm48mAFtHA4elhkkyyAsUavL2XFifW7THft4IScREZZfCiLeJ1RcD5RPaRhHyTSMW8w9nZJ/zACQfXcdvJkT0IsPhxOJz3TF0AAX4fBI+dRvgRpSAingyXtjh64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdU6eYsR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdU6eYsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E891F000E9;
	Tue, 21 Jul 2026 21:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668338;
	bh=mXF2MrYUiJDiA0FafCUtdurHzcFT87mGT2FeDFF3rA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VdU6eYsRGD8O7ZoNS744ZZ6a0X+Gn6uYHXI0o5G4duuYUf93BcElJH8dvvrczauZY
	 T+pHVkXgb09oV3zjdxJOlSbmp2kbnthx0e+ZjQOLFKE/SctrXGrZWN/bE40xvx4GEZ
	 czfGCW68XqeRN2yrczBrrX2ZrIuwyNQCce1fxNBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.1 0137/1067] ksmbd: serialize QUERY_DIRECTORY requests per file
Date: Tue, 21 Jul 2026 17:12:18 +0200
Message-ID: <20260721152427.658950871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4126,6 +4126,8 @@ int smb2_query_dir(struct ksmbd_work *wo
 		ksmbd_debug(SMB, "Search pattern is %s\n", srch_ptr);
 	}
 
+	mutex_lock(&dir_fp->readdir_lock);
+
 	if (srch_flag & SMB2_REOPEN || srch_flag & SMB2_RESTART_SCANS) {
 		ksmbd_debug(SMB, "Restart directory scan\n");
 		generic_file_llseek(dir_fp->filp, 0, SEEK_SET);
@@ -4230,6 +4232,7 @@ no_buf_len:
 			goto err_out;
 	}
 
+	mutex_unlock(&dir_fp->readdir_lock);
 	kfree(srch_ptr);
 	ksmbd_fd_put(work, dir_fp);
 	ksmbd_revert_fsids(work);
@@ -4237,6 +4240,7 @@ no_buf_len:
 
 err_out:
 	pr_err("error while processing smb2 query dir rc = %d\n", rc);
+	mutex_unlock(&dir_fp->readdir_lock);
 	kfree(srch_ptr);
 
 err_out2:
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -574,6 +574,7 @@ struct ksmbd_file *ksmbd_open_fd(struct
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
@@ -103,6 +104,7 @@ struct ksmbd_file {
 
 	/* if ls is happening on directory, below is valid*/
 	struct ksmbd_readdir_data	readdir_data;
+	struct mutex			readdir_lock;
 	int				dot_dotdot[2];
 	unsigned int			f_state;
 	bool				reserve_lease_break;


