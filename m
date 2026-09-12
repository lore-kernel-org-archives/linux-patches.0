Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C5E35F602;
	Sat, 12 Sep 2026 09:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204159; cv=none; b=IW6odppsDMFjRRZYJDH12Oc2vx2CwQYnrYIpY5SUu8wQwMRPKQ7G53LudIyu6OvtG23HdbKdY6DAHdaCHWZSl1HglGJEz2WE1wwnIYMu5Uv5pOavxqPGG2zvsk4WMCARKsWXEcK7xBnhGNjrfxKxVtBEdoY4K7ifFknVprC4llY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204159; c=relaxed/simple;
	bh=y8NYOw/3/Bdc2iSZa7eP1ME3oJ4xGn7Qh+x38n4RGP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+9AeZw5ot1O1AtVE3PNnfJu7pXGHCPmbM1gspTE9qnyFpdr2cBi2bhTD3YD22H2UkP50qCqezdE/EvDgMAhXxgxf6qaql7LEIoeNZZlAlPesL+wgZdPQfnyR05OWYjwpr7H7TdaGJDKnrkF4SV8i1sahG7XXr93nYf3FgtAkhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJ+cRUvx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJ+cRUvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57061F000FF;
	Sat, 12 Sep 2026 09:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204158;
	bh=ilPfmrNo7VjavkmWWxfyBWpLpvE4rhFK1rorVV83k5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJ+cRUvxyI0RTb8e8yYfaEMSo8hKCu4FAYnu4kwIzYPv3zjQrLYC/J99Wy7eBrQ44
	 r9XtvnUyCJ4/YKkRHrkCQSfqdaLP//ST2gNNEJk40wDHa0MSijGJIQ0b6B4hFHkkFd
	 pI2AxqdapDsqn/3r0slsfGwi/7SU8+NWhvpPs8Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1512/1815] ksmbd: retain connection for pending notify work
Date: Sat, 12 Sep 2026 08:54:22 +0200
Message-ID: <20260912065724.494376008@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit f495154703cbcc0050cfd53469bd56965791616b ]

Deferred CHANGE_NOTIFY work keeps an async message ID after the original
request work is released. A durable handle can outlive its connection, so
the connection teardown can destroy its async IDA before the handle close
releases the pending notify work.

Give the synthetic deferred work a connection reference. Release it after
the async ID in ksmbd_free_work_struct(). This keeps the async IDA alive
until the deferred work is released, even when the original connection has
already left the connection list.

During server shutdown there is no client to receive a cleanup response.
Skip the write and only release the pending work.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: b0148dc5625d ("ksmbd: serialize oplock close with pending break ownership")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/ksmbd_work.c | 2 ++
 fs/smb/server/ksmbd_work.h | 2 ++
 fs/smb/server/smb2pdu.c    | 4 +++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index 97502273a49c0..c3f8915c39523 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -86,6 +86,8 @@ void ksmbd_free_work_struct(struct ksmbd_work *work)
 
 	if (work->async_id)
 		ksmbd_release_id(&work->conn->async_ida, work->async_id);
+	if (work->owns_conn_ref)
+		ksmbd_conn_put(work->conn);
 	kmem_cache_free(work_cache, work);
 }
 
diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 50c4aa779647d..e35a40d764d6e 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -90,6 +90,8 @@ struct ksmbd_work {
 	bool                            compress_response:1;
 	/* Is this SYNC or ASYNC ksmbd_work */
 	bool                            asynchronous:1;
+	/* Work owns a reference to @conn. */
+	bool				owns_conn_ref:1;
 	bool                            need_invalidate_rkey:1;
 
 	unsigned int                    remote_key;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 14ba8ed098ffa..ba00678c66193 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9851,7 +9851,9 @@ int smb2_notify(struct ksmbd_work *work)
 
 	smb2_send_interim_resp(work, STATUS_PENDING);
 
-	in_work->conn = work->conn;
+	/* Keep the async IDA alive until the deferred work is released. */
+	in_work->conn = ksmbd_conn_get(work->conn);
+	in_work->owns_conn_ref = true;
 	in_hdr = smb_get_msg(in_work->response_buf);
 	memcpy(in_hdr, ksmbd_resp_buf_next(work), __SMB2_HEADER_STRUCTURE_SIZE);
 	in_hdr->Flags |= SMB2_FLAGS_ASYNC_COMMAND;
-- 
2.53.0



