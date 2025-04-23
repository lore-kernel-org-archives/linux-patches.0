Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CA71F5435;
	Wed, 23 Apr 2025 15:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421642; cv=none; b=ggWzu4mrv7LM9xt6h8tQzVbjuNlllncqzVC+e8JQuBYTfEZySRk+2NPkGVYrGS14KC1JFhQ5WbddZ01n/yk8OGnN245KHsLPc06ylGHNt/Gdml8qFzzAZIu8mPGUSr22b2X2zMS7Z2j2A4PNvLkt80scvjGD7SoUPcyBs8b3wFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421642; c=relaxed/simple;
	bh=6PIpxABVYn9QulES4zMEMOqNeqPEbxwvEXAMDAmTR0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=miw31BBd+PzoJjXwnFaHMYwUfdSwNxzm0tYOrZFfJ8qSdDx7uGe8BWbo945VSt5H93W0GCFb92Lu564+RC+rrhNyyTa+PDDB0XLz/Y1z7GeiCnozjd/e/rJw4vUvdgs+17FOEEjA4XI+zmhZwFpmgRGjJdsuAhRiJLuBqB08GQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQqWnLwy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQqWnLwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78556C4CEE2;
	Wed, 23 Apr 2025 15:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421641;
	bh=6PIpxABVYn9QulES4zMEMOqNeqPEbxwvEXAMDAmTR0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQqWnLwyqoztbgVh/qMFaDcb3afelU63Lh101II3FGbWMtuLH3Sp2YNhQbCkaoCPi
	 F6OlR2cUSGn4VSIUv2LU/QJn30xftpA3dje52j1MS9BWVe3oIpHSTgUsyNHAluntWe
	 q4Xf/WzT4FIQXLFuKshJ+JX/IYCk/04LRKmJSN2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junwen Sun <sunjw8888@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 203/393] cifs: Ensure that all non-client-specific reparse points are processed by the server
Date: Wed, 23 Apr 2025 16:41:39 +0200
Message-ID: <20250423142651.775096765@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1145,6 +1145,16 @@ static int reparse_info_to_fattr(struct
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
 		break;
 	}
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -633,8 +633,6 @@ int parse_reparse_point(struct reparse_d
 			const char *full_path,
 			bool unicode, struct cifs_open_info_data *data)
 {
-	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
-
 	data->reparse.buf = buf;
 
 	/* See MS-FSCC 2.1.2 */
@@ -658,8 +656,6 @@ int parse_reparse_point(struct reparse_d
 		}
 		return 0;
 	default:
-		cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag: 0x%08x\n",
-			      le32_to_cpu(buf->ReparseTag));
 		return -EOPNOTSUPP;
 	}
 }


