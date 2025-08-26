Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CA438DD8;
	Tue, 26 Aug 2025 12:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212696; cv=none; b=MIkF28/PL4wq/JZnDLsIPyN8NNur23ytrOcJvDwVI0G8r7tRkRUhtElE4FI3o6CPlr0WcCIbZVxIyDykGJmzIXHsnJ5QvAWy/wbuXDYFUrFsPes7JPQwiHBHRrmpcxx0c7MEGS350vhBETgUcFtDzlNehNGGw7xvlGPbJORTbLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212696; c=relaxed/simple;
	bh=A1juVJRsVfOilUgpx7M6rxSTVXVmEnyxoikVGiIn4tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M28XPwwal3dXPdGJLSHieuVfIfONCQybTNHWM9N9Ef2DA+z9AEmZXU34t2jryeDTIiZ+/Sa4PaXKMjO0X8TvzjQ8F+S7batDkB9kV9xt7jN8YUZy9ZrQSzlPR718p8zutU0rtuN4H/rPJAU0Ct2hg0yql/RyqvskU9z2UF0ddKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvP5bfWa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvP5bfWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C1FC4CEF1;
	Tue, 26 Aug 2025 12:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212696;
	bh=A1juVJRsVfOilUgpx7M6rxSTVXVmEnyxoikVGiIn4tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PvP5bfWaORfZa89GbM4vFXcNJkgoKfPFQ8RQEl75+gT6iFZM4wiT4/WWgJ2Hv8KID
	 VmxMoGfG8/NTKKxEwoK+XAih9QFC2wZ7/tMn5q70AROs/8gOuQFS6k/TmLwrIShFMd
	 ZnmyfaGvfaVu0hDQ5WcZprF2NuSxSBZHJvf5mPSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/587] smb/server: avoid deadlock when linking with ReplaceIfExists
Date: Tue, 26 Aug 2025 13:03:37 +0200
Message-ID: <20250826110954.665029058@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/server/smb2pdu.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d3dd3b9b4005..85e7bc3a2bd3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6011,7 +6011,6 @@ static int smb2_create_link(struct ksmbd_work *work,
 {
 	char *link_name = NULL, *target_name = NULL, *pathname = NULL;
 	struct path path, parent_path;
-	bool file_present = false;
 	int rc;
 
 	if (buf_len < (u64)sizeof(struct smb2_file_link_info) +
@@ -6044,11 +6043,8 @@ static int smb2_create_link(struct ksmbd_work *work,
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
@@ -6056,21 +6052,17 @@ static int smb2_create_link(struct ksmbd_work *work,
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



