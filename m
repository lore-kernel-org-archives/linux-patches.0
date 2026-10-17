Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458113AAF60;
	Sat, 17 Oct 2026 17:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258393; cv=none; b=nNNOddrPK7UIU02VbN0zeYIqWHrmYuGvBApg2s0mY3vuTjZq2ZBgXBHnF67VRehjTDzl+Fe0jY+H5kpxjZe06+ISdaIJbbp/leGYB0wlmbkEp0gChVmwc+OZB8Sok4SodAGPppxYXWl7uvO9yky1c1MpsXB2j72JSZty7l4Kgp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258393; c=relaxed/simple;
	bh=JuAi+noSOx2QO5BXdQnrNDNJuzNiqe5oNWlqNwhLQP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJMyE1t7HJ/bvd+Vl5NoMaV/vh2+qluYbvomO2cdbFOgJfD6e1uJgNAE/wQNUlL+XOmaHowPEGGYJzb32RtlMw220Aed7cO01YFo9p+6Py2rWt9Qb/L/nIadVjwBTMC1fY6TRovG8iKVnoC+vBMJQdlAyzZpq0OCAIaKblv5O9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+r+RZRN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+r+RZRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEA01F000C4;
	Sat, 17 Oct 2026 17:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258391;
	bh=WXCveqR4d6BfP6flOcerxQd/kgZThn7dUXVH6y2FBM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+r+RZRN9cufTzwUfGwS2+kD6gRYLX7Yg/4nvqOqBYs7/RVNlb82Q/nXLSbVaIIV+
	 aYXcqoyKp5kXhEq2yPf9S10VqmDc3hx+xLu2NuLAEQJ0dy8ruMRjEkGVDuAHoqDcqY
	 ETe/hj+HuCDfGEKxhFgcyUc0nm8PGp+I49bFDV/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0869/1674] ksmbd: use volume UUID in FS_OBJECT_ID_INFORMATION
Date: Sat, 17 Oct 2026 17:52:21 +0200
Message-ID: <20261017160453.418751474@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 3a64125730cabc34fccfbc230c2667c2e14f7308 ]

Use sb->s_uuid for a proper volume identifier as the primary choice.
For filesystems that do not provide a UUID, fall back to stfs.f_fsid
obtained from vfs_statfs().

Cc: stable@vger.kernel.org
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b6b67a9e09a98..4f4307ce1482d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5543,7 +5543,6 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 				    struct smb2_query_info_req *req,
 				    struct smb2_query_info_rsp *rsp)
 {
-	struct ksmbd_session *sess = work->sess;
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_share_config *share = work->tcon->share_conf;
 	int fsinfoclass = 0;
@@ -5679,10 +5678,11 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 
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
-- 
2.53.0



