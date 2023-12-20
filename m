Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B214CE15;
	Wed, 20 Dec 2023 16:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGz2ONWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4A7C433C8;
	Wed, 20 Dec 2023 16:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088779;
	bh=kRfRtORWGJVmVKMdN+zK1jrLHwH4DNFZzcSHuEeQdrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGz2ONWnmNh1igb9lsFOphTCg6c4DjwOZPI4o46P/ZaMI0urjSmo2TTh9hoHXbKy/
	 Ho/f5NZ5KoBGHd5V6rUciUHkhuRbfKO+ju9E4C3bTazJ7cVLbfez+0QNF1LLzHQmNq
	 VP+QYE7FKSqFJARRPjsaPuv1sUyswuG2agZHp7pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 055/159] ksmbd: fill sids in SMB_FIND_FILE_POSIX_INFO response
Date: Wed, 20 Dec 2023 17:08:40 +0100
Message-ID: <20231220160933.907553278@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit d5919f2a1459083bd0aaede7fc44e945290e44df ]

This patch fill missing sids in SMB_FIND_FILE_POSIX_INFO response.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4754,7 +4754,9 @@ static int find_file_posix_info(struct s
 {
 	struct smb311_posix_qinfo *file_info;
 	struct inode *inode = file_inode(fp->filp);
+	struct user_namespace *user_ns = file_mnt_user_ns(fp->filp);
 	u64 time;
+	int out_buf_len = sizeof(struct smb311_posix_qinfo) + 32;
 
 	file_info = (struct smb311_posix_qinfo *)rsp->Buffer;
 	file_info->CreationTime = cpu_to_le64(fp->create_time);
@@ -4771,10 +4773,24 @@ static int find_file_posix_info(struct s
 	file_info->HardLinks = cpu_to_le32(inode->i_nlink);
 	file_info->Mode = cpu_to_le32(inode->i_mode & 0777);
 	file_info->DeviceId = cpu_to_le32(inode->i_rdev);
-	rsp->OutputBufferLength =
-		cpu_to_le32(sizeof(struct smb311_posix_qinfo));
-	inc_rfc1001_len(rsp_org, sizeof(struct smb311_posix_qinfo));
-	return 0;
+
+	/*
+	 * Sids(32) contain two sids(Domain sid(16), UNIX group sid(16)).
+	 * UNIX sid(16) = revision(1) + num_subauth(1) + authority(6) +
+	 *		  sub_auth(4 * 1(num_subauth)) + RID(4).
+	 */
+	id_to_sid(from_kuid_munged(&init_user_ns,
+				   i_uid_into_mnt(user_ns, inode)),
+				   SIDUNIX_USER,
+				   (struct smb_sid *)&file_info->Sids[0]);
+	id_to_sid(from_kgid_munged(&init_user_ns,
+				   i_gid_into_mnt(user_ns, inode)),
+				   SIDUNIX_GROUP,
+				   (struct smb_sid *)&file_info->Sids[16]);
+
+	rsp->OutputBufferLength = cpu_to_le32(out_buf_len);
+	inc_rfc1001_len(rsp_org, out_buf_len);
+	return out_buf_len;
 }
 
 static int smb2_get_info_file(struct ksmbd_work *work,
@@ -4894,8 +4910,8 @@ static int smb2_get_info_file(struct ksm
 			pr_err("client doesn't negotiate with SMB3.1.1 POSIX Extensions\n");
 			rc = -EOPNOTSUPP;
 		} else {
-			rc = find_file_posix_info(rsp, fp, work->response_buf);
-			file_infoclass_size = sizeof(struct smb311_posix_qinfo);
+			file_infoclass_size = find_file_posix_info(rsp, fp,
+					work->response_buf);
 		}
 		break;
 	default:


