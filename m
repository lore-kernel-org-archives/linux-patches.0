Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069E63A7F4C;
	Fri,  4 Sep 2026 05:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499147; cv=none; b=WSaKpGBNCY1cRaPDtEO+nfVxNr/+aDfCjdDkqUDF+j6cex2hSFlK5ROaCIMZGzCZb8Ze2qm9su7jLg59HNXw7bZ9Hw4FQCBQ50ORfcznp7feWxqOkEnIo1HhMzEeYUYrDQdZfQB1KsrN1FDRxmeCgKDFjVBB1P4Xz3VsWfIkka0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499147; c=relaxed/simple;
	bh=R/rSy+SMYjkUEmy6LHTagOibq++G68rr8s1KIHjVK+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsyCQfhaCMPHAYeuaZBqY6cP2rInDTBsw9bk1DhjmKqDk8KiqmxP1TbL3FZf9yx9KIZsHI4Uqws2pj0MvCLyLVrGtcFWG9xjA/Rj/tTNM6OzhTBz6T9DeVtawhbFZVcppq0eNVg5ZdC+3qfS4ZwZLZDcUCToKbWipJi7OX/Agws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZJ/ENbR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZJ/ENbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6211F00A3D;
	Fri,  4 Sep 2026 05:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499145;
	bh=1ftbj8JiOu050iiTDgW2P13vJDIXkeFaGOSUGKMH+cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZJ/ENbRYy/zi/I2tM3VxEG8uIrw5vcY+dbS+yPgvuIu44NY7wWbNcmHoqC0lKGmg
	 5DP7yw8hqAYG7zC0KN9eLV5Yj/S9wu6dGNHu7A/gqMY6vXE57s/FdHZdTmfcom7zhq
	 0EeP3pT+6YZa6oGqrrs7crI0KA61ntrXl3qCI2QU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 7.2 271/713] ecryptfs: hold msg ctx list lock when cleaning daemon queue
Date: Fri,  4 Sep 2026 06:53:59 +0200
Message-ID: <20260904045809.911965952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

commit 779972513c2fa8c7938e54976f686091dafff22f upstream.

ecryptfs_exorcise_daemon() drops queued messages from a dying daemon
without holding ecryptfs_msg_ctx_lists_mux, but
ecryptfs_msg_ctx_alloc_to_free() requires that lock.

Take the list lock while moving the queued contexts back to the free
list to avoid racing with other global msg ctx list users.

Fixes: f66e883eb618 ("eCryptfs: integrate eCryptfs device handle into the module.")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/messaging.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -166,6 +166,7 @@ int ecryptfs_exorcise_daemon(struct ecry
 		mutex_unlock(&daemon->mux);
 		goto out;
 	}
+	mutex_lock(&ecryptfs_msg_ctx_lists_mux);
 	list_for_each_entry_safe(msg_ctx, msg_ctx_tmp,
 				 &daemon->msg_ctx_out_queue, daemon_out_list) {
 		list_del(&msg_ctx->daemon_out_list);
@@ -174,6 +175,7 @@ int ecryptfs_exorcise_daemon(struct ecry
 		       "the out queue of a dying daemon\n", __func__);
 		ecryptfs_msg_ctx_alloc_to_free(msg_ctx);
 	}
+	mutex_unlock(&ecryptfs_msg_ctx_lists_mux);
 	hlist_del(&daemon->euid_chain);
 	mutex_unlock(&daemon->mux);
 	kfree_sensitive(daemon);


