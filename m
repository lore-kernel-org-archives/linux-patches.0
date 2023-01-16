Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4673633EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88C4C433D2;
	Mon, 16 Jan 2023 16:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884953;
	bh=vNOmU7rZkVjrdmxsBFK45aj3vDOd+UDKlEm2qmY65W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHFYGY9goB0Q8kTzRnDCh3kht4yPOWKEgKVhtfu/k73d9Yi2R3l43OlKPNFzk8B/Y
	 Wh8GzIrxmKFpau4/8skEIuwxSDcu784xbhj/Jrlf9x7X8s4sA1EFNRfZm25VI5q7Ug
	 S7oFhKzc5MHUdVAzFm/BFao7kRYdSftIIoLJKb88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Volker Lendecke <vl@samba.org>,
	Tom Talpey <tom@talpey.com>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 19/86] cifs: Fix uninitialized memory read for smb311 posix symlink create
Date: Mon, 16 Jan 2023 16:50:53 +0100
Message-Id: <20230116154747.894867804@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Volker Lendecke <vl@samba.org>

commit a152d05ae4a71d802d50cf9177dba34e8bb09f68 upstream.

If smb311 posix is enabled, we send the intended mode for file
creation in the posix create context. Instead of using what's there on
the stack, create the mfsymlink file with 0644.

Fixes: ce558b0e17f8a ("smb3: Add posix create context for smb3.11 posix mounts")
Cc: stable@vger.kernel.org
Signed-off-by: Volker Lendecke <vl@samba.org>
Reviewed-by: Tom Talpey <tom@talpey.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/link.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -459,6 +459,7 @@ smb3_create_mf_symlink(unsigned int xid,
 	oparms.disposition = FILE_CREATE;
 	oparms.fid = &fid;
 	oparms.reconnect = false;
+	oparms.mode = 0644;
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
 		       NULL, NULL);


