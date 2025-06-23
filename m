Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6040F223DE5;
	Mon, 23 Jun 2025 22:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717419; cv=none; b=IUyuTnA6vEnp6/nqfH/e1UrXV2GsQNUojJmJbVrHbD7q0U7WaORR1XolOrRIftIW2xQw4HlhjgzRB6JW2Y6lsM1VeZ62jz9u1lllH56vPmsRjxLL5WGFZGq3EoR7M9CkEymZOaJ6aYBDtT8Opcg+4RaGhAv+PdjBdHHt+CNUTRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717419; c=relaxed/simple;
	bh=j8RgE4gy0VEZFnXE6/Y9CoVU0vdQ/OZMmxd0sQdk+e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0RbUL1y7yPGkxhw2pH3KSZhX4QPIKDo92VWAQtWEN3RZ+Z52FFamEErSrjaLW+KzvqMEm3sNRi+dtP9oErLnw7+zX/JRHUkOHOcjbVotnIgpc2cLap2zHeMnq8M+k9uIGKsqqxTLlRMrCg+AeLVRseoQbqhebJTaAsc+7fO7mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LK3L3OYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LK3L3OYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A4FC4CEEA;
	Mon, 23 Jun 2025 22:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717418;
	bh=j8RgE4gy0VEZFnXE6/Y9CoVU0vdQ/OZMmxd0sQdk+e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LK3L3OYGjGn1Kes9LVOVZaAXFnWGzYRMYQDWH2fq2xZbgJL04IyuECg1nr8v+jZyZ
	 4cmWRjpyBF/w3mszoE/3JjxMduMSrzz0sB65pT3+JWhIs9j5lyPbW8zYPhVQbh6uNl
	 YqppL1ANVVAFt/0SVe1aUax3JC7jrTRW1CHDlbnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 384/414] tcp: fix passive TFO socket having invalid NAPI ID
Date: Mon, 23 Jun 2025 15:08:41 +0200
Message-ID: <20250623130651.552158668@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



