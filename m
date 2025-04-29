Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D430021ABDB;
	Tue, 29 Apr 2025 17:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947160; cv=none; b=hAdzOqoQe8B7xP5tcOO/Kee+QhH8V/16ZZyyfsUJ2p0vBetl4LfPeCKyfHXonTpgt/+EuVvPRvrECS21MzWtw4Ol++VpBF0vLdbFYnXjdbd3yFi23LC0rMG5GcjvxZx+htyfj8pgGwqyUiD/AQKO7GNUjzQ6mUfdmCp7d/ty1QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947160; c=relaxed/simple;
	bh=CrSGKe/4Axv7rv687199w4VJFUaN6Ngh5JNHZYI50vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dASt9BlmkKN6nKIO98ki85UxypzPKRC5dGIQgH36WYTX1j5i2PIv94OtxL5FhfjPnY9vCRldC9fRFHe1MtxpP+xsFN26y6diPJej5M1K1kR4SiFkgkKKPMvtFuSzQ92lbTzNd++CXnYg1F8ceVZ9+IsLbpHasPSAsD6ifqJelms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvxoehbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvxoehbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB095C4CEE3;
	Tue, 29 Apr 2025 17:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947160;
	bh=CrSGKe/4Axv7rv687199w4VJFUaN6Ngh5JNHZYI50vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvxoehbJjS8hXTCkSLfhjs6JvljAZlYlY4Q+TE5m/tyNSOxjbb7s9Kv/73eJ9sm+V
	 1NZire49U3T5Mzr4I+bmYKTcKgU2JU6KdeXxSjXir4g8R+R0OeTJZnYw2738JyMab0
	 +rnSMrhs6Em/5EBFnybmI8BTARpEGLUKXwrENUvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Cliff Liu <donghua.liu@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
Subject: [PATCH 5.10 164/286] smb: client: fix potential deadlock when releasing mids
Date: Tue, 29 Apr 2025 18:41:08 +0200
Message-ID: <20250429161114.630865036@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit e6322fd177c6885a21dd4609dc5e5c973d1a2eb7 upstream.

All release_mid() callers seem to hold a reference of @mid so there is
no need to call kref_put(&mid->refcount, __release_mid) under
@server->mid_lock spinlock.  If they don't, then an use-after-free bug
would have occurred anyways.

By getting rid of such spinlock also fixes a potential deadlock as
shown below

CPU 0                                CPU 1
------------------------------------------------------------------
cifs_demultiplex_thread()            cifs_debug_data_proc_show()
 release_mid()
  spin_lock(&server->mid_lock);
                                     spin_lock(&cifs_tcp_ses_lock)
				      spin_lock(&server->mid_lock)
  __release_mid()
   smb2_find_smb_tcon()
    spin_lock(&cifs_tcp_ses_lock) *deadlock*

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[cifs_mid_q_entry_release() is renamed to release_mid() and
 _cifs_mid_q_entry_release() is renamed to __release_mid() by
 commit 70f08f914a37 ("cifs: remove useless DeleteMidQEntry()")
 which is integrated into v6.0, so preserve old names in v5.10.]
Signed-off-by: Cliff Liu <donghua.liu@windriver.com>
Signed-off-by: He Zhe <Zhe.He@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsproto.h |    7 ++++++-
 fs/cifs/smb2misc.c  |    2 +-
 fs/cifs/transport.c |    9 +--------
 3 files changed, 8 insertions(+), 10 deletions(-)

--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -85,7 +85,7 @@ extern struct mid_q_entry *AllocMidQEntr
 					struct TCP_Server_Info *server);
 extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
 extern void cifs_delete_mid(struct mid_q_entry *mid);
-extern void cifs_mid_q_entry_release(struct mid_q_entry *midEntry);
+void _cifs_mid_q_entry_release(struct kref *refcount);
 extern void cifs_wake_up_task(struct mid_q_entry *mid);
 extern int cifs_handle_standard(struct TCP_Server_Info *server,
 				struct mid_q_entry *mid);
@@ -646,4 +646,9 @@ static inline int cifs_create_options(st
 		return options;
 }
 
+static inline void cifs_mid_q_entry_release(struct mid_q_entry *midEntry)
+{
+	kref_put(&midEntry->refcount, _cifs_mid_q_entry_release);
+}
+
 #endif			/* _CIFSPROTO_H */
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -780,7 +780,7 @@ __smb2_handle_cancelled_cmd(struct cifs_
 {
 	struct close_cancelled_open *cancelled;
 
-	cancelled = kzalloc(sizeof(*cancelled), GFP_ATOMIC);
+	cancelled = kzalloc(sizeof(*cancelled), GFP_KERNEL);
 	if (!cancelled)
 		return -ENOMEM;
 
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -88,7 +88,7 @@ AllocMidQEntry(const struct smb_hdr *smb
 	return temp;
 }
 
-static void _cifs_mid_q_entry_release(struct kref *refcount)
+void _cifs_mid_q_entry_release(struct kref *refcount)
 {
 	struct mid_q_entry *midEntry =
 			container_of(refcount, struct mid_q_entry, refcount);
@@ -168,13 +168,6 @@ static void _cifs_mid_q_entry_release(st
 	mempool_free(midEntry, cifs_mid_poolp);
 }
 
-void cifs_mid_q_entry_release(struct mid_q_entry *midEntry)
-{
-	spin_lock(&GlobalMid_Lock);
-	kref_put(&midEntry->refcount, _cifs_mid_q_entry_release);
-	spin_unlock(&GlobalMid_Lock);
-}
-
 void DeleteMidQEntry(struct mid_q_entry *midEntry)
 {
 	cifs_mid_q_entry_release(midEntry);


