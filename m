Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68C441C96;
	Wed, 20 Dec 2023 16:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvQeDkwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B932C433C8;
	Wed, 20 Dec 2023 16:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088890;
	bh=6GpR7vqAgW9Hl2dzvICBWmHTrTJFbOgyCOADBSvQ1Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvQeDkwvbemJUGNaH8eHvbBFly5agV+5/fx7Eqlz4+IPrl6ojpQFfNysmOSs8cL5o
	 wq/fm+7TMGd1y2PYHo6ejvs419Xpy/0m2x7tcQ1hMK7cDLiOaBL7oLDLnADfECR9rw
	 MaT5yjDB+pWFxwy/rmX/UDZX3ErGvLeI4wCQ6Elw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 066/159] ksmbd: use F_SETLK when unlocking a file
Date: Wed, 20 Dec 2023 17:08:51 +0100
Message-ID: <20231220160934.448747631@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 7ecbe92696bb7fe32c80b6cf64736a0d157717a9 ]

ksmbd seems to be trying to use a cmd value of 0 when unlocking a file.
That activity requires a type of F_UNLCK with a cmd of F_SETLK. For
local POSIX locking, it doesn't matter much since vfs_lock_file ignores
@cmd, but filesystems that define their own ->lock operation expect to
see it set sanely.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6803,7 +6803,7 @@ static int smb2_set_flock_flags(struct f
 	case SMB2_LOCKFLAG_UNLOCK:
 		ksmbd_debug(SMB, "received unlock request\n");
 		flock->fl_type = F_UNLCK;
-		cmd = 0;
+		cmd = F_SETLK;
 		break;
 	}
 
@@ -7182,7 +7182,7 @@ out:
 		rlock->fl_start = smb_lock->start;
 		rlock->fl_end = smb_lock->end;
 
-		rc = vfs_lock_file(filp, 0, rlock, NULL);
+		rc = vfs_lock_file(filp, F_SETLK, rlock, NULL);
 		if (rc)
 			pr_err("rollback unlock fail : %d\n", rc);
 


