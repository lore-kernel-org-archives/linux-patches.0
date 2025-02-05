Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CAF151988;
	Wed,  5 Feb 2025 14:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766377; cv=none; b=QmMsAE2CPJB5ycE/BYqOUms47OMlTvHsLx6cNNE9+MQYuaXm1FDbv82A4bZznKpE3Q/pSbu8hjvSwNXqQ7YEQCDQZKvyNCFdVAsd8nTxpAVr594ynnDaEalWRGC4RZ2tFsdoxm+xwVrj8ioE7q+TzHSmpv+FyOquv9CVcHa7DfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766377; c=relaxed/simple;
	bh=V51tno+ENlRNz4hJDNR6/JMf1TRXjdwchlNlroIXFhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WupaqMJy3TLHvvI/jJUQd3sxSXIQKvbG13/bMToZ5RSnLHIqihmJ497ehjW+BWD8pxospMkFX3v3GIianaiKYtYxRrgNyOgIe6fWAQ+lGUmUtuGiCl+yOpCouDUWDNk7cx8k7A0/d8SUPIKSfHuI8WcmkayzyU+QW3zFcdLSqLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MI3aGoqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MI3aGoqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E771C4CED1;
	Wed,  5 Feb 2025 14:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766377;
	bh=V51tno+ENlRNz4hJDNR6/JMf1TRXjdwchlNlroIXFhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MI3aGoqd8whTSQtDHEb1t9zA86YJkV/yi/2F8kd4v1HgUjSUyd4NHdVQeHMn80vfS
	 vGCCeaBdAh7iCnl1zpJ7WjqJyzM5ktQht5yypuKamWm6+oWfoN67KlrePGGCeqEs3o
	 1fRSVtZaiWBvkIwVfMJLTg998ulIC6z+VBeMkm34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 357/393] cifs: Validate EAs for WSL reparse points
Date: Wed,  5 Feb 2025 14:44:36 +0100
Message-ID: <20250205134433.961140089@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

[ Upstream commit ef201e8759d20bf82b5943101147072de12bc524 ]

Major and minor numbers for char and block devices are mandatory for stat.
So check that the WSL EA $LXDEV is present for WSL CHR and BLK reparse
points.

WSL reparse point tag determinate type of the file. But file type is
present also in the WSL EA $LXMOD. So check that both file types are same.

Fixes: 78e26bec4d6d ("smb: client: parse uid, gid, mode and dev from WSL reparse points")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index d3abb99cc9909..e56a8df23fec9 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -674,11 +674,12 @@ int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
 	return parse_reparse_point(buf, plen, cifs_sb, full_path, true, data);
 }
 
-static void wsl_to_fattr(struct cifs_open_info_data *data,
+static bool wsl_to_fattr(struct cifs_open_info_data *data,
 			 struct cifs_sb_info *cifs_sb,
 			 u32 tag, struct cifs_fattr *fattr)
 {
 	struct smb2_file_full_ea_info *ea;
+	bool have_xattr_dev = false;
 	u32 next = 0;
 
 	switch (tag) {
@@ -721,13 +722,24 @@ static void wsl_to_fattr(struct cifs_open_info_data *data,
 			fattr->cf_uid = wsl_make_kuid(cifs_sb, v);
 		else if (!strncmp(name, SMB2_WSL_XATTR_GID, nlen))
 			fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
-		else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen))
+		else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
+			/* File type in reparse point tag and in xattr mode must match. */
+			if (S_DT(fattr->cf_mode) != S_DT(le32_to_cpu(*(__le32 *)v)))
+				return false;
 			fattr->cf_mode = (umode_t)le32_to_cpu(*(__le32 *)v);
-		else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen))
+		} else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
 			fattr->cf_rdev = reparse_mkdev(v);
+			have_xattr_dev = true;
+		}
 	} while (next);
 out:
+
+	/* Major and minor numbers for char and block devices are mandatory. */
+	if (!have_xattr_dev && (tag == IO_REPARSE_TAG_LX_CHR || tag == IO_REPARSE_TAG_LX_BLK))
+		return false;
+
 	fattr->cf_dtype = S_DT(fattr->cf_mode);
+	return true;
 }
 
 static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
@@ -801,7 +813,9 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 	case IO_REPARSE_TAG_AF_UNIX:
 	case IO_REPARSE_TAG_LX_CHR:
 	case IO_REPARSE_TAG_LX_BLK:
-		wsl_to_fattr(data, cifs_sb, tag, fattr);
+		ok = wsl_to_fattr(data, cifs_sb, tag, fattr);
+		if (!ok)
+			return false;
 		break;
 	case IO_REPARSE_TAG_NFS:
 		ok = posix_reparse_to_fattr(cifs_sb, fattr, data);
-- 
2.39.5



