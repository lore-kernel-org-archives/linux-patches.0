Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD621AB6FD;
	Mon, 14 Oct 2024 14:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917135; cv=none; b=Dl1b1Xnvc0ngsqpax0RYw2A4cSPAHAPhEAXVNcJ6r1xQmZVARLvlHmlDs+KoABt6H73acUqcdqzwWJ6AEorbU4al0LjZT1H6tuw1ZMuMhcxpMRBNnF6ynwaTYvaGJg2Z/r8DRhs9YlFyiETYy+vo779kgD/5YMHL+zQNnCdfLwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917135; c=relaxed/simple;
	bh=tnuI5jgqib0aVd4bah0ulQCFa3w77EK/qAy2yacvO9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PKBxK1TGwTosjFvY7Po08mYldzlORR4g+59Gd+VLTbSOkhYOJzkmDjTmFXGGtmmcK9uvSEJQcddjuArrLdBM50a4yt8zpKRrgLvrUuj7NS/pAVt2z2J85nxtUP0FmzuBdCeBhfXR5Iz5XXlEr1u/BRIJqZy8Nqtuv1/g7twrdxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BjHATtAo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BjHATtAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A63C4CEC3;
	Mon, 14 Oct 2024 14:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917135;
	bh=tnuI5jgqib0aVd4bah0ulQCFa3w77EK/qAy2yacvO9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BjHATtAoP+MQCnv3g/dyr2XgEuX3+clrTiatTK7xQsrnt0t2KduvBc217FLjgftSu
	 uZQ6RbM6ZadNlj+Mcpw3L5YJtJq4upVo7vlGQUFF2LH16Oq1c0PgO8xqOxj7GifDGa
	 B9W/dp6Ax5EEWiGZUhZuCCyZmQCF/5/HhpE6aHW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	=?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <courmisch@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/213] phonet: Handle error of rtnl_register_module().
Date: Mon, 14 Oct 2024 16:21:07 +0200
Message-ID: <20241014141049.255772258@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit b5e837c86041bef60f36cf9f20a641a30764379a ]

Before commit addf9b90de22 ("net: rtnetlink: use rcu to free rtnl
message handlers"), once the first rtnl_register_module() allocated
rtnl_msg_handlers[PF_PHONET], the following calls never failed.

However, after the commit, rtnl_register_module() could fail silently
to allocate rtnl_msg_handlers[PF_PHONET][msgtype] and requires error
handling for each call.

Handling the error allows users to view a module as an all-or-nothing
thing in terms of the rtnetlink functionality.  This prevents syzkaller
from reporting spurious errors from its tests, where OOM often occurs
and module is automatically loaded.

Let's use rtnl_register_many() to handle the errors easily.

Fixes: addf9b90de22 ("net: rtnetlink: use rcu to free rtnl message handlers")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Rémi Denis-Courmont <courmisch@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/phonet/pn_netlink.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/net/phonet/pn_netlink.c b/net/phonet/pn_netlink.c
index 7008d402499d5..894e5c72d6bff 100644
--- a/net/phonet/pn_netlink.c
+++ b/net/phonet/pn_netlink.c
@@ -285,23 +285,17 @@ static int route_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 	return err;
 }
 
+static const struct rtnl_msg_handler phonet_rtnl_msg_handlers[] __initdata_or_module = {
+	{THIS_MODULE, PF_PHONET, RTM_NEWADDR, addr_doit, NULL, 0},
+	{THIS_MODULE, PF_PHONET, RTM_DELADDR, addr_doit, NULL, 0},
+	{THIS_MODULE, PF_PHONET, RTM_GETADDR, NULL, getaddr_dumpit, 0},
+	{THIS_MODULE, PF_PHONET, RTM_NEWROUTE, route_doit, NULL, 0},
+	{THIS_MODULE, PF_PHONET, RTM_DELROUTE, route_doit, NULL, 0},
+	{THIS_MODULE, PF_PHONET, RTM_GETROUTE, NULL, route_dumpit,
+	 RTNL_FLAG_DUMP_UNLOCKED},
+};
+
 int __init phonet_netlink_register(void)
 {
-	int err = rtnl_register_module(THIS_MODULE, PF_PHONET, RTM_NEWADDR,
-				       addr_doit, NULL, 0);
-	if (err)
-		return err;
-
-	/* Further rtnl_register_module() cannot fail */
-	rtnl_register_module(THIS_MODULE, PF_PHONET, RTM_DELADDR,
-			     addr_doit, NULL, 0);
-	rtnl_register_module(THIS_MODULE, PF_PHONET, RTM_GETADDR,
-			     NULL, getaddr_dumpit, 0);
-	rtnl_register_module(THIS_MODULE, PF_PHONET, RTM_NEWROUTE,
-			     route_doit, NULL, 0);
-	rtnl_register_module(THIS_MODULE, PF_PHONET, RTM_DELROUTE,
-			     route_doit, NULL, 0);
-	rtnl_register_module(THIS_MODULE, PF_PHONET, RTM_GETROUTE,
-			     NULL, route_dumpit, RTNL_FLAG_DUMP_UNLOCKED);
-	return 0;
+	return rtnl_register_many(phonet_rtnl_msg_handlers);
 }
-- 
2.43.0



