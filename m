Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035365;
	b=sWqPf+WbhEtnY2kRnu+lHsNPky4BD5LPX+c/8VB/hQ+GLQgDxgR0sS89aU1j9xyd5+mR
	 QET0asvEqIOUnHYHrQ3apR59HYvYZXwceyx9DvlhrMH159T3aNb6+eFPzsEyfvmx1qUyC
	 NCwM2OFIsrkt0CPWbpf7ejTQS1HFiuv65oFbqn9Q1QwXu4Giw1I5YCOKksLEtI+9P/Zm1
	 d3pn9jZ5EJbac8paYBFFkRpQ35hA1FS2RWpVUwTYJ/X027Sv0uQ/QyDajNcb5laPAUNwZ
	 hgZycqpM31S9qcz8bw8HJJRut0TWAPO0Yye9X9zPagNFNhMj3QV56TnrI4eXVoqyGPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bt/ensvgRkiOvTwOzfNzSYUMIYmstq+FNBG7QwxxR00=;
	b=OdLZ10QeA+RPqwYxw/J+/7TvkzGD+C6RUCQfk6ngqEWaMU0oAc5RbOb3fb8SUVlrs5ph
	 x47cx5OAovKJLXjBMNZ+O8rToXBIdCJwjqz/YxikvPuiHjgziMuan02Ja7etbPHljZJhY
	 XtL+0uecy0av5mKH5IyNNVNdX0PcLhoMlR5so713T2CCtDr0PNCLLL0BDSO7YHoC9ZIJG
	 1aSd7Z03Y+ntskGitQOxhm8eLezKS0M5HSnmtAI+oXup+60PqajEi8f0bYbZsBvKBNDCP
	 /61AAx14XXKxlpspoovKH65qf4NnPRB9lYQyhIAcIzHeEStk4eTMdzqv2QLmDPRvULA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X88KyuGN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6530F606A31C;
	Wed, 18 Nov 2026 20:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X88KyuGN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90BB1F000C4;
	Wed, 18 Nov 2026 20:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035365;
	bh=bt/ensvgRkiOvTwOzfNzSYUMIYmstq+FNBG7QwxxR00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X88KyuGNtvhv5e69wokXvRsEeegys35I43LQZ2DXXitBH+JjWNL/TpB04KLoyiRHv
	 o8RT6UGZ8NQfIw2fqyEyOa2HNpXvEXKNy9WN9xjwms4KYnrAoQtCB+XxXFeL6BBZtk
	 kKGqrVKemf1wA857Z80Pdc3dzk9R1Zjg9k7A9i6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Liu <bird@lzu.edu.cn>,
	Paulo Alcantara <pc@manguebit.org>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>
Subject: [PATCH 6.6 0677/3318] smb: client: fix buffer overflow in SMB2_tcon()
Date: Wed, 18 Nov 2026 15:21:39 +0100
Message-ID: <20261118150338.480958137@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2024,8 +2024,6 @@ static inline void cifs_stats_fail_inc(s
 	cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_failed[code]);
 }
 
-#define MAX_SHARENAME_LENGTH (255 /* server */ + 80 /* share */ + 1 /* NULL */)
-
 /* These are similar values to what Windows uses */
 static inline void init_copy_chunk_defaults(struct cifs_tcon *tcon)
 {
@@ -2056,7 +2054,15 @@ SMB2_tcon(const unsigned int xid, struct
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
 


