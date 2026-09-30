Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC3A47A0DD;
	Wed, 30 Sep 2026 18:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791762; cv=none; b=IFa9W6mb0/Dd/vom3y+zm3u4PuwGDdP9vAshiZN183eRblDxMmmi8raYNIVCvYH/o3oDyzLpXwiLQ+ZKCxs+7ZSz1oweAkruRYC2PsBh6/+/ru/zbKkMSoPCL/4j9fw91XtscEGH6+H17aVMGP43JQmjR+uDKyri8gU4flCvhX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791762; c=relaxed/simple;
	bh=YysgYHOvVpuFWUqNcqd8Ezvd1xhAWJzxoKNM6pV1FFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ss8ATLnRluxEWx/XHXqR4NtHk6Pp3q/scbqWXD7+rJdjT0sDJHkQJ0hj1WE2ZjqaSe7WZd8aHc8LF2FOckDq8d66gJRn+qIKT7+CqzLPwXNPlCOe8epMAIt5+Ts0Cp0vm1Qcd/TckCClMHJK/k6nMjbkvzg+Ryr/+apiVNqIaAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bky34IBj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bky34IBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338161F000FF;
	Wed, 30 Sep 2026 18:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791760;
	bh=2SWL6w80na9wHgQxSOk5caRdX48Ua0ieESwE65Xfcb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bky34IBj32NkQ4T+A/sAjj3b9RVVYe36orpCQh/gnuKsLMPQCXdayFlfPNbtV9LPB
	 6dQ04f+i3+Ieu6HuTRf6E/vOuEoHQ64r2SDF7h1T36EhL8xaIR2lfzCt16rKyIzF4e
	 4Dv8mWghTiGPMUVVV3mrvKmZZqxVPL2tI8/9I9Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 371/752] ipv6: fix fib6 walker UAF on seq stop
Date: Wed, 30 Sep 2026 17:24:01 +0200
Message-ID: <20260930152406.307117814@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <zihanx@nebusec.ai>

commit 19b4ed644d68098cc62ab612727f40d30f43476c upstream.

ipv6_route_iter_active() treats a walker in FWS_U at the table root as
already unlinked. fib6_del_route() can move a still-linked walker into
that same state when the current leaf is the last route at the root,
so ipv6_route_native_seq_stop() skips fib6_walker_unlink(). The seq
private object can then be freed while it remains on
net->ipv6.fib6_walkers. A later route deletion walks the dangling list
and uses the freed walker.

Use the list head as membership state and reinitialize it when
unlinking. Keep the existing w->node check so a never-started iterator
with a zeroed private object is not treated as linked.

The same stop helper is used by /proc/net/ipv6_route and by the BPF
ipv6_route iterator. The BPF show path only widens the race.

Fixes: 8d2ca1d7b5c3 ("ipv6: avoid high order memory allocations for /proc/net/ipv6_route")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/89699735763f6c297584d7c2ff106239cc1e8ce0.1788837093.git.zihanx@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_fib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -84,7 +84,7 @@ static void fib6_walker_link(struct net
 static void fib6_walker_unlink(struct net *net, struct fib6_walker *w)
 {
 	write_lock_bh(&net->ipv6.fib6_walker_lock);
-	list_del(&w->lh);
+	list_del_init(&w->lh);
 	write_unlock_bh(&net->ipv6.fib6_walker_lock);
 }
 
@@ -2647,7 +2647,7 @@ static void *ipv6_route_seq_start(struct
 static bool ipv6_route_iter_active(struct ipv6_route_iter *iter)
 {
 	struct fib6_walker *w = &iter->w;
-	return w->node && !(w->state == FWS_U && w->node == w->root);
+	return w->node && !list_empty(&w->lh);
 }
 
 static void ipv6_route_native_seq_stop(struct seq_file *seq, void *v)


