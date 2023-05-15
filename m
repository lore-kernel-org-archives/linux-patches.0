Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E77FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C64C433EF;
	Mon, 15 May 2023 17:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170435;
	bh=e4QBGwX+Izxjh1QZWTpkp9px+pDzxg0KWgSxmDigml8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9y4h9FGCQbDeAWE/GuoT1EtWguihFEeUEoBcVd/rO2stJIp4Gc7HkRRxqevVpBJX
	 p1L+zQYmLo4dV/utXNZgyYsMGEuPL4tTaLnaP/X1djUxvY/LkI155IDHRqdV82Y78X
	 sDo/max3NjhbpWFjcIAK6zN9PQ8g2uMvLpvmb+FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 130/239] SMB3: force unmount was failing to close deferred close files
Date: Mon, 15 May 2023 18:26:33 +0200
Message-Id: <20230515161725.595698424@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steve French <stfrench@microsoft.com>

commit 2cb6f968775a9fd60c90a6042b9550bcec3ea087 upstream.

In investigating a failure with xfstest generic/392 it
was noticed that mounts were reusing a superblock that should
already have been freed. This turned out to be related to
deferred close files keeping a reference count until the
closetimeo expired.

Currently the only way an fs knows that mount is beginning is
when force unmount is called, but when this, ie umount_begin(),
is called all deferred close files on the share (tree
connection) should be closed immediately (unless shared by
another mount) to avoid using excess resources on the server
and to avoid reusing a superblock which should already be freed.

In umount_begin, close all deferred close handles for that
share if this is the last mount using that share on this
client (ie send the SMB3 close request over the wire for those
that have been already closed by the app but that we have
kept a handle lease open for and have not sent closes to the
server for yet).

Reported-by: David Howells <dhowells@redhat.com>
Acked-by: Bharath SM <bharathsm@microsoft.com>
Cc: <stable@vger.kernel.org>
Fixes: 78c09634f7dc ("Cifs: Fix kernel oops caused by deferred close for files.")
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -743,6 +743,7 @@ static void cifs_umount_begin(struct sup
 	spin_unlock(&tcon->tc_lock);
 	spin_unlock(&cifs_tcp_ses_lock);
 
+	cifs_close_all_deferred_files(tcon);
 	/* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
 	/* cancel_notify_requests(tcon); */
 	if (tcon->ses && tcon->ses->server) {


