Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044518;
	b=vQIwvuGm+BhgbT5mTJCC+LiPVYGJAX+daYRPqokJ6u9Qayoy1T1XSAf6BBag5L92si6z
	 TkU35PRJMsgX9+lalumTjQG+nCnV5GfNTUlg9pdeFiFyXB9UDF3CusjiYDHtIHyLzFX1S
	 OvwbdeFMJk/wAJwG6lBbjc/lLk6Ppgf1c6UIKd2vSDbQsD1t8BYTMQgkUAiFqM7t4AgZz
	 Fvk1BDwiLtZJH6+zFljd8bRobBdp6ZHg6mL+zFl9BQXc+jmfat6iVrqKIyfRzTTgbiRWN
	 IIOaX0YvkM/SGu3OiixXNVRLxhPwAxBDO6WibspP9kl2SRf12eMlFeRVxWtQImrmbgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hk2CM+oEKtvfI9jv/YBJ3cyAkQLvbIzpkxPnk69vKLU=;
	b=3mAc507K4xVT5zZ6fRrjArUP1pckAYbo3avvEyvfrv6tG946fivc+DirwCJEX/gqx/KT
	 6pD1ZJn9DtANuEqIiIoTGu48C5JWa9Mhq1NPkvacTlYX/IihucECk+S2amCNhQn/nUSBu
	 oiwBJTQFVacyFBJK7AslZ0BZJVavAPbeX9ZDNO20k2Gq4NBZgH8Yb4ddiKhJ4r69cxW42
	 kL98/NFGQ6sroQFIqxGgctepzLyP2Q/vbJdnUKXD4hgfJgc/3VKZ8Rz1znaj8xatG82+Y
	 AIzY5m1OMqOnBFKGhH1aBCEF4JZY4vyNTgaaMGryOe43/csQvMdKo2VdybHdBlkPV6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WymjImm2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE6B606A325;
	Wed, 18 Nov 2026 23:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WymjImm2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9D61F000D0;
	Wed, 18 Nov 2026 23:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044518;
	bh=Hk2CM+oEKtvfI9jv/YBJ3cyAkQLvbIzpkxPnk69vKLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WymjImm2RZObCsk5kBtZzg3sUFYkE/e2zDPVXk9aIO75n7EGhNcegVyTbAG0Lxud0
	 OsNb/at9QLkNRGZrZyTSiDKUBt/V3Fx7yahV6Cqj85G5aAO38KFS4gsRN2biYCnOb6
	 TippG+Q+661sVHMssVyONGJa04YPCSukUSw7SbPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Liu <bird@lzu.edu.cn>,
	Paulo Alcantara <pc@manguebit.org>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>
Subject: [PATCH 6.1 0596/2857] smb: client: fix buffer overflow in SMB2_tcon()
Date: Wed, 18 Nov 2026 15:27:10 +0100
Message-ID: <20261118150222.947396917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Luxiao Xu <rakukuip@gmail.com>

commit 73cc469b0ff7551f8537ea919709973e6dc4f514 upstream.

In SMB2_tcon(), unc_path is allocated with a fixed buffer size of
MAX_SHARENAME_LENGTH * 2 bytes (672 bytes). However, the user-controlled
UNC path (tree) length is passed to cifs_strtoUTF16(), which assumes the
destination buffer is large enough and writes strlen(tree) + 1 UTF-16 code
units.

Commit 62a1a439e0fd ("cifs: clean up handling of unc= option") removed the
length check on UNC mount options, allowing mount paths to exceed
MAX_SHARENAME_LENGTH while retaining the fixed-size buffer allocation in
SMB2_tcon(). Consequently, an oversized UNC string causes cifs_strtoUTF16()
to write past the end of the heap object, resulting in a slab-out-of-bounds
write. Furthermore, if a tree exceeds MAX_TREE_SIZE characters, strscpy()
truncates it in cifs_tcon::tree_name, causing subsequent reconnects or
failovers to fail.

Fix this by first verifying that the length of tree does not exceed
MAX_TREE_SIZE, returning -EINVAL if it does. Then, dynamically allocate
unc_path based on the length of tree so that it safely accommodates all
UTF-16 code units for paths within MAX_TREE_SIZE.

Fixes: 62a1a439e0fd ("cifs: clean up handling of unc= option")
Cc: stable@vger.kernel.org
Reported-by: Xin Liu <bird@lzu.edu.cn>
Closes: https://bugtracker.nebusec.ai/f/3292
Assisted-by: LLM
Suggested-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
[pc: remove unused MAX_SHARENAME_LENGTH]
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1917,8 +1917,6 @@ static inline void cifs_stats_fail_inc(s
 	cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_failed[code]);
 }
 
-#define MAX_SHARENAME_LENGTH (255 /* server */ + 80 /* share */ + 1 /* NULL */)
-
 /* These are similar values to what Windows uses */
 static inline void init_copy_chunk_defaults(struct cifs_tcon *tcon)
 {
@@ -1952,7 +1950,15 @@ SMB2_tcon(const unsigned int xid, struct
 	if (!server || !tree)
 		return -EIO;
 
-	unc_path = kmalloc(MAX_SHARENAME_LENGTH * 2, GFP_KERNEL);
+	total_len = strlen(tree);
+	if (total_len > MAX_TREE_SIZE) {
+		cifs_server_dbg(VFS | ONCE,
+				"%s: tree name exceeded %u characters\n",
+				__func__, MAX_TREE_SIZE);
+		return -EINVAL;
+	}
+
+	unc_path = kmalloc((total_len + 1) * sizeof(*unc_path), GFP_KERNEL);
 	if (unc_path == NULL)
 		return -ENOMEM;
 


