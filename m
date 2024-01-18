Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE3C22EF7;
	Thu, 18 Jan 2024 11:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575693; cv=none; b=YVWL3p0xUEtQ5Ac4WSVzRyhbqfewTQmF9FJ2EbwdQ9bVPi/t7/t39M0iYIdcpHhPS+s6djwnqaHT5R3WePiAamrEqcbOIr3JbnAbX7y7K2xKEqg67k3saJalVkndm+OByTRvcepP84lun9eBnkVARbTR7SPuFhki+DkRslsLrws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575693; c=relaxed/simple;
	bh=Q906M49oBQnymsysIlm97ZFEHZgAPkLs++0ZEbS7Y2U=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=TX99vIJ+8PhB2wU92lr622Y895oB2oUIt+2FUobJqdSTVFK7edvOTwEKwuSHsCJltwNvCQHn4NkHlXTu6IQZdQpFL+0+s0HV3+AjIkt2secT0zco7LBOQJI2DrvZ+Hl6sK6xji7DytIlckR00eZjBAEt7f4ohmHAnlnyeIwfw28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOD85K5t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOD85K5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B77C433C7;
	Thu, 18 Jan 2024 11:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575693;
	bh=Q906M49oBQnymsysIlm97ZFEHZgAPkLs++0ZEbS7Y2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOD85K5tNI864c8zKrzp7hWm7iy6VLLpycL5xCZrU2nug7acXNuVkrHSauCLf43VA
	 69pkBshpZlYDyTvjt0iBZpZlHyLZJXC2AWx/mJn32S/HmtmLZGNNhlhya1T1A9Kgae
	 F+975APPcFP2Aven3V6h+orxkmtToZs1Mc9/Ckqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	j51569436@gmail.com,
	Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/100] smb: client: fix potential OOB in smb2_dump_detail()
Date: Thu, 18 Jan 2024 11:49:20 +0100
Message-ID: <20240118104314.059272956@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 567320c46a60a3c39b69aa1df802d753817a3f86 ]

Validate SMB message with ->check_message() before calling
->calc_smb_size().

This fixes CVE-2023-6610.

Reported-by: j51569436@gmail.com
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218219
Cc; stable@vger.kernel.org
Signed-off-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2misc.c | 30 +++++++++++++++---------------
 fs/smb/client/smb2ops.c  |  6 ++++--
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index fdf7a7f188c5..15fa022e7999 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -173,6 +173,21 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 	}
 
 	mid = le64_to_cpu(shdr->MessageId);
+	if (check_smb2_hdr(shdr, mid))
+		return 1;
+
+	if (shdr->StructureSize != SMB2_HEADER_STRUCTURE_SIZE) {
+		cifs_dbg(VFS, "Invalid structure size %u\n",
+			 le16_to_cpu(shdr->StructureSize));
+		return 1;
+	}
+
+	command = le16_to_cpu(shdr->Command);
+	if (command >= NUMBER_OF_SMB2_COMMANDS) {
+		cifs_dbg(VFS, "Invalid SMB2 command %d\n", command);
+		return 1;
+	}
+
 	if (len < pdu_size) {
 		if ((len >= hdr_size)
 		    && (shdr->Status != 0)) {
@@ -193,21 +208,6 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *server)
 		return 1;
 	}
 
-	if (check_smb2_hdr(shdr, mid))
-		return 1;
-
-	if (shdr->StructureSize != SMB2_HEADER_STRUCTURE_SIZE) {
-		cifs_dbg(VFS, "Invalid structure size %u\n",
-			 le16_to_cpu(shdr->StructureSize));
-		return 1;
-	}
-
-	command = le16_to_cpu(shdr->Command);
-	if (command >= NUMBER_OF_SMB2_COMMANDS) {
-		cifs_dbg(VFS, "Invalid SMB2 command %d\n", command);
-		return 1;
-	}
-
 	if (smb2_rsp_struct_sizes[command] != pdu->StructureSize2) {
 		if (command != SMB2_OPLOCK_BREAK_HE && (shdr->Status == 0 ||
 		    pdu->StructureSize2 != SMB2_ERROR_STRUCTURE_SIZE2_LE)) {
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 4596d2dfdec3..5a157000bdfe 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -398,8 +398,10 @@ smb2_dump_detail(void *buf, struct TCP_Server_Info *server)
 	cifs_server_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d\n",
 		 shdr->Command, shdr->Status, shdr->Flags, shdr->MessageId,
 		 shdr->Id.SyncId.ProcessId);
-	cifs_server_dbg(VFS, "smb buf %p len %u\n", buf,
-		 server->ops->calc_smb_size(buf));
+	if (!server->ops->check_message(buf, server->total_read, server)) {
+		cifs_server_dbg(VFS, "smb buf %p len %u\n", buf,
+				server->ops->calc_smb_size(buf));
+	}
 #endif
 }
 
-- 
2.43.0



