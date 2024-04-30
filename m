Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B5E12C54B;
	Tue, 30 Apr 2024 11:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475091; cv=none; b=BqWUIEA3U5psplgDjvfr2OC/3fEj5N6W8KQKkZvsZAE5WGuYQt+ieRw2niG9eLxJbEZagEBRwQ66LXDUUU5QRX+D15CqV01w0tEOymo4LlmSphCyyJ/7rUz6r6AA9ARorR+7GzW7SUFaKsHytGba37iau5t2C6zMCKZNZkET9Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475091; c=relaxed/simple;
	bh=MPoQHONkmhQDhC0lzVf9jz8yAaKZHxfGMKNV3ib36CQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ralKzBvn5Yq6ABRjY7n9+WNVwv3F0ANasCnschzFcZcI3AZM/mpGcttHds1GG/iK5++sDi/G08iVWLVFm5a3Y5TfLPPaGQ6y3MPOXeZvL+yCyt63yUOuhlRuY8HvhOXWHWndN+3W/F0bQXtRst3obtnlo4GS8s9eZuQ/20XyLsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mdrdoevw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mdrdoevw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAEEC2BBFC;
	Tue, 30 Apr 2024 11:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475091;
	bh=MPoQHONkmhQDhC0lzVf9jz8yAaKZHxfGMKNV3ib36CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mdrdoevw8jLx0CehP8fWHUvCaknrayCU/PhcFb8oiyJ5l+ypACjgYL5YeIehsl2iS
	 UBpxIXCvabFd2Ui9ciUF7kTp4prJKeAO/QrS+D8+EDYQzyQwpE8HRX74IST4zSMPFe
	 Of8wY8dclnOMXbaOhxklQL/lmrV8mEwdq7fUJyFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/138] net: gtp: Fix Use-After-Free in gtp_dellink
Date: Tue, 30 Apr 2024 12:39:35 +0200
Message-ID: <20240430103052.069580012@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4e19760cddefe..c8246363d3832 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -700,11 +700,12 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
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



