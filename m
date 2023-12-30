Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6137679DD;
	Sat, 30 Dec 2023 12:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltVQZrZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDB6C433C8;
	Sat, 30 Dec 2023 12:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938246;
	bh=5Yhde4+pUdiarnAI/agGhvKrnKSBzUZNGP9svSQrvtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltVQZrZ0emWBJKDLjpy0JZL36v4iFmjcMs19QLcFw9DllcY3u4ifb+SPncHSeu0Rp
	 QGNA9/rH6hCZgNBfmCIwFkR9ezqolCxpajkKtPE6z7OD6JaEdEZuXf4rPmxIOZWQ7J
	 xBApYB7hlEi3u/iij7HPZrx8/R2FKIpIlME9YK2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 083/112] smb: client: fix potential OOB in cifs_dump_detail()
Date: Sat, 30 Dec 2023 11:59:56 +0000
Message-ID: <20231230115809.444011704@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

commit b50492b05fd02887b46aef079592207fb5c97a4c upstream.

Validate SMB message with ->check_message() before calling
->calc_smb_size().

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifs_debug.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -38,11 +38,13 @@ void cifs_dump_detail(void *buf, struct
 #ifdef CONFIG_CIFS_DEBUG2
 	struct smb_hdr *smb = buf;
 
-	cifs_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d\n",
-		 smb->Command, smb->Status.CifsError,
-		 smb->Flags, smb->Flags2, smb->Mid, smb->Pid);
-	cifs_dbg(VFS, "smb buf %p len %u\n", smb,
-		 server->ops->calc_smb_size(smb));
+	cifs_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d Wct: %d\n",
+		 smb->Command, smb->Status.CifsError, smb->Flags,
+		 smb->Flags2, smb->Mid, smb->Pid, smb->WordCount);
+	if (!server->ops->check_message(buf, server->total_read, server)) {
+		cifs_dbg(VFS, "smb buf %p len %u\n", smb,
+			 server->ops->calc_smb_size(smb));
+	}
 #endif /* CONFIG_CIFS_DEBUG2 */
 }
 


