Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B2C381D4;
	Fri, 24 Nov 2023 18:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3zsZ0f5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E602C433C8;
	Fri, 24 Nov 2023 18:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850050;
	bh=5ua6jvmhcHEPIIg4k71MvNdivxXP9O/bcCCSKdwLYSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3zsZ0f5rHHfzxRZgwc4jo7NQQmEVUfA92XEqPNTiElLOsPICrdfm3SAAGTA436Rf
	 NqgnHy2uV5kHJMDJERRk262L2z0e40A9Y29EsLP4Q6YgzE9IlYCdZchMEPJTcydxAe
	 RMBUKB9tQMdtGoUYlQ6RTN3r60LzyDasYIaWlY08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 425/530] cifs: reconnect helper should set reconnect for the right channel
Date: Fri, 24 Nov 2023 17:49:51 +0000
Message-ID: <20231124172041.001327047@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

commit c3326a61cdbf3ce1273d9198b6cbf90965d7e029 upstream.

We introduced a helper function to be used by non-cifsd threads to
mark the connection for reconnect. For multichannel, when only
a particular channel needs to be reconnected, this had a bug.

This change fixes that by marking that particular channel
for reconnect.

Fixes: dca65818c80c ("cifs: use a different reconnect helper for non-cifsd threads")
Cc: stable@vger.kernel.org
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -156,13 +156,14 @@ cifs_signal_cifsd_for_reconnect(struct T
 	/* If server is a channel, select the primary channel */
 	pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
 
-	spin_lock(&pserver->srv_lock);
+	/* if we need to signal just this channel */
 	if (!all_channels) {
-		pserver->tcpStatus = CifsNeedReconnect;
-		spin_unlock(&pserver->srv_lock);
+		spin_lock(&server->srv_lock);
+		if (server->tcpStatus != CifsExiting)
+			server->tcpStatus = CifsNeedReconnect;
+		spin_unlock(&server->srv_lock);
 		return;
 	}
-	spin_unlock(&pserver->srv_lock);
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {


