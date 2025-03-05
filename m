Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06E825332E;
	Wed,  5 Mar 2025 18:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198498; cv=none; b=RbO6URhghBAeBGmMTJI2YO9aL+LhTY0LqLuG6CibG8giEZEAhB7vCbPrK0UUo9D12W5rjBv5QTd1FUFtLBkWwKEfTNAwVu4lIDZWIdqFiK5mY0aWjmAleL5EMPOpV1jqFZ5n6VMOsEYRVUqk5AGiHyMLJ4cAugbDTJ1vUWiashg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198498; c=relaxed/simple;
	bh=3OYT2uDQewjrPIa6RNPmrZr8VnUm/4YfjPyeOmJdEqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z95Fm4x9XsZ6+lD1OdM+0joHHmW5WlvsFHzg9Um4EpCCHadBSjKObiOtUy/c4r+nznrEN774aHPW98ch7EPAo9jl7VCZpMGJOJ/Cn7kvp0e8s7ubLU54+nAFtf5pAHlkO7UOmUwGguLAXV5YlNpN3ZlQ5QZu5tykVX42flgUFak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pp0Gplcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pp0Gplcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45486C4CED1;
	Wed,  5 Mar 2025 18:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198498;
	bh=3OYT2uDQewjrPIa6RNPmrZr8VnUm/4YfjPyeOmJdEqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pp0Gplcyi1lQDf4qVvzby+Sk8ExPpFm4qDHadweo8ZnGr9SYww4U389tC1VyzwO+m
	 /4Wt+QyOz4sarqEr7kw002p4w5bm3RYpMoxHtrKGaxqbcm8f2qH/rw2RoAlcUoLvc+
	 YA3E5TkodJ0Yu2LFX5DPFoorcbwHAKPp3mgyyrv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 048/157] tcp: devmem: dont write truncated dmabuf CMSGs to userspace
Date: Wed,  5 Mar 2025 18:48:04 +0100
Message-ID: <20250305174507.236333355@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 0d704bda6c416..d74281eca14f0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2438,14 +2438,12 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, const struct sk_buff *skb,
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
 
@@ -2499,16 +2497,12 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, const struct sk_buff *skb,
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



