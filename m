Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C4141CB47;
	Fri,  4 Sep 2026 06:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502341; cv=none; b=lzDRrKh4V+1ywPpr95mLPxpz8fkdCE/50maenEXbfbV1tR3x7Oe7l5jHINbgBAtjQR5WryGrb3zI5vlfCp9topQiWXKP+8aAZASYABRs3DQHFZ8a5Ma77mJEggOUraKWzGEo2DKBuqhfmpM6DLZBktLnWBZrFzn0AmiUnofdrIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502341; c=relaxed/simple;
	bh=AYnKIrPHR4/igMYveO3PLsf9nms34X/8RUiRqpEyXl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9BToifBbDu0aU3QiR6b5pdeCpE1PGZHTVWzsKpA6vShZWDWjyIUjNoHcGo0ef4Wr8sQB6+zT9UsAU/+zsXpfVLgaGnMclt1hsAnYuM+WGy9yo3Xvhtu9NnIJzIXmLuaz0uScReFH2dqehE3S+zo2k6ZB+ghGMJOaq5Ox2cYUqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBtI6M8+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBtI6M8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EC81F00A3D;
	Fri,  4 Sep 2026 06:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502339;
	bh=sJjS/Z/hLYMnfNS44ugTvYGstxaYOQXtgLar9cCK5ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xBtI6M8+rUKlH/MEUOvXgvJF6eU7HyezybLKIu1mSljkEelpKv5oBSmTWu2LP+VFG
	 iDQ3O32CEjDqkp2mx2ZRi+x48zYOmEGQM1+/umH7KRQEZJYE6foEc1Ah5nwmJ1Ds/V
	 TTlcyqdSuj2p5zkn/cXCRMnyK2XOAqCp8/opFNVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.12 136/403] ecryptfs: hold msg ctx list lock when cleaning daemon queue
Date: Fri,  4 Sep 2026 06:58:59 +0200
Message-ID: <20260904045737.933845344@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -165,6 +165,7 @@ int ecryptfs_exorcise_daemon(struct ecry
 		mutex_unlock(&daemon->mux);
 		goto out;
 	}
+	mutex_lock(&ecryptfs_msg_ctx_lists_mux);
 	list_for_each_entry_safe(msg_ctx, msg_ctx_tmp,
 				 &daemon->msg_ctx_out_queue, daemon_out_list) {
 		list_del(&msg_ctx->daemon_out_list);
@@ -173,6 +174,7 @@ int ecryptfs_exorcise_daemon(struct ecry
 		       "the out queue of a dying daemon\n", __func__);
 		ecryptfs_msg_ctx_alloc_to_free(msg_ctx);
 	}
+	mutex_unlock(&ecryptfs_msg_ctx_lists_mux);
 	hlist_del(&daemon->euid_chain);
 	mutex_unlock(&daemon->mux);
 	kfree_sensitive(daemon);


