Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C28B13D896;
	Tue, 23 Jul 2024 18:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760228; cv=none; b=S5rs1jccAA4aMQkmdQBrvoi+aXRS0uA8MtbOjFRiooU1nDyD5C5W2K3tXZJr6yUbuuggPnw8KZzgL/raYS2Z2upZjsQPeYSEdF3aSyWkj6PRdt06Ef/537DCA6b1pOzhHVvK7Lke9WZSArHQAt/xw1v+A+efQ4jWNWUCO6csYnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760228; c=relaxed/simple;
	bh=Qjbl/+mo6iy7JC0Smks8Xl9jaW0UwP/LTEiNwvAPqYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctVMibVA6VHx9sRcikxar/Kd3l+H71IUaw4t77MD9XIiDu2QgKYVvP6sIvTxWblSgrxKCAywEgz+m+PBxKp+g0qEO3bAXNTW8YIDRm2eyTLiYkbFUe372O9FXw4+L4GNCSscCSlLkb63k6VJlAlJ3j5gZGBsLuam4y3cxmvYqf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSGlSbaL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSGlSbaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01250C4AF0A;
	Tue, 23 Jul 2024 18:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760228;
	bh=Qjbl/+mo6iy7JC0Smks8Xl9jaW0UwP/LTEiNwvAPqYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSGlSbaLDsndbPMYE9YSSn/5OxiDQXtFqT7l+i+s8srXzoARNJF/1PW5IUl01cud1
	 RgF8lnHxLRIFpfqvEUjQIS1VnmS075tP9HwztxQEmUTkh8W9zvYlTvvnsNE/jHSok2
	 o7NNkWFM2XYRyHQuQ2drBWhNgjxNBAyB3bNzJT8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 146/163] ksmbd: return FILE_DEVICE_DISK instead of super magic
Date: Tue, 23 Jul 2024 20:24:35 +0200
Message-ID: <20240723180149.112935578@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 25a6e135569b3901452e4863c94560df7c11c492 ]

MS-SMB2 specification describes setting ->DeviceType to FILE_DEVICE_DISK
or FILE_DEVICE_CD_ROM. Set FILE_DEVICE_DISK instead of super magic in
FS_DEVICE_INFORMATION. And Set FILE_READ_ONLY_DEVICE for read-only share.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/common/smb2pdu.h | 34 ++++++++++++++++++++++++++++++++++
 fs/smb/server/smb2pdu.c |  9 +++++++--
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 202ff91281560..694d2b4a4ad99 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -917,6 +917,40 @@ struct smb2_query_directory_rsp {
 	__u8   Buffer[];
 } __packed;
 
+/* DeviceType Flags */
+#define FILE_DEVICE_CD_ROM              0x00000002
+#define FILE_DEVICE_CD_ROM_FILE_SYSTEM  0x00000003
+#define FILE_DEVICE_DFS                 0x00000006
+#define FILE_DEVICE_DISK                0x00000007
+#define FILE_DEVICE_DISK_FILE_SYSTEM    0x00000008
+#define FILE_DEVICE_FILE_SYSTEM         0x00000009
+#define FILE_DEVICE_NAMED_PIPE          0x00000011
+#define FILE_DEVICE_NETWORK             0x00000012
+#define FILE_DEVICE_NETWORK_FILE_SYSTEM 0x00000014
+#define FILE_DEVICE_NULL                0x00000015
+#define FILE_DEVICE_PARALLEL_PORT       0x00000016
+#define FILE_DEVICE_PRINTER             0x00000018
+#define FILE_DEVICE_SERIAL_PORT         0x0000001b
+#define FILE_DEVICE_STREAMS             0x0000001e
+#define FILE_DEVICE_TAPE                0x0000001f
+#define FILE_DEVICE_TAPE_FILE_SYSTEM    0x00000020
+#define FILE_DEVICE_VIRTUAL_DISK        0x00000024
+#define FILE_DEVICE_NETWORK_REDIRECTOR  0x00000028
+
+/* Device Characteristics */
+#define FILE_REMOVABLE_MEDIA			0x00000001
+#define FILE_READ_ONLY_DEVICE			0x00000002
+#define FILE_FLOPPY_DISKETTE			0x00000004
+#define FILE_WRITE_ONCE_MEDIA			0x00000008
+#define FILE_REMOTE_DEVICE			0x00000010
+#define FILE_DEVICE_IS_MOUNTED			0x00000020
+#define FILE_VIRTUAL_VOLUME			0x00000040
+#define FILE_DEVICE_SECURE_OPEN			0x00000100
+#define FILE_CHARACTERISTIC_TS_DEVICE		0x00001000
+#define FILE_CHARACTERISTIC_WEBDAV_DEVICE	0x00002000
+#define FILE_PORTABLE_DEVICE			0x00004000
+#define FILE_DEVICE_ALLOW_APPCONTAINER_TRAVERSAL 0x00020000
+
 /*
  * Maximum number of iovs we need for a set-info request.
  * The largest one is rename/hardlink
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7d26fdcebbf98..840c71c66b30b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5323,8 +5323,13 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 
 		info = (struct filesystem_device_info *)rsp->Buffer;
 
-		info->DeviceType = cpu_to_le32(stfs.f_type);
-		info->DeviceCharacteristics = cpu_to_le32(0x00000020);
+		info->DeviceType = cpu_to_le32(FILE_DEVICE_DISK);
+		info->DeviceCharacteristics =
+			cpu_to_le32(FILE_DEVICE_IS_MOUNTED);
+		if (!test_tree_conn_flag(work->tcon,
+					 KSMBD_TREE_CONN_FLAG_WRITABLE))
+			info->DeviceCharacteristics |=
+				cpu_to_le32(FILE_READ_ONLY_DEVICE);
 		rsp->OutputBufferLength = cpu_to_le32(8);
 		break;
 	}
-- 
2.43.0



