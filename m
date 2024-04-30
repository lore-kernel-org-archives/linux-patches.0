Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1A412C499;
	Tue, 30 Apr 2024 10:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474151; cv=none; b=I9lCOIA1SwqwctDlGE7ctkhTP8FhD9UaBCAB1ytcSD5NehuGSOKdQy2rOMyb6Re7FsETF2p2BxoQZqPDNwSXZLrXy+BHKXhv7XRiUdsi9/fcdaojsNi4QVgeUfFo+4wFj0EsG03vn9Fzg/Y31WvTMAON1DTWOq1Rh0qX4eFJ9/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474151; c=relaxed/simple;
	bh=LFhbGN6rHKgeSKqARm/7QmM2Nb4rOedwtlUPIcCKXW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1i91T1Zf6vdDeua+cxvMd6zot9AGHmcsnj7EC7kh9Vlva3Dfr31b+JP03JGxf+hN9ZU7i3c+iFWjaAQok0mhhpUs53lwXEpQ+nbQVAq4JxCwn2ADliuG2zI5KoQM8KYNZpLNmMKCTO22uGOzDDJshSG5cjDfMzTZ2BTn6C0PmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQqQz+Uq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQqQz+Uq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A589C2BBFC;
	Tue, 30 Apr 2024 10:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474151;
	bh=LFhbGN6rHKgeSKqARm/7QmM2Nb4rOedwtlUPIcCKXW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQqQz+UqLWMGI/9UcgL+1s00oE7VNlKMPulm7tsDil7Trm1ahJoHtye6krEkVHGpn
	 +gOnUWHbmkejq+7U5qLALsLO7Q+cp3CpgHHfdcPFhgGh6mwX27IZzosrQYB7OEYdDs
	 Rk7U+j7pv3LCso+MVNCcfOaMNSRKdK6lb3LmmHfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 072/228] net: gtp: Fix Use-After-Free in gtp_dellink
Date: Tue, 30 Apr 2024 12:37:30 +0200
Message-ID: <20240430103105.884235950@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <v4bel@theori.io>

[ Upstream commit f2a904107ee2b647bb7794a1a82b67740d7c8a64 ]

Since call_rcu, which is called in the hlist_for_each_entry_rcu traversal
of gtp_dellink, is not part of the RCU read critical section, it
is possible that the RCU grace period will pass during the traversal and
the key will be free.

To prevent this, it should be changed to hlist_for_each_entry_safe.

Fixes: 94dc550a5062 ("gtp: fix an use-after-free in ipv4_pdp_find()")
Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 2b5357d94ff56..63f932256c9f5 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1111,11 +1111,12 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 static void gtp_dellink(struct net_device *dev, struct list_head *head)
 {
 	struct gtp_dev *gtp = netdev_priv(dev);
+	struct hlist_node *next;
 	struct pdp_ctx *pctx;
 	int i;
 
 	for (i = 0; i < gtp->hash_size; i++)
-		hlist_for_each_entry_rcu(pctx, &gtp->tid_hash[i], hlist_tid)
+		hlist_for_each_entry_safe(pctx, next, &gtp->tid_hash[i], hlist_tid)
 			pdp_context_delete(pctx);
 
 	list_del_rcu(&gtp->list);
-- 
2.43.0



