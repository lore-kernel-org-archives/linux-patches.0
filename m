Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F67926B08D;
	Thu, 13 Feb 2025 15:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459023; cv=none; b=Ab1rfRkLejerbJVA19mdy08z3Ln7BQvt4lToW3ZTlTMVIn0YPtOaxHw5xunUj42yQWRkEiS0bnOxB4tJY8cx2wX26tIKzH7p8i2jQPzNXy4+JkfXCNNu6p2oqCv5rfaBVD9tJliCi8yzdlGAqWEd1YxjPuUrLN08mTeg2x9hT+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459023; c=relaxed/simple;
	bh=XgpNnAlyKJOPtr0XAOggFSU2/pJu10Qpa1T7AVK/R4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UenAceW3RZbmSfZgJBrexagH90YMfPeFP0a7BZ9ig6ytrSDoDqB3gxF9USsQg/ffoPJnbFd4j3kLiezvWBcOh/3kVH0vvgrtUWXUk9LReYgkg7/dZws6kJjgpktUK0GG0gom/1WDXAnM1jdoo5zod4VtOm3yctDqj1KfyS3wTXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0nnf26IB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nnf26IB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26D3C4CEE4;
	Thu, 13 Feb 2025 15:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459023;
	bh=XgpNnAlyKJOPtr0XAOggFSU2/pJu10Qpa1T7AVK/R4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0nnf26IB5cAGk7GaOVNNH1QwdtDtn8can2gKy5cEndsy1vEOzekS1wmhtOBUbWfS3
	 ogMsSbDAtY0GNddO8UvZ1bId21EXoMlIK7NxlioZ+oMJeepwMiLdy7fBrHm/ChjHMF
	 6rSZb7vqjyI7kWPGAq7D8L0GVKb9yfxHKMJTnduQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.13 146/443] cifs: Remove intermediate object of failed create SFU call
Date: Thu, 13 Feb 2025 15:25:11 +0100
Message-ID: <20250213142446.233497104@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5077,6 +5077,7 @@ int __cifs_sfu_make_node(unsigned int xi
 {
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_open_parms oparms;
+	struct cifs_open_info_data idata;
 	struct cifs_io_parms io_parms = {};
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifs_fid fid;
@@ -5146,10 +5147,20 @@ int __cifs_sfu_make_node(unsigned int xi
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
@@ -5164,8 +5175,18 @@ int __cifs_sfu_make_node(unsigned int xi
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


