Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008162D0C7E;
	Mon, 17 Aug 2026 14:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977253; cv=none; b=eSbrp5fhy62w4RkUKvZPY0lQdIkqbSWIzZ5S8yBe/nGOGPm/z0NSjYicVYi1Qnt+L0RjIouB7pHTB+CtmF2GieF6/6UXuUvclrfBU1oaq9Wva3k3mmBJFNpnWJ819azm6tthdB5R6EdZn4qYsbf4WNwP16jvvvaV3p9AHwKaR+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977253; c=relaxed/simple;
	bh=gQjikULnMSaS3FUdXfmXa9hiYnypeNifSbPAvjzSy8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3rOJ4CdDnEe+SzRthRHntZPh1qQLuioiewkorQRjQXM1tI72IWWKc89My/5KnzP7SK83JzbKRYIXPhp+pxMTKauv5uNu3ueAoBPvpJspfXAWmhbdZvFUWNWbQqwEIoAJXWwzPeABipFOE1vf6tQhQXAUN0Xj2sp9epsFPI5tbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMsoug9Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMsoug9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED581F000E9;
	Mon, 17 Aug 2026 14:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977251;
	bh=frvAmvgm1VHQATa7ihdbqCZUONcFcwOZDtEvSh/2sQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMsoug9ZRQLoUbF+E1QGyNEUVoXn9eGwaXoY0PwdgeTWmVeUurLucbLwp+ZP+o4Sv
	 c3AmJ01lcvFicttrdi90g1cBIUwFthTYwCY+Vjvd4g68m6QCmf0l6m1+E6LaIYSQaG
	 xSARmx3993HGZgWOTreEfTsUut6xE/liRvV5z07k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 264/456] smb: client: fix buffer leaks in SMB1 read and write
Date: Mon, 17 Aug 2026 15:30:54 +0200
Message-ID: <20260817132550.325302705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e6541bd5c63df..11a400663b9f2 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1661,8 +1661,10 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(pid >> 16));
 
 	/* tcon and ses pointer are checked in smb_init */
-	if (tcon->ses->server == NULL)
+	if (!tcon->ses->server) {
+		cifs_small_buf_release(pSMB);
 		return -ECONNABORTED;
+	}
 
 	pSMB->AndXCommand = 0xFF;       /* none */
 	pSMB->Fid = netfid;
@@ -1774,8 +1776,10 @@ CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
 	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(pid >> 16));
 
 	/* tcon and ses pointer are checked in smb_init */
-	if (tcon->ses->server == NULL)
+	if (!tcon->ses->server) {
+		cifs_buf_release(pSMB);
 		return -ECONNABORTED;
+	}
 
 	pSMB->AndXCommand = 0xFF;	/* none */
 	pSMB->Fid = netfid;
@@ -2205,8 +2209,10 @@ CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
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



