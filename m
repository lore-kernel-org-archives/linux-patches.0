Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A0D1C5F2D;
	Wed, 19 Mar 2025 14:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394920; cv=none; b=Ss9tsYb00bCZMab0/tzhP2nkDf8RBe/zFrkTddjKQy8CavGQq1ufNqypJhAWbVVkGkFbBCU0J8rAe/yS0bUIwp/wgONQBBXg3ZeGWpoykmFQw5R0tTxTuMHLZDF9kev96V4Rg2twiwIVhX5P/0X9W2+UnoQVh93Mv3/Q16t4k5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394920; c=relaxed/simple;
	bh=Tlb694bVZIz1PGr/J02v9mEkxmbuAZGeHMVf3G52oaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eOk8CEXo6GUmQ6WblcX58hTdjOBskZw1SbvWKLybk3vnfmW2fy+9IpA/MIbmvidSbySpVAkmKhBPLzTER58wk8CGqQAGJtZY4dK34FEhlv9G5VJo9S96saqoxs3pOM/w0Ws50sa+gv/8GWBESI2If1dMh7a+7Hi+j3tvF7azLhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGsOPC8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGsOPC8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB78DC4CEE4;
	Wed, 19 Mar 2025 14:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394920;
	bh=Tlb694bVZIz1PGr/J02v9mEkxmbuAZGeHMVf3G52oaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGsOPC8JBYdZz47ssI3PXtSRVadnZhwzneFSzvTR5VikIJzK8sCtbiD7kWf5jIFIx
	 E0iJRsiN4c9yB6wKOm8WQ5KFye3+OOZPPLJ3EYieiETomiZz5DAEIfMZIyv5OIroJT
	 du6NmpmPDCOMnD+zrCOzIH7ckfUmPW1swoQxdDiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 130/241] cifs: Treat unhandled directory name surrogate reparse points as mount directory nodes
Date: Wed, 19 Mar 2025 07:30:00 -0700
Message-ID: <20250319143030.942252721@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit b587fd128660d48cd2122f870f720ff8e2b4abb3 ]

If the reparse point was not handled (indicated by the -EOPNOTSUPP from
ops->parse_reparse_point() call) but reparse tag is of type name surrogate
directory type, then treat is as a new mount point.

Name surrogate reparse point represents another named entity in the system.

>From SMB client point of view, this another entity is resolved on the SMB
server, and server serves its content automatically. Therefore from Linux
client point of view, this name surrogate reparse point of directory type
crosses mount point.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c    | 13 +++++++++++++
 fs/smb/common/smbfsctl.h |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 4d8effe78be57..a1b06ca07fcc7 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1215,6 +1215,19 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 			rc = server->ops->parse_reparse_point(cifs_sb,
 							      full_path,
 							      iov, data);
+			/*
+			 * If the reparse point was not handled but it is the
+			 * name surrogate which points to directory, then treat
+			 * is as a new mount point. Name surrogate reparse point
+			 * represents another named entity in the system.
+			 */
+			if (rc == -EOPNOTSUPP &&
+			    IS_REPARSE_TAG_NAME_SURROGATE(data->reparse.tag) &&
+			    (le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY)) {
+				rc = 0;
+				cifs_create_junction_fattr(fattr, sb);
+				goto out;
+			}
 		}
 		break;
 	}
diff --git a/fs/smb/common/smbfsctl.h b/fs/smb/common/smbfsctl.h
index 4b379e84c46b9..3253a18ecb5cb 100644
--- a/fs/smb/common/smbfsctl.h
+++ b/fs/smb/common/smbfsctl.h
@@ -159,6 +159,9 @@
 #define IO_REPARSE_TAG_LX_CHR	     0x80000025
 #define IO_REPARSE_TAG_LX_BLK	     0x80000026
 
+/* If Name Surrogate Bit is set, the file or directory represents another named entity in the system. */
+#define IS_REPARSE_TAG_NAME_SURROGATE(tag) (!!((tag) & 0x20000000))
+
 /* fsctl flags */
 /* If Flags is set to this value, the request is an FSCTL not ioctl request */
 #define SMB2_0_IOCTL_IS_FSCTL		0x00000001
-- 
2.39.5



