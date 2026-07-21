Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0273859EE;
	Tue, 21 Jul 2026 17:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656551; cv=none; b=Spp9X7mxxnwv5PU9y0vnxBgh3/Ixsr+UKxqoBGrcIfAWYsrfXBJ2xTugZlrp/5lSTN9SRH6otkhA4382UR+R6vIDTz78w6VApzlgCet/StLxnSJ93v+FEqLEwNNcSqqnG1m+0k6vP1aiWz1A5zCSV0JS4oIxWlpvEJwZHtwD/A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656551; c=relaxed/simple;
	bh=YW72PIfgr9Qz4/ARfTJWHMV+jnxGa3+8IOBtyDKatn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdOmEYMt8ZsKpDTY5bKPBTpdmM8NdnqYlB0DK15Uam841B6pUNZm4VlCOB3eZZtBx30ThQZJLJT2PGTKjQOsuoLyDwvQCFRksxpldy7uQ9TmvxSWXrlo8LVcNXBtSUF7pYxadXp9Gunwo3ONC4lie+dX2RlNU10u53WulzdyNqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Mq43ImZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Mq43ImZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D15E1F000E9;
	Tue, 21 Jul 2026 17:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656550;
	bh=f/CSsHjT/Tp8eO6GVsnkqWCdIYcbWmkjf7JijVKqw6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Mq43ImZXVqBEQg9qz64tBPUp9QTcr3IHfLXoLWRHXjs24J3YUMGFD8Oh+RTndRAn
	 31gLX1tU/eyKY1A0Y5qyqeCN1PSToq+b2YsknSux1KU9Ypcx4yU42M2+IaGyEZZrTv
	 0xPmWAYjWktmBQ/YYo41G/M89Oq3o/171iM63Bwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0431/1611] NFSD: Handle layout stid in nfsd4_drop_revoked_stid()
Date: Tue, 21 Jul 2026 17:09:07 +0200
Message-ID: <20260721152524.971877539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 86b9898920a6d02b4149f4fef9efd77b8aa3b9ca ]

nfsd4_drop_revoked_stid() has no SC_TYPE_LAYOUT case, so when a
client sends FREE_STATEID for an admin-revoked layout stid, the
default branch releases cl_lock and returns without unhashing or
releasing the stid.  The stid remains in the IDR and on the
per-client list until the client is destroyed.

Remove the layout stid from the per-client list and call
nfs4_put_stid() to drop the creation reference.  When the
refcount reaches zero, nfsd4_free_layout_stateid() handles the
remaining cleanup: cancelling the fence worker, removing from
the per-file list, and freeing the slab object.

Fixes: 1e33e1414bec ("nfsd: allow layout state to be admin-revoked.")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index efa7e103cf190f..c9d9a7d46e7b23 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5049,6 +5049,7 @@ static void nfsd4_drop_revoked_stid(struct nfs4_stid *s)
 {
 	struct nfs4_client *cl = s->sc_client;
 	LIST_HEAD(reaplist);
+	struct nfs4_layout_stateid *ls;
 	struct nfs4_ol_stateid *stp;
 	struct nfs4_delegation *dp;
 	bool unhashed;
@@ -5074,6 +5075,12 @@ static void nfsd4_drop_revoked_stid(struct nfs4_stid *s)
 		spin_unlock(&cl->cl_lock);
 		nfs4_put_stid(s);
 		break;
+	case SC_TYPE_LAYOUT:
+		ls = layoutstateid(s);
+		list_del_init(&ls->ls_perclnt);
+		spin_unlock(&cl->cl_lock);
+		nfs4_put_stid(s);
+		break;
 	default:
 		spin_unlock(&cl->cl_lock);
 	}
-- 
2.53.0



