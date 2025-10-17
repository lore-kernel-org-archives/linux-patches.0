Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F18289811;
	Fri, 17 Oct 2025 15:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714247; cv=none; b=BUcT+65sx89noKT0jNRRhvGQodRRZJivdbd6xYFbuhx5p62WBQcET8KmNfIAenkLZORqx/rNY/dq7ye4bXpBc4I5C4mm3Tc5MpxmS2XRLAooF5I1QzA+9lMRKf0KAygPDjXnUevKCoWMwQiGiyu0u1gL2uIizQhRdamdRnZ8j7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714247; c=relaxed/simple;
	bh=PObRQY1DI4rYFluVzHUidWLnY+7lSO1A5m1h/qMeQRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=htNvPccPioUggbQ+F+NR9pq74zhPKsmyVSOSeFarQ8dSnK7Tms2PO/mIYoIV2aHPST5GIPRb+SGlN0q88LV0lvIok2lWBpmclfkEgYHK6Tc1yI50XSlwMPOl+ZRkZ6kEJTp83lYkAekZm9+v0mf25Sj0F/ijaKrzdDi6LhW0Hgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpCJ3xLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpCJ3xLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC6FC4CEE7;
	Fri, 17 Oct 2025 15:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714247;
	bh=PObRQY1DI4rYFluVzHUidWLnY+7lSO1A5m1h/qMeQRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpCJ3xLNKsWRw0hBj0KT/mXRLpeZg5JiXh9nCNilDoD3txj4MvYODWxzvxIUTpN20
	 B1geANhcJ3woevNwA5ojw5QrD50gKbIzBRzepNuFrD0qngCIygxLuCmHdDEcCNKHv5
	 e3MKBhQlyWgeLTdnmx310tgK3/38FT7b/iGEjlm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/277] cifs: Query EA $LXMOD in cifs_query_path_info() for WSL reparse points
Date: Fri, 17 Oct 2025 16:51:26 +0200
Message-ID: <20251017145150.021310148@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0385a514f59e9..4670c3e451a75 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -671,14 +671,72 @@ static int cifs_query_path_info(const unsigned int xid,
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
@@ -688,8 +746,8 @@ static int cifs_query_path_info(const unsigned int xid,
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



