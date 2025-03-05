Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8500250C02;
	Wed,  5 Mar 2025 17:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197297; cv=none; b=JuXnnDXC1WnT38CcvOcvT3m2A7qWHRlkGfLqdH9FU1C1rYMewDShBPeoeH7dW5+wfEgHoQUS10qJXYPIZ2SHZJ757alhOZSIHrR5OLmTfHLsXlDGsCbFrJQRnhtgyDL8b/fI4WnIuJgbxWOxIsoRMXBo0Ht5aGTW1pcInrToW34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197297; c=relaxed/simple;
	bh=8uBL0e8VsrlStgaAh8DLqefyopEaf0Bm8cCbFLRFs2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1SN/mtKiLvZWxjJhNRMPH3foHdC66icYNG4D1wIcMkNMg0hzdrr5gwh9kbT0P0M5C3C8te3Ln715qTUmUkI/FGVs+3RihqcLht+pM3u0DShgMxMwM1SQwXlxrAsHyfBshacYR7s8MxbHjTh+bg1sMO2/gBKtFJdAVXO3NmeADE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjiM1iX+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjiM1iX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C59C4CED1;
	Wed,  5 Mar 2025 17:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197297;
	bh=8uBL0e8VsrlStgaAh8DLqefyopEaf0Bm8cCbFLRFs2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjiM1iX+WlNiVy8T/TxXCry2DwR4zt6NQfCbQwosxhYKx16zI94EW4ZBr6paX21qd
	 2Z3jr/AfedgjpA+IUsrQexaMltBkt1g84BY2SBBnU+4YuoGugTiCNcAWglQ6upk9+5
	 AzeV/wT+I6Bv0EICps9orv9uEBeQA+jdQDBHdr/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <mrpre@163.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/176] strparser: Add read_sock callback
Date: Wed,  5 Mar 2025 18:47:14 +0100
Message-ID: <20250305174508.064410217@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiayuan Chen <mrpre@163.com>

[ Upstream commit 0532a79efd68a4d9686b0385e4993af4b130ff82 ]

Added a new read_sock handler, allowing users to customize read operations
instead of relying on the native socket's read_sock.

Signed-off-by: Jiayuan Chen <mrpre@163.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://patch.msgid.link/20250122100917.49845-2-mrpre@163.com
Stable-dep-of: 36b62df5683c ("bpf: Fix wrong copied_seq calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/strparser.rst |  9 ++++++++-
 include/net/strparser.h                |  2 ++
 net/strparser/strparser.c              | 11 +++++++++--
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/strparser.rst b/Documentation/networking/strparser.rst
index 6cab1f74ae05a..7f623d1db72aa 100644
--- a/Documentation/networking/strparser.rst
+++ b/Documentation/networking/strparser.rst
@@ -112,7 +112,7 @@ Functions
 Callbacks
 =========
 
-There are six callbacks:
+There are seven callbacks:
 
     ::
 
@@ -182,6 +182,13 @@ There are six callbacks:
     the length of the message. skb->len - offset may be greater
     then full_len since strparser does not trim the skb.
 
+    ::
+
+	int (*read_sock)(struct strparser *strp, read_descriptor_t *desc,
+                     sk_read_actor_t recv_actor);
+
+    The read_sock callback is used by strparser instead of
+    sock->ops->read_sock, if provided.
     ::
 
 	int (*read_sock_done)(struct strparser *strp, int err);
diff --git a/include/net/strparser.h b/include/net/strparser.h
index 41e2ce9e9e10f..0a83010b3a64a 100644
--- a/include/net/strparser.h
+++ b/include/net/strparser.h
@@ -43,6 +43,8 @@ struct strparser;
 struct strp_callbacks {
 	int (*parse_msg)(struct strparser *strp, struct sk_buff *skb);
 	void (*rcv_msg)(struct strparser *strp, struct sk_buff *skb);
+	int (*read_sock)(struct strparser *strp, read_descriptor_t *desc,
+			 sk_read_actor_t recv_actor);
 	int (*read_sock_done)(struct strparser *strp, int err);
 	void (*abort_parser)(struct strparser *strp, int err);
 	void (*lock)(struct strparser *strp);
diff --git a/net/strparser/strparser.c b/net/strparser/strparser.c
index 8299ceb3e3739..95696f42647ec 100644
--- a/net/strparser/strparser.c
+++ b/net/strparser/strparser.c
@@ -347,7 +347,10 @@ static int strp_read_sock(struct strparser *strp)
 	struct socket *sock = strp->sk->sk_socket;
 	read_descriptor_t desc;
 
-	if (unlikely(!sock || !sock->ops || !sock->ops->read_sock))
+	if (unlikely(!sock || !sock->ops))
+		return -EBUSY;
+
+	if (unlikely(!strp->cb.read_sock && !sock->ops->read_sock))
 		return -EBUSY;
 
 	desc.arg.data = strp;
@@ -355,7 +358,10 @@ static int strp_read_sock(struct strparser *strp)
 	desc.count = 1; /* give more than one skb per call */
 
 	/* sk should be locked here, so okay to do read_sock */
-	sock->ops->read_sock(strp->sk, &desc, strp_recv);
+	if (strp->cb.read_sock)
+		strp->cb.read_sock(strp, &desc, strp_recv);
+	else
+		sock->ops->read_sock(strp->sk, &desc, strp_recv);
 
 	desc.error = strp->cb.read_sock_done(strp, desc.error);
 
@@ -468,6 +474,7 @@ int strp_init(struct strparser *strp, struct sock *sk,
 	strp->cb.unlock = cb->unlock ? : strp_sock_unlock;
 	strp->cb.rcv_msg = cb->rcv_msg;
 	strp->cb.parse_msg = cb->parse_msg;
+	strp->cb.read_sock = cb->read_sock;
 	strp->cb.read_sock_done = cb->read_sock_done ? : default_read_sock_done;
 	strp->cb.abort_parser = cb->abort_parser ? : strp_abort_strp;
 
-- 
2.39.5



