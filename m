Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66462FE597;
	Tue, 12 Aug 2025 18:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025040; cv=none; b=YxKcDqxiVjns4Rymk5jXkRxXNU7xsTqt4J7MC8gcMRrz8MtiQ3pFeHCFU+jl/eErJvsnRKAtHXJyfFUlRAjkjPebITWOdL6efHepK+VlxgftKXRA6ENhn3slEK84Vche4dndFjxpV/Mz+Xeat0PmO6FSAo02X69h5ywN/bfpC0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025040; c=relaxed/simple;
	bh=broWWSm0zW3dvkne8bNcoRE2gkx7Wu/l+WjQ/YMDex0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbvWsSnR8rUGWHGWXbQWAqa5DQByU6gNuzxuqJExlSljk0jQYq6320q4zggBB7kMz9NRo6tTN0qRGJBMKsFxgbV9L3IGcgfeVQSLIGCWyBoE+57UywxafFwrxQXP+TIbtBZ2yYLRcFY06yydGyUG3OVCG5LZ+RYrcbqtE7jevKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IooRq/xx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IooRq/xx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4553EC4CEF0;
	Tue, 12 Aug 2025 18:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025040;
	bh=broWWSm0zW3dvkne8bNcoRE2gkx7Wu/l+WjQ/YMDex0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IooRq/xxUjR1RCCrS0H4UrVfccvtnt4JqdAMs5jdQcjlS+4S8wcmzi/S5Rsh47HZ+
	 qPVh3GVgSTzvY6Gg3k8HYaug0+feQI9Tk0Q7MPMfCNy80nMvw0p3QXj6JD4ZB5WNCN
	 ZEJcb/AjmwnYnhLAmaWnr21ylK6/0OAkk0o0clZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 552/627] NFS/localio: nfs_uuid_put() fix races with nfs_open/close_local_fh()
Date: Tue, 12 Aug 2025 19:34:07 +0200
Message-ID: <20250812173452.902492787@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit fdd015de767977f21892329af5e12276eb80375f ]

In order for the wait in nfs_uuid_put() to be safe, it is necessary to
ensure that nfs_uuid_add_file() doesn't add a new entry once the
nfs_uuid->net has been NULLed out.

Also fix up the wake_up_var_locked() / wait_var_event_spinlock() to both
use the nfs_uuid address, since nfl, and &nfl->uuid could be used elsewhere.

Acked-by: Mike Snitzer <snitzer@kernel.org>
Tested-by: Mike Snitzer <snitzer@kernel.org>
Link: https://lore.kernel.org/all/175262893035.2234665.1735173020338594784@noble.neil.brown.name/
Fixes: 21fb44034695 ("nfs_localio: protect race between nfs_uuid_put() and nfs_close_local_fh()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs_common/nfslocalio.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/nfs_common/nfslocalio.c b/fs/nfs_common/nfslocalio.c
index 64949c46c174..f1f1592ac134 100644
--- a/fs/nfs_common/nfslocalio.c
+++ b/fs/nfs_common/nfslocalio.c
@@ -177,7 +177,7 @@ static bool nfs_uuid_put(nfs_uuid_t *nfs_uuid)
 			/* nfs_close_local_fh() is doing the
 			 * close and we must wait. until it unlinks
 			 */
-			wait_var_event_spinlock(nfl,
+			wait_var_event_spinlock(nfs_uuid,
 						list_first_entry_or_null(
 							&nfs_uuid->files,
 							struct nfs_file_localio,
@@ -243,15 +243,20 @@ void nfs_localio_invalidate_clients(struct list_head *nn_local_clients,
 }
 EXPORT_SYMBOL_GPL(nfs_localio_invalidate_clients);
 
-static void nfs_uuid_add_file(nfs_uuid_t *nfs_uuid, struct nfs_file_localio *nfl)
+static int nfs_uuid_add_file(nfs_uuid_t *nfs_uuid, struct nfs_file_localio *nfl)
 {
+	int ret = 0;
+
 	/* Add nfl to nfs_uuid->files if it isn't already */
 	spin_lock(&nfs_uuid->lock);
-	if (list_empty(&nfl->list)) {
+	if (rcu_access_pointer(nfs_uuid->net) == NULL) {
+		ret = -ENXIO;
+	} else if (list_empty(&nfl->list)) {
 		rcu_assign_pointer(nfl->nfs_uuid, nfs_uuid);
 		list_add_tail(&nfl->list, &nfs_uuid->files);
 	}
 	spin_unlock(&nfs_uuid->lock);
+	return ret;
 }
 
 /*
@@ -285,11 +290,13 @@ struct nfsd_file *nfs_open_local_fh(nfs_uuid_t *uuid,
 	}
 	rcu_read_unlock();
 	/* We have an implied reference to net thanks to nfsd_net_try_get */
-	localio = nfs_to->nfsd_open_local_fh(net, uuid->dom, rpc_clnt,
-					     cred, nfs_fh, pnf, fmode);
+	localio = nfs_to->nfsd_open_local_fh(net, uuid->dom, rpc_clnt, cred,
+					     nfs_fh, pnf, fmode);
+	if (!IS_ERR(localio) && nfs_uuid_add_file(uuid, nfl) < 0) {
+		/* Delete the cached file when racing with nfs_uuid_put() */
+		nfs_to_nfsd_file_put_local(pnf);
+	}
 	nfs_to_nfsd_net_put(net);
-	if (!IS_ERR(localio))
-		nfs_uuid_add_file(uuid, nfl);
 
 	return localio;
 }
@@ -338,7 +345,7 @@ void nfs_close_local_fh(struct nfs_file_localio *nfl)
 	 */
 	spin_lock(&nfs_uuid->lock);
 	list_del_init(&nfl->list);
-	wake_up_var_locked(&nfl->nfs_uuid, &nfs_uuid->lock);
+	wake_up_var_locked(nfs_uuid, &nfs_uuid->lock);
 	spin_unlock(&nfs_uuid->lock);
 }
 EXPORT_SYMBOL_GPL(nfs_close_local_fh);
-- 
2.39.5



