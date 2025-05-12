Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6918629825B;
	Mon, 12 May 2025 18:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073263; cv=none; b=EpESo1LGeUwINx3VP/63Vv/ZMu7qsLxgEWePPuyu8z6Vu9XaX9ToHM8sw2ENOolWKj1/zygTTwfpQlQXWf9CD8NyFjsoQAg1UtpvJJNSUBBJXH6PM0NlYntKCNFzkjLNgF1oUJftxeevDGVNQjaVcpLtBE3KUr9HGokvuheo7jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073263; c=relaxed/simple;
	bh=szKki3rPnekN61gOG8N0BnUwFHyLjM4e7eEGkYzhT/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtYtxks3SG5gURQPIY8olGPR9HvfpGbv1k0UGVD5KmxCRP1xvz5qK742/i5e6aZZ27llhlBbzH/yKaPYwK6OhUpM47csj+C61/wVcFP0Wq3ObQQzFJOf8uuaizFphlLHnYW9VJgQUX7vXPRAmg1ucLyJ9bLIO3r9JJV97YN8JY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azwj8gEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azwj8gEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9A4C4CEEF;
	Mon, 12 May 2025 18:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073262;
	bh=szKki3rPnekN61gOG8N0BnUwFHyLjM4e7eEGkYzhT/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azwj8gEBGOz6m9YL8ibgtioW23JandEqzOCqRg2JQ0SZkr7WZiywlKzsfLDWGGxAf
	 sRlLDQyVBdYy8KVGVxR0qaUiw3oD5k0C/rRYNtFnk42J1zXTJEHUw/bGgPk7f7RdWx
	 kG2PCzRti0AoZDciZlchWakTJIff/uDzIvRZWk3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Heelan <seanheelan@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 008/113] ksmbd: Fix UAF in __close_file_table_ids
Date: Mon, 12 May 2025 19:44:57 +0200
Message-ID: <20250512172028.038419777@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sean Heelan <seanheelan@gmail.com>

commit 36991c1ccde2d5a521577c448ffe07fcccfe104d upstream.

A use-after-free is possible if one thread destroys the file
via __ksmbd_close_fd while another thread holds a reference to
it. The existing checks on fp->refcount are not sufficient to
prevent this.

The fix takes ft->lock around the section which removes the
file from the file table. This prevents two threads acquiring the
same file pointer via __close_file_table_ids, as well as the other
functions which retrieve a file from the IDR and which already use
this same lock.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Heelan <seanheelan@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs_cache.c |   33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -644,21 +644,40 @@ __close_file_table_ids(struct ksmbd_file
 		       bool (*skip)(struct ksmbd_tree_connect *tcon,
 				    struct ksmbd_file *fp))
 {
-	unsigned int			id;
-	struct ksmbd_file		*fp;
-	int				num = 0;
+	struct ksmbd_file *fp;
+	unsigned int id = 0;
+	int num = 0;
 
-	idr_for_each_entry(ft->idr, fp, id) {
-		if (skip(tcon, fp))
+	while (1) {
+		write_lock(&ft->lock);
+		fp = idr_get_next(ft->idr, &id);
+		if (!fp) {
+			write_unlock(&ft->lock);
+			break;
+		}
+
+		if (skip(tcon, fp) ||
+		    !atomic_dec_and_test(&fp->refcount)) {
+			id++;
+			write_unlock(&ft->lock);
 			continue;
+		}
 
 		set_close_state_blocked_works(fp);
+		idr_remove(ft->idr, fp->volatile_id);
+		fp->volatile_id = KSMBD_NO_FID;
+		write_unlock(&ft->lock);
+
+		down_write(&fp->f_ci->m_lock);
+		list_del_init(&fp->node);
+		up_write(&fp->f_ci->m_lock);
 
-		if (!atomic_dec_and_test(&fp->refcount))
-			continue;
 		__ksmbd_close_fd(ft, fp);
+
 		num++;
+		id++;
 	}
+
 	return num;
 }
 


