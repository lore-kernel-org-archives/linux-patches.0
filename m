Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9973DA7D3;
	Wed, 30 Sep 2026 19:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795837; cv=none; b=JxPH2V8NCQrfI1w6BVzIquM4G/wg50CuU9iVU6ViQXAp99hBhixIusZO+jTJ9MYXq6/K4Pi+wS+dLY0vzmDHdet/5T/OUkSe0G1iALRAI3FQb847IsAaLS9e11Z2Bc4iXp1KqEbvp/je5gA5GX2ToHYy6UWCGxNlzXusW7FHsGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795837; c=relaxed/simple;
	bh=4plE8jVH+9GcQe01JT8cb75xY851hNK+B21IUDvDbIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBsdknt8FbUzlBp6fecACfnYsNZ1YI//gv24Os5B1NPDwzUDXEFcc10mJHCX8zJLHlIjknsDCrEFbkUTALgenTVl/uoByzPHVMQEPPJwTX/W7npY8hxJqrid6XrrqIDEbtDOSLFJHWzWFm7YFbcMPdwvRSr0TX2HHGGeifyPKXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swE8q5Wy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swE8q5Wy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933BD1F000FF;
	Wed, 30 Sep 2026 19:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795836;
	bh=yfjLro7ySMAksTVo58fhxtg+jSvCUvPy+cH/Q0U4vu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=swE8q5WyanyMZ7L0dtKYa58v+6wO99sceraMJ61V5ZQUT51zpxXhWnArlFd7ETn3c
	 ycFqc50+11iwJDuDVfq7dhx59ydDpGC/WmDk+86NT0Wtcr0NmdhNNQABFhFpN8ggoM
	 QwEx2VvnaBPKy8O9wqEi8xvyhld9bLPuf7TMD1Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.6 0664/1193] smb: client: pin DFS superblock in iterator callback
Date: Wed, 30 Sep 2026 17:22:28 +0200
Message-ID: <20260930152448.990137033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -1269,8 +1269,14 @@ static void tcon_super_cb(struct super_b
 	if (t1->ses == t2->ses &&
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
 
@@ -1287,15 +1293,8 @@ static struct super_block *__cifs_get_su
 
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


