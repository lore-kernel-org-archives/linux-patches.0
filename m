Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472B9171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A9DC433D2;
	Mon, 22 May 2023 19:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784073;
	bh=ekDKN2bTmYHv3j6isOwHAPkjjoGc6UUuYWF8zEHPMU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2aZveWObWKyW4K1TD8cDdxdMhNCmwS3ibS+oXt37fPONgRFlLmW5txbd86IVKN/H
	 /ecvakdQXUcmLliK/lcjOBszRbGWT86iZ1ZnCpnhxEhZ8Qd91mfd+W9VLQwkG30cEA
	 o/u8UjeGWHKo7R8vC03X1x8f7aZ6rY3Ktx561fLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 254/292] SMB3: Close all deferred handles of inode in case of handle lease break
Date: Mon, 22 May 2023 20:10:11 +0100
Message-Id: <20230522190412.296012607@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
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
@@ -5087,8 +5087,6 @@ void cifs_oplock_break(struct work_struc
 	struct TCP_Server_Info *server = tcon->ses->server;
 	int rc = 0;
 	bool purge_cache = false;
-	struct cifs_deferred_close *dclose;
-	bool is_deferred = false;
 
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
@@ -5129,14 +5127,9 @@ oplock_break_ack:
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


