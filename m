Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5593597E;
	Mon, 23 Jun 2025 22:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716417; cv=none; b=Yqcktu1zdTAaLMup6/4NeTVSMJPbGhWWgxC72FbMxLv0u/h9oNVi5IsQCtoZnNPim38jLvtfBomj/8lJvb/267LFGeOXGuhK9LeHCUSyKvZ7AWxnNdJE20DUeV8SMaIZex5pp/4Y8481M5QWroil/449t00+3OGLD6P34ZY8Tqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716417; c=relaxed/simple;
	bh=WPtRGSWX2QXNMaS7K/y1fpUamKDwTBipdo9yde8Mrjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Si4yX+2I5NsCvouWnZLcwSMOEGnMZl1cFaMaNcaPzZ9y16nrO/ZBM40AeGvaixtkSsIPu5+EfrJXlbm0klCu3mcBBr+eiLPwC26xZmOz7jUy3L9aKrR/xkohn33bDhFMJJkp3m2dhHgJ2QU4oNZVxAO2xRFNlzUCbyO30pmYcGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfToMToT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfToMToT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2749C4CEEA;
	Mon, 23 Jun 2025 22:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716417;
	bh=WPtRGSWX2QXNMaS7K/y1fpUamKDwTBipdo9yde8Mrjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfToMToTfB5HTkTtir0+DNNMWR3EsVOv/lXvRKpa28GqBYBnxoJ1BTaC2VbCk6+QG
	 kmrjdty2zhhbhcwFjhWKQpUT9JvuTzWef/Fy8lCxZgbG508dG4wRWeQGphvNX+twMt
	 QATvt0StLnuv5kj7y9Xt0dJ9kgG+L2XU510+Z5hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 262/290] tcp: fix passive TFO socket having invalid NAPI ID
Date: Mon, 23 Jun 2025 15:08:43 +0200
Message-ID: <20250623130634.791641836@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 32b28fc21b63c..408985eb74eef 100644
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



