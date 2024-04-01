Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FD0481D7;
	Mon,  1 Apr 2024 16:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989712; cv=none; b=PRzsG9UzgmbMXLv1nekDr/31CwW37EXuOkdU+/Qt2ub5XCnkwqP/N59rPDOugQS4IPXvHJyOLwAlFAcz1r1MAZ21Pl3Jzk/Ho2nyd4AJKV+7S4OXjhmvQBj7+p+rtmb48n+NOlB+aK4cS0UbUiFlnnY6n9EysSkb8ogEPCUKOYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989712; c=relaxed/simple;
	bh=6qv8rJVL7P7ZD+ePADtHXTfa0FHa3Jq2SpxDQlHM43Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxYOiNV8g2hhH7JN7IftrDrxmRLfJ5nChV+UB4ZED8WXGFdtGwcvWG809ccVDQES9rsK1tRS2AK5PFoviOR2OWsfxHhjQPUXF6J/gakN/p2TwHRGE17RRbQXoytd1nBtqg8C0i9bFlaDJZqf90kAUJ1OWjKi/MfAbFZ/v0S7kZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1f/kP8Ul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1f/kP8Ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43074C43390;
	Mon,  1 Apr 2024 16:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989712;
	bh=6qv8rJVL7P7ZD+ePADtHXTfa0FHa3Jq2SpxDQlHM43Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1f/kP8UlI/Io7zxX4c+1v0PaHu94qI/n5ufii6gZiDlShq+njskMY4RgccGLq2YIv
	 Q5HJ2MoMLxAPqYGs87lRF5S/GKM9kgugD6o0TpWxl9/3M9SiPb+nsUmdzYwBqsrlKF
	 CgK1JO6yLsJI9Js6Zg+8oB1+bRGuGNOxULIyEOL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/396] server: convert to new timestamp accessors
Date: Mon,  1 Apr 2024 17:43:00 +0200
Message-ID: <20240401152551.822342886@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 769cfc919e35c70a5110b0843fb330746363acb8 ]

Convert to using the new inode timestamp accessor functions.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20231004185347.80880-67-jlayton@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 5614c8c487f6 ("ksmbd: replace generic_fillattr with vfs_getattr")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e8c03445271d0..0c97d3c860726 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4857,9 +4857,9 @@ static void find_file_posix_info(struct smb2_query_info_rsp *rsp,
 
 	file_info = (struct smb311_posix_qinfo *)rsp->Buffer;
 	file_info->CreationTime = cpu_to_le64(fp->create_time);
-	time = ksmbd_UnixTimeToNT(inode->i_atime);
+	time = ksmbd_UnixTimeToNT(inode_get_atime(inode));
 	file_info->LastAccessTime = cpu_to_le64(time);
-	time = ksmbd_UnixTimeToNT(inode->i_mtime);
+	time = ksmbd_UnixTimeToNT(inode_get_mtime(inode));
 	file_info->LastWriteTime = cpu_to_le64(time);
 	time = ksmbd_UnixTimeToNT(inode_get_ctime(inode));
 	file_info->ChangeTime = cpu_to_le64(time);
@@ -5466,9 +5466,9 @@ int smb2_close(struct ksmbd_work *work)
 		rsp->EndOfFile = cpu_to_le64(inode->i_size);
 		rsp->Attributes = fp->f_ci->m_fattr;
 		rsp->CreationTime = cpu_to_le64(fp->create_time);
-		time = ksmbd_UnixTimeToNT(inode->i_atime);
+		time = ksmbd_UnixTimeToNT(inode_get_atime(inode));
 		rsp->LastAccessTime = cpu_to_le64(time);
-		time = ksmbd_UnixTimeToNT(inode->i_mtime);
+		time = ksmbd_UnixTimeToNT(inode_get_mtime(inode));
 		rsp->LastWriteTime = cpu_to_le64(time);
 		time = ksmbd_UnixTimeToNT(inode_get_ctime(inode));
 		rsp->ChangeTime = cpu_to_le64(time);
-- 
2.43.0



