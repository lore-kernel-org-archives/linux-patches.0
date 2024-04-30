Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B8012C499;
	Tue, 30 Apr 2024 10:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474424; cv=none; b=ZEOKeNCyp5/M/jrj99M4JKY8BOniRxxouJeDvtgDsJNbopZuUBzGdaZq22ceL/nbH97qQ+ILQlIGR0tEdUx47R/BkUFjcYRjJR0jV06d0a74+pAwMqa9Qt/VOxSBsIaK8NSjDiJ5t6jjMJpTcpTf06PipmcaXM2CYp+uQtVl2LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474424; c=relaxed/simple;
	bh=PNRIhRX6fNbM4TLUcErpZ1RmkG+furojVYgGpZ3rrw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXL+AJKj5V24JeGI0o7qGwiR5o1fcODGjIr5rOUHGAqzdDua6bpOqJyUXbCYGTz9RKwkyUSZ0Blg1Y2mnW+eYcGywIynG7k38QdFYiD5ruyuBT7xdPXAz80y1xPXPWbdraPIljhXti+UnV4cqxEyhWXz2q2vC/7liR1FwpJkBKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e65GGZup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e65GGZup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A63C2BBFC;
	Tue, 30 Apr 2024 10:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474424;
	bh=PNRIhRX6fNbM4TLUcErpZ1RmkG+furojVYgGpZ3rrw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e65GGZupm5dN3vi3yfxtO7fXEaaTykyIgppuUlXYOYOyvnePSWjMlSZUDEgowD3kx
	 0ifvrTtwpl+BD8lOQc1LhNBx1Re+zcGd1DKXw3mho5n4FMTOdqzzT5iuxoSl9aZRET
	 v4eJFdQybyLu7KdDrXuS0FaE1MEmqC/2ZVlU9Uso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 153/228] smb: client: Fix struct_group() usage in __packed structs
Date: Tue, 30 Apr 2024 12:38:51 +0200
Message-ID: <20240430103108.221521287@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit 9a1f1d04f63c59550a5364858b46eeffdf03e8d6 upstream.

Use struct_group_attr() in __packed structs, instead of struct_group().

Below you can see the pahole output before/after changes:

pahole -C smb2_file_network_open_info fs/smb/client/smb2ops.o
struct smb2_file_network_open_info {
	union {
		struct {
			__le64     CreationTime;         /*     0     8 */
			__le64     LastAccessTime;       /*     8     8 */
			__le64     LastWriteTime;        /*    16     8 */
			__le64     ChangeTime;           /*    24     8 */
			__le64     AllocationSize;       /*    32     8 */
			__le64     EndOfFile;            /*    40     8 */
			__le32     Attributes;           /*    48     4 */
		};                                       /*     0    56 */
		struct {
			__le64     CreationTime;         /*     0     8 */
			__le64     LastAccessTime;       /*     8     8 */
			__le64     LastWriteTime;        /*    16     8 */
			__le64     ChangeTime;           /*    24     8 */
			__le64     AllocationSize;       /*    32     8 */
			__le64     EndOfFile;            /*    40     8 */
			__le32     Attributes;           /*    48     4 */
		} network_open_info;                     /*     0    56 */
	};                                               /*     0    56 */
	__le32                     Reserved;             /*    56     4 */

	/* size: 60, cachelines: 1, members: 2 */
	/* last cacheline: 60 bytes */
} __attribute__((__packed__));

pahole -C smb2_file_network_open_info fs/smb/client/smb2ops.o
struct smb2_file_network_open_info {
	union {
		struct {
			__le64     CreationTime;         /*     0     8 */
			__le64     LastAccessTime;       /*     8     8 */
			__le64     LastWriteTime;        /*    16     8 */
			__le64     ChangeTime;           /*    24     8 */
			__le64     AllocationSize;       /*    32     8 */
			__le64     EndOfFile;            /*    40     8 */
			__le32     Attributes;           /*    48     4 */
		} __attribute__((__packed__));           /*     0    52 */
		struct {
			__le64     CreationTime;         /*     0     8 */
			__le64     LastAccessTime;       /*     8     8 */
			__le64     LastWriteTime;        /*    16     8 */
			__le64     ChangeTime;           /*    24     8 */
			__le64     AllocationSize;       /*    32     8 */
			__le64     EndOfFile;            /*    40     8 */
			__le32     Attributes;           /*    48     4 */
		} __attribute__((__packed__)) network_open_info;       /*     0    52 */
	};                                               /*     0    52 */
	__le32                     Reserved;             /*    52     4 */

	/* size: 56, cachelines: 1, members: 2 */
	/* last cacheline: 56 bytes */
};

pahole -C smb_com_open_rsp fs/smb/client/cifssmb.o
struct smb_com_open_rsp {
	...

