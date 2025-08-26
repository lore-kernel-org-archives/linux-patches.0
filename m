Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955D9350D61;
	Tue, 26 Aug 2025 13:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216103; cv=none; b=Bz7JaFVu9Bf1k2l/1ERMfTmV9jlit9zOg4fQMvgKlRyHj8cQKZ2pMLTprTb9Zm852If3Kd5U8PHeu6Xvi8kFZT5etDrYPSL4PXrLv2O/3iI8vDDbT460D0dF6cVHrF/c6mdRJDHNe91iGzMvsrE6doMh6hRCLV0YkELU1b7frU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216103; c=relaxed/simple;
	bh=lCMTqazBoeNqF5A10hN5yc0X3I5HvWdiQ2ZJdPtAUX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7OycddKmhSVqMzddhCL1d/9Ewc487THD9E6rmxp4t7YSrnuhAbaNPCkRKCPUWWDuUTDvabwalIr5u85a2TzMIwxDYJTgFTzZnn4Ud7oXnhmpql3xhQItJZX27PXat6fmNPz7EhbGfWC7dBUMktyVmwhhVlAVTV6AZWS0WF0zL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5d4s6p4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5d4s6p4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8CFC113CF;
	Tue, 26 Aug 2025 13:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216103;
	bh=lCMTqazBoeNqF5A10hN5yc0X3I5HvWdiQ2ZJdPtAUX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5d4s6p4zQDbP8tMHnkIy7BedSOPv0tIiZ07pdTHPKD2zDNbnMv1GdO3+W7dc97qy
	 TIRZBV18FihlzeJW/s8qmhSsuQK24Rn+AOZ3T2FosKAcRkPcqJocJHl/choSnfoDOz
	 Mo6nj1yJtTV1SSYj5vbW1nIyh1Af2hI3ze+6GESk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 285/644] smb/server: avoid deadlock when linking with ReplaceIfExists
Date: Tue, 26 Aug 2025 13:06:16 +0200
Message-ID: <20250826110953.443128971@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neil@brown.name>

[ Upstream commit d5fc1400a34b4ea5e8f2ce296ea12bf8c8421694 ]

If smb2_create_link() is called with ReplaceIfExists set and the name
does exist then a deadlock will happen.

ksmbd_vfs_kern_path_locked() will return with success and the parent
directory will be locked.  ksmbd_vfs_remove_file() will then remove the
file.  ksmbd_vfs_link() will then be called while the parent is still
locked.  It will try to lock the same parent and will deadlock.

This patch moves the ksmbd_vfs_kern_path_unlock() call to *before*
ksmbd_vfs_link() and then simplifies the code, removing the file_present
flag variable.

Signed-off-by: NeilBrown <neil@brown.name>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 76334a983cd2..3439dbad9389 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5612,7 +5612,6 @@ static int smb2_create_link(struct ksmbd_work *work,
 {
 	char *link_name = NULL, *target_name = NULL, *pathname = NULL;
 	struct path path, parent_path;
-	bool file_present = false;
 	int rc;
 
 	if (buf_len < (u64)sizeof(struct smb2_file_link_info) +
@@ -5645,11 +5644,8 @@ static int smb2_create_link(struct ksmbd_work *work,
 	if (rc) {
 		if (rc != -ENOENT)
 			goto out;
-	} else
-		file_present = true;
-
-	if (file_info->ReplaceIfExists) {
-		if (file_present) {
+	} else {
+		if (file_info->ReplaceIfExists) {
 			rc = ksmbd_vfs_remove_file(work, &path);
 			if (rc) {
 				rc = -EINVAL;
@@ -5657,21 +5653,17 @@ static int smb2_create_link(struct ksmbd_work *work,
 					    link_name);
 				goto out;
 			}
-		}
-	} else {
-		if (file_present) {
+		} else {
 			rc = -EEXIST;
 			ksmbd_debug(SMB, "link already exists\n");
 			goto out;
 		}
+		ksmbd_vfs_kern_path_unlock(&parent_path, &path);
 	}
-
 	rc = ksmbd_vfs_link(work, target_name, link_name);
 	if (rc)
 		rc = -EINVAL;
 out:
-	if (file_present)
-		ksmbd_vfs_kern_path_unlock(&parent_path, &path);
 
 	if (!IS_ERR(link_name))
 		kfree(link_name);
-- 
2.39.5



