Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B34339711;
	Fri, 17 Oct 2025 15:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715230; cv=none; b=ho3IH8Sy5mUBv1MKXrE7VnbyRGPIOYH9yKE53YdANAJnz69WG3plXWoxseFJsY1b3nselYkGfr/wGtO6dInKzO+tWRqfy1Fbkb7EyJ6oPkxlb/CVUaMaXtK7uEwH+y/nPjf0Ow8xO6nh/NUUF1YUJuOW0o79kef5V8V/Eo2zLJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715230; c=relaxed/simple;
	bh=0Os194jqDh01CVkU7lL1yuZzeYVaphZBGWwHiVi/OIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n2XBKmfdM7brk2z5ZA3t93Fi3mGRxT4WMz8EWkCDOFzVzUl8PAoqa3Mp50awVosL59WhhF5RMfaWQldMtH1J5GUPcJ60DKAPIkE6tTIft9K4relx/JkNmdV/64E8fDmU0lAGgvjJQf+jYbnaioI+1bVyeN8kgfChlxL6vWbuCqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gB7zr3Yr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gB7zr3Yr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0993BC4CEE7;
	Fri, 17 Oct 2025 15:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715230;
	bh=0Os194jqDh01CVkU7lL1yuZzeYVaphZBGWwHiVi/OIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gB7zr3Yr39K2fSlBc+xpJbSJmI/uccqRdpZZ2zKud60dQ/bTC/VC6lFkaO3rv4Shn
	 AUQQDBUUgR+DiejnxPjbkIE6rlfMOV0Snogl6j1kjEPzzg+VIs78zjL3o6aD/cnArH
	 7hgF9kYDH/KqOfm8laelpHLmqd0lOsqILoCviPEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 126/371] cifs: Query EA $LXMOD in cifs_query_path_info() for WSL reparse points
Date: Fri, 17 Oct 2025 16:51:41 +0200
Message-ID: <20251017145206.492397359@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 057ac50638bcece64b3b436d3a61b70ed6c01a34 ]

EA $LXMOD is required for WSL non-symlink reparse points.

Fixes: ef86ab131d91 ("cifs: Fix querying of WSL CHR and BLK reparse points over SMB1")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb1ops.c | 62 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index a02d41d1ce4a3..3fdbb71036cff 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -651,14 +651,72 @@ static int cifs_query_path_info(const unsigned int xid,
 	}
 
 #ifdef CONFIG_CIFS_XATTR
+	/*
+	 * For non-symlink WSL reparse points it is required to fetch
+	 * EA $LXMOD which contains in its S_DT part the mandatory file type.
+	 */
+	if (!rc && data->reparse_point) {
+		struct smb2_file_full_ea_info *ea;
+		u32 next = 0;
+
+		ea = (struct smb2_file_full_ea_info *)data->wsl.eas;
+		do {
+			ea = (void *)((u8 *)ea + next);
+			next = le32_to_cpu(ea->next_entry_offset);
+		} while (next);
+		if (le16_to_cpu(ea->ea_value_length)) {
+			ea->next_entry_offset = cpu_to_le32(ALIGN(sizeof(*ea) +
+						ea->ea_name_length + 1 +
+						le16_to_cpu(ea->ea_value_length), 4));
+			ea = (void *)((u8 *)ea + le32_to_cpu(ea->next_entry_offset));
+		}
+
+		rc = CIFSSMBQAllEAs(xid, tcon, full_path, SMB2_WSL_XATTR_MODE,
+				    &ea->ea_data[SMB2_WSL_XATTR_NAME_LEN + 1],
+				    SMB2_WSL_XATTR_MODE_SIZE, cifs_sb);
+		if (rc == SMB2_WSL_XATTR_MODE_SIZE) {
+			ea->next_entry_offset = cpu_to_le32(0);
+			ea->flags = 0;
+			ea->ea_name_length = SMB2_WSL_XATTR_NAME_LEN;
+			ea->ea_value_length = cpu_to_le16(SMB2_WSL_XATTR_MODE_SIZE);
+			memcpy(&ea->ea_data[0], SMB2_WSL_XATTR_MODE, SMB2_WSL_XATTR_NAME_LEN + 1);
+			data->wsl.eas_len += ALIGN(sizeof(*ea) + SMB2_WSL_XATTR_NAME_LEN + 1 +
+						   SMB2_WSL_XATTR_MODE_SIZE, 4);
+			rc = 0;
+		} else if (rc >= 0) {
+			/* It is an error if EA $LXMOD has wrong size. */
+			rc = -EINVAL;
+		} else {
+			/*
+			 * In all other cases ignore error if fetching
+			 * of EA $LXMOD failed. It is needed only for
+			 * non-symlink WSL reparse points and wsl_to_fattr()
+			 * handle the case when EA is missing.
+			 */
+			rc = 0;
+		}
+	}
+
 	/*
 	 * For WSL CHR and BLK reparse points it is required to fetch
 	 * EA $LXDEV which contains major and minor device numbers.
 	 */
 	if (!rc && data->reparse_point) {
 		struct smb2_file_full_ea_info *ea;
+		u32 next = 0;
 
 		ea = (struct smb2_file_full_ea_info *)data->wsl.eas;
+		do {
+			ea = (void *)((u8 *)ea + next);
+			next = le32_to_cpu(ea->next_entry_offset);
+		} while (next);
+		if (le16_to_cpu(ea->ea_value_length)) {
+			ea->next_entry_offset = cpu_to_le32(ALIGN(sizeof(*ea) +
+						ea->ea_name_length + 1 +
+						le16_to_cpu(ea->ea_value_length), 4));
+			ea = (void *)((u8 *)ea + le32_to_cpu(ea->next_entry_offset));
+		}
+
 		rc = CIFSSMBQAllEAs(xid, tcon, full_path, SMB2_WSL_XATTR_DEV,
 				    &ea->ea_data[SMB2_WSL_XATTR_NAME_LEN + 1],
 				    SMB2_WSL_XATTR_DEV_SIZE, cifs_sb);
@@ -668,8 +726,8 @@ static int cifs_query_path_info(const unsigned int xid,
 			ea->ea_name_length = SMB2_WSL_XATTR_NAME_LEN;
 			ea->ea_value_length = cpu_to_le16(SMB2_WSL_XATTR_DEV_SIZE);
 			memcpy(&ea->ea_data[0], SMB2_WSL_XATTR_DEV, SMB2_WSL_XATTR_NAME_LEN + 1);
-			data->wsl.eas_len = sizeof(*ea) + SMB2_WSL_XATTR_NAME_LEN + 1 +
-					    SMB2_WSL_XATTR_DEV_SIZE;
+			data->wsl.eas_len += ALIGN(sizeof(*ea) + SMB2_WSL_XATTR_NAME_LEN + 1 +
+						   SMB2_WSL_XATTR_MODE_SIZE, 4);
 			rc = 0;
 		} else if (rc >= 0) {
 			/* It is an error if EA $LXDEV has wrong size. */
-- 
2.51.0



