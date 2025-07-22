Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5124A2B9A5;
	Tue, 22 Jul 2025 14:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193272; cv=none; b=bl4fbM/sp7tlzFQfeg5f+eprlEswYe1oEEc8IrvsqkIGV6NfUcUohXVwC6dLZ8S5y5Hh9WgcSKfhuCDLnZoSQ8T4qTnUapzTEODz5DYZzYx3Y4xp5XglhG0E8VuFJol48rPZ9pAodJJlppH+sl7eEZqNfBpW4yGcGhn2aZJhK9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193272; c=relaxed/simple;
	bh=x2DEbByyukECbDGN4rcJltAd6MdinJ9F6UsiKHRowS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6V7dI9UtuFt6db8FXVmUUCLgAdy+HtHP11gcWuiqKZWbakx2NkqAWTqIJ2ip9xREiM1vx+fdgMZQx/Mal5mvO8bftLL6ys3jh2YeTUwVDwKfZu42EJahsqZWAJP1DazS5dleuAbRUtia46xDSaUKfzdm1iKCAHasza7pUOrVOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5QaK/Bn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5QaK/Bn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6961C4CEEB;
	Tue, 22 Jul 2025 14:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193272;
	bh=x2DEbByyukECbDGN4rcJltAd6MdinJ9F6UsiKHRowS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5QaK/Bn5ZhtvGkwuVBgE9He2Jfc/1bKn+bBLxv7QXeQyEFOt6GL8kulCJpI/42jA
	 TBCEBBlJj1CYHd8VVIZfPk9a9cDoEu5wW688JpCyEksFRb+Ry/ZTeNw9vak29nVI+o
	 dg6oXvGq1aMtTEzAE9eC4U2yk1S1D4isK9tnm4MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralph Boehme <slow@samba.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 043/187] Fix SMB311 posix special file creation to servers which do not advertise reparse support
Date: Tue, 22 Jul 2025 15:43:33 +0200
Message-ID: <20250722134347.358582595@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 8767cb3fbd514c4cf85b4f516ca30388e846f540 upstream.

Some servers (including Samba), support the SMB3.1.1 POSIX Extensions (which use reparse
points for handling special files) but do not properly advertise file system attribute
FILE_SUPPORTS_REPARSE_POINTS.  Although we don't check for this attribute flag when
querying special file information, we do check it when creating special files which
causes them to fail unnecessarily.   If we have negotiated SMB3.1.1 POSIX Extensions
with the server we can expect the server to support creating special files via
reparse points, and even if the server fails the operation due to really forbidding
creating special files, then it should be no problem and is more likely to return a
more accurate rc in any case (e.g. EACCES instead of EOPNOTSUPP).

Allow creating special files as long as the server supports either reparse points
or the SMB3.1.1 POSIX Extensions (note that if the "sfu" mount option is specified
it uses a different way of storing special files that does not rely on reparse points).

Cc: <stable@vger.kernel.org>
Fixes: 6c06be908ca19 ("cifs: Check if server supports reparse points before using them")
Acked-by: Ralph Boehme <slow@samba.org>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2inode.c |    3 ++-
 fs/smb/client/smb2ops.c   |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1346,7 +1346,8 @@ struct inode *smb2_get_reparse_inode(str
 	 * empty object on the server.
 	 */
 	if (!(le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS))
-		return ERR_PTR(-EOPNOTSUPP);
+		if (!tcon->posix_extensions)
+			return ERR_PTR(-EOPNOTSUPP);
 
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
 			     SYNCHRONIZE | DELETE |
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5246,7 +5246,8 @@ static int smb2_make_node(unsigned int x
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
 		rc = cifs_sfu_make_node(xid, inode, dentry, tcon,
 					full_path, mode, dev);
-	} else if (le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS) {
+	} else if ((le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS)
+		|| (tcon->posix_extensions)) {
 		rc = smb2_mknod_reparse(xid, inode, dentry, tcon,
 					full_path, mode, dev);
 	}


