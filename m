Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B24168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C860C433EF;
	Mon,  8 May 2023 10:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543113;
	bh=MV2/obIo1SmIrVNPfDMX+Putmo3myiKA/3YBD6AfvVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zhHpXE2sPtCPlULJDrrvA1lBnNaqsR1jBvp82ndiLKClUR2WB7XvWrn7mKW1PTH7B
	 iOFbanACIEj7bw+VPWsaPM3AggaSdYsdPqay6aleHhZh5akA+lSfmVR5ac5j7oa1Ee
	 7pM4YCn8YnTG6qRspiTM9ttbiYdkRLcUsDsxOGRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 653/663] cifs: protect session status check in smb2_reconnect()
Date: Mon,  8 May 2023 11:47:59 +0200
Message-Id: <20230508094451.312509811@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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

commit 5bff9f741af60b143a5ae73417a8ec47fd5ff2f4 upstream.

Use @ses->ses_lock to protect access of @ses->ses_status.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -175,8 +175,17 @@ smb2_reconnect(__le16 smb2_command, stru
 		}
 	}
 	spin_unlock(&tcon->tc_lock);
-	if ((!tcon->ses) || (tcon->ses->ses_status == SES_EXITING) ||
-	    (!tcon->ses->server) || !server)
+
+	ses = tcon->ses;
+	if (!ses)
+		return -EIO;
+	spin_lock(&ses->ses_lock);
+	if (ses->ses_status == SES_EXITING) {
+		spin_unlock(&ses->ses_lock);
+		return -EIO;
+	}
+	spin_unlock(&ses->ses_lock);
+	if (!ses->server || !server)
 		return -EIO;
 
 	spin_lock(&server->srv_lock);
@@ -204,8 +213,6 @@ again:
 	if (rc)
 		return rc;
 
-	ses = tcon->ses;
-
 	spin_lock(&ses->chan_lock);
 	if (!cifs_chan_needs_reconnect(ses, server) && !tcon->need_reconnect) {
 		spin_unlock(&ses->chan_lock);


