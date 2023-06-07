Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A6F3AE6F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86468C433EF;
	Wed,  7 Jun 2023 20:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169955;
	bh=LO6yQfyBMAR+ONrUy3F5CovU26WDzNzI0Q4gnRdP3WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwwtpVfB2i3WiJ4MdDOVjZvYMYcewg/0ztaQd22dEksei0yRie9gWRsYkKGFi1meV
	 3ZrMyNrwxyEIc+0yAqwUg50gUWziVcYAeuy/2TI4s9anaJmBuuYy9Qh03tRxnTMjzq
	 Ts8cnkZDWeUU3eP5Q1uL1ZIH6S6/P4jPdOmPgI9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.3 277/286] ksmbd: fix incorrect AllocationSize set in smb2_get_info
Date: Wed,  7 Jun 2023 22:16:16 +0200
Message-ID: <20230607200932.337908324@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

commit 6cc2268f5647cbfde3d4fc2e4ee005070ea3a8d2 upstream.

If filesystem support sparse file, ksmbd should return allocated size
using ->i_blocks instead of stat->size. This fix generic/694 xfstests.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4380,21 +4380,6 @@ static int get_file_basic_info(struct sm
 	return 0;
 }
 
-static unsigned long long get_allocation_size(struct inode *inode,
-					      struct kstat *stat)
-{
-	unsigned long long alloc_size = 0;
-
-	if (!S_ISDIR(stat->mode)) {
-		if ((inode->i_blocks << 9) <= stat->size)
-			alloc_size = stat->size;
-		else
-			alloc_size = inode->i_blocks << 9;
-	}
-
-	return alloc_size;
-}
-
 static void get_file_standard_info(struct smb2_query_info_rsp *rsp,
 				   struct ksmbd_file *fp, void *rsp_org)
 {
@@ -4409,7 +4394,7 @@ static void get_file_standard_info(struc
 	sinfo = (struct smb2_file_standard_info *)rsp->Buffer;
 	delete_pending = ksmbd_inode_pending_delete(fp);
 
-	sinfo->AllocationSize = cpu_to_le64(get_allocation_size(inode, &stat));
+	sinfo->AllocationSize = cpu_to_le64(inode->i_blocks << 9);
 	sinfo->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	sinfo->NumberOfLinks = cpu_to_le32(get_nlink(&stat) - delete_pending);
 	sinfo->DeletePending = delete_pending;
@@ -4474,7 +4459,7 @@ static int get_file_all_info(struct ksmb
 	file_info->Attributes = fp->f_ci->m_fattr;
 	file_info->Pad1 = 0;
 	file_info->AllocationSize =
-		cpu_to_le64(get_allocation_size(inode, &stat));
+		cpu_to_le64(inode->i_blocks << 9);
 	file_info->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	file_info->NumberOfLinks =
 			cpu_to_le32(get_nlink(&stat) - delete_pending);
@@ -4663,7 +4648,7 @@ static int get_file_network_open_info(st
 	file_info->ChangeTime = cpu_to_le64(time);
 	file_info->Attributes = fp->f_ci->m_fattr;
 	file_info->AllocationSize =
-		cpu_to_le64(get_allocation_size(inode, &stat));
+		cpu_to_le64(inode->i_blocks << 9);
 	file_info->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	file_info->Reserved = cpu_to_le32(0);
 	rsp->OutputBufferLength =


