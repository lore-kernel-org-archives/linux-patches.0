Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4473C280331;
	Fri,  7 Aug 2026 15:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116761; cv=none; b=TDNINDzL4WJ+8YfF67qqhATul+Qhz8EnPdjPldAtcyJBWLD4rLw8Ca6Fu0j7V0ZmrYp8S9ThoN3r82ijoQBLHfEtsFxjOZNtWm6DUiEiYeSrD8K8cZwwkyJX6bROu4znEbyXrUA6RUg0arPCjPbz6PFs22/CxgYvEwSfiXUNiZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116761; c=relaxed/simple;
	bh=cjNh/byOwYqGCI5eFH3VbDREgSlTqiUa36LqxbN1Ac8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+7O77RYED6nYV9sJqegn8dWWhJJp+93moHZMthyJqfIcsv+2eRunfcYSRat2xz9wN9zhsxKQ6jSnojjb61qFRcmpcG+MLVOcvK7erFpG0istSQmR9/RPLk/lMr3YAy1NsS+K0qQucCeFDoEPL/OaGuGKEcaqm5oOGmnqZffcAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f90Xe1JY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f90Xe1JY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11DD1F000E9;
	Fri,  7 Aug 2026 15:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116760;
	bh=U4MvXVM6xcx5bTOVN4FRos30JQnI7LI6/XxVyiRtCmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f90Xe1JY3XQw6tW+jtUhMaKf9wt/eZEW1Xa+HpdLNBiYl0qTTw5pl270Em7LH4Lsx
	 M7nyxyA7B3x9ahKeDVS3i/s4KF30g/0XKfrkxLwW2q3w+vmIYA22CUuqqQBgIuG1mf
	 //7azB45D+K+bIG11gs8SpQ/Zp2v+L+7wmxTPkMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 082/438] smb: client: fix buffer leaks in SMB1 read and write
Date: Fri,  7 Aug 2026 16:34:38 +0200
Message-ID: <20260807143429.730587240@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Feng <dawei.feng@seu.edu.cn>

[ Upstream commit 6a3e16d60e81a4aa3056ab15617036cfbea2e07d ]

CIFSSMBRead(), CIFSSMBWrite() and CIFSSMBWrite2() allocate a request
buffer before checking whether tcon->ses->server is NULL. If that
defensive check ever fails, the helper returns -ECONNABORTED without
releasing the request buffer.

Fix these leaks by releasing the allocated request buffer before
returning from these error paths. Use cifs_small_buf_release() for the
buffers allocated by small_smb_init() and cifs_buf_release() for the
buffer allocated by smb_init().

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1.1.

An x86_64 allyesconfig build showed no new warnings.

Runtime validation used a temporary fault-injection hook to force
tcon->ses->server to NULL after request-buffer initialization. On the
unfixed kernel, the harness observed two leaked small request buffers and
one leaked large request buffer, with directed kmemleak dumps confirming
the CIFS buffer allocation stacks. After the fix, no CIFS request-buffer
deltas remained.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 9e27bfa7376b1..024c5d462424d 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1681,8 +1681,10 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(pid >> 16));
 
 	/* tcon and ses pointer are checked in smb_init */
-	if (tcon->ses->server == NULL)
+	if (!tcon->ses->server) {
+		cifs_small_buf_release(pSMB);
 		return -ECONNABORTED;
+	}
 
 	pSMB->AndXCommand = 0xFF;       /* none */
 	pSMB->Fid = netfid;
@@ -1796,8 +1798,10 @@ CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
 	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(pid >> 16));
 
 	/* tcon and ses pointer are checked in smb_init */
-	if (tcon->ses->server == NULL)
+	if (!tcon->ses->server) {
+		cifs_buf_release(pSMB);
 		return -ECONNABORTED;
+	}
 
 	pSMB->AndXCommand = 0xFF;	/* none */
 	pSMB->Fid = netfid;
@@ -2077,8 +2081,10 @@ CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
 	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(pid >> 16));
 
 	/* tcon and ses pointer are checked in smb_init */
-	if (tcon->ses->server == NULL)
+	if (!tcon->ses->server) {
+		cifs_small_buf_release(pSMB);
 		return -ECONNABORTED;
+	}
 
 	pSMB->AndXCommand = 0xFF;	/* none */
 	pSMB->Fid = netfid;
-- 
2.53.0



