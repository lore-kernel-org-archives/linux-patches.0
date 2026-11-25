Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624003;
	b=gwNQ8PrQBXfY/BUBFJwS3ZYFCmtBWij6HPG9xQxwkaO61EBJdx2chavR8oDC8dRUjfl1
	 +qNtwfsVaecWZ5FwdLCexRATuBIRKwQJ+UgzrUiOHNPhz+TZrf0QkhhgcxbRI14P3AKb2
	 h0SEdKPtejClThNnjo15ei9VYfTejE5tZ7+fgDEEq9bqqMno63/BL3jssJuPF0zkr4WWy
	 I8huc4FtS0czUu1NNg+cablM0FwyWbLyABlMNn0W5gsp76PcI2vV11td8J8XeHsYqDvkC
	 m/W96LoXb+dGb/ldilWlCP5vwLWA6sI0FM2BSIkoUoL2jgb+kvp4KE7IJoRMWT59ReQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0QcHGuvTFxywcucfYOOUB3CYW3bNVylr/qpyXokwPeU=;
	b=29VcZSevHEBFw4ly4ur6cHjf4CWbS+3GiPoDx0Lr1Awr63urHnfunopgPeaF/UVhYoi9
	 13MQFut9si9RG31MoRxoAMrZsIN3wBqPQ6gqBm4f1SEoTm99r23wnlIYhDFbqybrvTxsA
	 v0jJWwvO7cjqu/0ALYUcy5B7mrvL63D3abXiaERB6OvQT6CJRPUdMK8aRC0C6VAqwh2cf
	 qb7YS/cNcXl7eWNS0OZJhev62tzH0od/mHADDUUdobyReOH5IVGCKqmHEMU/kWuW7HBq9
	 Fx39TIkWd9qQW78oI4XoeJDmLepjztlfYVbVgih+yCQXzYxeo2+/HH0nna08san6RXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQWerjMZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BBE606A327;
	Wed, 25 Nov 2026 16:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQWerjMZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604261F000C0;
	Wed, 25 Nov 2026 16:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624002;
	bh=0QcHGuvTFxywcucfYOOUB3CYW3bNVylr/qpyXokwPeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQWerjMZpgk7JPC+xLJbL1LEqa03YiX8gs2szpKEugdESAet5hZHW4MErFf0vnIcH
	 tc25JUFs4weQxL0ex8RWTGm24G2YBiZfcEz6aQUdmwcPvjKpEfAAdakLyYUz62nJ7R
	 QZKOoR7tYylH7LfsYniN4Fc+Qb7Z3tr5nNHeAXEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haobin Wu <853555@gmail.com>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/816] 9p: skip intermediate directory entry name copy in p9dirent_read()
Date: Wed, 25 Nov 2026 15:26:43 +0100
Message-ID: <20261125143850.493306943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haobin Wu <853555@gmail.com>

[ Upstream commit 8bb0279930cc90975f03bad4d83282613e5f57fa ]

v9fs_dir_readdir_dotl() decodes each entry of a Rreaddir reply with
p9dirent_read(), which parses it through p9pdu_readf("Qqbs"). The 's'
conversion in p9pdu_vreadf() already allocates a NUL-terminated copy
of the name from the wire buffer; p9dirent_read() then strscpy()s that
copy into the fixed 256-byte p9_dirent::d_name and frees the original.

The wire format carries the name length in 16 bits, so a name longer
than 255 bytes is valid on the wire and may well be valid on the
server's filesystem, but it makes strscpy() return -E2BIG.
v9fs_dir_readdir_dotl() turns that into -EIO and aborts getdents64(),
so every entry after the long one disappears from the listing.

Drop the second copy: keep the string allocated by p9pdu_vreadf() in
p9_dirent and let v9fs_dir_readdir_dotl(), its only user, free it once
dir_emit() has consumed it. p9_dirent is a short-lived stack object, so
the string's lifetime does not change.

Note that the VFS only rejects names of PATH_MAX bytes or more in
verify_dirent_name(), so after this change a name between NAME_MAX and
PATH_MAX is returned by getdents64() even though any later lookup on it
fails with -ENAMETOOLONG. The next patch skips such entries.

Fixes: 7751bdb3a095 ("9p: readdir implementation for 9p2000.L")
Closes: https://github.com/microsoft/WSL/issues/41192
Signed-off-by: Haobin Wu <853555@gmail.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Message-ID: <20260918024851.51229-2-853555@gmail.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_dir.c         |  6 +++++-
 include/net/9p/client.h |  2 +-
 net/9p/protocol.c       | 12 ++----------
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 323f85352f6a4..733ec42258bc6 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -196,8 +196,12 @@ static int v9fs_dir_readdir_dotl(struct file *file, struct dir_context *ctx)
 			if (!dir_emit(ctx, curdirent.d_name,
 				      strlen(curdirent.d_name),
 				      QID2INO(&curdirent.qid),
-				      curdirent.d_type))
+				      curdirent.d_type)) {
+				kfree(curdirent.d_name);
 				return 0;
+			}
+
+			kfree(curdirent.d_name);
 
 			ctx->pos = curdirent.d_off;
 			rdir->head += err;
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 838a94218b593..9f3079c6f3867 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -268,7 +268,7 @@ struct p9_dirent {
 	struct p9_qid qid;
 	u64 d_off;
 	unsigned char d_type;
-	char d_name[256];
+	char *d_name;
 };
 
 struct iov_iter;
diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index 0e6603b1ec906..0a97b4de243ab 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -771,7 +771,7 @@ int p9dirent_read(struct p9_client *clnt, char *buf, int len,
 {
 	struct p9_fcall fake_pdu;
 	int ret;
-	char *nameptr;
+	char *nameptr = NULL;
 
 	fake_pdu.size = len;
 	fake_pdu.capacity = len;
@@ -786,15 +786,7 @@ int p9dirent_read(struct p9_client *clnt, char *buf, int len,
 		return ret;
 	}
 
-	ret = strscpy(dirent->d_name, nameptr, sizeof(dirent->d_name));
-	if (ret < 0) {
-		p9_debug(P9_DEBUG_ERROR,
-			 "On the wire dirent name too long: %s\n",
-			 nameptr);
-		kfree(nameptr);
-		return ret;
-	}
-	kfree(nameptr);
+	dirent->d_name = nameptr;
 
 	return fake_pdu.offset;
 }
-- 
2.53.0



