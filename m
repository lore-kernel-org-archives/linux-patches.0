Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBF03FA5CC;
	Mon, 17 Aug 2026 15:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979767; cv=none; b=PGzCG3xEd9qUmrgC0auR6yCbKSw5pOsE0sukYFkSUUkTvPS9KLgj/1lG6mo6QWlalo6VdrFg126T0LGHLvk1fVuBTaff2bOzsHIMhgPag8KmDqX9omShYG5Vf4P3TGRGem7E87OWjx9bi6pxk4dqsfxP8VqrEJ342sjEZSZEBlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979767; c=relaxed/simple;
	bh=JaxeJJTdSHx72r9ElaV49f/SwxaaVctIApN/yTFN/5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaeL3gHeuLKeZwKV5oIfhRBs91g0ct1L1ioslxbr/tXaDOFXDA3MjXIoBz6nEC0skSFqkPybRrzIlPuQBDqIPloQ8ozr6rD38dx3JtiVQQ+eApQTrOoqssadIoVK5TuIg0YJDHBGBNI06a6Puj5LOvQU8g8W5cGmpsmim4QyO/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQ5Y9R5K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQ5Y9R5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AA21F000E9;
	Mon, 17 Aug 2026 15:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979765;
	bh=W3klAFdvW+mYKCgJwqn71pFE3vPeCcEf1ciWOgsnENM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQ5Y9R5Kn/pBUev9zHdCn/M2AlXzPKWYzWYIn8KNWBEp7tKEk1QOPlxSmx8ex2KVu
	 VYNBZZq7eEaDh+JWR0uNFtNXeo1hvz3VQhKAQ/r7LGjlTVk4A9fgrFaXL4uiLnImKv
	 ce552jqpafpBzF6tvjm4cBiA/qi8K+2ngmTOnEM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 340/609] smb: client: fix buffer leaks in SMB1 read and write
Date: Mon, 17 Aug 2026 15:30:36 +0200
Message-ID: <20260817132555.620728302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
index 49d7726830044..95cf7e69a411d 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1409,8 +1409,10 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(pid >> 16));
 
 	/* tcon and ses pointer are checked in smb_init */
-	if (tcon->ses->server == NULL)
+	if (!tcon->ses->server) {
+		cifs_small_buf_release(pSMB);
 		return -ECONNABORTED;
+	}
 
 	pSMB->AndXCommand = 0xFF;       /* none */
 	pSMB->Fid = netfid;
@@ -1522,8 +1524,10 @@ CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
 	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(pid >> 16));
 
 	/* tcon and ses pointer are checked in smb_init */
-	if (tcon->ses->server == NULL)
+	if (!tcon->ses->server) {
+		cifs_buf_release(pSMB);
 		return -ECONNABORTED;
+	}
 
 	pSMB->AndXCommand = 0xFF;	/* none */
 	pSMB->Fid = netfid;
@@ -1776,8 +1780,10 @@ CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
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



