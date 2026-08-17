Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E535643E9FB;
	Mon, 17 Aug 2026 14:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975984; cv=none; b=kVmxn1oEbUnv5wW83+Gykh5oiAqjluNKiyZ+JS3U0XdOLGVLZgU1t9YJaeGeEVX6M0HlXIpPGxUyq/ncSQXIxTFh0Elr5Xmq3TTqpC+r/MBZuyh3f/5Hdn/WU8TVpLHKn22ubsDq3Bkf87XLdmR2dHrDiyU5wu2RJLmRxa6YnWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975984; c=relaxed/simple;
	bh=ujg/GnqFNH0SxZyOCQPhS29N0f9jn4pMSHMtmmhkroI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ky5mjY0HsfU8towUPeQO7f5NwnZqiVAge/Kh/ujNitXqSEw0Ec0autKGI33HERpwCkFX4nXg4RbtxyjhNS3mDckM/cF9zyKscw2U+UFL/QUgFCKc3iX5dq0TvGdDgzj3+Rl9iEnJAvcVWvtoSiZ+fiWp4JRz02QcdtBqBGBN8ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQiqwUt1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQiqwUt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FC21F000E9;
	Mon, 17 Aug 2026 14:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975982;
	bh=CbcVVyMsjfQ/iOCN5Q0KhXKHzZ+7W0eol3Ed9VTeyCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQiqwUt17xZ0TOx0g8QOzOfkOUgwiuFAtlvd+dMyDe6oeytfGeeJNrO4hAtgt+D4+
	 MlpCvO0tgD420JanX/kcKfPiuE41bcf5YTjCl/irtwUXb7+V9jmuYqxUFSRaYNsGdG
	 rt7tcn1BP27ot4+rdo1eOyLsxFncbb/ZfUJAPIZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 216/389] smb: client: fix buffer leaks in SMB1 read and write
Date: Mon, 17 Aug 2026 15:30:55 +0200
Message-ID: <20260817132547.638817159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 fs/cifs/cifssmb.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index a19e5e7c7d0f4..67ff1669cab2a 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1774,8 +1774,10 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(pid >> 16));
 
 	/* tcon and ses pointer are checked in smb_init */
-	if (tcon->ses->server == NULL)
+	if (!tcon->ses->server) {
+		cifs_small_buf_release(pSMB);
 		return -ECONNABORTED;
+	}
 
 	pSMB->AndXCommand = 0xFF;       /* none */
 	pSMB->Fid = netfid;
@@ -1887,8 +1889,10 @@ CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
 	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(pid >> 16));
 
 	/* tcon and ses pointer are checked in smb_init */
-	if (tcon->ses->server == NULL)
+	if (!tcon->ses->server) {
+		cifs_buf_release(pSMB);
 		return -ECONNABORTED;
+	}
 
 	pSMB->AndXCommand = 0xFF;	/* none */
 	pSMB->Fid = netfid;
@@ -2317,8 +2321,10 @@ CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
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



