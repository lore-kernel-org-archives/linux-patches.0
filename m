Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A452222B2;
	Mon, 23 Jun 2025 22:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717641; cv=none; b=Er0a1WX/7AJP+8rzclpJjf2Rc1cKX02qJZETxCkX1TFGAGyeIgnNshFjF4p1Mcjx5xfqJBEwo2qSdZh24aYM5ucfWZ6GMGGl9yaE6AMGGquRiHTYBi7wTzyDwzm19cb9rHpGpbTmr4pEMo/VrdNkJy5mvvjyvIb6fmZNFVFFGdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717641; c=relaxed/simple;
	bh=0jfwImt9BUfR1MMc5P4CTQel6Y6GK/ziGuucHoKIL10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqGuYot1lCyUQ+io5Fg/IvUCPKzuJ0DIaLEcQXuMx3z8uC5IloMZJT3UbApcqjj8ECPLePJNP/hIZOkmCeGINRhtpi2umwSIyK8S4GDgJ38ughwtAEgChloD5HWoiqlC+dtxF5iqmtuOjwxwhNcs/PYppPLf194nNS+qhyLOG3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRJL/u37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRJL/u37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7A2C4CEEA;
	Mon, 23 Jun 2025 22:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717641;
	bh=0jfwImt9BUfR1MMc5P4CTQel6Y6GK/ziGuucHoKIL10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRJL/u37QaMbm0xV/PJhb2Msj/fCS/0NcKvgGTPg7L5Cr92cqp94BcmvDikswxIm6
	 PboR/FsYAKiUXH5ZZPXueZtPsKBGLARi6Z16LD70EyMJ1awIw4WtGkpsfZVOx9Lmty
	 QyvAzPo/iHKtDW7mBKusrw9N9dO84jaMyUyXGIFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 486/508] tcp: fix passive TFO socket having invalid NAPI ID
Date: Mon, 23 Jun 2025 15:08:51 +0200
Message-ID: <20250623130657.010065412@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: David Wei <dw@davidwei.uk>

[ Upstream commit dbe0ca8da1f62b6252e7be6337209f4d86d4a914 ]

There is a bug with passive TFO sockets returning an invalid NAPI ID 0
from SO_INCOMING_NAPI_ID. Normally this is not an issue, but zero copy
receive relies on a correct NAPI ID to process sockets on the right
queue.

Fix by adding a sk_mark_napi_id_set().

Fixes: e5907459ce7e ("tcp: Record Rx hash and NAPI ID in tcp_child_process")
Signed-off-by: David Wei <dw@davidwei.uk>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250617212102.175711-5-dw@davidwei.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_fastopen.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index cb01c770d8cf5..cbce1306bb08c 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -3,6 +3,7 @@
 #include <linux/tcp.h>
 #include <linux/rcupdate.h>
 #include <net/tcp.h>
+#include <net/busy_poll.h>
 
 void tcp_fastopen_init_key_once(struct net *net)
 {
@@ -279,6 +280,8 @@ static struct sock *tcp_fastopen_create_child(struct sock *sk,
 
 	refcount_set(&req->rsk_refcnt, 2);
 
+	sk_mark_napi_id_set(child, skb);
+
 	/* Now finish processing the fastopen child socket. */
 	tcp_init_transfer(child, BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB, skb);
 
-- 
2.39.5



