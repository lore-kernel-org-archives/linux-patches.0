Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F74422323;
	Thu, 18 Jan 2024 10:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575132; cv=none; b=Qoa+eOzaAlbmqxp0pHO4ot58fXIEthykoIT9klwJ4FndFuwmCT4bOwc3PUHP/bvPTQTZkKxWnVyQ7rfarLUxGSf6OzHk6EGBQHjrBRAwyPoSq3aq5J4E6WCGEzwBZFdaw4Kg3+HkF8jCapity9IKOWrvwDM0rCGZapXZrxa06KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575132; c=relaxed/simple;
	bh=hPmJhE5Ub8wBc0Rd+vMSZoyNFCvozzZkJRMYgtfiBTE=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=e8rhoKSYucSco/RHB9E0YLZNl3cwdkYhgxFfxKD6dRHTlXsX7abtVzQoNZDH+dNsGly8j1Yi/6cMB1XXg7QXNL4W5QkQBjby12hEl2nRLNU81ADQptnBGkBBr8FuIVUKU0cjSNFlFmc8e3QKco7as0xtEFbKP0yajNVswCMTA4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cs0sQtzx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cs0sQtzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91AEC433C7;
	Thu, 18 Jan 2024 10:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575132;
	bh=hPmJhE5Ub8wBc0Rd+vMSZoyNFCvozzZkJRMYgtfiBTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cs0sQtzx/NjoXkFzFBtvVXnp94Aw1Q1InKOWzridkSAUXuBTwu9ehu3x9CCt2572d
	 z7aIsYb7d3w0YC3B5J0AKCFkrkcn1yLEXydH1xUZjFDA76FiSqjbgFzeCX1MQe8F4Z
	 JIDoxlBqTfSJophssZDrjsqJYSZW6IhfQkf+KriU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/150] smb: client, common: fix fortify warnings
Date: Thu, 18 Jan 2024 11:47:24 +0100
Message-ID: <20240118104321.088590837@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 0015eb6e12384ff1c589928e84deac2ad1ceb236 ]

When compiling with gcc version 14.0.0 20231126 (experimental)
and CONFIG_FORTIFY_SOURCE=y, I've noticed the following:

In file included from ./include/linux/string.h:295,
                 from ./include/linux/bitmap.h:12,
                 from ./include/linux/cpumask.h:12,
                 from ./arch/x86/include/asm/paravirt.h:17,
                 from ./arch/x86/include/asm/cpuid.h:62,
                 from ./arch/x86/include/asm/processor.h:19,
                 from ./arch/x86/include/asm/cpufeature.h:5,
                 from ./arch/x86/include/asm/thread_info.h:53,
                 from ./include/linux/thread_info.h:60,
                 from ./arch/x86/include/asm/preempt.h:9,
                 from ./include/linux/preempt.h:79,
                 from ./include/linux/spinlock.h:56,
                 from ./include/linux/wait.h:9,
                 from ./include/linux/wait_bit.h:8,
                 from ./include/linux/fs.h:6,
                 from fs/smb/client/smb2pdu.c:18:
In function 'fortify_memcpy_chk',
    inlined from '__SMB2_close' at fs/smb/client/smb2pdu.c:3480:4:
./include/linux/fortify-string.h:588:25: warning: call to '__read_overflow2_field'
declared with attribute warning: detected read beyond size of field (2nd parameter);
maybe use struct_group()? [-Wattribute-warning]
  588 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

and:

In file included from ./include/linux/string.h:295,
                 from ./include/linux/bitmap.h:12,
                 from ./include/linux/cpumask.h:12,
                 from ./arch/x86/include/asm/paravirt.h:17,
                 from ./arch/x86/include/asm/cpuid.h:62,
                 from ./arch/x86/include/asm/processor.h:19,
                 from ./arch/x86/include/asm/cpufeature.h:5,
                 from ./arch/x86/include/asm/thread_info.h:53,
                 from ./include/linux/thread_info.h:60,
                 from ./arch/x86/include/asm/preempt.h:9,
                 from ./include/linux/preempt.h:79,
                 from ./include/linux/spinlock.h:56,
                 from ./include/linux/wait.h:9,
                 from ./include/linux/wait_bit.h:8,
                 from ./include/linux/fs.h:6,
                 from fs/smb/client/cifssmb.c:17:
In function 'fortify_memcpy_chk',
    inlined from 'CIFS_open' at fs/smb/client/cifssmb.c:1248:3:
./include/linux/fortify-string.h:588:25: warning: call to '__read_overflow2_field'
declared with attribute warning: detected read beyond size of field (2nd parameter);
maybe use struct_group()? [-Wattribute-warning]
  588 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In both cases, the fortification logic inteprets calls to 'memcpy()' as an
