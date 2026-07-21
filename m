Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7963227BB5;
	Tue, 21 Jul 2026 18:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658022; cv=none; b=Na4ncMOb6QTGs6f4G25GESfAbXohfrJ0pk1p0YadvnSJvexy76elne6p6h394+HDcnJwwRxd2Nl021idZFCY0W7DbuPVHCTjPr2ncupy+DTDr7qIt2GxL7hJ5SAi84MB7hjSg2jdyb5UXGYIYXdCzWXVV+d22/0vnooYKPLaTIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658022; c=relaxed/simple;
	bh=g9ZfaopfQI/axJvqIADcjxFmBufHqqm9fs4QmTZQKB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+n3yOBQ/IrNO46R+/A/GGMMHkWukxo63P6Ej5BuPiZLTTFCiVSBcf8GN1a2B5l27mQKc9L/CpTR6gWELUVcaOues6+CTd3b1z0Dy4MBMkvpLg7DHdQXAVJIx6FZg+dUbxvoSRT7c97ZVH/bLqDoi3Es0D7Cm55Cj29Wrq1rlfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fO3nKUv3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fO3nKUv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198001F000E9;
	Tue, 21 Jul 2026 18:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658021;
	bh=OA4NcvBn0eh8ezpjj+68qLnm3Chh5OCdnTC3LhZA4Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fO3nKUv385yrKGO6TyUhpWcmqGYhHPsPaw4nI67ufiXQJlJmZFhgqj5LecsTfsxGz
	 hm6nfLInSB08M1Ecxc7Xdg9HGH5NwRGmL9Xag4qxIfpcVkTfMwqf+DDpm7U3b2k3ah
	 Q2/q18WhkUEdLFt+evJZc9oXy3BzTEjd/d9KbFbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0987/1611] sctp: fix addr_wq_timer race in sctp_free_addr_wq()
Date: Tue, 21 Jul 2026 17:18:23 +0200
Message-ID: <20260721152537.592745518@linuxfoundation.org>
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
index 6ce58fc95ef512..bbeff25185b176 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -695,8 +695,9 @@ static void sctp_free_addr_wq(struct net *net)
 	struct sctp_sockaddr_entry *addrw;
 	struct sctp_sockaddr_entry *temp;
 
+	timer_shutdown_sync(&net->sctp.addr_wq_timer);
+
 	spin_lock_bh(&net->sctp.addr_wq_lock);
-	timer_delete(&net->sctp.addr_wq_timer);
 	list_for_each_entry_safe(addrw, temp, &net->sctp.addr_waitq, list) {
 		list_del(&addrw->list);
 		kfree(addrw);
-- 
2.53.0



