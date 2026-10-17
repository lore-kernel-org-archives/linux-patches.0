Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8676C392829;
	Sat, 17 Oct 2026 17:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258311; cv=none; b=DgUx381eo9LYwZWfTGpvGtAOC9FRWjoNLFhdWlnQ6vFtuuCK9jrzlGgo88EKztwlhue7aIK9aXFnjVDGhrJMJaYnRqX0Mgw8nMd8TvUYJfXjWq3jtNfElp4D2A46odvP893GDLVYz1aQDIRhHPs1406XJN2xbZoTRX5bUMHIBDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258311; c=relaxed/simple;
	bh=/TVi6kgIZ/KGwRbg6LPUgSnUlJd2kAOuzuTcU/mbBlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLtarABnWJw5HcAdZK7/uDZeeh4XYQa2il9L9Oxkj+7Ym1k8PMhuWNOnbOr9wHCdGUBYt1jepopk8eqc0NWLcn1z+kIuHPfS3xcbV+5zulSzMzXjqpVSzyY1WZDguGB3ITvoUVO4vJ9mGBED69/BqrReHgPT9K+Im6954gd270U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvtL3E70; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvtL3E70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88821F000C4;
	Sat, 17 Oct 2026 17:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258310;
	bh=v7QGJ+FNbY0K00cJniTqar0Ro1yJI+mnURYmXs5LPJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uvtL3E709bmIWEt76IR8u/nV0ONzUUtYdw5nxcYhf9FpMjz01ndWRIgX94FFlmf6i
	 KJKpbWDfl/3B5dVRHwPzmZpqI2e557L51gB0r+mb9vqeiIf3Ygg8uasgXAZ6sOimrM
	 zaLvjVyC9G5qQjljmJEDSuhf/UviKXE6q570NLGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0801/1674] tcp_metrics: use dst_dev_net_rcu()
Date: Sat, 17 Oct 2026 17:51:13 +0200
Message-ID: <20261017160451.672378723@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 50c127a69cd6285300931853b352a1918cfa180f ]

Replace three dst_dev() with a lockdep enabled helper.

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_metrics.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 49983d864e4f3..ca88ba261ea1e 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -170,7 +170,7 @@ static struct tcp_metrics_block *tcpm_new(struct dst_entry *dst,
 	struct net *net;
 
 	spin_lock_bh(&tcp_metrics_lock);
-	net = dev_net(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 
 	/* While waiting for the spin-lock the cache might have been populated
 	 * with this entry and so we have to check again.
@@ -273,7 +273,7 @@ static struct tcp_metrics_block *__tcp_get_metrics_req(struct request_sock *req,
 		return NULL;
 	}
 
-	net = dev_net(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 	hash ^= net_hash_mix(net);
 	hash = hash_32(hash, tcp_metrics_hash_log);
 
@@ -318,7 +318,7 @@ static struct tcp_metrics_block *tcp_get_metrics(struct sock *sk,
 	else
 		return NULL;
 
-	net = dev_net(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 	hash ^= net_hash_mix(net);
 	hash = hash_32(hash, tcp_metrics_hash_log);
 
-- 
2.53.0



