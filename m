Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793362517;
	b=fEf69bF+IF3qDVNngFtF/TJ60CblS4hLBrvlNjaiGbxkRId6BPIaOX11zDLa7u1miLjv
	 ZNceIl4hT1r5D4+v5+xVfRRd0+Qz3mz52EoCbeEWvlJgY73xsHO9pLwlBpHT+m3gwoZoj
	 WeOp4RxpyLk6701NQqsB7CkWB1rxeuZiQEjZN8sli5EdymPkohit9RSYuPm27g67iMFof
	 iek6jy2iogJk4raA+4DgyG5FDcSx5tb2P2PB5OB87mMKHImrcdDVHXW0zsPJIb4lfSRN8
	 n+HqPMvYvtuZ/r+bJkCG9J9qIUuDGmrSP8/5eijDmhuzlWqX6d+FT14anXNjjE8iscw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793362517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tGU2gN2dl/OXHHZknLIYOc27Cgw/TNxUKpLc/NlIc5E=;
	b=KRh6RcRTEzQh0ul0yOHKONikGGgB1fchME95V7gDk8ybvMoarsBsp8yAWjWf4mpMGDX8
	 XQcsJVeYABxltcicSU9n7sGz5Lzj4vnKHEm1u6m77mP4E0O0XYCa9v4EoWYD90JM0k9Nv
	 Zw7dxpbnnIzW2t6J5SDy0eBAIJ7Ot14k/YOOB4ghHkRsGGDeD2JT/jSnmunGG6iM4jdwj
	 scCIqxDa1OCMo5cv/OqLUzNzw75oHXhbAqZKX8y6rFjkeJ6q4Uf81xwu6qSIriKhyzj39
	 F7EuiQZ3X7WDpbefv+leP8L5wlmFJLcnB4rMh2aELNFwu+0VMtH3FJe2AULV2dyOUJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FXKj5w9j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6446D606A31F;
	Fri, 30 Oct 2026 12:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FXKj5w9j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B4C1F000C1;
	Fri, 30 Oct 2026 12:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793362516;
	bh=tGU2gN2dl/OXHHZknLIYOc27Cgw/TNxUKpLc/NlIc5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FXKj5w9j+EJ8/3zDKDnNSdXwtW/O7h0bZokcpLQZghmEZj+xLUQOGP4qbbGcTqwGq
	 AkMvdIjKQLYAAz2QSME5SDSyJFoR5D8KVttC0MR1ari602S+9uLS5H1asXtnyAoRI1
	 t5l6OtKkiZfzDUNuNHZAc+fsgEZKvXZfHZzBXZ+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ihopenre-eng <ihopenre@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 01/10] ksmbd: wait for negotiation before receiving another PDU
Date: Fri, 30 Oct 2026 13:15:02 +0100
Message-ID: <20261030121255.294253042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030121255.257615100@linuxfoundation.org>
References: <20261030121255.257615100@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 68f410faedaf6ee74d81e574733c50ebcc1bd8ed ]

The receive thread queues a request and can read the next PDU before
the negotiation worker finishes. While need_neg is set, the next PDU
can cause ksmbd_init_smb_server() to replace conn->ops. A pipelined
SMB2 request can therefore make the worker handle an earlier, shorter
SMB1 request with SMB2 operations and read beyond its buffer.

An SMB1 multi-protocol negotiate may be followed by an SMB2 NEGOTIATE
that changes conn->ops again. Wait for work queued while the connection
is new or needs negotiation to complete before reading another PDU.
This keeps the operations stable for both stages of negotiation without
changing when need_neg is cleared.

Fixes: dc8289f91238 ("ksmbd: fix slab-out-of-bounds in init_smb2_rsp_hdr")
Reported-by: ihopenre-eng <ihopenre@gmail.com>
Reviewed-by: ihopenre-eng <ihopenre@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/server.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index e113b23d96f94..e36e82b94a047 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -371,6 +371,7 @@ static void handle_ksmbd_work(struct work_struct *wk)
 static int queue_ksmbd_work(struct ksmbd_conn *conn)
 {
 	struct ksmbd_work *work;
+	bool wait_for_neg = ksmbd_conn_new(conn) || ksmbd_conn_need_negotiate(conn);
 	int err;
 
 	err = ksmbd_init_smb_server(conn);
@@ -393,6 +394,10 @@ static int queue_ksmbd_work(struct ksmbd_conn *conn)
 	conn->last_active = jiffies;
 	INIT_WORK(&work->work, handle_ksmbd_work);
 	ksmbd_queue_work(work);
+	/* Negotiation can change conn->ops, finish it before reading another PDU. */
+	if (wait_for_neg)
+		wait_event(conn->req_running_q,
+			   atomic_read(&conn->req_running) == 0);
 	return 0;
 }
 
-- 
2.53.0



