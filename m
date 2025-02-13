Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646B7281360;
	Thu, 13 Feb 2025 14:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457621; cv=none; b=uVSF2AebFiYzHMpFPiZS2XkEJNAfHp/FQR+B7E5LZmZR6pIo12P8PHgeqaI2L35AgjWMnIpT/IXDnhP+eAqtncoH1VE8IEfB1849RNKDAWtNxORwftrnTnpoKDlJhYIInL89O9a5qIwqW33xDjwft7m7SoaaUTIKERBr7BPmp7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457621; c=relaxed/simple;
	bh=+Zqi9st7eFZdr+6wRfBAFem+0H6hDjGvPVu+EAt8xok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HuVTTMVUb7/QPfw3JxAqozArUShAJqktfAzHXFyqAFOdroHabkt4QNHpJeRPDCtnkpYGljpS3DgDpf9uOqcARga4MSKSuaju8lF19ZiO0G1uCo9/8Kbxj9KCeUDNZRfz9Qu33DElRIz3VlguyrRAyXIg8fcBAbVe7VngwR5q+T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0invaodv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0invaodv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDD1C4CED1;
	Thu, 13 Feb 2025 14:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457621;
	bh=+Zqi9st7eFZdr+6wRfBAFem+0H6hDjGvPVu+EAt8xok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0invaodvp9FiUm7Owd6Y7y/nL6CJrKQ2y2T+xcYsxvpIOxyYcZi80eVX7pFNW29Gd
	 Q7VU6iBTOPPHiRM4hOeUVTSr1Xvu8Tsn2d+lz9sUxSnAmRkuIIzNSIUvDQpMTWgz4c
	 9zdhDYcdx0IrjDARpoBoVv4ASbI2sr8uk5wuL7Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 132/422] cifs: Remove intermediate object of failed create SFU call
Date: Thu, 13 Feb 2025 15:24:41 +0100
Message-ID: <20250213142441.643732132@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

commit 25f6184e24b3991eae977a29ecf27d537cc930b2 upstream.

Check if the server honored ATTR_SYSTEM flag by CREATE_OPTION_SPECIAL
option. If not then server does not support ATTR_SYSTEM and newly
created file is not SFU compatible, which means that the call failed.

If CREATE was successful but either setting ATTR_SYSTEM failed or
writing type/data information failed then remove the intermediate
object created by CREATE. Otherwise intermediate empty object stay
on the server.

This ensures that if the creating of SFU files with system attribute is
unsupported by the server then no empty file stay on the server as a result
of unsupported operation.

This is for example case with Samba server and Linux tmpfs storage without
enabled xattr support (where Samba stores ATTR_SYSTEM bit).

Cc: stable@vger.kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5104,6 +5104,7 @@ int __cifs_sfu_make_node(unsigned int xi
 {
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_open_parms oparms;
+	struct cifs_open_info_data idata;
 	struct cifs_io_parms io_parms = {};
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_fid fid;
@@ -5173,10 +5174,20 @@ int __cifs_sfu_make_node(unsigned int xi
 			     CREATE_OPTION_SPECIAL, ACL_NO_MODE);
 	oparms.fid = &fid;
 
-	rc = server->ops->open(xid, &oparms, &oplock, NULL);
+	rc = server->ops->open(xid, &oparms, &oplock, &idata);
 	if (rc)
 		goto out;
 
+	/*
+	 * Check if the server honored ATTR_SYSTEM flag by CREATE_OPTION_SPECIAL
+	 * option. If not then server does not support ATTR_SYSTEM and newly
+	 * created file is not SFU compatible, which means that the call failed.
+	 */
+	if (!(le32_to_cpu(idata.fi.Attributes) & ATTR_SYSTEM)) {
+		rc = -EOPNOTSUPP;
+		goto out_close;
+	}
+
 	if (type_len + data_len > 0) {
 		io_parms.pid = current->tgid;
 		io_parms.tcon = tcon;
@@ -5191,8 +5202,18 @@ int __cifs_sfu_make_node(unsigned int xi
 					     iov, ARRAY_SIZE(iov)-1);
 	}
 
+out_close:
 	server->ops->close(xid, tcon, &fid);
 
+	/*
+	 * If CREATE was successful but either setting ATTR_SYSTEM failed or
+	 * writing type/data information failed then remove the intermediate
+	 * object created by CREATE. Otherwise intermediate empty object stay
+	 * on the server.
+	 */
+	if (rc)
+		server->ops->unlink(xid, tcon, full_path, cifs_sb, NULL);
+
 out:
 	kfree(symname_utf16);
 	return rc;


