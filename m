Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB33539A;
	Wed,  5 Mar 2025 18:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198065; cv=none; b=RcT2I25guJxtRHYvXBHUqUFMK4LCHj1GBcZQKHA6QVeQBDzgsydv4pWCBp1aXg87AX4MFJsEFOUfSY4hM4UYoUckYUdHZbXwJvigbtcu1mOM4Xlri8bt4MQB7c3lvg39tSNlSi/OjoWr4vmEXvtB1vjG6u+62NBMEa2N3xPwREI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198065; c=relaxed/simple;
	bh=OIRPf3zjFGv1yi7IMOduB0MyBGv3hhvYXj/Ol8PiHOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjB5oZGn3Mf2zkWWRxPGCHfplfG11jAKnWISEmHzRQqYMLamVltI2WS3/H/O1gv3xEBCDPpds+uE9kILZt3JNPXKsLVJqsq2jgR0azLE1gzYIOhLj4vPpdWH4LF+2WMUm0CCuCYOlQQYQOZne8eF3WM2LJH7DbXzuHbsOMGu6Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N08SzIyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N08SzIyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC31C4CED1;
	Wed,  5 Mar 2025 18:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198065;
	bh=OIRPf3zjFGv1yi7IMOduB0MyBGv3hhvYXj/Ol8PiHOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N08SzIyx+t8W0YMNc9/ik8Stm/JmZWlTHC6b95WTdie7AMf1gXh84Hw/wnv+R8Pr6
	 krpwqiGXOwYGdFOxnMzwlUVk9QdOb01A7COIyE5GWjbonA88Xe3OksQ78BsG/g5rfZ
	 /bo8Z4A6DGuK6LcxEWswfvujiS7Tey03DI8ccjQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/150] tcp: devmem: dont write truncated dmabuf CMSGs to userspace
Date: Wed,  5 Mar 2025 18:48:02 +0100
Message-ID: <20250305174505.955893284@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf@fomichev.me>

[ Upstream commit 18912c520674ec4d920fe3826e7e4fefeecdf5ae ]

Currently, we report -ETOOSMALL (err) only on the first iteration
(!sent). When we get put_cmsg error after a bunch of successful
put_cmsg calls, we don't signal the error at all. This might be
confusing on the userspace side which will see truncated CMSGs
but no MSG_CTRUNC signal.

Consider the following case:
- sizeof(struct cmsghdr) = 16
- sizeof(struct dmabuf_cmsg) = 24
- total cmsg size (CMSG_LEN) = 40 (16+24)

When calling recvmsg with msg_controllen=60, the userspace
will receive two(!) dmabuf_cmsg(s), the first one will
be a valid one and the second one will be silently truncated. There is no
easy way to discover the truncation besides doing something like
"cm->cmsg_len != CMSG_LEN(sizeof(dmabuf_cmsg))".

Introduce new put_devmem_cmsg wrapper that reports an error instead
of doing the truncation. Mina suggests that it's the intended way
this API should work.

Note that we might now report MSG_CTRUNC when the users (incorrectly)
call us with msg_control == NULL.

Fixes: 8f0b3cc9a4c1 ("tcp: RX path for devmem TCP")
Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250224174401.3582695-1-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/socket.h |  2 ++
 net/core/scm.c         | 10 ++++++++++
 net/ipv4/tcp.c         | 26 ++++++++++----------------
 3 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index d18cc47e89bd0..c3322eb3d6865 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -392,6 +392,8 @@ struct ucred {
 
 extern int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_storage *kaddr);
 extern int put_cmsg(struct msghdr*, int level, int type, int len, void *data);
+extern int put_cmsg_notrunc(struct msghdr *msg, int level, int type, int len,
+			    void *data);
 
 struct timespec64;
 struct __kernel_timespec;
diff --git a/net/core/scm.c b/net/core/scm.c
index 4f6a14babe5ae..733c0cbd393d2 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -282,6 +282,16 @@ int put_cmsg(struct msghdr * msg, int level, int type, int len, void *data)
 }
 EXPORT_SYMBOL(put_cmsg);
 
+int put_cmsg_notrunc(struct msghdr *msg, int level, int type, int len,
+		     void *data)
+{
+	/* Don't produce truncated CMSGs */
+	if (!msg->msg_control || msg->msg_controllen < CMSG_LEN(len))
+		return -ETOOSMALL;
+
+	return put_cmsg(msg, level, type, len, data);
+}
+
 void put_cmsg_scm_timestamping64(struct msghdr *msg, struct scm_timestamping_internal *tss_internal)
 {
 	struct scm_timestamping64 tss;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 68cb6a966b18b..b731a4a8f2b0d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2456,14 +2456,12 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, const struct sk_buff *skb,
 			 */
 			memset(&dmabuf_cmsg, 0, sizeof(dmabuf_cmsg));
 			dmabuf_cmsg.frag_size = copy;
-			err = put_cmsg(msg, SOL_SOCKET, SO_DEVMEM_LINEAR,
-				       sizeof(dmabuf_cmsg), &dmabuf_cmsg);
-			if (err || msg->msg_flags & MSG_CTRUNC) {
-				msg->msg_flags &= ~MSG_CTRUNC;
-				if (!err)
-					err = -ETOOSMALL;
+			err = put_cmsg_notrunc(msg, SOL_SOCKET,
+					       SO_DEVMEM_LINEAR,
+					       sizeof(dmabuf_cmsg),
+					       &dmabuf_cmsg);
+			if (err)
 				goto out;
-			}
 
 			sent += copy;
 
@@ -2517,16 +2515,12 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, const struct sk_buff *skb,
 				offset += copy;
 				remaining_len -= copy;
 
-				err = put_cmsg(msg, SOL_SOCKET,
-					       SO_DEVMEM_DMABUF,
-					       sizeof(dmabuf_cmsg),
-					       &dmabuf_cmsg);
-				if (err || msg->msg_flags & MSG_CTRUNC) {
-					msg->msg_flags &= ~MSG_CTRUNC;
-					if (!err)
-						err = -ETOOSMALL;
+				err = put_cmsg_notrunc(msg, SOL_SOCKET,
+						       SO_DEVMEM_DMABUF,
+						       sizeof(dmabuf_cmsg),
+						       &dmabuf_cmsg);
+				if (err)
 					goto out;
-				}
 
 				atomic_long_inc(&niov->pp_ref_count);
 				tcp_xa_pool.netmems[tcp_xa_pool.idx++] = skb_frag_netmem(frag);
-- 
2.39.5



