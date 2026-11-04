Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829000;
	b=BEWnmsszSHiXBMANMqlZuXBF92xmOEc7lpe5S34lSxfExmZ1RzjAf4dEty7ULeXtU+JT
	 epGzFK1NS5KmwHMD6BLfMucYhDLlY6Q+bexpwjsT9zzNTwgAod3RTCXimtnuHhLpBsjxw
	 n1k71Z1/+WM04IIgr3L0kXuuR+IHQJqIlRnI4n7s5b09UnfEPMHRkwXwNEetcvcNJfiqe
	 X8Cnud+tBGwy+qkWC2qbKwwAnuWpYtkyEth39B/OqcAoitxpCGzBNJlHfZtzVXdiBLFK1
	 zDARWyxl2Njqeg2AyD9VgVbjzYIObOXpkogsctC8ULmXbPAZkG4d1XcUrdRLbbOEUqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=++Io5WlLoJABC2qrtDah4UrkJ9kiIfFV/EvHrqM5wSQ=;
	b=IGS0hgI5O6gkkcWmf4J/R4R/p6dwIkab1RnbRokAwVqw1yWiPMIbkcqznDkVwKOWvQC4
	 M5NefV/cByACFgx9OvIXHQFkLOFo3V/tjpWoT1/UpY6433A7O3vBJ703XLK1B7OOS/SkO
	 P5xFRg/rlfBVIQxdwWeY3qxseNMtVkKLFhmS+x7y//PaHIjWWhDOyGnwjJEMJNQXQBJuj
	 hw1lSiNvL421Tq55cka1sBlhfdx3UCDEHGvnBIscq7B59C3XJIJEBNync/gdimTFC5GYm
	 mgFIS8RbepeAxxfDy+ONWYIFO8CukEl3UNeGvbW6U1kT1/RvkJ2tGhCVNvPt4NOsqFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T7x7hgFT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CC5607F2A2;
	Wed,  4 Nov 2026 21:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T7x7hgFT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7AD1F000C1;
	Wed,  4 Nov 2026 21:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829000;
	bh=++Io5WlLoJABC2qrtDah4UrkJ9kiIfFV/EvHrqM5wSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7x7hgFTwf/Qic7iLvLyHVg9dj1yQ+Qyf57bv7wzL5zs9NA+pEAR32xJnR9fb0fum
	 /87kcWCmmrXg+Nlivhy1xBnVh+1zviCnsyTDNYNrWyZcE5jA7kbcwtuhKzlnpwp4cw
	 knYh8ge9ouY85uI9g0H/XeRc0i08TRPleTquMTok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Liu <bird@lzu.edu.cn>,
	Paulo Alcantara <pc@manguebit.org>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>
Subject: [PATCH 7.3 379/547] smb: client: fix buffer overflow in SMB2_tcon()
Date: Wed,  4 Nov 2026 16:09:23 -0500
Message-ID: <20261104211049.067956911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2118,8 +2118,6 @@ static inline void cifs_stats_fail_inc(s
 	cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_failed[code]);
 }
 
-#define MAX_SHARENAME_LENGTH (255 /* server */ + 80 /* share */ + 1 /* NULL */)
-
 /* These are similar values to what Windows uses */
 static inline void init_copy_chunk_defaults(struct cifs_tcon *tcon)
 {
@@ -2150,7 +2148,15 @@ SMB2_tcon(const unsigned int xid, struct
 	if (!server || !tree)
 		return smb_EIO(smb_eio_trace_null_pointers);
 
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
 


