Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBA53B9930;
	Tue, 21 Jul 2026 21:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670376; cv=none; b=htzO5GOa/W2EAUKO9DAXhOkKJwh1DPN0bjdYmLA4uVAHw03hmUI06a0oi3jRNqeQVz/DiaGjxRKU+SN8aYtqqgjPI/eAkyAC60f3kwRcWkpI8ix9xQ0WkDRX/+Q7cfai9ckRJpL5YwIY2E0GmI0k56DVwds/3KCzRlfctAi984c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670376; c=relaxed/simple;
	bh=W8W25fKkdci6kjOmXE+OSXowclu6Sj9oGtt2uhtDjpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8OES02IDmQdhbLUx38bUyDCSzzSlpZOJnmGEIFDmAMoI+ilmUpWI1hDQaTTl/O3UF5Waj+8HQFnMzDHA4uAl7r1LZ3uAg2vk2TIE/5MJssL9GRFkHm0MblaxBsPlXcpKhFk8c0XDoA3+nKa3Jtq4ILomuR+lyuXHfQ95eoh0Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVHnpuIT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVHnpuIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D70F1F000E9;
	Tue, 21 Jul 2026 21:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670375;
	bh=kyr7oo6N7ni7BT+PC6ZgJk4TCB2LqpHvpK6IxugrWnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xVHnpuITqkCvBNkFygnv5/dpaswF75flTThalAHays1kETdtKvATPtNzLb6SD1jaA
	 QQ8SToNEoEZmuyP6R+ZWGKNlHeUP0V9zypg+dQ3ZmvBOY4sgQSDQewRwi9ZSaL3LdN
	 i+FPVIhw3RBEjRmGTeRkMFn7R3q8KSeiQDfkU/6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+36256deb69a588e9290e@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 0909/1067] mac802154: remove interfaces with RCU list deletion
Date: Tue, 21 Jul 2026 17:25:10 +0200
Message-ID: <20260721152444.870610151@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -706,7 +706,7 @@ void ieee802154_remove_interfaces(struct
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
-		list_del(&sdata->list);
+		list_del_rcu(&sdata->list);
 
 		unregister_netdevice(sdata->dev);
 	}


