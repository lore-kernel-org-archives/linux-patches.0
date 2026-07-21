Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7A53AE6E4;
	Tue, 21 Jul 2026 20:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667581; cv=none; b=CeUJ0u5CNUXrp0fQZpgyHcoxML22+JFbQ9GRIdWXv83/ZIkXDI1JDwfy+pX6SGWZvlZ/9T9OACKuwMk/uojrJR4bQPplMmz4crAugRSygsKHAKpegKpfhiEH/5uUZfnlpVPqkeMYAU8tnZNz57nuZ9zgvBHVb6r4dKGwPDFIkGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667581; c=relaxed/simple;
	bh=iEbqImxfdjQIu45EkqK5iUjxx07NICqXWvhtj8MdmBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WX7lAbdjy6oC0KF363I6MaszNRtvjzv4DeOWKOgVRrbQ1IMt3iNw5bVU1cbqaIh+I2hvttbDlkUGE4kM+mzRypcxtF28TN+ick1QRAAgsNbeBjSvwuqvT5GeAAjfqG4DLhvrrLz2o3j7DaNCangqOWvA49+fLFhjyiXm3x308Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9kE9Var; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9kE9Var"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183F21F000E9;
	Tue, 21 Jul 2026 20:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667580;
	bh=Ng5qjF9eje/x780DsNScMSWVbZ76zKYzs0o/AuLs5Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d9kE9Var/OhVxgr8wiA1xwfHryzwCjOj9LvFXZ9gMJ7ZjwHgrAGDdZOq34GueufJq
	 Gh/AARTmx1uWxNF6dHtY8DVNGTShoazl7169rYKgLUanmqOyS35V8AyEOEQYljJT+i
	 TbkyeI54NJNpFUp2Z/tLHcE9LKCO/CmzRfo9YerM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+36256deb69a588e9290e@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 1116/1266] mac802154: remove interfaces with RCU list deletion
Date: Tue, 21 Jul 2026 17:25:53 +0200
Message-ID: <20260721152506.774857232@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

commit 539dfcf69105d8d3d4d677b71de6e5ede2e6dfa0 upstream.

Queue wake, stop, and disable paths walk local->interfaces under RCU.
The bulk hardware teardown path removes entries with list_del(), so an
asynchronous transmit completion can follow a poisoned list node in
ieee802154_wake_queue().

Use list_del_rcu() as in the single-interface removal path. The following
unregister_netdevice() waits for in-flight RCU readers before freeing the
netdevice, so no separate grace-period wait is needed.

Fixes: 592dfbfc72f5 ("mac820154: move interface unregistration into iface")
Reported-by: syzbot+36256deb69a588e9290e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=36256deb69a588e9290e
Cc: stable@vger.kernel.org
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260701164222.9094-1-alhouseenyousef@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac802154/iface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -703,7 +703,7 @@ void ieee802154_remove_interfaces(struct
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
-		list_del(&sdata->list);
+		list_del_rcu(&sdata->list);
 
 		unregister_netdevice(sdata->dev);
 	}


