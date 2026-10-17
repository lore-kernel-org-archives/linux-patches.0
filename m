Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62463C0601;
	Sat, 17 Oct 2026 17:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259204; cv=none; b=hSx9/+gc+V1PaLgJVMxgI+Pa+cNiB3laJHvfvN3gHZP8ZmAkVmjtqJhN9MXCD9s9vwPiiKoFTTd8spnARXF9zWRH7+CvKO46KYlmD0R+Dv4DAONdWd2oFvZ0m090LUFCXEorew8Zg+gnNqAwJPigDru/xFAV6FANE+IOBbjGbiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259204; c=relaxed/simple;
	bh=EzwhNIjI7LIuN8MYTEfs0Teqyer7KdmzGuU2v2hTPaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcS4tIXfreiSgRH9/BgCdMVSJX5sM9JhRULRhCXKUUk/Ln1D/g8cwDMWVL+xLwyVNfHlKTRmdhvGV5td75Ac8vxGPQfWY/X8xhUYUKnX3keuZJ5YNHmzv2B3LY0PesFGfYrs5/yUG2G0mjRfoqE413NZqWK2U7gsxnHaL5joRgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZyVq+xB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZyVq+xB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3201F000C4;
	Sat, 17 Oct 2026 17:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259203;
	bh=U9P1lvQMN8tMhnGJtlG5zEz+Rf3tID9h47XNaMSX3Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rZyVq+xBl8jFQ3t6dpt1BTWlHPMZizXTqHeYL1MMfJ7iA7GMdJL7rKcWoU92p5HXv
	 RJPYh+iM3TBRUdj41gkCh4ROh6mj0+O2iKmpnBgvMba8GzUIvJVOoLPVFtZJfEYo/Z
	 s6jlEtCANOeJ6thLSoZbWMfaU3EBv1fLKGkIYlSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1135/1674] sctp: fix addr_wq_timer race in sctp_free_addr_wq()
Date: Sat, 17 Oct 2026 17:56:47 +0200
Message-ID: <20261017160500.293789719@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index ade01785cb1b5..f91448f35b0ca 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -692,8 +692,9 @@ static void sctp_free_addr_wq(struct net *net)
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



