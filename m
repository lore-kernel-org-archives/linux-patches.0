Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E646824DFF6;
	Mon, 12 May 2025 17:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072652; cv=none; b=fMcKS9D4xPoChzm3lz7+65SKk5TNhK1oGJONu/6kUMK9h5LQkKLQAhgSjgO1pDJmLQO/4Yzda0JowAyu9UnNexeQ1NxJbH097Vz5tuhAbmoOSGqVW252B81+uDzz9GuaVpJFSlUglaxDzzCLRsRJ1/JYHlZD8btBrKiJThWeU4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072652; c=relaxed/simple;
	bh=/S8SQJQyeudJk2tdfmtSdvC8jdXYaG3eifPd+ihA2Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoZifzSpUqj/rAQVF95t9nAs8Tua9ZsxWQZQduR+5VhhLDejX+34BQSh4vZJi031Rmlzlu4CtzotG0/+RykG65JeseuczenYUawbnu4JUniyCL/HADxA8lOAOpdNKlfA3m+6+7u+7gf7ClWkOQ0SPmrm6vCv31wpWNmYE+grKJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nW6MNU3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nW6MNU3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E4FC4CEE7;
	Mon, 12 May 2025 17:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072651;
	bh=/S8SQJQyeudJk2tdfmtSdvC8jdXYaG3eifPd+ihA2Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nW6MNU3VawH7o0jxiCGSHb8UCk9NM0GqpAPa/UC3n4ChOsz/iOryhViVTPY+eaI8Z
	 Hpqz+bKtWh67xYI+gaDnKu+RhKNebAWkPFLTnp4u29yWBmA/KFBZOkjYaL4vqvQIQz
	 RTitzDIVzUKuBs+5hD6uRg/ysXCHFU7lSRZm2nRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Heelan <seanheelan@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 015/184] ksmbd: Fix UAF in __close_file_table_ids
Date: Mon, 12 May 2025 19:43:36 +0200
Message-ID: <20250512172042.296407397@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -661,21 +661,40 @@ __close_file_table_ids(struct ksmbd_file
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
 


