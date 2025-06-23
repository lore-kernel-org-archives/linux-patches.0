Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD81222576;
	Mon, 23 Jun 2025 22:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716657; cv=none; b=i89S4Bi/HjrTDwCx2GPNCTHNdtwfMYogZNwekQ/NCUTEkVKWLAAqY3YCO7IGaAUFDjhYA4UwlEMnRreKPJw69KAm+gZ8cMg0ZeVlZwetDuT0FYDrt7AoG9Gep4LaTpHiTEQFMNZf8ts22m8V2O5MF1yjQC/1FoJOsjLXuVRV/PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716657; c=relaxed/simple;
	bh=X14ylerMHmbwEuwzjbZsQ3+zkaidEogYI6cK5UGbunw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkXxY4NgZEdtipa3NjJY0SScKaDcJm1tPNTZAthdzqPGjlCIJc7abHkcwRR35ZeQ0S9hfB/J9IncQEtBvmwPgFqeY8vi4SrZuI3JvrT0hifkvy473YOzg9O22Y86lB0N+D9dCPP9+NJttGsbtzAhJzYMpfSjjLTVuA6lnw45aHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8A9cvwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8A9cvwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CA8C4CEEA;
	Mon, 23 Jun 2025 22:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716656;
	bh=X14ylerMHmbwEuwzjbZsQ3+zkaidEogYI6cK5UGbunw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8A9cvwjma1felmyERV7517qI8uSD4sTo/1+lXs0RH/2Ms0KECQdS8+DR1wPCjRtM
	 c8zTg7IcjXuTaJ7QKJpF6ol0LoiFj2IwMCxikc10y3V+qw/0jNqytR9duPmf/nkNVK
	 kenGpYCGODjDKn83nz8vU78JBpfUGJkpuIGTVyEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 545/592] tcp: fix passive TFO socket having invalid NAPI ID
Date: Mon, 23 Jun 2025 15:08:23 +0200
Message-ID: <20250623130713.403627399@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1a6b1bc542451..dd8b60f5c5553 100644
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



