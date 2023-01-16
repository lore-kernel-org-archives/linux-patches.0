Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8806946B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E104C43396;
	Mon, 16 Jan 2023 16:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885160;
	bh=70M/6CFXQxN8otdCYgmX93IcjyPrToQqoOE+5d6rypU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yA31sMBUFO9+DdkXEZQrjmVz+f2zV++9E55jGEwt2b4MVdvghg95DxEZQ71QYLzEE
	 B6lDugdrY/71UNjQTToZMzX+WKaHjoKgNMtEmPuhSwDIrq9sh8VyU4iKRw9O7lS4O5
	 HKhgd5UijL8qFSQMk7ec3vioJ/Zovg8Ep3F9gEck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Volker Lendecke <vl@samba.org>,
	Tom Talpey <tom@talpey.com>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 11/64] cifs: Fix uninitialized memory read for smb311 posix symlink create
Date: Mon, 16 Jan 2023 16:51:18 +0100
Message-Id: <20230116154744.044656703@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
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
@@ -471,6 +471,7 @@ smb3_create_mf_symlink(unsigned int xid,
 	oparms.disposition = FILE_CREATE;
 	oparms.fid = &fid;
 	oparms.reconnect = false;
+	oparms.mode = 0644;
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
 		       NULL, NULL);


