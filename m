Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16E38BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CA3C433EF;
	Tue, 28 Mar 2023 15:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015803;
	bh=2boXBRddl0ytg0FKMy80fRtusvI6jtmgSh2XHJv+gnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2d1liS5ExbRP5L7vdb4TNrqqtWGUGDgGuQL/q1oJ5WvVH0psSzjnovMZ5KVCZ00I9
	 fxSopP3ccm6KUbQBsiRRuRaFZ/sSk3ZKrlnWkXXnS6FjYr1ansUz/4Nvms43T9f/+R
	 BKPAGEw88YWGn0RfITtcJHwtBL2kWdzw2n0oVpRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 150/224] cifs: lock chan_lock outside match_session
Date: Tue, 28 Mar 2023 16:42:26 +0200
Message-Id: <20230328142623.626507261@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

commit 2f4e429c846972c8405951a9ff7a82aceeca7461 upstream.

Coverity had rightly indicated a possible deadlock
due to chan_lock being done inside match_session.
All callers of match_* functions should pick up the
necessary locks and call them.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Cc: stable@vger.kernel.org
Fixes: 724244cdb382 ("cifs: protect session channel fields with chan_lock")
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1774,7 +1774,7 @@ out_err:
 	return ERR_PTR(rc);
 }
 
-/* this function must be called with ses_lock held */
+/* this function must be called with ses_lock and chan_lock held */
 static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 {
 	if (ctx->sectype != Unspecified &&
@@ -1785,12 +1785,8 @@ static int match_session(struct cifs_ses
 	 * If an existing session is limited to less channels than
 	 * requested, it should not be reused
 	 */
-	spin_lock(&ses->chan_lock);
-	if (ses->chan_max < ctx->max_channels) {
-		spin_unlock(&ses->chan_lock);
+	if (ses->chan_max < ctx->max_channels)
 		return 0;
-	}
-	spin_unlock(&ses->chan_lock);
 
 	switch (ses->sectype) {
 	case Kerberos:
@@ -1918,10 +1914,13 @@ cifs_find_smb_ses(struct TCP_Server_Info
 			spin_unlock(&ses->ses_lock);
 			continue;
 		}
+		spin_lock(&ses->chan_lock);
 		if (!match_session(ses, ctx)) {
+			spin_unlock(&ses->chan_lock);
 			spin_unlock(&ses->ses_lock);
 			continue;
 		}
+		spin_unlock(&ses->chan_lock);
 		spin_unlock(&ses->ses_lock);
 
 		++ses->ses_count;
@@ -2742,6 +2741,7 @@ cifs_match_super(struct super_block *sb,
 
 	spin_lock(&tcp_srv->srv_lock);
 	spin_lock(&ses->ses_lock);
+	spin_lock(&ses->chan_lock);
 	spin_lock(&tcon->tc_lock);
 	if (!match_server(tcp_srv, ctx) ||
 	    !match_session(ses, ctx) ||
@@ -2754,6 +2754,7 @@ cifs_match_super(struct super_block *sb,
 	rc = compare_mount_options(sb, mnt_data);
 out:
 	spin_unlock(&tcon->tc_lock);
+	spin_unlock(&ses->chan_lock);
 	spin_unlock(&ses->ses_lock);
 	spin_unlock(&tcp_srv->srv_lock);
 


