Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74F43905F4;
	Fri,  4 Sep 2026 05:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500828; cv=none; b=TVk4VEhX8KR/lHIMQxdV8HiguEcaXJgUGqwTQ0FYr5A4KaPWxpIQCeqr6Vg4g/9IYVJWGq5TUdMvaG99YfYf2m0cjXNN9l9WWdk02bQrmXYLDggMWAiAthnac2ZEZ9z4Jk+CoIZqmdylp7qv1Ql+EIfx29oq2NaZbwu3JvktIgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500828; c=relaxed/simple;
	bh=Co/SGqHHoKxhlg+OIkCqXOXASlWv53TO9pzyKXmPhS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnrNunKZH6VUsrQGAVfnACm1zxSClmg5tsRSDWrHy5LSmqqsj0N0HXNSriFEPMnJ1EKLm6OHJ0olVQiSWfuc8LLdYPAwOYsq4Un6tjvnuNAjyK7G45DL1oltRG2xeVyfcUwustL1av/qhFkBmSC8IBVlPe6AnP5TJWbIF0ajGIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVdLRkXG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVdLRkXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7111F00A3D;
	Fri,  4 Sep 2026 05:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500827;
	bh=SgkYkzHYz2WzIrTQ0OM4h6Oz94SrqA0kWiKnrqklumg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OVdLRkXGRooRswJXnds87T6lbxOIricrjzSEHHnX5BXMcWazu5oUxyKrNlpCYfDHn
	 tiu/sPnyIaqfs6LnhLLxx7jP4cqTZeqdjmb9gph5CbGjrRjXq7sP/lUdKmk9YuR6Zd
	 Xzr4VhnaWq6utt9UJpUwcg6evA9McSwFV6YhWM1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.18 193/552] ecryptfs: hold msg ctx list lock when cleaning daemon queue
Date: Fri,  4 Sep 2026 06:55:50 +0200
Message-ID: <20260904045753.391515443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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


