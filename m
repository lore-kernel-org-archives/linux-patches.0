Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5421AA1F4;
	Fri,  4 Sep 2026 05:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498881; cv=none; b=FlX9JSnzSOg0XuyrhDamVbv/JMQPEQTXdFL/WM7Jbny50HBx7uWT+KxS12L7iETGyyDgP5Qp+Jqk7gssnh8RdW0oFxY6sW2MhG1qygpeYL6U8PTb6jOiJP3Ykm7HLVGQfy78iZcKlk8LNEQJl9uZ3DhGqhV3AaMhwrNSwjOYUd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498881; c=relaxed/simple;
	bh=06lw379w0TKu7SF7iEy9jEzg5ZSmkn7TcO7niw2wHJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0bkHWAQoHZbgfP5P38mWHJ8Bm9lh7ye7Koybt4Qm86vXxEChXIy2ZSDHNJmfmxYnI3zSnhYpoaQaAAPOiMUyT5yOtbRTiQMcXPrTdl8a8y4PDDyykGpEIG2WpSv8vJYIrrD3WeWPie80TXk9401WlaRsTosQ6ocIC7z2Qo39OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTpzU9Nl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTpzU9Nl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD8A1F00A3D;
	Fri,  4 Sep 2026 05:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498879;
	bh=LAAxFV0RcW28g96IkeTHRSESRPGLSPcQGcO6Aaw8nO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTpzU9Nlb5vb9pfr0BnB1lA0FhAT9mBSWIMtRT4ZO1oE6gVmqoqItbGv22xjYTaLX
	 0ADftnmGBh0tnhT6ELEZOBNRJhcypRJ3FqUX25ulwHSrPOZMk+kswGEIJvsWyfWQXo
	 fylh+HKYSM5uvMTH4l/YR3/0ZEtdjdjJSKWdptKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 176/713] nfsd: fix BUG_ON in nfsd4_alloc_layout_stateid on racing delegation revoke
Date: Fri,  4 Sep 2026 06:52:24 +0200
Message-ID: <20260904045807.763308335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit ca94ba36172046be6a694a7986f6931e47ed4d51 upstream.

nfsd4_alloc_layout_stateid reads fp->fi_deleg_file without holding
fi_lock when the parent stateid is a delegation. A concurrent delegation
revoke via the laundromat can clear fi_deleg_file under fi_lock, causing
nfsd_file_get() to return NULL and triggering the BUG_ON.

This race is client-reachable: two NFS clients can trigger it by having
one hold a delegation while another opens the same file to force a
recall. When the first client doesn't respond to the recall, the
laundromat revokes it. A concurrent LAYOUTGET from any client using the
delegation stateid hits the race window.

Fix this by taking fi_lock around the fi_deleg_file read in the
SC_TYPE_DELEG path, matching the locking discipline of the
find_any_file() arm, and replacing the BUG_ON with a graceful error
return that cleans up the partially-initialized layout stateid.

Fixes: c5c707f96fc9 ("nfsd: implement pNFS layout recalls")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260530-nfsd-fixes-v2-1-f27e8eb4d974@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4layouts.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -247,11 +247,17 @@ nfsd4_alloc_layout_stateid(struct nfsd4_
 	nfsd4_init_cb(&ls->ls_recall, clp, &nfsd4_cb_layout_ops,
 			NFSPROC4_CLNT_CB_LAYOUT);
 
-	if (parent->sc_type == SC_TYPE_DELEG)
+	if (parent->sc_type == SC_TYPE_DELEG) {
+		spin_lock(&fp->fi_lock);
 		ls->ls_file = nfsd_file_get(fp->fi_deleg_file);
-	else
+		spin_unlock(&fp->fi_lock);
+	} else {
 		ls->ls_file = find_any_file(fp);
-	BUG_ON(!ls->ls_file);
+	}
+	if (!ls->ls_file) {
+		nfs4_put_stid(stp);
+		return NULL;
+	}
 
 	ls->ls_fenced = false;
 	ls->ls_fence_delay = 0;


