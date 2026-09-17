Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9EA2D7D47;
	Thu, 17 Sep 2026 18:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671173; cv=none; b=DKwyxvGGU+dJ6AUefo2MIPh+2KDMo7oHQIliuLduJJh32kAAiWW6pghqPvCcHS1252AwOhy+kL6IJudgOzWkYU+IhnpKlq/rA3Yp9uGJYRbHOQXqYJuVJS7yVSH4xbsPlrmH7FBDLNTEF3GCilxi+PoWt1838Sm+ijJFwUHfKo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671173; c=relaxed/simple;
	bh=C4BiTr7JwJDJemEubPe4s+KltF9Q0pOBJsOufqL6tp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ea0FT7sPuw4D2haH2CFtSmbY0LQKLSfvklA/NdDEeW6LGxAVkC9VaU7IaNJF2tHTgL8kpXHJ+nGDdO4cUtnS+WWWKxS8MkS2IKdSWcpeoBsnTY0cqzK1YdUVqj/BLVc9ggFKbgN6hHWYkwg/TKzMTX3vDt/z9+71OvwPYlSyBMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVOU0Iw2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVOU0Iw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A32D1F000FF;
	Thu, 17 Sep 2026 18:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671171;
	bh=tdBURXRsvpv4egY0JXtl+ljmB9dobYvicXEtiUTRk6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DVOU0Iw2xxb7e8tO4sR7leg/AHtbZNlte4V5TaikDN3pivgcLlz5ZOpQDP7BeHirT
	 +fUbP/rQ2SrrSAz4dVGLoZOfS/2516nKFj1xe9iVMFgip319jq43zjZTX/XZKCN2VW
	 NQP4OUVoYQGXXufVNVlKjt0D9Q6qOtE2du6Jv60c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 0890/1102] smb: client: pin DFS superblock in iterator callback
Date: Thu, 17 Sep 2026 16:13:53 +0100
Message-ID: <20260917151602.924589651@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

commit d806d5a85dcbe2a0f181b2f0f9f61ddfbefa1818 upstream.

tcon_super_cb() stores a raw superblock pointer, but __cifs_get_super()
takes its active reference only after iterate_supers_type() has dropped
s_umount and its passive reference. Concurrent DFS automount expiry can
therefore free the superblock before cifs_sb_active() uses it.

A deterministic KASAN test reproduces the race as:

  BUG: KASAN: slab-use-after-free in cifs_sb_active+0x77/0x80

The same test passes with this change applied.

Take the active reference in the callback while iterate_supers_type()
still holds s_umount shared. cifs_put_tcp_super() remains the matching
release.

Fixes: bacd704a95ad ("cifs: handle prefix paths in reconnect")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/misc.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1206,8 +1206,14 @@ static void tcon_super_cb(struct super_b
 	     t1->ses->dfs_root_ses == t2->ses->dfs_root_ses) &&
 	    t1->ses->server == t2->ses->server &&
 	    t2->origin_fullpath &&
-	    dfs_src_pathname_equal(t2->origin_fullpath, t1->origin_fullpath))
+	    dfs_src_pathname_equal(t2->origin_fullpath, t1->origin_fullpath)) {
+		/*
+		 * Take the active reference while iterate_supers_type() still
+		 * holds s_umount shared.
+		 */
+		cifs_sb_active(sb);
 		sd->sb = sb;
+	}
 	spin_unlock(&t2->tc_lock);
 }
 
@@ -1224,15 +1230,8 @@ static struct super_block *__cifs_get_su
 
 	for (; *fs_type; fs_type++) {
 		iterate_supers_type(*fs_type, f, &sd);
-		if (sd.sb) {
-			/*
-			 * Grab an active reference in order to prevent automounts (DFS links)
-			 * of expiring and then freeing up our cifs superblock pointer while
-			 * we're doing failover.
-			 */
-			cifs_sb_active(sd.sb);
+		if (sd.sb)
 			return sd.sb;
-		}
 	}
 	pr_warn_once("%s: could not find dfs superblock\n", __func__);
 	return ERR_PTR(-EINVAL);


