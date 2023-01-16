Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA76E33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7AEC433EF;
	Mon, 16 Jan 2023 15:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884610;
	bh=R6oZbqNU/2ppKcaBnPmrVX8xGwVcBk6i1S/XMl4WZlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwNen6fl37xVoIDIdsYAzpoIEjKWg15YRraUi/y5H0rFYlt1wmHYKjZBIxuE5BVjE
	 jS9KvwY05ciV3S0Oh2RqBfl2cYlGJ5S4/hfLDX+VTGklfmoid07+gRJBS7T2aM4jaG
	 idk/272EaAHxb/4ZdRjocIpePnr6TooBbe+xKyEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 041/183] cifs: do not query ifaces on smb1 mounts
Date: Mon, 16 Jan 2023 16:49:24 +0100
Message-Id: <20230116154805.126104685@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

commit 22aeb01db7080e18c6aeb4361cc2556c9887099a upstream.

Users have reported the following error on every 600 seconds
(SMB_INTERFACE_POLL_INTERVAL) when mounting SMB1 shares:

	CIFS: VFS: \\srv\share error -5 on ioctl to get interface list

It's supported only by SMB2+, so do not query network interfaces on
SMB1 mounts.

Fixes: 6e1c1c08cdf3 ("cifs: periodically query network interfaces from server")
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2609,11 +2609,14 @@ cifs_get_tcon(struct cifs_ses *ses, stru
 	INIT_LIST_HEAD(&tcon->pending_opens);
 	tcon->status = TID_GOOD;
 
-	/* schedule query interfaces poll */
 	INIT_DELAYED_WORK(&tcon->query_interfaces,
 			  smb2_query_server_interfaces);
-	queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
-			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
+	if (ses->server->dialect >= SMB30_PROT_ID &&
+	    (ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
+		/* schedule query interfaces poll */
+		queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
+				   (SMB_INTERFACE_POLL_INTERVAL * HZ));
+	}
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_add(&tcon->tcon_list, &ses->tcon_list);


