Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345923911A9;
	Sat, 17 Oct 2026 16:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254434; cv=none; b=dmJLfhtwv6s6PseQFKE24HVJwjE9r9NbMuU7XR9GVx28GMm4Tr+2a+rwpe0YPIgwbumswiN4m8zHNIaprOrvMsMWsuLr9YUhyBKwz7Kh7kZIYoOptJ8BU7uwJnxBCrt/dvmmnX9ONdTH8BwlidkMlUOS711uF43m0m1X+fNAPHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254434; c=relaxed/simple;
	bh=8N/bYLERuvaWH15wwAxh1uDFjvoOH8ed/sQ9AQC49Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bh7Ewx2L/rZtng8w3ekrni7Y+mES3CrEbNMwMPTTMbuWFpUemzodxhM6LhAkUcINlvxPqq91yHhOGenUCFMaRga9xq4mjAolIFoi9V/gcYuSRTvVCExUJwEvLqQ7KAHUiUCSfsWjQHAlqjB1IfrI+3lCK4RRXP3ur7q3e71u+qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YAaeK9nu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAaeK9nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E821F000C4;
	Sat, 17 Oct 2026 16:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254433;
	bh=bIODOJodbjhc2qk49JBpHav8pzBF0Ro6eANr68Ltd6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YAaeK9nu+gftp/YwNIL+iwYgi7VOCFWo6aeVAHpxakIwbaJpF4NOx1a0A5GeAkz0Z
	 uiBpVk/CoUfrUTnAAGfHKnRuWWmmGA8iJ52QfqVn6wpGVKsum7D3TNSuQ8Ozwsjul+
	 ZWZgUdAPGwcWSLLqJA7lkX4bDTZhGhzSE+Z/qTwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 445/869] sctp: fix addr_wq_timer race in sctp_free_addr_wq()
Date: Sat, 17 Oct 2026 17:54:46 +0200
Message-ID: <20261017160048.554286417@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 976c19de0f22a857ba0112f39635f8fd7a257568 ]

sctp_free_addr_wq() previously removed addr_wq_timer using timer_delete()
while holding addr_wq_lock. However, timer_delete() does not guarantee that
a currently running timer handler has completed.

This allows a race with sctp_addr_wq_timeout_handler(), where the handler
may still run after addr_waitq has been freed, acquire addr_wq_lock, and
access freed memory, leading to a use-after-free.

Fix this by calling timer_shutdown_sync() before taking addr_wq_lock.  This
guarantees that any in-flight timer handler has finished and prevents the
timer from being re-armed during teardown, making subsequent cleanup safe.

Fixes: 4db67e808640 ("sctp: Make the address lists per network namespace")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/5dc95f295bdb5c3f60e880dd9aa5112dc5c071cc.1782757874.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/protocol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index c6d74fa517cd8..66ede52383f86 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -693,8 +693,9 @@ static void sctp_free_addr_wq(struct net *net)
 	struct sctp_sockaddr_entry *addrw;
 	struct sctp_sockaddr_entry *temp;
 
+	timer_shutdown_sync(&net->sctp.addr_wq_timer);
+
 	spin_lock_bh(&net->sctp.addr_wq_lock);
-	del_timer(&net->sctp.addr_wq_timer);
 	list_for_each_entry_safe(addrw, temp, &net->sctp.addr_waitq, list) {
 		list_del(&addrw->list);
 		kfree(addrw);
-- 
2.53.0



