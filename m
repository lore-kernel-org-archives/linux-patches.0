Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215052;
	b=4UarI0duUgUyY4kShKnSlsjWup7ELEC35sJNqC3LsKVRnOvViaMVxG/rmAguQLWGEEcS
	 c2dXkpE3L33ky6Vw1vrgt5aViJy7IrAOAFqhOlxgCQUR2qZ6426xyASk+ZTMCYo5OtP9G
	 0GS/hE4Z/g34k3mGlThnw3gCD+cWfGjzA5J21+I63+YhgLP/1V4F8g71UetY3Gf5JjaCM
	 HPnLBoa1xypBCzjzhE6EtFdMTiJgkUeUEFtPuilsDijiy8GU69lVj+E6Bnm/VxdI9xHPY
	 MulkndkVEHPZaCMCymH3FWVEjzjaeq63D5VAc5ntbiwa7UJIM0+3H3t3DSjXYRp4FoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4F9axttJ8UFHjOk1K/QBEySeHgt1yqMWWN2wRc1BVQc=;
	b=JZ3hNwfx3i+O8tABHbyaMKLduFJJj9HDbzjaFMWA1vr7W66ew7Uh+i3vDZEjowtkvvO0
	 d7afAfxgaBDKLboQ09XAVovD3IFLgGXmaLTqYsGmSdqYB7VZ/83lpc1CD0v/9T0RegkZh
	 OovqVq3rxTIsrSNv7bI+XJcgDwwGLTkFnzACp2dGVqrYavdoysLzWUEmhbP3fHO/pTLI1
	 RLXxPBDpAyL9E1/6Bf7jR2X66W37hZNXpLBEf/wIsfYn15gSjEmqbXyOXdfkLgTsPziAk
	 G9yG7lQgWNF5cTgvStJWUOcJiXi4enJ+i8H/FzUz7QdCvIJJU4qFA7gHvu5DMfQhUtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2OBPRrPL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEC3606A31E;
	Wed, 28 Oct 2026 19:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2OBPRrPL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D091F01825;
	Wed, 28 Oct 2026 19:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215051;
	bh=4F9axttJ8UFHjOk1K/QBEySeHgt1yqMWWN2wRc1BVQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2OBPRrPLTifDIL3DMOloQqv6Zi4BdbWHoIRlOLZ7KDDRB7BplXfB385DOss4Acq9p
	 ZppI9tnxoHRMEhF4xaUlHscPzigMD5/85syqff3r7rSg74qJ5y3bskJNf6GmirEJqA
	 zthQFoGFsJDu/jjxESCDcEVp1ZoJFkWQPuIRVxTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Yin <yinxin.x@bytedance.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1074/1887] fsnotify: fix inode reference leak in fsnotify_recalc_mask()
Date: Wed, 28 Oct 2026 17:52:50 +0100
Message-ID: <20261028170523.849628697@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 4aca914ac152f5d055ddcb36704d1e539ac08977 ]

fsnotify_recalc_mask() fails to handle the return value of
__fsnotify_recalc_mask(), which may return an inode pointer that needs
to be released via fsnotify_drop_object() when the connector's HAS_IREF
flag transitions from set to cleared.

This manifests as a hung task with the following call trace:

  INFO: task umount:1234 blocked for more than 120 seconds.
  Call Trace:
   __schedule
   schedule
   fsnotify_sb_delete
   generic_shutdown_super
   kill_anon_super
   cleanup_mnt
   task_work_run
   do_exit
   do_group_exit

