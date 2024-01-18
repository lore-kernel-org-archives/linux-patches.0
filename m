Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4D722F1B;
	Thu, 18 Jan 2024 10:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575524; cv=none; b=SP1N32qEfinNgUKGXGw8V3knZbvSpyNCvx/YQ6bB4+Q95Kag7iqhvaZi8jXMad2E4OZqGv8oVfnPPmePUcXYv/Solfuwdm7X/6yNrMQqdXCGH6t5J0cMksRBAr/ls4Bp1DpOv2wLRr0CLyXUQMid9iHa9UreGWYABTxm5NpkgJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575524; c=relaxed/simple;
	bh=0eq5fQmiYVUYdqGEXAdoGNP8IpS2Qb8t+trG8Ljs8BA=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=pGulXjE830XWACjk1mQmdkAHcHlKuWkyr73+dAWBDL8s9QjHtBYUXQjfTWCu1+hlpQg6K8pQv7CRwMVEC3dhQ1djZaH8EdGgsvIBZrTx0u5GZSwg2UZNMqaNqRhU1HfE7i9+qX1vLUSp4/Z7eUwsNXZr4ozP2QngMtsUsCAOLV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVeke/vc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVeke/vc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0027AC433C7;
	Thu, 18 Jan 2024 10:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575524;
	bh=0eq5fQmiYVUYdqGEXAdoGNP8IpS2Qb8t+trG8Ljs8BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVeke/vcogQ9FKrP1fzvz/8itbVXujbUWAUWE7uew2vDIX7ljeBUTk/tXts27/llm
	 NTzmDXXzuS48kdeq3gWaVtZQ9AqEaKE6n0BD+MNzY+oFTbEt3nEUSEJsWQt+hiPfaV
	 N9tNoIiz3O1PKQoeGVkyFYOOEGRnAKRAYVsdCECw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/100] smb: client, common: fix fortify warnings
Date: Thu, 18 Jan 2024 11:48:21 +0100
Message-ID: <20240118104311.460981213@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c403816d0b6c..97bb1838555b 100644
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
@@ -2268,11 +2270,13 @@ typedef struct {
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
index c90d4ec9292c..67c5fc2b2db9 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1234,8 +1234,10 @@ CIFS_open(const unsigned int xid, struct cifs_open_parms *oparms, int *oplock,
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
index 2dfbf1b23cfa..e65f998ea4cf 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3429,12 +3429,10 @@ __SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
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
index a5773a06aba8..8d011fedecd0 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -339,13 +339,15 @@ struct smb2_file_reparse_point_info {
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
index 5593bb49954c..a3936ff53d9d 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -699,13 +699,16 @@ struct smb2_close_rsp {
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



