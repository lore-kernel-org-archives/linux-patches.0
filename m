Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027618;
	b=hiVPjPfhkXffiTzJBqVSCMnnrwtbWbUFWLfEbk7Ng2Ee290HXVW0LcEfOHUI1k51lNsW
	 hcQz669dJ6PJkIICRktF7o+tm+VMbho6UhLmiiPb7EM3yR3UC+VjOh3n4Y2C/BoDEvwj1
	 tP78KkOszFCn9CRhfwOCJ3/Tw8TulNQFg0ARoNVo1zwREmJxfpMD34PO6fGPki2aF8J51
	 QKn+DwZVI8B1nmoJJ1AIFuMvK/0i7XFJj7Ph0rxPNue/HP1urFf7W5ivs6EPFX9iY1dSw
	 AiYlR9MrzkXVPzzNGDU9URLhAnrsNv/yhmcWeZdLV1WEEFUWbRzj4ZVx063isUBdbYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oLoO4uDvq6jttfOk9K4TZ5wbAjBY4yI2l2Hy7Y2QxME=;
	b=vMOkvJDqkWppmhTkWN/VSf8ZrZAV+UjqJ0rD0ATZtNt58Br05cOk9koCF+3Y5fHpuqCa
	 HfGkQOT8wQ/vs+grzmhOa9dktxuRF+MRIACFgJKPGc7GZbDaEWItWW2YKtfhvE+M9V72o
	 Rs/sbDUCF1jU73ZWeYxkvrD49CsaJjJHx2b/2wy07Sq4/+Y8rMq6JLn145V5cR5ESBjFD
	 8QXb/FMESaDI7BjMhdhl1cPG5hH+Q4VBR2x2rqg5Act3h1BSR0ErHHvcjIgNeGpBZOzRa
	 RxIEvx4CVqS8QjcJThLdgrojk7dcv4Cu2p+l6IrVCCXq2BoI1sPXZquSoI2obGaHyqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fb1LqYVO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12364606A32C;
	Wed, 18 Nov 2026 18:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fb1LqYVO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B601F000C4;
	Wed, 18 Nov 2026 18:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027617;
	bh=oLoO4uDvq6jttfOk9K4TZ5wbAjBY4yI2l2Hy7Y2QxME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fb1LqYVOjLSd+dsMBSUo1j0Krz7i/l8lMci/0rnW9Kl/fVPV+oI7tNsDSAbJfzUfy
	 kyMO/iwxUiMapCKRIAOsYAFNoxWuJZMaidw/9TNQQrCP167EvgnJSHu5OhoafrcjDo
	 keQk0kYV+m91NWKNZh0fs0D0B3uxkjdVD2/5BMYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed <mohammed.saad.alquraini@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1852/2151] ksmbd: fix fd_limit accounting across durable reconnects
Date: Wed, 18 Nov 2026 15:59:47 +0100
Message-ID: <20261118150229.259821867@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