The race window that triggers the iref leak:

  Thread A (adding mark)              Thread B (removing mark)
  ──────────────────────              ────────────────────────
  fsnotify_add_mark_locked():
    fsnotify_add_mark_list():
      spin_lock(conn->lock)
      add mark_B(evictable) to list
      spin_unlock(conn->lock)
    return

    /* ---- gap: no lock held ---- */

                                      fsnotify_detach_mark(mark_A):
                                        spin_lock(mark_A->lock)
                                        clear ATTACHED flag on mark_A
                                        spin_unlock(mark_A->lock)
                                        fsnotify_put_mark(mark_A)

    fsnotify_recalc_mask():
      spin_lock(conn->lock)
      __fsnotify_recalc_mask():
        /* mark_A skipped: ATTACHED cleared */
        /* only mark_B(evictable) remains */
        want_iref = false
        has_iref = true  /* not yet cleared */
        -> HAS_IREF transitions true -> false
        -> returns inode pointer
      spin_unlock(conn->lock)
      /* BUG: return value discarded!
       * iput() and fsnotify_put_sb_watched_objects()
       * are never called */

Fix this by deferring the transition true -> false of HAS_IREF flag from
fsnotify_recalc_mask() (Thread A) to fsnotify_put_mark() (thread B).

Fixes: c3638b5b1374 ("fsnotify: allow adding an inode mark without pinning inode")
Signed-off-by: Xin Yin <yinxin.x@bytedance.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/CAOQ4uxiPsbHb0o5voUKyPFMvBsDkG914FYDcs4C5UpBMNm0Vcg@mail.gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/mark.c | 39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index b419a5ccf192d..951d7de29f824 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -153,7 +153,12 @@ static struct inode *fsnotify_update_iref(struct fsnotify_mark_connector *conn,
 	return inode;
 }
 
-static void *__fsnotify_recalc_mask(struct fsnotify_mark_connector *conn)
+/*
+ * Calculate mask of events for a list of marks.
+ *
+ * Return true if any of the attached marks want to hold an inode reference.
+ */
+static bool __fsnotify_recalc_mask(struct fsnotify_mark_connector *conn)
 {
 	u32 new_mask = 0;
 	bool want_iref = false;
@@ -173,6 +178,34 @@ static void *__fsnotify_recalc_mask(struct fsnotify_mark_connector *conn)
 	}
 	*fsnotify_conn_mask_p(conn) = new_mask;
 
+	return want_iref;
+}
+
+/*
+ * Calculate mask of events for a list of marks after attach/modify mark
+ * and get an inode reference for the connector if needed.
+ *
+ * A concurrent add of evictable mark and detach of non-evictable mark can
+ * lead to __fsnotify_recalc_mask() returning false want_iref, but in this
+ * case we defer clearing iref to fsnotify_recalc_mask_clear_iref() called
+ * from fsnotify_put_mark().
+ */
+static void fsnotify_recalc_mask_set_iref(struct fsnotify_mark_connector *conn)
+{
+	bool has_iref = conn->flags & FSNOTIFY_CONN_FLAG_HAS_IREF;
+	bool want_iref = __fsnotify_recalc_mask(conn) || has_iref;
+
+	(void) fsnotify_update_iref(conn, want_iref);
+}
+
+/*
+ * Calculate mask of events for a list of marks after detach mark
+ * and return the inode object if its reference is no longer needed.
+ */
+static void *fsnotify_recalc_mask_clear_iref(struct fsnotify_mark_connector *conn)
+{
+	bool want_iref = __fsnotify_recalc_mask(conn);
+
 	return fsnotify_update_iref(conn, want_iref);
 }
 
@@ -209,7 +242,7 @@ void fsnotify_recalc_mask(struct fsnotify_mark_connector *conn)
 
 	spin_lock(&conn->lock);
 	update_children = !fsnotify_conn_watches_children(conn);
-	__fsnotify_recalc_mask(conn);
+	fsnotify_recalc_mask_set_iref(conn);
 	update_children &= fsnotify_conn_watches_children(conn);
 	spin_unlock(&conn->lock);
 	/*
@@ -342,7 +375,7 @@ void fsnotify_put_mark(struct fsnotify_mark *mark)
 		objp = fsnotify_detach_connector_from_object(conn, &type);
 		free_conn = true;
 	} else {
-		objp = __fsnotify_recalc_mask(conn);
+		objp = fsnotify_recalc_mask_clear_iref(conn);
 		type = conn->type;
 	}
 	WRITE_ONCE(mark->connector, NULL);
-- 
2.53.0



