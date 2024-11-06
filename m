Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB667171C9;
	Wed,  6 Nov 2024 12:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896310; cv=none; b=KXS86k24JCq3RQGM6WH7qzn/fdJk8FkSjrOrl8UOUfAvsmQs5qNoPRFd8PjNxVVpK/L5/0Irb8j8xjhHmmNKi1GUXzIKBKhkJpR0vxiLPCbZbOjrkb2pdSMAoM+gCwP2O29FOEl3VIlPSG5Cj/aOWvf3pdrW+T8ufCYimAIF+7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896310; c=relaxed/simple;
	bh=QK6c3hnYlHJ+0s9pthi6a5z+SMCgWJLRWwVEeVKC3oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+CWqRQeYWjGkO4nTdE5tcMSirFi95vqA+h5l1zjgGDvlzcBGctzGQMNLFa222twgxcNRpbyOXDcHG+sBBuzw2T0xS8h7dzNT3IUPUs6qqFsxWRwtJ5R+1PV3j8EZz43WQeMfO9QJr/lRkCVpH4NOr7+aAl3j+SGCsLyvoEmFeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tu0FKUd2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tu0FKUd2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7052EC4CECD;
	Wed,  6 Nov 2024 12:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896309;
	bh=QK6c3hnYlHJ+0s9pthi6a5z+SMCgWJLRWwVEeVKC3oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tu0FKUd2uc2nVN+xPm3TCRu2/S07qx49yDCtWgO44RddG7R7+pamj5RllOEW+g2Fd
	 BX8iS7gTuf5l0zEjVSIxRUPiIyGpIKeNTcd7JsdK+WFTDr8lqrquR4QW5vP2X54pbH
	 kAYqZxUeYwyK4xxVeiGI2HeSDgPUW+v/ASnwxjOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+36218cddfd84b5cc263e@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.11 124/245] wifi: cfg80211: clear wdev->cqm_config pointer on free
Date: Wed,  6 Nov 2024 13:02:57 +0100
Message-ID: <20241106120322.276028681@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit d5fee261dfd9e17b08b1df8471ac5d5736070917 upstream.

When we free wdev->cqm_config when unregistering, we also
need to clear out the pointer since the same wdev/netdev
may get re-registered in another network namespace, then
destroyed later, running this code again, which results in
a double-free.

Reported-by: syzbot+36218cddfd84b5cc263e@syzkaller.appspotmail.com
Fixes: 37c20b2effe9 ("wifi: cfg80211: fix cqm_config access race")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20241022161742.7c34b2037726.I121b9cdb7eb180802eafc90b493522950d57ee18@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1236,6 +1236,7 @@ static void _cfg80211_unregister_wdev(st
 	/* deleted from the list, so can't be found from nl80211 any more */
 	cqm_config = rcu_access_pointer(wdev->cqm_config);
 	kfree_rcu(cqm_config, rcu_head);
+	RCU_INIT_POINTER(wdev->cqm_config, NULL);
 
 	/*
 	 * Ensure that all events have been processed and


