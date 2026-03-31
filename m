Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD81413225;
	Tue, 31 Mar 2026 16:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975699; cv=none; b=lA03jtJSuVpV9sjcSVpan5naxaieojgGxB2BXMzIUfRDwM9meOtAepnC0OB/cMt7dc30qGzNnT/WfSsXbbVfamAPrypI7vCzVKn1oSrtzsEEnTqsWvpfm+W/2GP+m1U8tzpWeMq0iypJsBhSokxozJyaxH2cxZAPeRVJDCiTBA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975699; c=relaxed/simple;
	bh=4X5eFl6zEtpI1RCn9NA1XFUZ7qcxUXGAzbUpoMHKgRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqY/MZ6MlozSYtXSDVjsanfrp9aByJzQlNDw86Bc4Uah0e5KAQMgHJwtHwhivLccCN9qVYnwVFBMZHXcctVC0m/ihNUS1zsJqRdk6rQfJeMBdOlk54V2xuTv4X5v/Ex4VvZneu1FliJZOmy2lTsVkMLgIWFnVEf9pDs/sdJku+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=toZW0OWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="toZW0OWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037B1C19423;
	Tue, 31 Mar 2026 16:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975699;
	bh=4X5eFl6zEtpI1RCn9NA1XFUZ7qcxUXGAzbUpoMHKgRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=toZW0OWwFevoITkfEmTIus5quT/BZlrDDY4My+UFGXlZu3kVEMh71QZBoClEm/zS6
	 vyaU0FLKJRYd1vufOO8p2G5cqXba5voNM2pcb23CU+rnOQ4lBin9irtexIAahGMXxD
	 82FC+mWarb7Nsky6GGkk0YFmsg0ZspFHl7mzriIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/244] xfrm: Fix work re-schedule after cancel in xfrm_nat_keepalive_net_fini()
Date: Tue, 31 Mar 2026 18:20:02 +0200
Message-ID: <20260331161743.615838793@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit daf8e3b253aa760ff9e96c7768a464bc1d6b3c90 ]

After cancel_delayed_work_sync() is called from
xfrm_nat_keepalive_net_fini(), xfrm_state_fini() flushes remaining
states via __xfrm_state_delete(), which calls
xfrm_nat_keepalive_state_updated() to re-schedule nat_keepalive_work.

The following is a simple race scenario:

           cpu0                             cpu1

cleanup_net() [Round 1]
  ops_undo_list()
    xfrm_net_exit()
      xfrm_nat_keepalive_net_fini()
        cancel_delayed_work_sync(nat_keepalive_work);
      xfrm_state_fini()
        xfrm_state_flush()
          xfrm_state_delete(x)
            __xfrm_state_delete(x)
              xfrm_nat_keepalive_state_updated(x)
                schedule_delayed_work(nat_keepalive_work);
  rcu_barrier();
  net_complete_free();
  net_passive_dec(net);
    llist_add(&net->defer_free_list, &defer_free_list);

cleanup_net() [Round 2]
  rcu_barrier();
  net_complete_free()
    kmem_cache_free(net_cachep, net);
                                     nat_keepalive_work()
                                       // on freed net

To prevent this, cancel_delayed_work_sync() is replaced with
disable_delayed_work_sync().

Fixes: f531d13bdfe3 ("xfrm: support sending NAT keepalives in ESP in UDP states")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_nat_keepalive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_nat_keepalive.c b/net/xfrm/xfrm_nat_keepalive.c
index 82f0a301683f0..8a0379c8c41c8 100644
--- a/net/xfrm/xfrm_nat_keepalive.c
+++ b/net/xfrm/xfrm_nat_keepalive.c
@@ -251,7 +251,7 @@ int __net_init xfrm_nat_keepalive_net_init(struct net *net)
 
 int xfrm_nat_keepalive_net_fini(struct net *net)
 {
-	cancel_delayed_work_sync(&net->xfrm.nat_keepalive_work);
+	disable_delayed_work_sync(&net->xfrm.nat_keepalive_work);
 	return 0;
 }
 
-- 
2.51.0



