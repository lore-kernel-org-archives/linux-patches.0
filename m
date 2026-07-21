Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05AC381E92;
	Tue, 21 Jul 2026 17:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653519; cv=none; b=WW9B7yGRJD7+z/Jc8exMT6KSCrflq/3qsaPqAyEBDzVgDHsz+oDB+0L/yyZkWsUriKhDWKSWA5FT2sYTkzArfENUFaD7ihrCCxvp5rX3ALuvR17NB6jzj+TwDGxCvBlgk5x8NdHFD0AKp88sBlDVdSRce1OS0WitEySVLp1lQtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653519; c=relaxed/simple;
	bh=8DswrC6V2U5ghpJceFk1CbhfmVONsvtJ9MRcC5dB5EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1u+ilLYmK6JTsTYv/Se/1yVLvZjNgplHRkr0DLXJpW3tnSJq7IobZAv/ndEs+Pq/6HNeAniBoXIBKi+XJ+RfWAcTtM9cI7GRsEkdTD9TxwHFGGeVDymZQOCkDKUleaw3OEZhmJ9OB6NVazx0wubKZujs1t3yhIcomHPLL1d3YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hIrqQkzi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hIrqQkzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257DF1F000E9;
	Tue, 21 Jul 2026 17:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653517;
	bh=+4bCYUzqAPA1FFmrbIlOK1YzYrKr3agPo4IW1r6CXwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hIrqQkzixCOK0ZCFlPxJ2ZwyRHlF/0X+ne4T2x9vULoJfSqM2iN+F0QPbta1NFSFW
	 f/vlCD7HRGU288b6t42mg+YV64OogldtmUjemCtqbIGLzb5jcZxwNeF1W1LKsD7ydT
	 gsYi30lTCgY0Sy0VpNaawy5lFFQsoDiPJr0uvZK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1357/2077] sctp: fix addr_wq_timer race in sctp_free_addr_wq()
Date: Tue, 21 Jul 2026 17:17:10 +0200
Message-ID: <20260721152624.824718493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5c6fa8e8d34d33..e95061b672ef4d 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -663,8 +663,9 @@ static void sctp_free_addr_wq(struct net *net)
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



