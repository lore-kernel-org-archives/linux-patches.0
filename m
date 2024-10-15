Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D3A1EBA0A;
	Tue, 15 Oct 2024 12:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994348; cv=none; b=b4jAr+0dZVKmq2F4yySTk3fVG6/4UdxnJCt+X11O6QtTKGUGZVBZEzUVll9OKqzFMNSx8+4ApDrswQ0BjLMhbG0eP0TPXqr6QqTD33gzzakt5ewfXo4U2+TFHIDeER9LGoLPSO7F0tvzlXaktYtjVVVqH/K7vRqlnRhKmB/Rc5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994348; c=relaxed/simple;
	bh=zcgAUocq4r0n2kQmhELcvhW8B3oXc9bvEa+LA5t7LEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDfYD8eRcIu1nCW9hocStwMZZoHY5tOKG5FDlSnEeCvdu7r7nF/AtuosKxudlrYwvp2NuKkbAgMkZId4/JUu8ETAy5maTS2Ce12wHYT/GerHDO+3yKV21Zlu2azThV2LJ5OC3b0uqM03bhI2bQ/vidNNPdN+kicXLlMDjR5fLeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7pbu+zc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7pbu+zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9353BC4CEC6;
	Tue, 15 Oct 2024 12:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994348;
	bh=zcgAUocq4r0n2kQmhELcvhW8B3oXc9bvEa+LA5t7LEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7pbu+zcxk+dNkoYH47dTQUvajgUO1iUTTvHBuhFU1i07HP+HDa3Tpnd5a3R32Bjx
	 TyQSuwQ0KY2Tq4tAgKZr8NSqoUQC13RJNQDXkSihU/yy80lv5CtRhRrFwXE7m6T5MY
	 1CdnFqaheyfhMmcHTNNahpSnkYS+JloH5jAA2/6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 655/691] rtnetlink: Add bulk registration helpers for rtnetlink message handlers.
Date: Tue, 15 Oct 2024 13:30:03 +0200
Message-ID: <20241015112506.322833044@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: d51705614f66 ("mctp: Handle error of rtnl_register_module().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rtnetlink.h | 17 +++++++++++++++++
 net/core/rtnetlink.c    | 29 +++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index c9d3ae92c9321..dcb1c92e69879 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -20,6 +20,15 @@ enum rtnl_kinds {
 	RTNL_KIND_SET
 };
 
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
@@ -27,6 +36,14 @@ int rtnl_register_module(struct module *owner, int protocol, int msgtype,
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
index 8fc86d1edf561..24795110b2ff3 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -348,6 +348,35 @@ void rtnl_unregister_all(int protocol)
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