	union {
		struct {
			__le64     CreationTime;         /*    48     8 */
			__le64     LastAccessTime;       /*    56     8 */
			/* --- cacheline 1 boundary (64 bytes) --- */
			__le64     LastWriteTime;        /*    64     8 */
			__le64     ChangeTime;           /*    72     8 */
			__le32     FileAttributes;       /*    80     4 */
		};                                       /*    48    40 */
		struct {
			__le64     CreationTime;         /*    48     8 */
			__le64     LastAccessTime;       /*    56     8 */
			/* --- cacheline 1 boundary (64 bytes) --- */
			__le64     LastWriteTime;        /*    64     8 */
			__le64     ChangeTime;           /*    72     8 */
			__le32     FileAttributes;       /*    80     4 */
		} common_attributes;                     /*    48    40 */
	};                                               /*    48    40 */

	...

	/* size: 111, cachelines: 2, members: 14 */
	/* last cacheline: 47 bytes */
} __attribute__((__packed__));

pahole -C smb_com_open_rsp fs/smb/client/cifssmb.o
struct smb_com_open_rsp {
	...

	union {
		struct {
			__le64     CreationTime;         /*    48     8 */
			__le64     LastAccessTime;       /*    56     8 */
			/* --- cacheline 1 boundary (64 bytes) --- */
			__le64     LastWriteTime;        /*    64     8 */
			__le64     ChangeTime;           /*    72     8 */
			__le32     FileAttributes;       /*    80     4 */
		} __attribute__((__packed__));           /*    48    36 */
		struct {
			__le64     CreationTime;         /*    48     8 */
			__le64     LastAccessTime;       /*    56     8 */
			/* --- cacheline 1 boundary (64 bytes) --- */
			__le64     LastWriteTime;        /*    64     8 */
			__le64     ChangeTime;           /*    72     8 */
			__le32     FileAttributes;       /*    80     4 */
		} __attribute__((__packed__)) common_attributes;       /*    48    36 */
	};                                               /*    48    36 */

	...

	/* size: 107, cachelines: 2, members: 14 */
	/* last cacheline: 43 bytes */
} __attribute__((__packed__));

pahole -C FILE_ALL_INFO fs/smb/client/cifssmb.o
typedef struct {
	union {
		struct {
			__le64     CreationTime;         /*     0     8 */
			__le64     LastAccessTime;       /*     8     8 */
			__le64     LastWriteTime;        /*    16     8 */
			__le64     ChangeTime;           /*    24     8 */
			__le32     Attributes;           /*    32     4 */
		};                                       /*     0    40 */
		struct {
			__le64     CreationTime;         /*     0     8 */
			__le64     LastAccessTime;       /*     8     8 */
			__le64     LastWriteTime;        /*    16     8 */
			__le64     ChangeTime;           /*    24     8 */
			__le32     Attributes;           /*    32     4 */
		} common_attributes;                     /*     0    40 */
	};                                               /*     0    40 */

	...

	/* size: 113, cachelines: 2, members: 17 */
	/* last cacheline: 49 bytes */
} __attribute__((__packed__)) FILE_ALL_INFO;

pahole -C FILE_ALL_INFO fs/smb/client/cifssmb.o
typedef struct {
	union {
		struct {
			__le64     CreationTime;         /*     0     8 */
			__le64     LastAccessTime;       /*     8     8 */
			__le64     LastWriteTime;        /*    16     8 */
			__le64     ChangeTime;           /*    24     8 */
			__le32     Attributes;           /*    32     4 */
		} __attribute__((__packed__));           /*     0    36 */
		struct {
			__le64     CreationTime;         /*     0     8 */
			__le64     LastAccessTime;       /*     8     8 */
			__le64     LastWriteTime;        /*    16     8 */
			__le64     ChangeTime;           /*    24     8 */
			__le32     Attributes;           /*    32     4 */
		} __attribute__((__packed__)) common_attributes;       /*     0    36 */
	};                                               /*     0    36 */

	...

	/* size: 109, cachelines: 2, members: 17 */
	/* last cacheline: 45 bytes */
} __attribute__((__packed__)) FILE_ALL_INFO;

Fixes: 0015eb6e1238 ("smb: client, common: fix fortify warnings")
Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifspdu.h |    4 ++--
 fs/smb/client/smb2pdu.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -882,7 +882,7 @@ typedef struct smb_com_open_rsp {
 	__u8 OplockLevel;
 	__u16 Fid;
 	__le32 CreateAction;
-	struct_group(common_attributes,
+	struct_group_attr(common_attributes, __packed,
 		__le64 CreationTime;
 		__le64 LastAccessTime;
 		__le64 LastWriteTime;
@@ -2266,7 +2266,7 @@ typedef struct {
 /* QueryFileInfo/QueryPathinfo (also for SetPath/SetFile) data buffer formats */
 /******************************************************************************/
 typedef struct { /* data block encoding of response to level 263 QPathInfo */
-	struct_group(common_attributes,
+	struct_group_attr(common_attributes, __packed,
 		__le64 CreationTime;
 		__le64 LastAccessTime;
 		__le64 LastWriteTime;
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -319,7 +319,7 @@ struct smb2_file_reparse_point_info {
 } __packed;
 
 struct smb2_file_network_open_info {
-	struct_group(network_open_info,
+	struct_group_attr(network_open_info, __packed,
 		__le64 CreationTime;
 		__le64 LastAccessTime;
 		__le64 LastWriteTime;


