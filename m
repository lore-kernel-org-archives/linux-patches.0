Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8C5278161;
	Sat, 12 Sep 2026 15:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226939; cv=none; b=GE+eLoK4kLwLNPD2AVsdyvHI432+JuKW10WOMQGpURV4QReGHCWocCzYNhdZN8FfjhR4hEh9m3TxYoVaD1JslBwfrc0allaGdh4Rc0/QLAk7+R8qGdALeS+hQPwxrsu1qL17nxO2bqbh52MT9CXIxsWdry/pKFRrplrrXYztMhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226939; c=relaxed/simple;
	bh=sUJE32euu2JZ20tnHEpvBdOFqsQmrZtLojsbaAJXb7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sngy4Qdk4PNBIAQHfaHBU8svikZqLLrl955oXEz8/anGLU8GtExjGXTjyflk7h8Ei0YvzTsgfxQAPX7Pri39EqC546ThDljEwUbooztUdGPZld/XnC79n3Y3ilAqPkJCkbRw83wjSS49D3oS8bpMlBsbTohjV6aeftsDmBNp/XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMJs3J23; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMJs3J23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BC61F000FF;
	Sat, 12 Sep 2026 15:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226938;
	bh=3RLsaeB6xWSv4XuKhlerA3ahfhOZW11GVZWTnKhe8do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cMJs3J238IDYQkmHA81yeQNq57OTLP2EJZNp/ROrsWh8fAslnbM9AlXrD5PfRX17z
	 mq4IZ/dObwo6P6qWFaP6Q/wLIIYKtpxY6L9eC1wqOTwN/ZHsIuxBfFua92dYko+gOg
	 IqmhQDFfFgmaUSVXllmsia42AFnft5D848O1hC+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.1 0079/1191] ecryptfs: hold msg ctx list lock when cleaning daemon queue
Date: Sat, 12 Sep 2026 08:46:47 +0200
Message-ID: <20260912065549.942628680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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


