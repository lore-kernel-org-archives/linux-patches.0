Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DD93314B4;
	Tue, 16 Dec 2025 11:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884959; cv=none; b=Y8aA/3Ph3svCant7Q7e/flIWdFvT6fzcANN5TXMNFFRKJjrdCuOIBYbRVVSGvgzEdtI0ASdVuKHiVDpzA6uxc6pTQN2f2d8W18pMrEIAl7dXDE/Fh5rr0K6qxQ/4EIi4oPtjzLUd7nF4NRhSgdC64dM5fgWT5hAD45ccA0HU2wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884959; c=relaxed/simple;
	bh=esQ6pfHbpy16oo46aBf375dn+IKbuKc6GINBkEVdUJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7GU5R/e5AGqs/CJQndEHbNAZmOPA8ke5sTNX2OagN2IG3DKgpuHSBCTRryFuYtAPAyjvrDLZB0JzaujJ6HLPHNAbtGuCbIb4aCx0ZkjjOGGu3ZmArk1sqpqo03VeUf4Ib6Rvgj2z9J6zG+WVLOJtPaEOit3wicmjj4O6jqk//E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=foWxd5O4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="foWxd5O4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D299C4CEF1;
	Tue, 16 Dec 2025 11:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884958;
	bh=esQ6pfHbpy16oo46aBf375dn+IKbuKc6GINBkEVdUJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=foWxd5O4NG31cWPaKLkPb+3VUtgZ+G0MZe9DQLTVaD9NNvY++N9dgcBmlu3FKfVte
	 EerpbhGmfmwQyuT9FgnLKORIywGZByoLsH7eVFKk0ZluyP+B//hTOG5i3NMKHAPdLj
	 y9WOy4mIp7oreyeY+3x2vT7I0z5BTRMuGbUb2f3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Gyokhan Kochmarla <gyokhan@amazon.com>
Subject: [PATCH 6.12 349/354] tcp_metrics: use dst_dev_net_rcu()
Date: Tue, 16 Dec 2025 12:15:16 +0100
Message-ID: <20251216111333.552752806@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 50c127a69cd6285300931853b352a1918cfa180f ]

Replace three dst_dev() with a lockdep enabled helper.

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Gyokhan Kochmarla <gyokhan@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_metrics.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -170,7 +170,7 @@ static struct tcp_metrics_block *tcpm_ne
 	struct net *net;
 
 	spin_lock_bh(&tcp_metrics_lock);
-	net = dev_net_rcu(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 
 	/* While waiting for the spin-lock the cache might have been populated
 	 * with this entry and so we have to check again.
@@ -273,7 +273,7 @@ static struct tcp_metrics_block *__tcp_g
 		return NULL;
 	}
 
-	net = dev_net_rcu(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 	hash ^= net_hash_mix(net);
 	hash = hash_32(hash, tcp_metrics_hash_log);
 
@@ -318,7 +318,7 @@ static struct tcp_metrics_block *tcp_get
 	else
 		return NULL;
 
-	net = dev_net_rcu(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 	hash ^= net_hash_mix(net);
 	hash = hash_32(hash, tcp_metrics_hash_log);
 


