Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93589221FCA;
	Mon,  2 Jun 2025 14:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873095; cv=none; b=XBQM2B0NHeT/6NdlY9QAgulvAP3Zy8eG1TFr2udtCjuCccfxMvW7PedXy4JWJswoPkptQZ9ot16+aYWeDJ71iuRQqCSRrLQ4bdoNmzzVILOe942/ErxbKdV/rslkb5rvwwdm4ibgCC6WvdGwFFgsUQl7Uq3AOJYtYdnSEvtlaYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873095; c=relaxed/simple;
	bh=hkKUTc9lYg2pJcfV8mUFQonPfEg4wUlCbyfVD9hpIWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S0gGhp+o3dg2VozPjKMv65FchQqcBpGwq55AAu1M1VXp3fIl/H1kTg4RgYhycUui3LjoYO2hklcV27tHzsa+a0TejVnIv8yBWLYbvmntyDKQb+sv0SV/dzxM9faBQwXpNVqD8F+zthklTNiyPfA4sDjWSgVBNGecTfIT9mylFk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mi2TdIpq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mi2TdIpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBAAC4CEEB;
	Mon,  2 Jun 2025 14:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873095;
	bh=hkKUTc9lYg2pJcfV8mUFQonPfEg4wUlCbyfVD9hpIWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mi2TdIpqtM6tL7ZcD2BM2Jiih6mf6kqnk1/LKcptJXRiQb6VqHuGRwmoM0fkg0hZC
	 eyFt2s+ra6R8o7oZTNjkw0WWWDUrP2wfJd/lJKsqoa3FzZlpvneiQ7jNnvDf9mS+cy
	 DMYfsb58lIk0sgTIL6IK5yU5EuAdfd+r2I5QJbB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/444] cifs: Fix querying and creating MF symlinks over SMB1
Date: Mon,  2 Jun 2025 15:41:40 +0200
Message-ID: <20250602134342.382957223@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

[ Upstream commit 4236ac9fe5b8b42756070d4abfb76fed718e87c2 ]

Old SMB1 servers without CAP_NT_SMBS do not support CIFS_open() function
and instead SMBLegacyOpen() needs to be used. This logic is already handled
in cifs_open_file() function, which is server->ops->open callback function.

So for querying and creating MF symlinks use open callback function instead
of CIFS_open() function directly.

This change fixes querying and creating new MF symlinks on Windows 98.
Currently cifs_query_mf_symlink() is not able to detect MF symlink and
cifs_create_mf_symlink() is failing with EIO error.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/link.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index d86da949a9190..007da0a699cb0 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -257,7 +257,7 @@ cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_io_parms io_parms = {0};
 	int buf_type = CIFS_NO_BUFFER;
-	FILE_ALL_INFO file_info;
+	struct cifs_open_info_data query_data;
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
@@ -269,11 +269,11 @@ cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 		.fid = &fid,
 	};
 
-	rc = CIFS_open(xid, &oparms, &oplock, &file_info);
+	rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, &query_data);
 	if (rc)
 		return rc;
 
-	if (file_info.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
+	if (query_data.fi.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
 		rc = -ENOENT;
 		/* it's not a symlink */
 		goto out;
@@ -312,7 +312,7 @@ cifs_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 		.fid = &fid,
 	};
 
-	rc = CIFS_open(xid, &oparms, &oplock, NULL);
+	rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
 	if (rc)
 		return rc;
 
-- 
2.39.5



