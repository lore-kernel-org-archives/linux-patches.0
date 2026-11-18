Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021409;
	b=gqytDp0lILKVbfqN+My2wikdLBlmWzunrcDFfG6nUIMJQe4H5AmimnRYvL02JZ75vZT3
	 PtLRVqkcigIOzaCyNx44oW6xAKHi3VQX621l4/6AsfLfHttQ2SZI9k9GVRKDJt4HiChy6
	 AWcRxWR/sKK3rp+7lpAKAXiqtO8YIL1C4AeyQV+sJJw4B9c3ozjZyw2moeJU6+nFZGc5d
	 0BCelMRgZM1Uttt6MA8TBeRNxEh0+MR7D8CW3BId91zm6n1aR/tPH1EvlW0HYUjcGKgWt
	 xiz57MK6xUh5A2NylGXenF6lchcQ7K1XMVaDyRfDAzbvLQNmZhR8z4Cim5AKVC/4LjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6/vhDqhodzT+OW6KH96fftSU7KybQAFIMno+5QN64+w=;
	b=N1vO2yqGeg6uh+RPYSCNMsho11we0W/+kRFibu8zPRWso2+3WHH0BTXelqi8iIE5p/a7
	 7eeCmA5ePdhDCs82dCXPVnYL/grhgHYnj9jF2quqNLBrsuDBrQKr5y3d+iaFib3Qo/tl2
	 zi6gS8uhYpXjBqhTu9UcfRok2SNkplKrjuqaJKV6KDzlVqcIkgYw1j0beDeaKR6a/8Tix
	 WlO4/XL68znyIxdmEdpbJHKqAyl1KH9iVojPj+D5VXzWg6h2+3XuyzakcxUNbm3QiooxH
	 sReMqVq2Xu8sBA4OXOTGzGNeMWkWJJS27k5FCZIgIGVAPpm132MbYhsBOrCK4oHsALg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hiCQ1Zii;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B606606A320;
	Wed, 18 Nov 2026 17:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hiCQ1Zii
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E5F1F000C4;
	Wed, 18 Nov 2026 17:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021409;
	bh=6/vhDqhodzT+OW6KH96fftSU7KybQAFIMno+5QN64+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hiCQ1Ziit/zFG0UcQ7VQrKUtCSs/6irczzJoXIYsKdfApuPpSMCBWnLx6EYlM585q
	 kge1op7BimZ/PvvgMvHbPzymCK3P42rpNotKDjqaFPVIe4+BYF4hvjC7eQE6IotO39
	 SfSlFC8vs9a6bfN1wV9Qx8D/Vu+tE5PcDIyu86GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed <mohammed.saad.alquraini@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2297/2651] ksmbd: fix fd_limit accounting across durable reconnects
Date: Wed, 18 Nov 2026 15:58:57 +0100
Message-ID: <20261118150407.930041916@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f00d4d81283a8..c6999ed4e6d67 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1283,11 +1283,6 @@ static int __open_id(struct ksmbd_file_table *ft, struct ksmbd_file *fp,
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
@@ -1297,7 +1292,6 @@ static int __open_id(struct ksmbd_file_table *ft, struct ksmbd_file *fp,
 		ret = 0;
 	} else {
 		id = KSMBD_NO_FID;
-		fd_limit_close();
 	}
 
 	__open_id_set(fp, id, type);
@@ -1317,10 +1311,15 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
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
@@ -1374,6 +1373,8 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	ksmbd_conn_put(fp->conn);
 	ksmbd_share_config_put(fp->share_conf);
 	kmem_cache_free(filp_cache, fp);
+err_fd_limit:
+	fd_limit_close();
 	return ERR_PTR(ret);
 }
 
-- 
2.53.0



