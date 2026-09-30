Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479F850B8B1;
	Wed, 30 Sep 2026 16:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785684; cv=none; b=NPR+0Ovkx6srbagdJf84kxWpNo/OW3VQuj9tD2MHW6+3QHaP4vrEXYt2idVp68LNh68O6mwJHJFCWJ+aol0qelL0qmLw/R9rTw7ZPrpSksyOi/G1fn8P0Xd24jgv2krl0IcAthhtBoQRPq5Prl8g95SsK6X+j+GDmd383vvWbf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785684; c=relaxed/simple;
	bh=z6BVd3LzBiMCSWOwudJC+/aTy7rGWK6BvXRLAtUhAI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TY1HNWfUyeXFS26zDaXMioNi+0nesdmjLjBCj15iZuI/gCQF7LYYRNHi/7D9UcNfhHmZMhK5uzrGa0eq9XprXmM+gZbdmVQM6k4fjsnvnXjmaUta3KLkxmEjTMcx/ahpjR4vfMQa2okiXQehWZ893NXE6BdQDdBIL7Vl/NTa7rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StvfcsMc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StvfcsMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362891F00899;
	Wed, 30 Sep 2026 16:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785676;
	bh=iJbR5ymBPouXDCbE0dlH6/TrrTFLQWiDNrfC/vCY2OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=StvfcsMcAxXLEnXx2f+/xyYZUrkdEIT1F7U4nQlCu38B8Rx8SPe64omiBNnZErpnz
	 ezA4GNr3VpMz6F/orVDG1WwbexNJkv80EnNqeTd6cmTAHYCqQVuXtzdwWHUbr1iqyf
	 o8JA+16xHfCgF/OenSWitLpCMQDyiv+60jKZMtNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjoern Doebel <doebel@amazon.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.1 547/982] smb: client: avoid leaking refcount when cifs_sb_tlink() fails
Date: Wed, 30 Sep 2026 17:21:23 +0200
Message-ID: <20260930152428.519957989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjoern Doebel <doebel@amazon.de>

commit 23b26f4408ac3f35a482d2e5cf6fc865d4201b71 upstream.

cifs_oplock_break() takes over the reference that
cifs_queue_oplock_break() acquired when it queued the work, and drops it
with _cifsFileInfo_put() once the break has been processed.

Only in setups with "-o multiuser", cifs_sb_tlink() may fail, at which
point cifs_oplock_break() returns without putting the file reference,
mirroring the reference leak we already fixed in the companion patch to
cifs_queue_oplock_break().

This would trigger a crash due to busy inodes on the next unmount:

  BUG: Dentry ... still in use (1) [unmount of cifs cifs]
  VFS: Busy inodes after unmount of cifs (cifs)

Drop the reference on that path as well. Doing so before the out label
mirrors the normal path, which also puts the reference before
cifs_done_oplock_break().

Found by Sashiko code review. The failure path was not exercised at
runtime.

Fixes: e8f5f849ffce2 ("cifs: fix potential oops in cifs_oplock_break")
Cc: stable@vger.kernel.org
Assisted-by: Kiro:claude-opus-5
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -5188,8 +5188,11 @@ void cifs_oplock_break(struct work_struc
 			TASK_UNINTERRUPTIBLE);
 
 	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink))
+	if (IS_ERR(tlink)) {
+		/* drop the reference taken when the break was queued */
+		_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 		goto out;
+	}
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 


