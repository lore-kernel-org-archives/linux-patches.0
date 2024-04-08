Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8357D095;
	Mon,  8 Apr 2024 13:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584022; cv=none; b=txs/XhH10jRB0nUY2EOx5qrx9SM0/qrHthmIAHQWtidvViXMSeKYknjYwgWMnLgpYKQ1zEZWqH1BFCtbGnIv9Lm8tqOXLDGMMKMbdMpPZpM5TapLG8MzvB3cT3T+OkJJNRWLNK1k1zlO30bYF8lkSY1d1YI3iYPS3fQ6ttEqyPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584022; c=relaxed/simple;
	bh=789yApSdIxZvx1Pf//iCH2UOYcYjWrV+CXySEGLIURM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2898/RACsACIhhuSIXyemBa1ahG6wPjqPUcoVmx8pvSwhRpx/AXWDH+pMgHrzANvVCV1/W3WxBqpwhP/lCLiSe6n4RKBaPcrULidnPPuHD7rEyKgiLtuBYid89RlBzGnn6dcVZXVSoC+72eOyRh8ExuoCAg21+hac2dYXWcBiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ii4m5JOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ii4m5JOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0D1C433F1;
	Mon,  8 Apr 2024 13:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584022;
	bh=789yApSdIxZvx1Pf//iCH2UOYcYjWrV+CXySEGLIURM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ii4m5JOus05TZIBIwa00ptP26p3rNtrut7htvWb4m8hroIt+aeMGeZfVwrmUa4t+V
	 19eJO9KHLp83iKvO1bmM3K+VKtEDAsONWjllM0TFkTypsEewIkCSidGe42Bb1ck42z
	 WctmlLySsENdOuu4XjCw71bdjRfoIQXqkpoWtxg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 249/273] smb: client: fix potential UAF in cifs_debug_files_proc_show()
Date: Mon,  8 Apr 2024 14:58:44 +0200
Message-ID: <20240408125317.183948734@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -250,6 +250,8 @@ static int cifs_debug_files_proc_show(st
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
@@ -2295,4 +2295,14 @@ struct smb2_compound_vars {
 	struct smb2_file_link_info link_info;
 };
 
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


