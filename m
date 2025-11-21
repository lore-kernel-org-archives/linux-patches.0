Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373F634C155;
	Fri, 21 Nov 2025 14:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733622; cv=none; b=rsQ8SCSfVsseKmVS4kOZDGTGONKG/Ttwu87b79CsGgfLmMij4vmEW0nKfIRSbbItBbbcL6L2g3tG3SvG6ohYqpFH1ISBoYDgwO2+3lRPO+ujjIhD8yF0m1JR5Iuq9ALNmzLSBfvlYguwqyXFGFnUva/YOs9Kc22Uy0/FoRBMHMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733622; c=relaxed/simple;
	bh=dOZCsHN8pgdm2kaHmTiMOmf+fd1X9Tn0wxsPS8LOhWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/6qAoLr4nFrnMSuYIQGKXNfaduzk8DXUythMkvZay0yPoNxD5VucFm3HL7aLVyIdUuwP8OI36uF3W1eyhE7RQF/MPt8zmKVMYOwVJUwfkcT0uXL944CCF7QhD1QR1yXpw21roQdkhg6Arv16a20ZsvyXv/b2QxUvry5Yte+ey0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnzFCD8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnzFCD8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6239C4CEF1;
	Fri, 21 Nov 2025 14:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733622;
	bh=dOZCsHN8pgdm2kaHmTiMOmf+fd1X9Tn0wxsPS8LOhWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnzFCD8Kc9Blkr1Dxy60tbmBB/ITTLxICgcK+LQ//uAz324F5oX2lgve+iBkxa0GF
	 4r60pIbH4Uuoooy7TFqjhyTWqehXmJC1P3/tXNyYP946ii/WCCQyC/qoQ0PxIhzRkX
	 uRKgP5SLAIzYS2wkiPbYYiCPT4VDpCIcoV3yJNoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 499/529] net: netpoll: flush skb pool during cleanup
Date: Fri, 21 Nov 2025 14:13:18 +0100
Message-ID: <20251121130248.769449050@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 6c59f16f1770481a6ee684720ec55b1e38b3a4b2 ]

The netpoll subsystem maintains a pool of 32 pre-allocated SKBs per
instance, but these SKBs are not freed when the netpoll user is brought
down. This leads to memory waste as these buffers remain allocated but
unused.

Add skb_pool_flush() to properly clean up these SKBs when netconsole is
terminated, improving memory efficiency.

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20241114-skb_buffers_v2-v3-2-9be9f52a8b69@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 49c8d2c1f94c ("net: netpoll: fix incorrect refcount handling causing incorrect cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netpoll.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -538,6 +538,14 @@ static int netpoll_parse_ip_addr(const c
 	return -1;
 }
 
+static void skb_pool_flush(struct netpoll *np)
+{
+	struct sk_buff_head *skb_pool;
+
+	skb_pool = &np->skb_pool;
+	skb_queue_purge_reason(skb_pool, SKB_CONSUMED);
+}
+
 int netpoll_parse_options(struct netpoll *np, char *opt)
 {
 	char *cur=opt, *delim;
@@ -786,7 +794,7 @@ put_noaddr:
 
 	err = __netpoll_setup(np, ndev);
 	if (err)
-		goto put;
+		goto flush;
 	rtnl_unlock();
 
 	/* Make sure all NAPI polls which started before dev->npinfo
@@ -797,6 +805,8 @@ put_noaddr:
 
 	return 0;
 
+flush:
+	skb_pool_flush(np);
 put:
 	DEBUG_NET_WARN_ON_ONCE(np->dev);
 	if (ip_overwritten)
@@ -844,6 +854,8 @@ void __netpoll_cleanup(struct netpoll *n
 		call_rcu(&npinfo->rcu, rcu_cleanup_netpoll_info);
 	} else
 		RCU_INIT_POINTER(np->dev->npinfo, NULL);
+
+	skb_pool_flush(np);
 }
 EXPORT_SYMBOL_GPL(__netpoll_cleanup);
 


