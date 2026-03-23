Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DC53B0AF8;
	Mon, 23 Mar 2026 14:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274528; cv=none; b=LxEelpRFIEJ0CobBN1nZC4pu19kDueEq96HJ/FuB+x3u9cYjBo1w1WIih1N8DOCJsgGAZcPMfABq1FPXW1Seet5mLmRfvz6Mcl4D3uUWy+9MYF21CAsw2qbfWRZxEdcXdZtmcyu3pTqimtB26dlFEy4RP6knigh0FfTuOvuMbsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274528; c=relaxed/simple;
	bh=hOgAKDatKaiFXUSIZv4KDyfuMB/b3BLC+d6H13PfIwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDp4CSP9J/ml5QmP07+y65p5//IbA/COrfM18cjPXLbRGjta0oSGWd2w4QCw6xz7vlG2AYcaJIV6ccCKMbJYiQXGfuLiYWi7W0dAiwitlB7usweLSKPCxxi+sREV9SIkKpbjHRbV+uUXk85YOlhyKSBdaaLlzgmWVS7PO8UTClc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3FY1Mtu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3FY1Mtu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123B3C4CEF7;
	Mon, 23 Mar 2026 14:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274527;
	bh=hOgAKDatKaiFXUSIZv4KDyfuMB/b3BLC+d6H13PfIwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k3FY1Mtuaq6Iy/iXBuIj1fGPK1WedvhXvoxxb4F8c+QmQeWdhWHnN5Y0CMgcjQj0N
	 IXiqTtbchbnw2mlAxKoDimlWOpmDPK9btHUkT1A0jPCJroxWM+3W5ZZCeDyLuWsUjS
	 8va1hIVD3eZOAqj2Mk13iRry7kpQDJ9om24AL/mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 025/212] ksmbd: use volume UUID in FS_OBJECT_ID_INFORMATION
Date: Mon, 23 Mar 2026 14:44:06 +0100
Message-ID: <20260323134504.551934664@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5462,7 +5462,6 @@ static int smb2_get_info_filesystem(stru
 				    struct smb2_query_info_req *req,
 				    struct smb2_query_info_rsp *rsp)
 {
-	struct ksmbd_session *sess = work->sess;
 	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_share_config *share = work->tcon->share_conf;
 	int fsinfoclass = 0;
@@ -5592,10 +5591,11 @@ static int smb2_get_info_filesystem(stru
 
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


