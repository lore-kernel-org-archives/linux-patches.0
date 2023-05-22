Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2D4171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5BEC433EF;
	Mon, 22 May 2023 19:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784826;
	bh=Z5MW+7Uyjs8ZxbT9xpRDInLLzeI14n182uK6ADFW0BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eccUtz3AauxZA7hEZ12+jWNuv0WlweOtC0clht/88Q058at0/NHJXUL37KxnNA615
	 MPy57OY6HsgnrzCy60YPMv3FnopOZkxOjuSzCwH6xEiC9HOSAYaoTzM7uATkkhF0VA
	 mvXk8ih7TQI2zrYWaN5zoZTllNZ2glCGZLgZwzmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 188/364] cifs: missing lock when updating session status
Date: Mon, 22 May 2023 20:08:13 +0100
Message-Id: <20230522190417.434256514@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 943fb67b090212f1d3789eb7796b1c9045c62fd6 ]

Coverity noted a place where we were not grabbing
the ses_lock when setting (and checking) ses_status.

Addresses-Coverity: 1536833 ("Data race condition (MISSING_LOCK)")
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 59a10330e299b..8e9a672320ab7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1918,18 +1918,22 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
 	/* ses_count can never go negative */
 	WARN_ON(ses->ses_count < 0);
 
+	spin_lock(&ses->ses_lock);
 	if (ses->ses_status == SES_GOOD)
 		ses->ses_status = SES_EXITING;
 
-	cifs_free_ipc(ses);
-
 	if (ses->ses_status == SES_EXITING && server->ops->logoff) {
+		spin_unlock(&ses->ses_lock);
+		cifs_free_ipc(ses);
 		xid = get_xid();
 		rc = server->ops->logoff(xid, ses);
 		if (rc)
 			cifs_server_dbg(VFS, "%s: Session Logoff failure rc=%d\n",
 				__func__, rc);
 		_free_xid(xid);
+	} else {
+		spin_unlock(&ses->ses_lock);
+		cifs_free_ipc(ses);
 	}
 
 	spin_lock(&cifs_tcp_ses_lock);
-- 
2.39.2



