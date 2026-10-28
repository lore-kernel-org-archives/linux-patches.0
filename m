Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217245;
	b=g1ossSm1L8FRnLuYSsITId/bQ+wAOVzow5/zQcX7UkGJYW1V1eJwKV5jbctS0w4h6dan
	 MN1mwc8LaJJPFpRjWwZg3Y1m65NnVFGjWxP4gDXITEhXamEBLiv00BdqTrhtOTuWts1Uo
	 4yK18frv7TZqNg0pTKlmAwEzob2KBtpv5ufQdaJAzn2xIC9uAaVFWugifeDRX0T7yUoxs
	 LtDkGeUyoXpb6queL6PzJsGyq5Vb23UPTF99RkV6/yW+o5JtdZVFtwRFll+AoDxymIObi
	 qPygUtTqU1kRPeELp/kUjfvWmlIWem5KnP01w0CsYZxOLica7xWe4/7B8FeOsR+lz0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217245;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nasb8Yb7LeNQcdQgOabCxQ5CpZ/H54nFmoG6fue0D68=;
	b=ZPWje9sMohSgEnjLo1l11FmpVrytqiDcpsHX/AziMoh7FZb5Of9zH5FRsFqIwfyiSyYE
	 ay8S7p53C9LWvoM2ORg9aQdtGtXAYE9jtl+FvuRsUHvdiYJlpToh/86UNdAo3BJ52sDbI
	 EbY+WcKps4ddEFaDcEk20V10rmDXNj4bTWftcHleZlehPZPEQc1ZwoMqJDmOZp4UdI8/w
	 +4oiSG4YHeggM/1/10jw9vJ1DEbuSX4iMUI1AVMK0DgaEnbho5X+6kknSbm0ooMBmsEDg
	 1PyiyDMfBLgw7rI85WwuA5mtcCIxk22hm4i795Z0t+acEJ5axV97ykROJFO+faYpVfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQysrumL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8BD606A31E;
	Wed, 28 Oct 2026 19:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQysrumL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8321F031E1;
	Wed, 28 Oct 2026 19:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217245;
	bh=nasb8Yb7LeNQcdQgOabCxQ5CpZ/H54nFmoG6fue0D68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQysrumLYgyFfsC3CZBvx2pHQ143LNcZIq57qgCE+LISK/3dIVQgvGQJlbsZpQQeY
	 u15/xP5ATgQBtSiKi5NsFlUh8MUinn0BWHrwMw+VlqpLViq0QSkc4YK6XyGZPlZRdx
	 zsb0+IydZAf/i9xlkVSjTJZOAo6az/qiBY8y/zTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1792/1887] cifs: add revalidation on FSCTL failure in smb2_duplicate_extents()
Date: Wed, 28 Oct 2026 18:04:48 +0100
Message-ID: <20261028170540.227138395@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit 53676a5e28231186c9f56d87b7998b640699bc15 ]

smb2_duplicate_extents() has no handling for
FSCTL_DUPLICATE_EXTENTS_TO_FILE failure: when the FSCTL fails, local
inode metadata may be stale from the pre-extension or from concurrent
remote writes, but is never refreshed.

Force revalidation on FSCTL failure and use i_size_read() for the
pre-extension check.

Fixes: cfc63fc8126a ("smb3: fix cached file size problems in duplicate extents (reflink)")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ sashal: adapted the if/else block to a standalone failure check because the success-path metadata query is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index ecc5f27ff1413..5a07d411a00a6 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2027,7 +2027,7 @@ smb2_duplicate_extents(const unsigned int xid,
 		src_off, dest_off, len);
 
 	inode = d_inode(trgtfile->dentry);
-	if (inode->i_size < dest_off + len) {
+	if (i_size_read(inode) < dest_off + len) {
 		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
 		if (rc)
 			goto duplicate_extents_out;
@@ -2052,6 +2052,11 @@ smb2_duplicate_extents(const unsigned int xid,
 	if (ret_data_len > 0)
 		cifs_dbg(FYI, "Non-zero response length in duplicate extents\n");
 
+	if (rc) {
+		CIFS_I(inode)->time = 0; /* force reval */
+		cifs_invalidate_cache(inode, 0);
+	}
+
 duplicate_extents_out:
 	return rc;
 }
-- 
2.53.0