attempts to copy an amount of data which exceeds the size of the specified
field (i.e. more than 8 bytes from __le64 value) and thus issues an overread
warning. Both of these warnings may be silenced by using the convenient
'struct_group()' quirk.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifspdu.h | 24 ++++++++++++++----------
 fs/smb/client/cifssmb.c |  6 ++++--
 fs/smb/client/smb2pdu.c |  8 +++-----
 fs/smb/client/smb2pdu.h | 16 +++++++++-------
 fs/smb/common/smb2pdu.h | 17 ++++++++++-------
 5 files changed, 40 insertions(+), 31 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 83ccc51a54d0..c0513fbb8a59 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -882,11 +882,13 @@ typedef struct smb_com_open_rsp {
 	__u8 OplockLevel;
 	__u16 Fid;
 	__le32 CreateAction;
-	__le64 CreationTime;
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le32 FileAttributes;
+	struct_group(common_attributes,
+		__le64 CreationTime;
+		__le64 LastAccessTime;
+		__le64 LastWriteTime;
+		__le64 ChangeTime;
+		__le32 FileAttributes;
+	);
 	__le64 AllocationSize;
 	__le64 EndOfFile;
 	__le16 FileType;
@@ -2264,11 +2266,13 @@ typedef struct {
 /* QueryFileInfo/QueryPathinfo (also for SetPath/SetFile) data buffer formats */
 /******************************************************************************/
 typedef struct { /* data block encoding of response to level 263 QPathInfo */
-	__le64 CreationTime;
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le32 Attributes;
+	struct_group(common_attributes,
+		__le64 CreationTime;
+		__le64 LastAccessTime;
+		__le64 LastWriteTime;
+		__le64 ChangeTime;
+		__le32 Attributes;
+	);
 	__u32 Pad1;
 	__le64 AllocationSize;
 	__le64 EndOfFile;	/* size ie offset to first free byte in file */
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index bad91ba6c3a9..9ee348e6d106 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1244,8 +1244,10 @@ CIFS_open(const unsigned int xid, struct cifs_open_parms *oparms, int *oplock,
 		*oplock |= CIFS_CREATE_ACTION;
 
 	if (buf) {
-		/* copy from CreationTime to Attributes */
-		memcpy((char *)buf, (char *)&rsp->CreationTime, 36);
+		/* copy commonly used attributes */
+		memcpy(&buf->common_attributes,
+		       &rsp->common_attributes,
+		       sizeof(buf->common_attributes));
 		/* the file_info buf is endian converted by caller */
 		buf->AllocationSize = rsp->AllocationSize;
 		buf->EndOfFile = rsp->EndOfFile;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 76a0b9dbcf75..5276992e3647 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3401,12 +3401,10 @@ __SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	} else {
 		trace_smb3_close_done(xid, persistent_fid, tcon->tid,
 				      ses->Suid);
-		/*
-		 * Note that have to subtract 4 since struct network_open_info
-		 * has a final 4 byte pad that close response does not have
-		 */
 		if (pbuf)
-			memcpy(pbuf, (char *)&rsp->CreationTime, sizeof(*pbuf) - 4);
+			memcpy(&pbuf->network_open_info,
+			       &rsp->network_open_info,
+			       sizeof(pbuf->network_open_info));
 	}
 
 	atomic_dec(&tcon->num_remote_opens);
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 220994d0a0f7..db08194484e0 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -319,13 +319,15 @@ struct smb2_file_reparse_point_info {
 } __packed;
 
 struct smb2_file_network_open_info {
-	__le64 CreationTime;
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le64 AllocationSize;
-	__le64 EndOfFile;
-	__le32 Attributes;
+	struct_group(network_open_info,
+		__le64 CreationTime;
+		__le64 LastAccessTime;
+		__le64 LastWriteTime;
+		__le64 ChangeTime;
+		__le64 AllocationSize;
+		__le64 EndOfFile;
+		__le32 Attributes;
+	);
 	__le32 Reserved;
 } __packed; /* level 34 Query also similar returned in close rsp and open rsp */
 
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index d58550c1c937..63f969a8e44d 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -700,13 +700,16 @@ struct smb2_close_rsp {
 	__le16 StructureSize; /* 60 */
 	__le16 Flags;
 	__le32 Reserved;
-	__le64 CreationTime;
-	__le64 LastAccessTime;
-	__le64 LastWriteTime;
-	__le64 ChangeTime;
-	__le64 AllocationSize;	/* Beginning of FILE_STANDARD_INFO equivalent */
-	__le64 EndOfFile;
-	__le32 Attributes;
+	struct_group(network_open_info,
+		__le64 CreationTime;
+		__le64 LastAccessTime;
+		__le64 LastWriteTime;
+		__le64 ChangeTime;
+		/* Beginning of FILE_STANDARD_INFO equivalent */
+		__le64 AllocationSize;
+		__le64 EndOfFile;
+		__le32 Attributes;
+	);
 } __packed;
 
 
-- 
2.43.0



