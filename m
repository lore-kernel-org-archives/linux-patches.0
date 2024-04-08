Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7511C2DF73;
	Mon,  8 Apr 2024 13:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582784; cv=none; b=cObfyNrXYxfUvzYM/Zq1lqXT7uaELLWmr8H6lkXzJ/N6MEbbQT6jMf9infMb6LqjRAJQdXOKdYZL3M63BrVIToQijEFVGUEiMtZImBdxGJ8YPMpPSC45aoROiOtaeHZ+bbd4J95vmNtRRTG1pkhjK6CBqNCZH1pDqNZBzKEiVu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582784; c=relaxed/simple;
	bh=ufOBVgCqODbnYLxKkLOFcpepn402Fhoa5idc3je3eho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3cEgIfFGSI1sjmEZL0X5lM/JfZpbFfhZZnQtHH0bkcxurgVm7mrGwDFml4E+EpSDRbo7HNVcLzkhV1dYmqqTm7lVxKBZsBu57sOuQV1X8wTrv19ljlw5NsHfZIuRalvsDu9lqWjyotNxSISAwPKskpgELYiv06ErvVsWMoNX18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fz9pVoD4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fz9pVoD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2713C43390;
	Mon,  8 Apr 2024 13:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582784;
	bh=ufOBVgCqODbnYLxKkLOFcpepn402Fhoa5idc3je3eho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fz9pVoD4/wuiW4mRhrDQ0kesAgyHX2EJHjCQfW7Drpg/BSUyIGxGxG7NI/+DUscVo
	 8c1H0r9R2k2BBOm1qAoOa+RwtKRNxDAx/zrpoGedS8a3jAO3ydqakBLIwRRhPB91R0
	 BAhOMiYVeGMxfH5iiaclFe+1EzhD4FBncYOd6wqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 133/138] smb: client: fix potential UAF in cifs_signal_cifsd_for_reconnect()
Date: Mon,  8 Apr 2024 14:59:07 +0200
Message-ID: <20240408125300.366859037@linuxfoundation.org>
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

commit e0e50401cc3921c9eaf1b0e667db174519ea939f upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -216,6 +216,8 @@ cifs_signal_cifsd_for_reconnect(struct T
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		spin_lock(&ses->chan_lock);
 		for (i = 0; i < ses->chan_count; i++) {
 			spin_lock(&ses->chans[i].server->srv_lock);


