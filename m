Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48304FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788A0C4339B;
	Mon, 15 May 2023 17:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171779;
	bh=76PnOE9v75Y2guwF1juenUlk/2HA0gRnsoBcKDL3FqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBzYc16oKD7MQwQdK4PU5jiw5ryuHGz7YsypZNRFOt0tNm+aEqCgGH+N4vIGjVM+6
	 Gj7+fzm87mVGmr+DcbrocAYWw0NiXj8GRM5EWeu48sY7Dp3BTraTW1GfKfvRD16ISB
	 eCovD0FWLvm+slXalJBw9A1R03lwlimtiNUcStMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 074/134] SMB3: force unmount was failing to close deferred close files
Date: Mon, 15 May 2023 18:29:11 +0200
Message-Id: <20230515161705.634771653@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161702.887638251@linuxfoundation.org>
References: <20230515161702.887638251@linuxfoundation.org>
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
@@ -715,6 +715,7 @@ static void cifs_umount_begin(struct sup
 		tcon->tidStatus = CifsExiting;
 	spin_unlock(&cifs_tcp_ses_lock);
 
+	cifs_close_all_deferred_files(tcon);
 	/* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
 	/* cancel_notify_requests(tcon); */
 	if (tcon->ses && tcon->ses->server) {


