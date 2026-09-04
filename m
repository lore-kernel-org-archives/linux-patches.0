Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9012AD37;
	Fri,  4 Sep 2026 05:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500576; cv=none; b=MP9oU92KnY3Co4EngnHSoAzDvEjCYGwXbWC74JTe/FaL9VXYz+FuR9R/TyPfBh7Lc5cry3Duok5tGrvD3WdpdBjT5ofIa+iuwDtSvzyaqe9rw7I/w19EVmJIcjegNkGf/WnxqU9s6p7CgUf2i+RsJIMjECA661I2IXo7mnYV91E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500576; c=relaxed/simple;
	bh=fB/b9xM2Vi0LWlEst0xNo1lXvwtvjWLO4iHF1xhUKdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgjJuB8AXj4DY5QYV54gw2RoL8TEwPKD9P4wVic+0yjohvM/nzZ93X+/2zuz+EZ+B0lRjvnlKBRAJ45qQTozs9b90nJ04XmPR/NO7Gz6phu9Lt8ig08hs4LntUPut46BYbGgUDU5zf98GvEvf4b9ZCjyG/azL3tNQfuJyWtG2VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKdpKrg4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKdpKrg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DFC1F00A3D;
	Fri,  4 Sep 2026 05:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500575;
	bh=9Zq02yBkhXfFaNpI0b+TRM0Am6XZIi4Vz/iVFG362mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IKdpKrg4Re/cJwoYMGbv0Jr43WKe5zFDjkG+VlfUi4xLZ0crm5ZQFKxgZyViYdWiA
	 aMlxpAiiAZ/lenNRlNIfqyF1U138MBVY78AhiK7ogdceeqXz15BgTA42P4ZhCOCnlu
	 vRxTonwW3O6JyxBdk0ZK5lvDcqaMfv7jX7HpTiOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 104/552] nfsd: guard nfsd_serv deref in nfsd_file_net_dispose
Date: Fri,  4 Sep 2026 06:54:21 +0200
Message-ID: <20260904045750.262491031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

commit 9f1ddfc8cb9076592401a611eb3a44d36186d014 upstream.

nfsd_file_net_dispose() is the consumer side of l->freeme: the nfsd
service thread loop calls it to drain entries that the filecache
garbage collector and shrinker append via
nfsd_file_dispose_list_delayed().  During per-net teardown,
nn->nfsd_serv is cleared before the filecache laundrette is shut
down, so the service thread can still run a dispose pass that finds
more than eight entries on l->freeme and dereferences a NULL
svc_serv:

    nfsd service thread loop
      nfsd_file_net_dispose(nn)
        if (!list_empty(&l->freeme)) {
            ...
            svc_wake_up(nn->nfsd_serv);   /* nn->nfsd_serv == NULL */
        }

The sibling helper nfsd_file_dispose_list_delayed() already documents
this ordering and caches nn->nfsd_serv into a local before testing it
for NULL.  nfsd_file_net_dispose() was introduced with the same raw
svc_wake_up(nn->nfsd_serv) call and never picked up the guard.

Fix by loading nn->nfsd_serv into a local svc_serv pointer and only
calling svc_wake_up() when it is non-NULL, matching the pattern in
nfsd_file_dispose_list_delayed().

Fixes: ffb402596147 ("nfsd: Don't leave work of closing files to a work queue")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20260602-nfsd-testing-v2-4-e4ea62e3cd5c@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/filecache.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -471,11 +471,20 @@ void nfsd_file_net_dispose(struct nfsd_n
 		for (i = 0; i < 8 && !list_empty(&l->freeme); i++)
 			list_move(l->freeme.next, &dispose);
 		spin_unlock(&l->lock);
-		if (!list_empty(&l->freeme))
-			/* Wake up another thread to share the work
+		if (!list_empty(&l->freeme)) {
+			/*
+			 * Wake up another thread to share the work
 			 * *before* doing any actual disposing.
+			 *
+			 * The filecache laundrette is shut down after
+			 * the nn->nfsd_serv pointer is cleared, but
+			 * before the svc_serv is freed.
 			 */
-			svc_wake_up(nn->nfsd_serv);
+			struct svc_serv *serv = nn->nfsd_serv;
+
+			if (serv)
+				svc_wake_up(serv);
+		}
 		nfsd_file_dispose_list(&dispose);
 	}
 }


