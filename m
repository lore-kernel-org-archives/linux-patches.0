Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4EB4CCDC7;
	Fri,  4 Sep 2026 05:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500570; cv=none; b=OyLrs2bCE2xsgUIJLt+K2pC3FjBQyX/yWbpedIoVsltn0rfm5prFIqDPASeERHCLIE3wAdW5XCjTQQcyUF0jLOWWPzslP9GSJczMpiYXZZsKJ65C/2n0xO0rP47m4RI7HfMs3ONOVny0235lTYqqVktjkDoSxZLDfm4wuWkgJgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500570; c=relaxed/simple;
	bh=X+j6yCZSAZqBD2331D4HDe9OOskf4Q0APZKFLQTJP20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XX85D7/YXHZsTRHwojFcScmq2KU5L7QGs7S9DoQz83Tj+Sp1ArVOGE45/7141/B9vC0Ok4p8awUqwZ1wRee3HTp3Br+rjJBtDeTtVTcWmGl8LLlloaNQfNQ+cirlvZyS6IQjq2xim0FpEgTPtUEaG6TYN2x3xLVsz8ScqLfbl7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YF5iIntu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YF5iIntu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5241F00A3D;
	Fri,  4 Sep 2026 05:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500569;
	bh=qwoPnevh8SCdvur70zjvo9IJ4wSK13RfuzFUPk6Qw1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YF5iIntu2HaUCdoeJ2ociWjHRWRsNDLR6G1g1dyeDB7Sx97++UtTkajAeu3yd4pdi
	 PT6H+TTf0Pd3BHi58iRpZCw/4rhXjbQ2drANNIj/0vLQAubCbdyV3PzrTDj4wCPBzo
	 Ty3WL65nkzf3cw0fAIN1yH5B0RAudBfod911vCpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 102/552] NFSD: restart ssc_expire_umount walk after dropping nfsd_ssc_lock
Date: Fri,  4 Sep 2026 06:54:19 +0200
Message-ID: <20260904045750.218740942@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 036c1b182f4da65363e79ec0ac276edc6b7296e5 upstream.

nfsd4_ssc_expire_umount() walks nn->nfsd_ssc_mount_list with
list_for_each_entry_safe(ni, tmp, ...).  For each expired entry it
sets nsui_busy = true, drops nfsd_ssc_lock to run mntput() on the
source vfsmount, then reacquires the lock to list_del + kfree the
entry and continue iterating via the macro's saved tmp pointer.

The nsui_busy flag protects the current ni from concurrent
nfsd4_ssc_setup_dul() finders during the lock-drop window, but it
does not pin tmp.  Another nfsd RPC thread that fails its source-
server mount and reaches nfsd4_ssc_cancel_dul() will, during that
same window, take nfsd_ssc_lock, list_del + kfree its own ssc_umount
item, and release the lock.  If that item is the saved tmp of the
expire walk, the next iteration dereferences a freed
nfsd4_ssc_umount_item.

Restart the walk from the head after the mntput() unlock window so
no saved next pointer survives the lock-drop.  The list is bounded
by the number of active inter-server source mounts (typically small)
and the expire delayed-work runs periodically rather than per-IO,
so the restart is cheap.

Fixes: f4e44b393389 ("NFSD: delay unmount source's export after inter-server copy completed.")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260524130654.1924556-1-michael.bommarito@gmail.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6738,30 +6738,36 @@ static void nfsd4_ssc_shutdown_umount(st
 static void nfsd4_ssc_expire_umount(struct nfsd_net *nn)
 {
 	bool do_wakeup = false;
-	struct nfsd4_ssc_umount_item *ni = NULL;
-	struct nfsd4_ssc_umount_item *tmp;
+	struct nfsd4_ssc_umount_item *ni;
 
+restart:
 	spin_lock(&nn->nfsd_ssc_lock);
-	list_for_each_entry_safe(ni, tmp, &nn->nfsd_ssc_mount_list, nsui_list) {
-		if (time_after(jiffies, ni->nsui_expire)) {
-			if (refcount_read(&ni->nsui_refcnt) > 1)
-				continue;
+	list_for_each_entry(ni, &nn->nfsd_ssc_mount_list, nsui_list) {
+		if (!time_after(jiffies, ni->nsui_expire))
+			break;
+		if (refcount_read(&ni->nsui_refcnt) > 1)
+			continue;
 
-			/* mark being unmount */
-			ni->nsui_busy = true;
-			spin_unlock(&nn->nfsd_ssc_lock);
-			mntput(ni->nsui_vfsmount);
-			spin_lock(&nn->nfsd_ssc_lock);
+		/* Prevent concurrent setup during unmount */
+		ni->nsui_busy = true;
+		spin_unlock(&nn->nfsd_ssc_lock);
+		mntput(ni->nsui_vfsmount);
+		spin_lock(&nn->nfsd_ssc_lock);
 
-			/* waiters need to start from begin of list */
-			list_del(&ni->nsui_list);
-			kfree(ni);
+		/* Force concurrent scanners to restart */
+		list_del(&ni->nsui_list);
+		kfree(ni);
 
-			/* wakeup ssc_connect waiters */
-			do_wakeup = true;
-			continue;
-		}
-		break;
+		/* wakeup ssc_connect waiters */
+		do_wakeup = true;
+		/*
+		 * Concurrent nfsd4_ssc_cancel_dul() can free any item
+		 * on the list under nfsd_ssc_lock while mntput() runs
+		 * above.  Restart from the head; the list is short and
+		 * the expire worker is periodic, so this is cheap.
+		 */
+		spin_unlock(&nn->nfsd_ssc_lock);
+		goto restart;
 	}
 	if (do_wakeup)
 		wake_up_all(&nn->nfsd_ssc_waitq);


