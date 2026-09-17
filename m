Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1464E3224;
	Thu, 17 Sep 2026 15:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660548; cv=none; b=VZRH027xJE/ft0cjRZnIx38Fcqd1ut93+Ynl7yRU4k8F6hsfLORgLrnNwloE97BGy/skkc3rNbjdHhLzQLKkSR4R7isOEaeLAmAv8sLuAKceOYmTApv0qWiaN7eQZV3411SONPXvU0UEmkXbwcEGB4HHEY9CgikpjtaCDQUkkms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660548; c=relaxed/simple;
	bh=16Tu2OSriFGh0HkxR771oN1859xAGpbbq3t2s0Gnr9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJSc9F2dOHIZubVq6UVJQ1JdiITJsEndEPMOcTU7AJ6ljSfQjW0MAyi/q++XcJK1YQM3X3+7X8MrT1y/eoemZSKJzqjGlhNLzgtgo4w3WEvIw+pf3RZ2mxYZBtXpYagxyNldoJNHerfFZwIvE6vgYoTG+r4TsP/dq0WvUfFY1FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sh+8dLE/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sh+8dLE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181A51F000FF;
	Thu, 17 Sep 2026 15:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660546;
	bh=XIAHHeDjJSttV5VWOnbtQWQPUW7AYjarSizLL49yaUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sh+8dLE/ULkzpNs3rhcWld+UosE+ozr0N2dXkbk2v3AC967B+e+wkOyFarj6ZRUyL
	 d2kYE3oIUgFMMU3+JNnFQPJAOueHrq69Ym4aUnu9mX70VQPRZmUuNMBELNu0Qgf5HJ
	 ci4EvzaWJp/jYwVuzoVkOzX4UEecta7LKa6inVpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 7.2 629/733] smb: client: fix WSL reparse point uid/gid override
Date: Thu, 17 Sep 2026 16:15:37 +0100
Message-ID: <20260917151408.236479359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit cd2b2b57921d4caa7875e83198bb2aa71254328b upstream.

wsl_to_fattr() unconditionally overwrites cf_uid/cf_gid with values
from WSL extended attributes ($LXUID/$LXGID), ignoring the forceuid
and forcegid mount options.

Fix this by initializing cf_uid/cf_gid to the mount defaults and
gating the $LXUID/$LXGID EA parsing on forceuid/forcegid.

Closes: https://sashiko.dev/#/patchset/20260906190803.667489-1-pc%40manguebit.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/reparse.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1137,10 +1137,14 @@ static bool wsl_to_fattr(struct cifs_ope
 			 struct cifs_sb_info *cifs_sb,
 			 u32 tag, struct cifs_fattr *fattr)
 {
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
 	struct smb2_file_full_ea_info *ea;
 	bool have_xattr_dev = false;
 	u32 next = 0;
 
+	fattr->cf_uid = cifs_sb->ctx->linux_uid;
+	fattr->cf_gid = cifs_sb->ctx->linux_gid;
+
 	switch (tag) {
 	case IO_REPARSE_TAG_LX_SYMLINK:
 		fattr->cf_mode |= S_IFLNK;
@@ -1177,11 +1181,13 @@ static bool wsl_to_fattr(struct cifs_ope
 		nlen = ea->ea_name_length;
 		v = (void *)((u8 *)ea->ea_data + ea->ea_name_length + 1);
 
-		if (!strncmp(name, SMB2_WSL_XATTR_UID, nlen))
-			fattr->cf_uid = wsl_make_kuid(cifs_sb, v);
-		else if (!strncmp(name, SMB2_WSL_XATTR_GID, nlen))
-			fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
-		else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
+		if (!strncmp(name, SMB2_WSL_XATTR_UID, nlen)) {
+			if (!(sbflags & CIFS_MOUNT_OVERR_UID))
+				fattr->cf_uid = wsl_make_kuid(cifs_sb, v);
+		} else if (!strncmp(name, SMB2_WSL_XATTR_GID, nlen)) {
+			if (!(sbflags & CIFS_MOUNT_OVERR_GID))
+				fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
+		} else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
 			/* File type in reparse point tag and in xattr mode must match. */
 			if (S_DT(fattr->cf_mode) != S_DT(le32_to_cpu(*(__le32 *)v)))
 				return false;


