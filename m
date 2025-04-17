Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142091A3178;
	Thu, 17 Apr 2025 18:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913555; cv=none; b=NZJgJOP8ZyQFLt8Q/X8ooWasCIUa4w4jaWzWLueuqNyIbYuZb9uOJb7qj1ahw30z8zfIyvLkpNR3eMrIeXU1CWzX/pFpRtf15MtlNqoUxqHxj+rNWPenybzYzkMg6/G26cQqfrLWMY8wPMn+rNGXgBQZzxENnjccdTqH13Efa5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913555; c=relaxed/simple;
	bh=Ocovh4R0O9Q1taEc869PfUVNeNbEgBtXojP0Qi/TKn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WUQrV/IcEPSleHQD00F8NreAvSkBxHeYyTYNom0k9OYbQXMNzpcFvaAQZQtzAy9lszasCtFx3ntBe65QqvtnHrhMJBMBMKz225i5TyjqWA/iJtgkVo1rcBZvSZgTNd/C1K4zNDuz4v3LVnz4Vvh7lIb5afSLpKJoRpi3JY5Js1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOy6cxy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOy6cxy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC22C4CEE7;
	Thu, 17 Apr 2025 18:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913554;
	bh=Ocovh4R0O9Q1taEc869PfUVNeNbEgBtXojP0Qi/TKn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NOy6cxy8YA+lzeU2RUJYqNKAnciXTXJu6sjQ7aS7QI8lXlLDpfF0ANC/L4N3XCRzE
	 keaGqnstBbQ3mBpj3bSoXdcyt0Qac1vwcteAbpvSnwWGX3EstIDlmbguuE0A/pnjIj
	 v5nl+61aWiiTneBvnSIGw93/F1hJGtvlQjmbAjrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junwen Sun <sunjw8888@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 377/449] cifs: Ensure that all non-client-specific reparse points are processed by the server
Date: Thu, 17 Apr 2025 19:51:05 +0200
Message-ID: <20250417175133.429285033@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

commit 6f8a394aa952257575910d57cf0a63627fa949a2 upstream.

Fix regression in mounts to e.g. onedrive shares.

Generally, reparse points are processed by the SMB server during the
SMB OPEN request, but there are few reparse points which do not have
OPEN-like meaning for the SMB server and has to be processed by the SMB
client. Those are symlinks and special files (fifo, socket, block, char).

For Linux SMB client, it is required to process also name surrogate reparse
points as they represent another entity on the SMB server system. Linux
client will mark them as separate mount points. Examples of name surrogate
reparse points are NTFS junction points (e.g. created by the "mklink" tool
on Windows servers).

So after processing the name surrogate reparse points, clear the
-EOPNOTSUPP error code returned from the parse_reparse_point() to let SMB
server to process reparse points.

And remove printing misleading error message "unhandled reparse tag:" as
reparse points are handled by SMB server and hence unhandled fact is normal
operation.

Fixes: cad3fc0a4c8c ("cifs: Throw -EOPNOTSUPP error on unsupported reparse point type from parse_reparse_point()")
Fixes: b587fd128660 ("cifs: Treat unhandled directory name surrogate reparse points as mount directory nodes")
Cc: stable@vger.kernel.org
Reported-by: Junwen Sun <sunjw8888@gmail.com>
Tested-by: Junwen Sun <sunjw8888@gmail.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/inode.c   |   10 ++++++++++
 fs/smb/client/reparse.c |    4 ----
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1228,6 +1228,16 @@ static int reparse_info_to_fattr(struct
 				cifs_create_junction_fattr(fattr, sb);
 				goto out;
 			}
+			/*
+			 * If the reparse point is unsupported by the Linux SMB
+			 * client then let it process by the SMB server. So mask
+			 * the -EOPNOTSUPP error code. This will allow Linux SMB
+			 * client to send SMB OPEN request to server. If server
+			 * does not support this reparse point too then server
+			 * will return error during open the path.
+			 */
+			if (rc == -EOPNOTSUPP)
+				rc = 0;
 		}
 
 		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc) {
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1069,8 +1069,6 @@ int parse_reparse_point(struct reparse_d
 			const char *full_path,
 			struct cifs_open_info_data *data)
 {
-	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
-
 	data->reparse.buf = buf;
 
 	/* See MS-FSCC 2.1.2 */
@@ -1097,8 +1095,6 @@ int parse_reparse_point(struct reparse_d
 		}
 		return 0;
 	default:
-		cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag: 0x%08x\n",
-			      le32_to_cpu(buf->ReparseTag));
 		return -EOPNOTSUPP;
 	}
 }


