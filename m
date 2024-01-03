Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849701BDED;
	Wed,  3 Jan 2024 16:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjpVXt5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C11C433C7;
	Wed,  3 Jan 2024 16:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704300994;
	bh=+9d3h+KJWfsfZH427et7z7aWRpaUrO8ICBbxmys1UKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjpVXt5Xn6hWCa596752GHieLuBr3k+n0ldJ2pMVudVda63676y7g4qeRExq/YFi3
	 CFJf1p3R3HgOmiIRmxADnvXeR92XE7TXLki03zdFHomaOoyYcHRGc/e2c02gbSjSn8
	 abswsLCWJHKTaa1nVpPe6JNz8JJqsd3VS++ycy18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/100] ksmbd: use F_SETLK when unlocking a file
Date: Wed,  3 Jan 2024 17:53:52 +0100
Message-ID: <20240103164856.723272757@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f5a46b6831636..554214fca5b78 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6845,7 +6845,7 @@ static int smb2_set_flock_flags(struct file_lock *flock, int flags)
 	case SMB2_LOCKFLAG_UNLOCK:
 		ksmbd_debug(SMB, "received unlock request\n");
 		flock->fl_type = F_UNLCK;
-		cmd = 0;
+		cmd = F_SETLK;
 		break;
 	}
 
@@ -7228,7 +7228,7 @@ int smb2_lock(struct ksmbd_work *work)
 		rlock->fl_start = smb_lock->start;
 		rlock->fl_end = smb_lock->end;
 
-		rc = vfs_lock_file(filp, 0, rlock, NULL);
+		rc = vfs_lock_file(filp, F_SETLK, rlock, NULL);
 		if (rc)
 			pr_err("rollback unlock fail : %d\n", rc);
 
-- 
2.43.0



