Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F789DDCB;
	Mon,  4 Mar 2024 21:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588211; cv=none; b=VO7ko/aRDf9vlRBAVlPD6pQfZa/O4OL+Rx+5TVN3UQBk3WY8R4/mHHUYlfdO8lafH/WYJGqy5fEmH0zyx36JKaDuI8cgaik7VcAEPp6NqovB1v077loA0L0xChMMcJpYndAEFxPn/l4P/3oHQ/xWJyLlo6h70Pl+ID58h8J7c14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588211; c=relaxed/simple;
	bh=0tPqminUxoUDDDTuAuOgWsLODCBKsviktsnOP+PftzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRiRWZFl10IxMKu6nx/AutchqGLwYYjkW7XsO6O+FtwR/5ctluiouRSvWxKPa0CNsR9Ps2c6Hpm8pKcYpcU3kER9JAKM6p3MTWaDUZG8eNQG5nCJRpjoWPII0MLgepsY60K5pp/inMNM0rzQ9/dydP91axt9L48GCI44aQ0QlDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7fYwRhV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7fYwRhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1FFC433C7;
	Mon,  4 Mar 2024 21:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588211;
	bh=0tPqminUxoUDDDTuAuOgWsLODCBKsviktsnOP+PftzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7fYwRhV0nqd8tGvnqZdoGY7dRbPPYfqv/D7p4Whq8yMADSUo695HbUnG+yNilRzA
	 MPEGJq+i8Au17GbbopfzY0J1LWnpjNRNwhKtBqzLll9CrKFyUuHZ9/OL61sCe3E6Mt
	 T7GDzrGZ8fgeKplo2uciTQBJIZoAXLcNCUysjy/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/143] ksmbd: fix wrong allocation size update in smb2_open()
Date: Mon,  4 Mar 2024 21:22:04 +0000
Message-ID: <20240304211550.034312021@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit a9f106c765c12d2f58aa33431bd8ce8e9d8a404a ]

When client send SMB2_CREATE_ALLOCATION_SIZE create context, ksmbd update
old size to ->AllocationSize in smb2 create response. ksmbd_vfs_getattr()
should be called after it to get updated stat result.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 3e885cdc5ffc7..e8c03445271d0 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2529,7 +2529,7 @@ static void smb2_new_xattrs(struct ksmbd_tree_connect *tcon, const struct path *
 	da.flags = XATTR_DOSINFO_ATTRIB | XATTR_DOSINFO_CREATE_TIME |
 		XATTR_DOSINFO_ITIME;
 
-	rc = ksmbd_vfs_set_dos_attrib_xattr(mnt_idmap(path->mnt), path, &da, false);
+	rc = ksmbd_vfs_set_dos_attrib_xattr(mnt_idmap(path->mnt), path, &da, true);
 	if (rc)
 		ksmbd_debug(SMB, "failed to store file attribute into xattr\n");
 }
@@ -3198,23 +3198,6 @@ int smb2_open(struct ksmbd_work *work)
 		goto err_out;
 	}
 
-	rc = ksmbd_vfs_getattr(&path, &stat);
-	if (rc)
-		goto err_out;
-
-	if (stat.result_mask & STATX_BTIME)
-		fp->create_time = ksmbd_UnixTimeToNT(stat.btime);
-	else
-		fp->create_time = ksmbd_UnixTimeToNT(stat.ctime);
-	if (req->FileAttributes || fp->f_ci->m_fattr == 0)
-		fp->f_ci->m_fattr =
-			cpu_to_le32(smb2_get_dos_mode(&stat, le32_to_cpu(req->FileAttributes)));
-
-	if (!created)
-		smb2_update_xattrs(tcon, &path, fp);
-	else
-		smb2_new_xattrs(tcon, &path, fp);
-
 	if (file_present || created)
 		ksmbd_vfs_kern_path_unlock(&parent_path, &path);
 
@@ -3315,6 +3298,23 @@ int smb2_open(struct ksmbd_work *work)
 		}
 	}
 
+	rc = ksmbd_vfs_getattr(&path, &stat);
+	if (rc)
+		goto err_out1;
+
+	if (stat.result_mask & STATX_BTIME)
+		fp->create_time = ksmbd_UnixTimeToNT(stat.btime);
+	else
+		fp->create_time = ksmbd_UnixTimeToNT(stat.ctime);
+	if (req->FileAttributes || fp->f_ci->m_fattr == 0)
+		fp->f_ci->m_fattr =
+			cpu_to_le32(smb2_get_dos_mode(&stat, le32_to_cpu(req->FileAttributes)));
+
+	if (!created)
+		smb2_update_xattrs(tcon, &path, fp);
+	else
+		smb2_new_xattrs(tcon, &path, fp);
+
 	memcpy(fp->client_guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
 
 	rsp->StructureSize = cpu_to_le16(89);
-- 
2.43.0



