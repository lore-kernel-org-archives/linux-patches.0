Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3AC332628
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301235; cv=none; b=LXMqxwdiDfnLmbImjlIwOBm7GJI+yJ9l3tlkMXwcb2VdrqFo1ObSoc9i2ejDKOTrR9ljWKw+Uk61uk0LF1F7U0qiAxbST24UJIZ/PqY3yuvHHC6E5DmcrLl1JVuvnQ/sqhzk8Ab8U3lgpj9MjbTdRMwBbEdmULGEDkaX3ETV70k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301235; c=relaxed/simple;
	bh=DbXUv4jDdo5qXVHpFbFNYw/IsrgpO94wkjxtxp9ErH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbVLkckqs+Kxn11US6yQz6B9JigglDgJf5jczSme8wf/f1lvxBZ01nUCHQ/l+XmBl5roGCrRMtZV2DFg7YubyyYjR3qVUEOUZogbycNdONcZ6SERDpyubldcU9oMezBUCEkV3YU1VIUS7FFLnDAunzidPxaBe36SzCJ2GI1+BSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rOyH5YpR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rOyH5YpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDB1C19423;
	Sat, 28 Feb 2026 17:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301235;
	bh=DbXUv4jDdo5qXVHpFbFNYw/IsrgpO94wkjxtxp9ErH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOyH5YpRNGn3OH4xfBw7aLysWIn6+Mdq+Qg/RvpCzoLGvFVLYxKeGMeHsfHZlhNiD
	 f9CvaJMgKoDXWnOmruuyXwYLAP5eOx7mwFBbT/oq4QXXZ1msN4Rn8YrcX8WwkG+5EU
	 WQs4LOkiQ1IPsBrErXqfpJiCWZoWjYlC5iHi436A8m0tYEkSZka3JSECjbgW3nwPO1
	 Pe5obnAmW1USEB5zcIsCh1QvDJd+sO/pHHejbLgPLBHmAPe1uED7oifDTtWYK3gg+y
	 SJtovrywp7RU/R5uIcj5AulRRNhf7YJimglAkuEsM/3VpGEqvm4GAdsUZmm9upvsM+
	 /J7iKlRcplYKA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Nicholas Carlini <nicholas@carlini.com>,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 414/752] ksmbd: fix signededness bug in smb_direct_prepare_negotiation()
Date: Sat, 28 Feb 2026 12:42:05 -0500
Message-ID: <20260228174750.1542406-414-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nicholas Carlini <nicholas@carlini.com>

[ Upstream commit 6b4f875aac344cdd52a1f34cc70ed2f874a65757 ]

smb_direct_prepare_negotiation() casts an unsigned __u32 value
from sp->max_recv_size and req->preferred_send_size to a signed
int before computing min_t(int, ...). A maliciously provided
preferred_send_size of 0x80000000 will return as smaller than
max_recv_size, and then be used to set the maximum allowed
alowed receive size for the next message.

By sending a second message with a large value (>1420 bytes)
the attacker can then achieve a heap buffer overflow.

This fix replaces min_t(int, ...) with min_t(u32)

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Signed-off-by: Nicholas Carlini <nicholas@carlini.com>
Reviewed-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 4e74934e1f277..f00bb28a4aa88 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2414,9 +2414,9 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 		goto put;
 
 	req = (struct smbdirect_negotiate_req *)recvmsg->packet;
-	sp->max_recv_size = min_t(int, sp->max_recv_size,
+	sp->max_recv_size = min_t(u32, sp->max_recv_size,
 				  le32_to_cpu(req->preferred_send_size));
-	sp->max_send_size = min_t(int, sp->max_send_size,
+	sp->max_send_size = min_t(u32, sp->max_send_size,
 				  le32_to_cpu(req->max_receive_size));
 	sp->max_fragmented_send_size =
 		le32_to_cpu(req->max_fragmented_size);
-- 
2.51.0

