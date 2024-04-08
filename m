Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C2F7E0EB;
	Mon,  8 Apr 2024 13:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583746; cv=none; b=b92zuFYWExklDrsCSUgH/pWAa9wswS9hSxShgiPnDCAi88YfGyahBE5CPaDUs1rSjEfIX+LPhnHjeotJpilFumMzK7bODGlzCkHd5wtbyJeiC7kkxUZ4fgH0021uHaLut5MBaBGhQ5z87KfC9Zwp2P8IuvdaVpf1H8VlP1dst+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583746; c=relaxed/simple;
	bh=6ehRmKgZhoAfB6cjv6bd9cGi6I7Ba5iOUINWErNgako=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VF1KgGr7K/RP/u3AiEXzSVeg8LW1+BpXOnWzXjg49UK+k5bic76G3R6XxH013VCFgiNKg7groBSHX8JnuRqIAssN4uY3r83CB8ANP07fLv2Ro5wnXKxDmQws1G6VWcQfeWVSudzy/4mcRsJIxqHL+F4/wDs0bZq45WTYqp5YJcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwU6w95N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwU6w95N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4E6C433C7;
	Mon,  8 Apr 2024 13:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583745;
	bh=6ehRmKgZhoAfB6cjv6bd9cGi6I7Ba5iOUINWErNgako=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwU6w95N4sw3HRgIUbK3b6SnBQdII8kaSFZ2FwzK5kSDRh9+jJKuSRErDZVNr1fXu
	 2WkadsBz14plEKVQ8a9XnnOXLX2P2pmGz0rJwTVpO/Q7PoR1GEloKioFG9Lb68XztP
	 qog9a1Y2m4ci6oxBvANLYZcvCDREtdIHkR7/ehC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 229/252] smb: client: fix potential UAF in cifs_debug_files_proc_show()
Date: Mon,  8 Apr 2024 14:58:48 +0200
Message-ID: <20240408125313.763454547@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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
@@ -2281,4 +2281,14 @@ struct smb2_compound_vars {
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


