Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E13D171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A724BC433EF;
	Mon, 22 May 2023 19:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785214;
	bh=T8Hdl8v6p0VVf0hlytspaifbqKPgigPQ7MHBSRIF2gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2DKHElrC1SkzGJk/TcbqpVWgcy7X2HZ5YRwnX9sqAvFkjxSKktUa9Mu8qc7Xxr3b
	 lTxxAhvKj+zPdIoQhQPq2QrDq3thc2qZxISddF2PgNhoIazS5NsOgSgYN+xuyRWnZq
	 5BKqj+d7ewF3H0EVOeI/wqYb9JWP1tzp0P0e4BTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.3 319/364] SMB3: Close all deferred handles of inode in case of handle lease break
Date: Mon, 22 May 2023 20:10:24 +0100
Message-Id: <20230522190420.751705519@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bharath SM <bharathsm@microsoft.com>

commit 47592fa8eb03742048b096b4696ec133384c45eb upstream.

Oplock break may occur for different file handle than the deferred
handle. Check for inode deferred closes list, if it's not empty then
close all the deferred handles of inode because we should not cache
handles if we dont have handle lease.

Eg: If openfilelist has one deferred file handle and another open file
handle from app for a same file, then on a lease break we choose the
first handle in openfile list. The first handle in list can be deferred
handle or actual open file handle from app. In case if it is actual open
handle then today, we don't close deferred handles if we lose handle lease
on a file. Problem with this is, later if app decides to close the existing
open handle then we still be caching deferred handles until deferred close
timeout. Leaving open handle may result in sharing violation when windows
client tries to open a file with limited file share access.

So we should check for deferred list of inode and walk through the list of
deferred files in inode and close all deferred files.

Fixes: 9e31678fb403 ("SMB3: fix lease break timeout when multiple deferred close handles for the same file.")
Cc: stable@kernel.org
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/file.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4882,8 +4882,6 @@ void cifs_oplock_break(struct work_struc
 	struct TCP_Server_Info *server = tcon->ses->server;
 	int rc = 0;
 	bool purge_cache = false;
-	struct cifs_deferred_close *dclose;
-	bool is_deferred = false;
 
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
@@ -4924,14 +4922,9 @@ oplock_break_ack:
 	 * file handles but cached, then schedule deferred close immediately.
 	 * So, new open will not use cached handle.
 	 */
-	spin_lock(&CIFS_I(inode)->deferred_lock);
-	is_deferred = cifs_is_deferred_close(cfile, &dclose);
-	spin_unlock(&CIFS_I(inode)->deferred_lock);
 
-	if (!CIFS_CACHE_HANDLE(cinode) && is_deferred &&
-			cfile->deferred_close_scheduled && delayed_work_pending(&cfile->deferred)) {
+	if (!CIFS_CACHE_HANDLE(cinode) && !list_empty(&cinode->deferred_closes))
 		cifs_close_deferred_file(cinode);
-	}
 
 	/*
 	 * releasing stale oplock after recent reconnect of smb session using


