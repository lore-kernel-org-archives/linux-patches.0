Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95504334695;
	Sat, 30 May 2026 17:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162006; cv=none; b=XJnyWSz7ovMMPgUk/PCHlwWwqnwb5GKKv7sUqps3L2HU4KtxCQr5buhyaQvJOc+n6mFopXKE6MzgShwz5JkwsXtZXXSSd59bjqzpBdp7K5a0U8J4dojch0NVvsCYbzYum9/+HJoLbgj34+9HjR/2sgtHS96O3dQhuaomMUSZBfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162006; c=relaxed/simple;
	bh=ykgZG/i4kk0o9ZhUX59VNn/JnxYaUnXJEMwmRL1+2vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o00Vl0uMDGnqP4uXyUB0AEvH6LPWIHtPm0BDFWza18jGxyMWVVEcUj86Jwg4rb4K6V0Robb0h+mZcgRZBhPvHWigjXeC9N3YMw4b0ngmT12u22LYbRjlZEG89mLc1b4VAgnZ+UQpn9jxeY7zLhe5ILAb9t5YiD2RJwDqSbejVRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AwGODUnU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AwGODUnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AAD1F00893;
	Sat, 30 May 2026 17:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162005;
	bh=ROpI0bVBm1KiyQN7zNtVaxOvHLQRoyJw4UmuewKD8ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AwGODUnUkMOYY/9UvVa+3+FpcMsoNI7rDumAnz0KyPmdKCjfTcw5Le7hLYgJrGo50
	 LGBAgkoYp7T05YUg9zv1q5J9DQNEf8SST9Ye7oHiW9yDJ6feg16xHAAkU80pQM2i7S
	 uaO8xKRBHy2DWOSW7TQxzPqtpBbg8zkVfhoWoaKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Jie <liangjie@lixiang.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>,
	Alva Lan <alvalan9@foxmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 791/969] smb: client: correctly handle ErrorContextData as a flexible array
Date: Sat, 30 May 2026 18:05:15 +0200
Message-ID: <20260530160322.454157581@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang Jie <liangjie@lixiang.com>

[ Upstream commit 215b7f9ecb8d7c14d56febdcdd246f3579c32aba ]

The `smb2_symlink_err_rsp` structure was previously defined with
`ErrorContextData` as a single `__u8` byte. However, the `ErrorContextData`
field is intended to be a variable-length array based on `ErrorDataLength`.
This mismatch leads to incorrect pointer arithmetic and potential memory
access issues when processing error contexts.

Updates the `ErrorContextData` field to be a flexible array
(`__u8 ErrorContextData[]`). Additionally, it modifies the corresponding
casts in the `symlink_data()` function to properly handle the flexible
array, ensuring correct memory calculations and data handling.

These changes improve the robustness of SMB2 symlink error processing.

Signed-off-by: Liang Jie <liangjie@lixiang.com>
Suggested-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ Remove the __counted_by_le annotation in v6.1. ]
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2file.c | 4 ++--
 fs/smb/client/smb2pdu.h  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index fe016144f3405..def2602ea0fb9 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -41,14 +41,14 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
 		end = (struct smb2_error_context_rsp *)((u8 *)err + iov->iov_len);
 		do {
 			if (le32_to_cpu(p->ErrorId) == SMB2_ERROR_ID_DEFAULT) {
-				sym = (struct smb2_symlink_err_rsp *)&p->ErrorContextData;
+				sym = (struct smb2_symlink_err_rsp *)p->ErrorContextData;
 				break;
 			}
 			cifs_dbg(FYI, "%s: skipping unhandled error context: 0x%x\n",
 				 __func__, le32_to_cpu(p->ErrorId));
 
 			len = ALIGN(le32_to_cpu(p->ErrorDataLength), 8);
-			p = (struct smb2_error_context_rsp *)((u8 *)&p->ErrorContextData + len);
+			p = (struct smb2_error_context_rsp *)(p->ErrorContextData + len);
 		} while (p < end);
 	} else if (le32_to_cpu(err->ByteCount) >= sizeof(*sym) &&
 		   iov->iov_len >= SMB2_SYMLINK_STRUCT_SIZE) {
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 2823526b66f7e..d12ca9c7e62bc 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -79,7 +79,7 @@ struct smb2_symlink_err_rsp {
 struct smb2_error_context_rsp {
 	__le32 ErrorDataLength;
 	__le32 ErrorId;
-	__u8  ErrorContextData; /* ErrorDataLength long array */
+	__u8  ErrorContextData[];
 } __packed;
 
 /* ErrorId values */
-- 
2.53.0



