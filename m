Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3FB6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE31C433EF;
	Mon,  3 Apr 2023 14:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532242;
	bh=5z3BT5YdvD8H1nZXhn2GHI5/AZRK/zqwo4rKywAzgow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGD9zpd5CkXCWjiuf4SSYOLofliTspSVc7nJeoxnXTGhto8ElzsVKe7f+p5Q6xGkS
	 1EFX9qEkRLHt1UQI92NzqXEfMxjoioa5KRmdwNtkbHCYYuyT3J/Qk06Mv8XMLCF54g
	 69smk3yQdRBwuOaQ2ds7bJBZz0/qcMFKhFimbnxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 147/173] cifs: prevent infinite recursion in CIFSGetDFSRefer()
Date: Mon,  3 Apr 2023 16:09:22 +0200
Message-Id: <20230403140419.213210622@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.com>

commit 09ba47b44d26b475bbdf9c80db9e0193d2b58956 upstream.

We can't call smb_init() in CIFSGetDFSRefer() as cifs_reconnect_tcon()
may end up calling CIFSGetDFSRefer() again to get new DFS referrals
and thus causing an infinite recursion.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Cc: stable@vger.kernel.org # 6.2
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifssmb.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4859,8 +4859,13 @@ CIFSGetDFSRefer(const unsigned int xid,
 		return -ENODEV;
 
 getDFSRetry:
-	rc = smb_init(SMB_COM_TRANSACTION2, 15, ses->tcon_ipc, (void **) &pSMB,
-		      (void **) &pSMBr);
+	/*
+	 * Use smb_init_no_reconnect() instead of smb_init() as
+	 * CIFSGetDFSRefer() may be called from cifs_reconnect_tcon() and thus
+	 * causing an infinite recursion.
+	 */
+	rc = smb_init_no_reconnect(SMB_COM_TRANSACTION2, 15, ses->tcon_ipc,
+				   (void **)&pSMB, (void **)&pSMBr);
 	if (rc)
 		return rc;
 


