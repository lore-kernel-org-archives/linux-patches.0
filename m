Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E3B4F4CF3;
	Tue, 13 Oct 2026 12:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892941; cv=none; b=gwGENaI4dbnm9VK3w46qK2qlsqKr/WmgniTixc0hfBgYBBf96nIgfGYqFTFRr4r5vzTmRlnZ6U9i5XeviHo5e5s43SlZ0I5B4IGQ9PgZH2ydHAQfXHh/Nnlfvd8PQ9jYokH1Ia8Cv1BZbk0w/BFk95JGjm8VWkU8cSBtmyKZOVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892941; c=relaxed/simple;
	bh=4leYayuxS6A48ZhisD2TZyA0bcrAg+r12ZkV4moKO+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+kVSwTPNcyVlUgkpgR2QTmNR+ZKkWjLI/EU8fy0FLSLbKkZX20dxdWOuINda1a4mRhFazADgRCpuTSocPvol5PmBgInR86jHhe6lscOxFnbIz6lYIYMjfgUuI/EP9WxS4ZKpYKoyef1ciac8Dd4Z51/A4rjUtan6TTtxnsCpMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhbPJwVM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhbPJwVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6321F000FF;
	Tue, 13 Oct 2026 12:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892940;
	bh=4w7K5o2I/FoYNbuPQw85JGN+K0W3O4MGo/eAox/kkFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UhbPJwVMZ5M1U6W0tQlBleTj+CL6Q84IYdjsQZuv+ZDy0TnD6YsW+M1JbxQi8JVMT
	 I48sst/f/PQwpLmzl8iLRnBocZo6vZQNdwEWdDpJN7dwFBIFh39SZc0UfyFOzad8dI
	 Or7lPZgGzF5w0H9v9t5omXwjUXcEaigdYGuwwZj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Jordan Rhee <jordanrhee@google.com>,
	Joshua Washington <joshwash@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 057/621] gve: fix napi_disable deadlock when attempting to disable XSK pools
Date: Tue, 13 Oct 2026 13:30:52 +0200
Message-ID: <20261013112922.216648115@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Washington <joshwash@google.com>

commit 0cb6939a4dfefa822007b7a71986e06bc4f61f54 upstream.

When disabling XSK pools, GVE calls the unlocked versions of
napi_disable and napi_enable. However, the netdev lock has already been
acquired before ndo_bpf is called because GVE supports queue management
ops. Calling the unlocked versions of napi_disable/enable results in a
deadlock when attempting to disable XSK pools, as the thread attempts to
re-acquire a lock it already holds.

Update the NAPI calls to use the locked versions.

This issue was found in production.

Fixes: 606048cbd834 ("net: designate XSK pool pointers in queues as "ops protected"")
Cc: stable@vger.kernel.org
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Jordan Rhee <jordanrhee@google.com>
Signed-off-by: Joshua Washington <joshwash@google.com>
Link: https://patch.msgid.link/20260930214735.3288780-4-joshwash@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1663,17 +1663,17 @@ static int gve_xsk_pool_disable(struct n
 	}
 
 	napi_rx = &priv->ntfy_blocks[priv->rx[qid].ntfy_id].napi;
-	napi_disable(napi_rx); /* make sure current rx poll is done */
+	napi_disable_locked(napi_rx); /* make sure current rx poll is done */
 
 	tx_qid = gve_xdp_tx_queue_id(priv, qid);
 	napi_tx = &priv->ntfy_blocks[priv->tx[tx_qid].ntfy_id].napi;
-	napi_disable(napi_tx); /* make sure current tx poll is done */
+	napi_disable_locked(napi_tx); /* make sure current tx poll is done */
 
 	gve_unreg_xsk_pool(priv, qid);
 	smp_mb(); /* Make sure it is visible to the workers on datapath */
 
-	napi_enable(napi_rx);
-	napi_enable(napi_tx);
+	napi_enable_locked(napi_rx);
+	napi_enable_locked(napi_tx);
 	if (gve_is_gqi(priv)) {
 		if (gve_rx_work_pending(&priv->rx[qid]))
 			napi_schedule(napi_rx);


