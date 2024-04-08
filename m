Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079557D3E0;
	Mon,  8 Apr 2024 13:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582694; cv=none; b=TFFXyrUg+AK+Y0xZmqkyJXhbO1Y7sAFGoOIRijhcgNROHBidvsCuw7AvpqoN1v8dvVwn/WY4Hx4kB9dHmiWfcj4GblOu1uOmfTVFk5Bk688o+UMEht/HDXUC7I+tSbsLDpduef3UYAmWmDthJoFpLC9AjAAtWse1iA7wVykO9Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582694; c=relaxed/simple;
	bh=e41CY8oJn15lsd2jqrQWhdIC1XBZVZlD1N9zqrN9i+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGIN8ZVdJXwrG7WljmUoMT1b3aJVaa/LICJJYQC+ollF2qA9hdSuGXVY2iIYONjO/f7NnmAa5jXccc0aQCD9DEBe/iHvNgdKsOyfGyKsCO/imDG4SDPDX4NAcgEEL/e/w9nHW3L239uxUhJo91/D3l3f1SUiyiM9wm6ca0b9fkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+nBsvLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+nBsvLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBF9C433C7;
	Mon,  8 Apr 2024 13:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582693;
	bh=e41CY8oJn15lsd2jqrQWhdIC1XBZVZlD1N9zqrN9i+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+nBsvLedx1lflDM1XAtUbbbuZhVsGoDnvPPHM/DCAd9vxlvVpCZBCPZcV2ao4wBY
	 RTqn/n/z8jgRDUtCqL86ZbrAfH5Tt37PtrFqs1c/e0ANu8DQBkrdqVSelEDL4osaW6
	 WwbeDocFL3ZDXfQDBOTB/mePkj1UG5bxTm/a+YDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 126/138] smb: client: fix potential UAF in cifs_debug_files_proc_show()
Date: Mon,  8 Apr 2024 14:59:00 +0200
Message-ID: <20240408125300.151372716@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

commit ca545b7f0823f19db0f1148d59bc5e1a56634502 upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifs_debug.c |    2 ++
 fs/smb/client/cifsglob.h   |   10 ++++++++++
 2 files changed, 12 insertions(+)

--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -186,6 +186,8 @@ static int cifs_debug_files_proc_show(st
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
 		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			if (cifs_ses_exiting(ses))
+				continue;
 			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 				spin_lock(&tcon->open_file_lock);
 				list_for_each_entry(cfile, &tcon->openFileList, tlist) {
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2178,4 +2178,14 @@ static inline struct scatterlist *cifs_s
 	return sg;
 }
 
+static inline bool cifs_ses_exiting(struct cifs_ses *ses)
+{
+	bool ret;
+
+	spin_lock(&ses->ses_lock);
+	ret = ses->ses_status == SES_EXITING;
+	spin_unlock(&ses->ses_lock);
+	return ret;
+}
+
 #endif	/* _CIFS_GLOB_H */


