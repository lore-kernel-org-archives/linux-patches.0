Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032637;
	b=P8RJcr7vKlvNreq9sKsRu05NQTj5RFzA2mAZa8f7JjmZtracDJGROU8nvbk+qj/+4Red
	 c2+SuboPu+4fDfRu5sT6kpOJ7mpdefIdYGdilUFE4lwPaXTuNKSAt11oW7Zo8H5U4S0gU
	 up+Vb8wj+9jiB+I0kVyyDabCcAC/XtqEHOupdjjsUfr0wLy2oRpPCFjDliNsstHZ/680I
	 rfGX+8QHkQ483NVx/FrDIj04aEhqdDWZA6EXQxeP8whQEpF+o9ZVZmVIpcJRF9kpXKNIq
	 OG55wsz+FwOFjGWdiSQeq+2vGDdBUHzuW35+GsIA+YqKP58bfdlR2AiT2EXpFdBH9LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nSqn/O6kiqvSMmDn3H/5jXmPfwOlLmjAmAtNuEv5SyA=;
	b=C7jqxVyvLfph4jLyezwwOJmrl5JD6EzpVcTxM1wpyjdrBq/dZki6LQhFYB6fvGSirMxM
	 sKITfJfWEaM0v7YqPV3bxaE62zyKxHDBRKv0ysQ7XusrGUDWV+TZiJyJhehtCDKJCrYBj
	 foPPD+0eYRbJhod/XQ6XwtwCzPZKMvNa519+lzqz3e+/f2sB8uJKfXYqvBmLwF8D3NhQL
	 UFskjmTX5FXhr9ipoY5SYrju0/hI3KCawwuUHT4KstjQYSABr+CdXVyGDYXXI4bEIttok
	 j/qgJ60xj9Z1xakpWH9EVk/H3h8Rbu5X2cPiFoyxxebmA/t/AadQCdvWxPOUKthuM9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eMS7ir9Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A89F606A32A;
	Wed, 18 Nov 2026 20:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eMS7ir9Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF30D1F000C4;
	Wed, 18 Nov 2026 20:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032637;
	bh=nSqn/O6kiqvSMmDn3H/5jXmPfwOlLmjAmAtNuEv5SyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eMS7ir9Qh3j62HFUY1dnPSiYAC+Iae+Gmq4AFcK6WrFmAtdel42Jv3qLUt3VwhrIg
	 WPu/L/cbZqrIdyCRI4ZYy6QCsd510XzMsyGC1h3OzHqYxUYxUtyItUWtkHkbcpM8Jt
	 XzP+WzJNrmIq8SgMyuyrkgDSzEDa0iWHThQ7Hf7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed <mohammed.saad.alquraini@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1482/1756] ksmbd: fix fd_limit accounting across durable reconnects
Date: Wed, 18 Nov 2026 16:00:09 +0100
Message-ID: <20261118150107.972930997@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit df5c868f6b80ca16c171cfac5e4e6c9be83ba4c2 ]

A disconnected durable handle keeps its ksmbd_file and the fd_limit
reservation taken at its initial open. Reconnecting allocates another
volatile ID and takes another reservation for the same file. Final close
returns only one reservation, so repeated reconnects permanently reduce
the server-wide open-file budget.

Move reservation into ksmbd_open_fd() and release it on every creation
failure. Keep the reservation until final close, including while a durable
handle is disconnected. Make ID allocation independent of fd_limit so
reconnects neither consume nor return slots. This also avoids returning an
unreserved slot when persistent ID allocation fails.

New opens continue to return -EMFILE when the budget is exhausted, keeping
the existing STATUS_INSUFFICIENT_RESOURCES mapping.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Reported-by: Mohammed <mohammed.saad.alquraini@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs_cache.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index bde487fb30054..2621d2cffe619 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -721,11 +721,6 @@ static int __open_id(struct ksmbd_file_table *ft, struct ksmbd_file *fp,
 	u64			id = 0;
 	int			ret;
 
-	if (type == OPEN_ID_TYPE_VOLATILE_ID && fd_limit_depleted()) {
-		__open_id_set(fp, KSMBD_NO_FID, type);
-		return -EMFILE;
-	}
-
 	idr_preload(KSMBD_DEFAULT_GFP);
 	write_lock(&ft->lock);
 	ret = idr_alloc_cyclic(ft->idr, fp, KSMBD_START_FID, INT_MAX - 1,
@@ -735,7 +730,6 @@ static int __open_id(struct ksmbd_file_table *ft, struct ksmbd_file *fp,
 		ret = 0;
 	} else {
 		id = KSMBD_NO_FID;
-		fd_limit_close();
 	}
 
 	__open_id_set(fp, id, type);
@@ -755,10 +749,15 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	struct ksmbd_file *fp;
 	int ret;
 
+	/* Durable reconnects reuse the slot held for the lifetime of fp. */
+	if (fd_limit_depleted())
+		return ERR_PTR(-EMFILE);
+
 	fp = kmem_cache_zalloc(filp_cache, KSMBD_DEFAULT_GFP);
 	if (!fp) {
 		pr_err("Failed to allocate memory\n");
-		return ERR_PTR(-ENOMEM);
+		ret = -ENOMEM;
+		goto err_fd_limit;
 	}
 
 	INIT_LIST_HEAD(&fp->blocked_works);
@@ -801,6 +800,8 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	/* fp->conn was set and refcounted before every branch here. */
 	ksmbd_conn_put(fp->conn);
 	kmem_cache_free(filp_cache, fp);
+err_fd_limit:
+	fd_limit_close();
 	return ERR_PTR(ret);
 }
 
-- 
2.53.0



