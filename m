Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B8622F06;
	Thu, 18 Jan 2024 10:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575380; cv=none; b=I3lsXtNytdRqwhoN4Lv9T3LHYJtIhgpnuGTeCPcVphq4Mo/m6JYbtpqP9gDOrOVqHRNBNNPQgd6mOAPSw0V9Ap2qMiNP15aZxoJEmWV6kUHo5jrG7ZpFdys+ysiJiLbASbffo8OLHZyQquTcjepHz2c8+xNJt0HkMg17n1is+e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575380; c=relaxed/simple;
	bh=i4cAxWuPSjJrx90rGQjr0eIaT1bPisyxbQro40EpU1o=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=a8hXwIjr084ElJhazeuCbWyr1GIeH4kqTPnKfaCqsDoZ/l4s1tx77XoPQApfOvzi0TnRo8hYTnp46dFsCl0M47hZDOEl6qQl5EuLox8Tls+qpPsAyhetcjxJbNIhkXztRv2d8egvsk6jaGZDW3pKE/q6Xcd5PuHwpP0uYi+3Uuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cwjy+kCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cwjy+kCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896A8C433C7;
	Thu, 18 Jan 2024 10:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575379;
	bh=i4cAxWuPSjJrx90rGQjr0eIaT1bPisyxbQro40EpU1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cwjy+kCEMulJzXJUubJrNYCMhUZlryu+pEL3Mr3WwKK9JisVEI79Is0tab+L4uN/p
	 cy62FlaB/bjSh6o6bGcW9YtxvoudYFCE5hRyOv1Fnkp6UmOHvtaVUGAl1OA5s20/A+
	 j4aFr28ypRUUG7aFs/gG4t6eAwCBnZhYTOhgYoo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	j51569436@gmail.com,
	Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/150] smb: client: fix potential OOB in smb2_dump_detail()
Date: Thu, 18 Jan 2024 11:48:53 +0100
Message-ID: <20240118104325.195278280@linuxfoundation.org>
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
index e20b4354e703..82b84a4941dd 100644
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
index 94e4af4128f1..0604696f59c1 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -403,8 +403,10 @@ smb2_dump_detail(void *buf, struct TCP_Server_Info *server)
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



