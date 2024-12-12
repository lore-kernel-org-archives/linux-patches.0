Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9936223E69;
	Thu, 12 Dec 2024 17:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025617; cv=none; b=WfYUHmP/SKIPIpGjmt28lQnxVhyOZRFTQF8w8bKpFJnFern2sLWyMyoEYYEOg9IHkFZvH8KlhUAkbN+EzHO18PocOMKmXcow/kllH4odDWXSDf7iPbQAZosZuWDnh9gfCtqZSCMrm8BoI7xaXxwlbVO418t9V3PzvG3qqVir/Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025617; c=relaxed/simple;
	bh=hgInaZkf+piglEdieimw8IY97nWfWHd+HFsk5v8Ums8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPWZoGJ5+DYktfnUi3gAQTcb9j3TnaG7029nk9Zf5rrjjSIEq5YR2otIm4N6rvVw55FlSVhapYzSnkIR2r2TnGcd+JqMvMs/Vay750fvuc2FnNshfLotqSJtJNAzSFcin+sr9Uq6pKJvk7/tDSpOtrqiRygbKyLwkMLDErmYLok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOI5nbzb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOI5nbzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC71C4CECE;
	Thu, 12 Dec 2024 17:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025616;
	bh=hgInaZkf+piglEdieimw8IY97nWfWHd+HFsk5v8Ums8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOI5nbzbglV33OvAE7RA/XLQRK+KwI6WZFvUsjXboBgiJCCZip9ZQN4Me0X9M3ydN
	 f29YxcQ6nQeRWtA4NIyR+Qwn18hRVNj6eCNGQrIuRZaYHVIGgRchujYB8xOYL5pAHJ
	 WsCtKI5sM0JqCBXmLxzCE0S8gEng648Yc1Tu9qx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ying Xue <ying.xue@windreiver.com>,
	Jon Maloy <jon.maloy@ericsson.com>,
	Tuong Lien <tuong.t.lien@dektech.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 229/321] tipc: add reference counter to bearer
Date: Thu, 12 Dec 2024 16:02:27 +0100
Message-ID: <20241212144239.022514851@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tuong Lien <tuong.t.lien@dektech.com.au>

[ Upstream commit 2a7ee696f7b000a970dcce0cb06fdcd0a9e6ee76 ]

As a need to support the crypto asynchronous operations in the later
commits, apart from the current RCU mechanism for bearer pointer, we
add a 'refcnt' to the bearer object as well.

So, a bearer can be hold via 'tipc_bearer_hold()' without being freed
even though the bearer or interface can be disabled in the meanwhile.
If that happens, the bearer will be released then when the crypto
operation is completed and 'tipc_bearer_put()' is called.

Acked-by: Ying Xue <ying.xue@windreiver.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6a2fa13312e5 ("tipc: Fix use-after-free of kernel socket in cleanup_bearer().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bearer.c | 14 +++++++++++++-
 net/tipc/bearer.h |  3 +++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index dc5c6b1e97910..fc0b787fb9286 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -334,6 +334,7 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 	b->net_plane = bearer_id + 'A';
 	b->priority = prio;
 	test_and_set_bit_lock(0, &b->up);
+	refcount_set(&b->refcnt, 1);
 
 	res = tipc_disc_create(net, b, &b->bcast_addr, &skb);
 	if (res) {
@@ -371,6 +372,17 @@ static int tipc_reset_bearer(struct net *net, struct tipc_bearer *b)
 	return 0;
 }
 
+bool tipc_bearer_hold(struct tipc_bearer *b)
+{
+	return (b && refcount_inc_not_zero(&b->refcnt));
+}
+
+void tipc_bearer_put(struct tipc_bearer *b)
+{
+	if (b && refcount_dec_and_test(&b->refcnt))
+		kfree_rcu(b, rcu);
+}
+
 /**
  * bearer_disable
  *
@@ -389,7 +401,7 @@ static void bearer_disable(struct net *net, struct tipc_bearer *b)
 	if (b->disc)
 		tipc_disc_delete(b->disc);
 	RCU_INIT_POINTER(tn->bearer_list[bearer_id], NULL);
-	kfree_rcu(b, rcu);
+	tipc_bearer_put(b);
 	tipc_mon_delete(net, bearer_id);
 }
 
diff --git a/net/tipc/bearer.h b/net/tipc/bearer.h
index ea0f3c49cbedb..faca696d422ff 100644
--- a/net/tipc/bearer.h
+++ b/net/tipc/bearer.h
@@ -165,6 +165,7 @@ struct tipc_bearer {
 	struct tipc_discoverer *disc;
 	char net_plane;
 	unsigned long up;
+	refcount_t refcnt;
 };
 
 struct tipc_bearer_names {
@@ -210,6 +211,8 @@ int tipc_media_set_window(const char *name, u32 new_value);
 int tipc_media_addr_printf(char *buf, int len, struct tipc_media_addr *a);
 int tipc_enable_l2_media(struct net *net, struct tipc_bearer *b,
 			 struct nlattr *attrs[]);
+bool tipc_bearer_hold(struct tipc_bearer *b);
+void tipc_bearer_put(struct tipc_bearer *b);
 void tipc_disable_l2_media(struct tipc_bearer *b);
 int tipc_l2_send_msg(struct net *net, struct sk_buff *buf,
 		     struct tipc_bearer *b, struct tipc_media_addr *dest);
-- 
2.43.0



