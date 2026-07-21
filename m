Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6764429822;
	Tue, 21 Jul 2026 18:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659251; cv=none; b=kYCYUmrVUF0fU2nZfuIFtEetf6tM19nTepz2cYihQuEslanhkid/Zu4poxwJsbrI6fh026wCnlYItVMW5gQ51Xrs+1Lri+cp22TDqFiD0xmAFyEfFKgFjmY0lEdodC1ER1vOT84yvC3X/Oxyz3HBatATkOXNRggGQRn9PSdJqB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659251; c=relaxed/simple;
	bh=y7nCCgz74ax4unlk5OHDtdQ2c/UwVjX19ldZQ1zBdmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcGijjB5+tdK8BZgkkI+9p3+RoieQlasKDVguzyKum5hyRnZT80vDvk+WxxrteiUdJdgW3M3hDv70iv6IPMfYWCb6z1IbTZ3FZjAr29GiOGZXhgV4dpzfXr8RoRyt5wbolV81PeR/e18lXuJJ4qC4lkGMG7WTrwG2gVRDbsA3Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b45I3PuL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b45I3PuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17131F00A3D;
	Tue, 21 Jul 2026 18:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659250;
	bh=cIK3mAtOCmLoduW/sTnKJgloGsig0B3frssZB8g3O1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b45I3PuL+GPlCLknnih8qh8E+ZIbERhfQyHdfX8FzCGEL/2zgI2Ku4FnYikkmJrK5
	 SeNiTms4Q5pdYJH2cA3B0ulJK5aOWewBNQz/TNiYdVjmhvSqWE+D12XDNKK+06LNQB
	 1TynhXUntzxkK740A9hfsbUY80m5QQGXcTMPZIww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+36256deb69a588e9290e@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 1451/1611] mac802154: remove interfaces with RCU list deletion
Date: Tue, 21 Jul 2026 17:26:07 +0200
Message-ID: <20260721152548.085387353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


