Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D22973748;
	Mon, 29 Jan 2024 17:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548539; cv=none; b=eNIDYTzl37R7ZcBxkZGa+Y5R37Xb97JvnVcgCC/JDPTrsv0mIoCO3RhTngCnVLkFiunsvdhYDfVV+J8SFmERk3l7raJUw95a+fubPzk+FShiuRUN3UeDjD5ZNtCgFUdn8pU7t4SSKIU5rKU6U+AYwOIlA+V8VitctGGfSEhjnDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548539; c=relaxed/simple;
	bh=TLHYZ8p6uF3IA51uiEbxv1vToSUEHRV9bhOLQYsyU50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YjmL+b6VzOYOO5YoO1/tsyWn2laWQmjFSzofIHyg8QZh++oyYx6R0clkiadn4yiVa9pmnsutlGxtojg+xSCvybXVKugHqRsR9ah2FxIEDNFF1O16j0nhMZ0v8U/q9I9OZSLrSRHNuB1NaKJAEwTHcsDc7wfnVJP0jXK5Q3fve0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdOxuIb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdOxuIb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FDEC43390;
	Mon, 29 Jan 2024 17:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548538;
	bh=TLHYZ8p6uF3IA51uiEbxv1vToSUEHRV9bhOLQYsyU50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdOxuIb6pTh+H1MW3K9ianxNq6W1WjM5XdprvLpeIQ3gC1bZNOVrg1NUoyrfR5Ffo
	 2GptFFP67l7IlrRqE2rudUtHMCZeeNhWk0k6q53b/bKBCUoY9+oWaSomjtyg5YzYnt
	 leXgDojl+KouYJ+DTAnlj3w7xgwyhxYAiKtCaAJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=D0=9C=D0=B0=D1=80=D0=BA=20=D0=9A=D0=BE=D1=80=D0=B5=D0=BD=D0=B1=D0=B5=D1=80=D0=B3?= <socketpair@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/331] net: fix removing a namespace with conflicting altnames
Date: Mon, 29 Jan 2024 09:04:02 -0800
Message-ID: <20240129170020.113724949@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit d09486a04f5da0a812c26217213b89a3b1acf836 ]

Mark reports a BUG() when a net namespace is removed.

    kernel BUG at net/core/dev.c:11520!

Physical interfaces moved outside of init_net get "refunded"
to init_net when that namespace disappears. The main interface
name may get overwritten in the process if it would have
conflicted. We need to also discard all conflicting altnames.
Recent fixes addressed ensuring that altnames get moved
with the main interface, which surfaced this problem.

Reported-by: Марк Коренберг <socketpair@gmail.com>
Link: https://lore.kernel.org/all/CAEmTpZFZ4Sv3KwqFOY2WKDHeZYdi0O7N5H1nTvcGp=SAEavtDg@mail.gmail.com/
Fixes: 7663d522099e ("net: check for altname conflicts when changing netdev's netns")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 9 +++++++++
 net/core/dev.h | 3 +++
 2 files changed, 12 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index e480afb50d4c..d72a4ff689ca 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11491,6 +11491,7 @@ static struct pernet_operations __net_initdata netdev_net_ops = {
 
 static void __net_exit default_device_exit_net(struct net *net)
 {
+	struct netdev_name_node *name_node, *tmp;
 	struct net_device *dev, *aux;
 	/*
 	 * Push all migratable network devices back to the
@@ -11513,6 +11514,14 @@ static void __net_exit default_device_exit_net(struct net *net)
 		snprintf(fb_name, IFNAMSIZ, "dev%d", dev->ifindex);
 		if (netdev_name_in_use(&init_net, fb_name))
 			snprintf(fb_name, IFNAMSIZ, "dev%%d");
+
+		netdev_for_each_altname_safe(dev, name_node, tmp)
+			if (netdev_name_in_use(&init_net, name_node->name)) {
+				netdev_name_node_del(name_node);
+				synchronize_rcu();
+				__netdev_name_node_alt_destroy(name_node);
+			}
+
 		err = dev_change_net_namespace(dev, &init_net, fb_name);
 		if (err) {
 			pr_emerg("%s: failed to move %s to init_net: %d\n",
diff --git a/net/core/dev.h b/net/core/dev.h
index fa2e9c5c4122..f2037d402144 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -64,6 +64,9 @@ int dev_change_name(struct net_device *dev, const char *newname);
 
 #define netdev_for_each_altname(dev, namenode)				\
 	list_for_each_entry((namenode), &(dev)->name_node->list, list)
+#define netdev_for_each_altname_safe(dev, namenode, next)		\
+	list_for_each_entry_safe((namenode), (next), &(dev)->name_node->list, \
+				 list)
 
 int netdev_name_node_alt_create(struct net_device *dev, const char *name);
 int netdev_name_node_alt_destroy(struct net_device *dev, const char *name);
-- 
2.43.0



