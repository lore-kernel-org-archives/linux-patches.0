Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A313A6B88;
	Mon, 23 Mar 2026 13:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273843; cv=none; b=mwa2RqqeX8zOjrotYNgAsaojSqPDQzDhrXAqyY/GcySGrb0ZwEXt3uAvsvbhorWnubsy48gdL7S3PCFvrNbsNC8az7GM2w4uFbbbooB8HuN3N86zYDp3YgZDReVu525NHco4Gzir9qTWER82T52JOBIN4X7xsQzjcFMi8ObYwS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273843; c=relaxed/simple;
	bh=SaPd7N0Io+SREiC/uaN2tpAHXtspnmkO66XuS/rwMh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+TBCsdbTnR8/MJjUGL/4SZKJhoQ+fuCV8la8hQY18sCQJS7GT74EhA35vxX1w3LA+1w+GPi+/6wiopL8vFZIK0rJCwZHi25k1hLqf55Rfe0pCo+uFSJ2ua4xq0ix994qmN4LrB4ISuT3OCahD5fEatbUD3VYyxb7x+sSUbHIcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKxd5Nf3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKxd5Nf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49BFC4CEF7;
	Mon, 23 Mar 2026 13:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273843;
	bh=SaPd7N0Io+SREiC/uaN2tpAHXtspnmkO66XuS/rwMh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKxd5Nf3IOJalC0fSiMlQhZ2+PnLJdcdO1aJiIvkWkelOGVBKd7ioAJo5x0x+26ZY
	 QMqG2IyGPeEdCYkEofSyeIQZARlRj0RrUlQ50axm7nEcIEm0hgaJ71KT7Pm4JUMmM7
	 jGiFo+ySzOqpBW2Ybr0WRp3wDPTWORpodReCtcbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.19 026/220] ksmbd: use volume UUID in FS_OBJECT_ID_INFORMATION
Date: Mon, 23 Mar 2026 14:43:23 +0100
Message-ID: <20260323134505.408631131@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 3a64125730cabc34fccfbc230c2667c2e14f7308 upstream.

Use sb->s_uuid for a proper volume identifier as the primary choice.
For filesystems that do not provide a UUID, fall back to stfs.f_fsid
obtained from vfs_statfs().

Cc: stable@vger.kernel.org
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5452,7 +5452,6 @@ static int smb2_get_info_filesystem(stru
 				    struct smb2_query_info_req *req,
 				    struct smb2_query_info_rsp *rsp)
 {
-	struct ksmbd_session *sess = work->sess;
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_share_config *share = work->tcon->share_conf;
 	int fsinfoclass = 0;
@@ -5589,10 +5588,11 @@ static int smb2_get_info_filesystem(stru
 
 		info = (struct object_id_info *)(rsp->Buffer);
 
-		if (!user_guest(sess->user))
-			memcpy(info->objid, user_passkey(sess->user), 16);
+		if (path.mnt->mnt_sb->s_uuid_len == 16)
+			memcpy(info->objid, path.mnt->mnt_sb->s_uuid.b,
+					path.mnt->mnt_sb->s_uuid_len);
 		else
-			memset(info->objid, 0, 16);
+			memcpy(info->objid, &stfs.f_fsid, sizeof(stfs.f_fsid));
 
 		info->extended_info.magic = cpu_to_le32(EXTENDED_INFO_MAGIC);
 		info->extended_info.version = cpu_to_le32(1);


