Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2DD3BE64B;
	Wed, 20 May 2026 18:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301326; cv=none; b=eklS4KiyaO9+aXGE6bQAp8L7hk2nUlHTyLdBcLzExHMaiKJaLNajsonrPdUf5L4TXak1aE7TPxvRG2o2jScB9vuboX8ibYMdQrIukKcPTqNm4tWNEASnDwCcSwAN02ue44d+kPPPECNylK4KpMjq3b3xnXN0hE9DswP02Gxcxb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301326; c=relaxed/simple;
	bh=xRawu+E53Gc8ecBEaEcSJ5TE/4Y5yBlUoVEFOsBLhrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WVKCK9cPGOq1scyiyDb5luyG+x0Czb1MmZmJqNAkWg8tPj2Ery6qQjYEK0bINDic6nadYTso6LTsqGVrOHtHPvs1Kli+AyEmJRyVAXbw2Afd7Ll1Tl1GQU6sNGVWKjX5xby+UnR9zjK/h6KZWWnvRzvQno8n4VcRLVfnrCzZ5jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgnfBikV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgnfBikV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EB21F000E9;
	Wed, 20 May 2026 18:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301325;
	bh=bA58Mo56mZKrl5MrKCPxHhPFg5cxske1e+tXFdt5DXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hgnfBikVtFsvCbmO0u1mjS/zLlCYthCW2DJjqDoNaYqkJD/nRm0Wd8UdNpPWa0oRV
	 xSsMwd2PYSYETQ+aFBxir8Ew7oY1TZmsjJjB3Jx5lKhZW4F9OPPCYOOMJJi5xCPE3z
	 eJzxkyfPOq5QosBuGtdNRu0x/TsYGTYBUY+TSHg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Yin <yinxin.x@bytedance.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 511/666] fsnotify: fix inode reference leak in fsnotify_recalc_mask()
Date: Wed, 20 May 2026 18:22:02 +0200
Message-ID: <20260520162122.337740791@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 09e50fe5757c4..a263305ed7c85 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -233,7 +233,12 @@ static struct inode *fsnotify_update_iref(struct fsnotify_mark_connector *conn,
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
@@ -257,6 +262,34 @@ static void *__fsnotify_recalc_mask(struct fsnotify_mark_connector *conn)
 	 */
 	WRITE_ONCE(*fsnotify_conn_mask_p(conn), new_mask);
 
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
 
@@ -293,7 +326,7 @@ void fsnotify_recalc_mask(struct fsnotify_mark_connector *conn)
 
 	spin_lock(&conn->lock);
 	update_children = !fsnotify_conn_watches_children(conn);
-	__fsnotify_recalc_mask(conn);
+	fsnotify_recalc_mask_set_iref(conn);
 	update_children &= fsnotify_conn_watches_children(conn);
 	spin_unlock(&conn->lock);
 	/*
@@ -408,7 +441,7 @@ void fsnotify_put_mark(struct fsnotify_mark *mark)
 		/* Update watched objects after detaching mark */
 		if (sb)
 			fsnotify_update_sb_watchers(sb, conn);
-		objp = __fsnotify_recalc_mask(conn);
+		objp = fsnotify_recalc_mask_clear_iref(conn);
 		type = conn->type;
 	}
 	WRITE_ONCE(mark->connector, NULL);
-- 
2.53.0



