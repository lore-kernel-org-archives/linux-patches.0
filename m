Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288C714BFB0;
	Thu, 23 May 2024 13:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470689; cv=none; b=j2U2JVU+0aGrB9jtfKHp/1n0EiQIIrDj4Z9Bn0ocxmPvlltzHjeBenwvBME/4rSaLODXlDrzJat8us59P/BgulHv0HwcNGyOKV9ybrC4CGiWA2JxCtzbX9S5RO/ppmOHgY5Tlk7lQ1vXM9/a+jcMl6e2f6+jHB1Zk3Psu/1CY2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470689; c=relaxed/simple;
	bh=Md5B/qbY7tNuY9/sgioKDQrDUwodlDNHyX+ewLQRseA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuX+SoI/zJZxsBKxei6ImPKrKAzGS4fW3JlBWIhTT8zN4Q3Wj4uGlC41inbIVk1wi4bZvZZ1ZR8GWM4Kbmjm1fNCk78tMPLnbGouNYdWvKv068JRZVI2dGrJsHd+SR5FnM4Nybq/45Fn6x4NAOEqHTvp9XzXdHH771TgigKh4FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svyRpCA/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svyRpCA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3A0C3277B;
	Thu, 23 May 2024 13:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470688;
	bh=Md5B/qbY7tNuY9/sgioKDQrDUwodlDNHyX+ewLQRseA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svyRpCA/pP2xY2lfnxnUmz+G8WkfU7jVmvsyFHFe3Q3q1jNk3He4cartmuvvnMuim
	 KsNUzYgAKpzUI8zjxIQWs+LxjtzHmuvTdt+BkNEYoui2atVUilZULVazl1Vqo4Yz+Z
	 V6NkQTra9lu6S2UJ5dsgaBnI0ATwP3MlB0on8BI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/102] cifs: get rid of dup length check in parse_reparse_point()
Date: Thu, 23 May 2024 15:12:47 +0200
Message-ID: <20240523130343.301369464@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 8a3c4e44c243308c2364a00f9944c3d6fbdeb125 ]

smb2_compound_op(SMB2_OP_GET_REPARSE) already checks if ioctl response
has a valid reparse data buffer's length, so there's no need to check
it again in parse_reparse_point().

In order to get rid of duplicate check, validate reparse data buffer's
length also in cifs_query_reparse_point().

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 14 ++++++++++++--
 fs/smb/client/smb2ops.c | 12 ------------
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index e9e33b0b3ac47..01e89070df5ab 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2700,11 +2700,12 @@ int cifs_query_reparse_point(const unsigned int xid,
 			     u32 *tag, struct kvec *rsp,
 			     int *rsp_buftype)
 {
+	struct reparse_data_buffer *buf;
 	struct cifs_open_parms oparms;
 	TRANSACT_IOCTL_REQ *io_req = NULL;
 	TRANSACT_IOCTL_RSP *io_rsp = NULL;
 	struct cifs_fid fid;
-	__u32 data_offset, data_count;
+	__u32 data_offset, data_count, len;
 	__u8 *start, *end;
 	int io_rsp_len;
 	int oplock = 0;
@@ -2774,7 +2775,16 @@ int cifs_query_reparse_point(const unsigned int xid,
 		goto error;
 	}
 
-	*tag = le32_to_cpu(((struct reparse_data_buffer *)start)->ReparseTag);
+	data_count = le16_to_cpu(io_rsp->ByteCount);
+	buf = (struct reparse_data_buffer *)start;
+	len = sizeof(*buf);
+	if (data_count < len ||
+	    data_count < le16_to_cpu(buf->ReparseDataLength) + len) {
+		rc = -EIO;
+		goto error;
+	}
+
+	*tag = le32_to_cpu(buf->ReparseTag);
 	rsp->iov_base = io_rsp;
 	rsp->iov_len = io_rsp_len;
 	*rsp_buftype = CIFS_LARGE_BUFFER;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 9b7cdb7d7ece8..3e07ab1564ea7 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2946,18 +2946,6 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 			u32 plen, struct cifs_sb_info *cifs_sb,
 			bool unicode, struct cifs_open_info_data *data)
 {
-	if (plen < sizeof(*buf)) {
-		cifs_dbg(VFS, "%s: reparse buffer is too small. Must be at least 8 bytes but was %d\n",
-			 __func__, plen);
-		return -EIO;
-	}
-
-	if (plen < le16_to_cpu(buf->ReparseDataLength) + sizeof(*buf)) {
-		cifs_dbg(VFS, "%s: invalid reparse buf length: %d\n",
-			 __func__, plen);
-		return -EIO;
-	}
-
 	data->reparse.buf = buf;
 
 	/* See MS-FSCC 2.1.2 */
-- 
2.43.0



