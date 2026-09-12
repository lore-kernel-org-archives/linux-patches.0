Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57664344DBD;
	Sat, 12 Sep 2026 17:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232735; cv=none; b=q1cKugsPhJeA+VoeJGWSe1+0gYXoUdv8yuQQrxx2KYJv+Napoz+rLzraxMB+WFJfL10p4N6js2XA9F4fKJdjWqiVtn+0SchqRM133T9u8K64s/JttDnP9+4SABmaAyTwMlYBbAN+lnTUQ6xS8nq72ljCh0URHwrJaALALnMutns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232735; c=relaxed/simple;
	bh=5a0Fra/WMF0ldQDjd0cVKARym+32qRkQxj8PzyJ/Inw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDL6IlSBIPx0XoirLABGPjFKwJtAy61/F6dcqseFjGIIxWaMFDgsN8jW6T9qvodhWbQ7UV4Ev8wnXo5rvEuZWkk3yPLX/BehNoE+xfE4lsciAJlrYelGhZHl3+LU3J1Ai0AtevtSjTng3G47p6woG64+gQRYSX2hkXN71Cfd46U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNOvQwKU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNOvQwKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AEB1F000FF;
	Sat, 12 Sep 2026 17:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232733;
	bh=6SEZs7dfirqiJ+G2FpKtL7t1sKG+1NWjosGZ40faNUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNOvQwKUPlKZu17DQ1WRmVvysRylVxXGFtM8An9JC0ElPXjBz3Z9OTvVTi2ifom+9
	 /X7/1XC+udMl/m5cH/8RkJJZkQpulEjsCuPwCAqCgOmWE1v4KIxap5/3gCHfys7eS4
	 6EmgQXOvqrF2SN1F8/fZi1fdAW34P8+bYn+aPsRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 033/935] NFSD: restart ssc_expire_umount walk after dropping nfsd_ssc_lock
Date: Sat, 12 Sep 2026 08:51:03 +0200
Message-ID: <20260912065527.598975013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6018,30 +6018,36 @@ static void nfsd4_ssc_shutdown_umount(st
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


