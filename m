Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF966FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0DCC433D2;
	Mon, 16 Jan 2023 17:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673889174;
	bh=/KF+WP5RUEUOoUdlomR06lfg4t1tbn8JP3OkX2Du+mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSp2rEoJck49omoT4qkS2R8cYBe76iUUHHuHgJ+DY03zXw4myqUiw7BLkWZZ05oei
	 MG1LBN5m3eViiGnhDbzMbM8rW2gszEjyLo38CTlChTtKcy5IXC5RSVFtCe+lTebixk
	 +boWiZ7tQRcD4Zb8FE1vAI6deHGh55PPX0nBOj88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.14 287/338] cifs: fix confusing debug message
Date: Mon, 16 Jan 2023 16:52:40 +0100
Message-Id: <20230116154833.573527973@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@cjr.nz>

commit a85ceafd41927e41a4103d228a993df7edd8823b upstream.

Since rc was initialised to -ENOMEM in cifs_get_smb_ses(), when an
existing smb session was found, free_xid() would be called and then
print

  CIFS: fs/cifs/connect.c: Existing tcp session with server found
  CIFS: fs/cifs/connect.c: VFS: in cifs_get_smb_ses as Xid: 44 with uid: 0
  CIFS: fs/cifs/connect.c: Existing smb sess found (status=1)
  CIFS: fs/cifs/connect.c: VFS: leaving cifs_get_smb_ses (xid = 44) rc = -12

Fix this by initialising rc to 0 and then let free_xid() print this
instead

  CIFS: fs/cifs/connect.c: Existing tcp session with server found
  CIFS: fs/cifs/connect.c: VFS: in cifs_get_smb_ses as Xid: 14 with uid: 0
  CIFS: fs/cifs/connect.c: Existing smb sess found (status=1)
  CIFS: fs/cifs/connect.c: VFS: leaving cifs_get_smb_ses (xid = 14) rc = 0

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2693,7 +2693,7 @@ cifs_set_cifscreds(struct smb_vol *vol _
 static struct cifs_ses *
 cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 {
-	int rc = -ENOMEM;
+	int rc = 0;
 	unsigned int xid;
 	struct cifs_ses *ses;
 	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
@@ -2735,6 +2735,8 @@ cifs_get_smb_ses(struct TCP_Server_Info
 		return ses;
 	}
 
+	rc = -ENOMEM;
+
 	cifs_dbg(FYI, "Existing smb sess not found\n");
 	ses = sesInfoAlloc();
 	if (ses == NULL)


