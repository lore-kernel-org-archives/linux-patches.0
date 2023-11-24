Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794FD364A4;
	Fri, 24 Nov 2023 18:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k97vKQeb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BD7C433C8;
	Fri, 24 Nov 2023 18:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850147;
	bh=GjEmLTpQjn2vhJdMZD4h221O8o96vR5coAjZB9xxe7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k97vKQebPRSiFMwTlTf2lOr6fhVxBLKpyADptAsSBkJEyf6FnRPRSrwhAi6jxO2J+
	 CcAjzYCiVzJ48qyFytLpfdZuzqeVS//k4OLfq0ISZC4iOzEKjzErGA0oVqSceWbXs3
	 oOCeMaCFR7dfCupNmCi7u5z07ZbCKPX09ocKIFJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 428/530] cifs: do not pass cifs_sb when trying to add channels
Date: Fri, 24 Nov 2023 17:49:54 +0000
Message-ID: <20231124172041.106485916@linuxfoundation.org>
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

commit 9599d59eb8fc0c0fd9480c4f22901533d08965ee upstream.

The only reason why cifs_sb gets passed today to cifs_try_adding_channels
is to pass the local_nls field for the new channels and binding session.
However, the ses struct already has local_nls field that is setup during
the first cifs_setup_session. So there is no need to pass cifs_sb.

This change removes cifs_sb from the arg list for this and the functions
that it calls and uses ses->local_nls instead.

Cc: stable@vger.kernel.org
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsproto.h |    2 +-
 fs/smb/client/connect.c   |    2 +-
 fs/smb/client/sess.c      |   12 ++++++------
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -610,7 +610,7 @@ void cifs_free_hash(struct shash_desc **
 
 struct cifs_chan *
 cifs_ses_find_chan(struct cifs_ses *ses, struct TCP_Server_Info *server);
-int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses);
+int cifs_try_adding_channels(struct cifs_ses *ses);
 bool is_server_using_iface(struct TCP_Server_Info *server,
 			   struct cifs_server_iface *iface);
 bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface);
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3561,7 +3561,7 @@ int cifs_mount(struct cifs_sb_info *cifs
 	ctx->prepath = NULL;
 
 out:
-	cifs_try_adding_channels(cifs_sb, mnt_ctx.ses);
+	cifs_try_adding_channels(mnt_ctx.ses);
 	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
 	if (rc)
 		goto error;
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -24,7 +24,7 @@
 #include "fs_context.h"
 
 static int
-cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
+cifs_ses_add_channel(struct cifs_ses *ses,
 		     struct cifs_server_iface *iface);
 
 bool
@@ -157,7 +157,7 @@ cifs_chan_is_iface_active(struct cifs_se
 }
 
 /* returns number of channels added */
-int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
+int cifs_try_adding_channels(struct cifs_ses *ses)
 {
 	struct TCP_Server_Info *server = ses->server;
 	int old_chan_count, new_chan_count;
@@ -230,7 +230,7 @@ int cifs_try_adding_channels(struct cifs
 			kref_get(&iface->refcount);
 
 			spin_unlock(&ses->iface_lock);
-			rc = cifs_ses_add_channel(cifs_sb, ses, iface);
+			rc = cifs_ses_add_channel(ses, iface);
 			spin_lock(&ses->iface_lock);
 
 			if (rc) {
@@ -354,7 +354,7 @@ cifs_ses_find_chan(struct cifs_ses *ses,
 }
 
 static int
-cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
+cifs_ses_add_channel(struct cifs_ses *ses,
 		     struct cifs_server_iface *iface)
 {
 	struct TCP_Server_Info *chan_server;
@@ -433,7 +433,7 @@ cifs_ses_add_channel(struct cifs_sb_info
 	 * This will be used for encoding/decoding user/domain/pw
 	 * during sess setup auth.
 	 */
-	ctx->local_nls = cifs_sb->local_nls;
+	ctx->local_nls = ses->local_nls;
 
 	/* Use RDMA if possible */
 	ctx->rdma = iface->rdma_capable;
@@ -479,7 +479,7 @@ cifs_ses_add_channel(struct cifs_sb_info
 
 	rc = cifs_negotiate_protocol(xid, ses, chan->server);
 	if (!rc)
-		rc = cifs_setup_session(xid, ses, chan->server, cifs_sb->local_nls);
+		rc = cifs_setup_session(xid, ses, chan->server, ses->local_nls);
 
 	mutex_unlock(&ses->session_mutex);
 


