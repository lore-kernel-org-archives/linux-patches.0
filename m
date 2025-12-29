Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5B933064B;
	Mon, 29 Dec 2025 16:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024956; cv=none; b=AaLE1NjRaKf67N7NWW7EFTJiHZBRDFZd+5c0VeBD71WeybCOJ9SHj63Pd0Cz4vj8Mw2CrPk2QR7fZYKVvo6uOIqfmotaNkF3DI7NFbZ76J9YpkCVa5MvSmjmNPL0LoacLynyUcqQCsDqv4FH9DU7Ph4neDa7zmDq06uRN9L8DSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024956; c=relaxed/simple;
	bh=E0ZheuBRvOI3aP6yP2qHWUEpUYVj4YzwKms6VfKjZTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpcVkSqjV085B6GAV4aM6CtzpPzX1f16SuHOxPlbsCFx+xw9gUDQW3C6h78QaeYrjrERro6COVwhnpy0/c1ecT/tDxf9LGbfkYofoQYiXtz0gNMOqHnJJE8+Tw0hxwcQt3vED50MU7BvvGUjAT/yNWL9frnqbcvu0Mi7GrbLKJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHMhL1JR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHMhL1JR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EA5C116C6;
	Mon, 29 Dec 2025 16:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024956;
	bh=E0ZheuBRvOI3aP6yP2qHWUEpUYVj4YzwKms6VfKjZTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHMhL1JR7bvJ2VAFQ7W+IE/OsC6Qqu1FJRqRlOheS7Gj+SYOfmiRQQtCVKrW1vuoP
	 aMreRt8DqYZAHbu0stSeNHTyWkfEXDG4Q0ffJM4T5S6KYOboZK8g0jZ7EbXxeq1FMQ
	 Oe2hS+pV1/OQygJxYoGOQLyQNvox7SX3VpNVk7HE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 043/430] smb/server: fix return value of smb2_ioctl()
Date: Mon, 29 Dec 2025 17:07:25 +0100
Message-ID: <20251229160725.951697801@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 269df046c1e15ab34fa26fd90db9381f022a0963 ]

__process_request() will not print error messages if smb2_ioctl()
always returns 0.

Fix this by returning the correct value at the end of function.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f901ae18e68ad..a2830ec67e782 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8164,7 +8164,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 		id = req->VolatileFileId;
 
 	if (req->Flags != cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL)) {
-		rsp->hdr.Status = STATUS_NOT_SUPPORTED;
+		ret = -EOPNOTSUPP;
 		goto out;
 	}
 
@@ -8184,8 +8184,9 @@ int smb2_ioctl(struct ksmbd_work *work)
 	case FSCTL_DFS_GET_REFERRALS:
 	case FSCTL_DFS_GET_REFERRALS_EX:
 		/* Not support DFS yet */
+		ret = -EOPNOTSUPP;
 		rsp->hdr.Status = STATUS_FS_DRIVER_REQUIRED;
-		goto out;
+		goto out2;
 	case FSCTL_CREATE_OR_GET_OBJECT_ID:
 	{
 		struct file_object_buf_type1_ioctl_rsp *obj_buf;
@@ -8475,8 +8476,10 @@ int smb2_ioctl(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_BUFFER_TOO_SMALL;
 	else if (ret < 0 || rsp->hdr.Status == 0)
 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+
+out2:
 	smb2_set_err_rsp(work);
-	return 0;
+	return ret;
 }
 
 /**
-- 
2.51.0



