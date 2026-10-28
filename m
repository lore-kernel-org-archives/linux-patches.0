Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215626;
	b=k50wd+RNiZZNWmgVdglANknQQNiIaVOJeLENZ/zkiw0+rYZGxRrpklG+jxfP7ppURlRW
	 2br6Ki7yCgltdmbsIkdLSscyUlI1aA08WsPVS1kjadF5tp/tC4Q7mQGy1MlN4vHaj2ks0
	 oRLyISCSQ9KDsUFuGy8eRCJtGdMhcI0i8X5E1xY9vVgTVJwn5GUaWzGQdjzuSqRBpyjN6
	 APQBC+Od96quMDaOcoVNEt3SOWdoj/0tdp66rGmWVG74f7zb48brx0WAtTIniv4bx+kf9
	 jxdp1w0xAqtEffsOWiNFeicq00EGS4RhJtxHMXuUWEnIOEC9qqaFIhSzBsxFSeUs/nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t7Zt3beWJLIUZM/tSYjlKKuxobnxb3PO/PhnPh6z7Wo=;
	b=1mKm3eWFl3ELhwfz/WDABGPyEkjBJrDuOm7nxj70P/MBERI6xa7SMgmKiBqTasdNRBZD
	 2d2MEdQPk7hCc1yXhCu8OwZkDpo+FWSHjYr94gUX4PSOJjQu7kAUJBbfLulUOcYvgwnxD
	 Eafg8vdAzzM24/GcyhUbvqubeFHA4ES6iYOrGFWmWJJAts41m2HqA574InlyoyzVCiM19
	 MIapbzR+lVUCahyzLdAsU6oyF2vHqIBl/dCS6TGEna/pfkXNsfr3DnbXtnGSyDIpHWRdX
	 WnKpYljQBzgeV9QcqNgpJw8aV0ODZsQDngZ9hfmWdi74ISJHMFM+Y18gUDBGd9eV8hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXLvwQZC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736AF606A31C;
	Wed, 28 Oct 2026 19:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXLvwQZC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E39E1F01825;
	Wed, 28 Oct 2026 19:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215626;
	bh=t7Zt3beWJLIUZM/tSYjlKKuxobnxb3PO/PhnPh6z7Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NXLvwQZC+myht0MotnMVw1ej5OHQzTxy3D66xM+xza5XhhgnvxAfqaprN/Q04Pw43
	 OFMA3Mjc7REQ7gDgVk5g2qZEUfDq5erpJ9Jo4P4ZHotHkVSMo0pAlmYV+QVcFqgWWJ
	 ZMq0l+Vg6Tas5/hcmqu8xet+VFiNGzSMuOyziebk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1233/1887] sctp: fix addr_wq_timer race in sctp_free_addr_wq()
Date: Wed, 28 Oct 2026 17:55:29 +0100
Message-ID: <20261028170527.481878207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 76a5825d427ee..bf8ef27377783 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -685,8 +685,9 @@ static void sctp_free_addr_wq(struct net *net)
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



