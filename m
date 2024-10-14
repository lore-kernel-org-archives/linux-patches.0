Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8781B85E2;
	Mon, 14 Oct 2024 15:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919973; cv=none; b=M7r46LO9PD3RbeYvhgP6JV0ftXIjQDhCy6EKdtcaAtdX4fp0IlofrSUI9P1HT2zxuf4j+5VokEgj0QBoebhACcQPzE/U5EwKuidO5o5cnHqo2PHdMpJCTGY8/5PIUwNX3A3WysRVKOFE7hbqV7Ci0uwJsZbnbgefmY52lhGqa/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919973; c=relaxed/simple;
	bh=+2rOGEmucCNQcVg1J+93ESI1ilRpVQkOHu/K3KkTko0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhcnUYW/bl1iemGxPhTquN5rsBqC7V9vMJXf9wqvjxEDi4L6It7iBRm+VWOXJAAxya1JyVfbrqc0y3uOu7IqqbiE5HzyA4rTNodBk685zmpkdxt7QHrIlSsxZ4e/qhASaVZ3HsgJi8IMFMWaGuJy/PQDbZGCT4CtgEtgGLPEHao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GA8G7cM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GA8G7cM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B12C4CEC3;
	Mon, 14 Oct 2024 15:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919972;
	bh=+2rOGEmucCNQcVg1J+93ESI1ilRpVQkOHu/K3KkTko0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0GA8G7cMdeOn5gdiyDK7roDytwIjddQ0OketS34Gai+iNOSEQ7K1A6A6/Q8W5czaZ
	 uuBtJAvoVl48Tm+Gfe6ys7W+llHdUbQAPI3n4ZjCYEayIFxsVgl9iNOwvKV7zkF2DS
	 saYTv6m91kgcAEjJ/v2BCFI+72xqDm3EUdHYd0BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 760/798] rtnetlink: Add bulk registration helpers for rtnetlink message handlers.
Date: Mon, 14 Oct 2024 16:21:54 +0200
Message-ID: <20241014141247.926414824@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 07cc7b0b942bf55ef1a471470ecda8d2a6a6541f ]

Before commit addf9b90de22 ("net: rtnetlink: use rcu to free rtnl message
handlers"), once rtnl_msg_handlers[protocol] was allocated, the following
rtnl_register_module() for the same protocol never failed.

However, after the commit, rtnl_msg_handler[protocol][msgtype] needs to
be allocated in each rtnl_register_module(), so each call could fail.

Many callers of rtnl_register_module() do not handle the returned error,
and we need to add many error handlings.

To handle that easily, let's add wrapper functions for bulk registration
of rtnetlink message handlers.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 78b7b991838a ("vxlan: Handle error of rtnl_register_module().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rtnetlink.h | 17 +++++++++++++++++
 net/core/rtnetlink.c    | 29 +++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 9f881b74f32ed..fdc7b4ce0ef7b 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -27,6 +27,15 @@ static inline enum rtnl_kinds rtnl_msgtype_kind(int msgtype)
 	return msgtype & RTNL_KIND_MASK;
 }
 
+struct rtnl_msg_handler {
+	struct module *owner;
+	int protocol;
+	int msgtype;
+	rtnl_doit_func doit;
+	rtnl_dumpit_func dumpit;
+	int flags;
+};
+
 void rtnl_register(int protocol, int msgtype,
 		   rtnl_doit_func, rtnl_dumpit_func, unsigned int flags);
 int rtnl_register_module(struct module *owner, int protocol, int msgtype,
@@ -34,6 +43,14 @@ int rtnl_register_module(struct module *owner, int protocol, int msgtype,
 int rtnl_unregister(int protocol, int msgtype);
 void rtnl_unregister_all(int protocol);
 
+int __rtnl_register_many(const struct rtnl_msg_handler *handlers, int n);
+void __rtnl_unregister_many(const struct rtnl_msg_handler *handlers, int n);
+
+#define rtnl_register_many(handlers)				\
+	__rtnl_register_many(handlers, ARRAY_SIZE(handlers))
+#define rtnl_unregister_many(handlers)				\
+	__rtnl_unregister_many(handlers, ARRAY_SIZE(handlers))
+
 static inline int rtnl_msg_family(const struct nlmsghdr *nlh)
 {
 	if (nlmsg_len(nlh) >= sizeof(struct rtgenmsg))
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index be663a7382ce9..afb52254a47ec 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -385,6 +385,35 @@ void rtnl_unregister_all(int protocol)
 }
 EXPORT_SYMBOL_GPL(rtnl_unregister_all);
 
+int __rtnl_register_many(const struct rtnl_msg_handler *handlers, int n)
+{
+	const struct rtnl_msg_handler *handler;
+	int i, err;
+
+	for (i = 0, handler = handlers; i < n; i++, handler++) {
+		err = rtnl_register_internal(handler->owner, handler->protocol,
+					     handler->msgtype, handler->doit,
+					     handler->dumpit, handler->flags);
+		if (err) {
+			__rtnl_unregister_many(handlers, i);
+			break;
+		}
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(__rtnl_register_many);
+
+void __rtnl_unregister_many(const struct rtnl_msg_handler *handlers, int n)
+{
+	const struct rtnl_msg_handler *handler;
+	int i;
+
+	for (i = n - 1, handler = handlers + n - 1; i >= 0; i--, handler--)
+		rtnl_unregister(handler->protocol, handler->msgtype);
+}
+EXPORT_SYMBOL_GPL(__rtnl_unregister_many);
+
 static LIST_HEAD(link_ops);
 
 static const struct rtnl_link_ops *rtnl_link_ops_get(const char *kind)
-- 
2.43.0



